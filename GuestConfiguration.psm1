Set-StrictMode -Version latest
$ErrorActionPreference = 'Stop'

Import-Module $PSScriptRoot/helpers/DscOperations.psm1 -Force
Import-Module $PSScriptRoot/helpers/GuestConfigurationPolicy.psm1 -Force
Import-LocalizedData -BaseDirectory $PSScriptRoot -FileName GuestConfiguration.psd1 -BindingVariable GuestConfigurationManifest

$currentCulture = [System.Globalization.CultureInfo]::CurrentCulture
if (($currentCulture.Name -eq 'en-US-POSIX') -and ($(Get-OSPlatform) -eq 'Linux')) {
    Write-Warning "'$($currentCulture.Name)' Culture is not supported, changing it to 'en-US'"
    # Set Culture info to en-US
    [System.Globalization.CultureInfo]::CurrentUICulture = [System.Globalization.CultureInfo]::new('en-US')
    [System.Globalization.CultureInfo]::CurrentCulture = [System.Globalization.CultureInfo]::new('en-US')
}

#inject version info to GuestConfigPath.psm1
InitReleaseVersionInfo $GuestConfigurationManifest.moduleVersion

<#
    .SYNOPSIS
        Creates a Guest Configuration policy package.

    .Parameter Name
        Guest Configuration package name.

    .Parameter Configuration
        Compiled DSC configuration document full path.

    .Parameter Path
        Output folder path.
        This is an optional parameter. If not specified, the package will be created in the current directory.

    .Parameter ChefInspecProfilePath
        Chef profile path, supported only on Linux.

    .Example
        New-GuestConfigurationPackage -Name WindowsTLS -Configuration ./custom_policy/WindowsTLS/localhost.mof -Path ./git/repository/release/policy/WindowsTLS

    .OUTPUTS
        Return name and path of the new Guest Configuration Policy package.
#>

function New-GuestConfigurationPackage {
    [CmdletBinding()]
    param (
        [parameter(Position = 0, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [parameter(Position = 1, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $Configuration,

        [ValidateNotNullOrEmpty()]
        [string] $ChefInspecProfilePath,

        [ValidateNotNullOrEmpty()]
        [string] $FilesToInclude,

        [string] $Path = '.'
    )

    Try {
        $verbose = ($PSBoundParameters.ContainsKey("Verbose") -and ($PSBoundParameters["Verbose"] -eq $true))
        $unzippedPackagePath = New-Item -ItemType Directory -Force -Path (Join-Path (Join-Path $Path $Name) 'unzippedPackage')
        $Configuration = Resolve-Path $Configuration

        if (-not (Test-Path -Path $Configuration -PathType Leaf)) {
            Throw "Invalid mof file path, please specify full file path for dsc configuration in -Configuration parameter."
        }
         
        Write-Verbose "Creating Guest Configuration package in temporary directory '$unzippedPackagePath'"

        # Verify that only supported resources are used in DSC configuration.
        Test-GuestConfigurationMofResourceDependencies -Path $Configuration -Verbose:$verbose

        # Save DSC configuration to the temporary package path.
        Save-GuestConfigurationMofDocument -Name $Name -SourcePath $Configuration -DestinationPath (Join-Path $unzippedPackagePath "$Name.mof") -Verbose:$verbose

        # Copy DSC resources
        Copy-DscResources -MofDocumentPath $Configuration -Destination $unzippedPackagePath -Verbose:$verbose

        if (-not [string]::IsNullOrEmpty($ChefInspecProfilePath)) {
            # Copy Chef resource and profiles.
            Copy-ChefInspecDependencies -PackagePath $unzippedPackagePath -Configuration $Configuration -ChefInspecProfilePath $ChefInspecProfilePath
        }

        # Copy FilesToInclude
        if (-not [string]::IsNullOrEmpty($FilesToInclude)) {
            if (Test-Path $FilesToInclude -PathType Leaf) {
                Copy-Item -Path $FilesToInclude -Destination $unzippedPackagePath
            }
            else {
                $filesToIncludeFolderName = Get-Item $FilesToInclude
                $FilesToIncludePath = Join-Path $unzippedPackagePath $filesToIncludeFolderName.Name
                Copy-Item -Path $FilesToInclude -Destination $FilesToIncludePath -Recurse
            }
        }
        
        # Create Guest Configuration Package.
        $packagePath = Join-Path $Path $Name
        New-Item -ItemType Directory -Force -Path $packagePath | Out-Null
        $packagePath = Resolve-Path $packagePath
        $packageFilePath = join-path $packagePath "$Name.zip"
        Remove-Item $packageFilePath -Force -ErrorAction SilentlyContinue

        Write-Verbose "Creating Guest Configuration package : $packageFilePath."
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::CreateFromDirectory($unzippedPackagePath, $packageFilePath)

        $result = [pscustomobject]@{
            Name = $Name
            Path = $packageFilePath
        }
        return $result
    }
    Finally {
    }
}

<#
    .SYNOPSIS
        Tests a Guest Configuration policy package.

    .Parameter Path
        Full path of the zipped Guest Configuration package.

    .Parameter Parameter
        Policy parameters.

    .Example
        Test-GuestConfigurationPackage -Path ./custom_policy/WindowsTLS.zip

        $Parameter = @(
            @{
                ResourceType = "Service"            # dsc configuration resource type (mandatory)
                ResourceId = 'windowsService'       # dsc configuration resource property id (mandatory)
                ResourcePropertyName = "Name"       # dsc configuration resource property name (mandatory)
                ResourcePropertyValue = 'winrm'     # dsc configuration resource property value (mandatory)
            })

        Test-GuestConfigurationPackage -Path ./custom_policy/AuditWindowsService.zip -Parameter $Parameter

    .OUTPUTS
        Returns compliance details.
#>

function Test-GuestConfigurationPackage {
    [CmdletBinding()]
    param (
        [parameter(Position = 0, Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $Path,

        [parameter(Mandatory = $false)]
        [Hashtable[]] $Parameter = @()
    )
    
    if (-not (Test-Path $Path -PathType Leaf)) {
        Throw 'Invalid Guest Configuration package path : $($Path)'
    }

    $verbose = ($PSBoundParameters.ContainsKey("Verbose") -and ($PSBoundParameters["Verbose"] -eq $true))
    $systemPSModulePath = [Environment]::GetEnvironmentVariable("PSModulePath", "Process")

    Try {
        # Create policy folder
        $Path = Resolve-Path $Path
        $policyPath = Join-Path $(Get-GuestConfigPolicyPath) ([System.IO.Path]::GetFileNameWithoutExtension($Path))
        Remove-Item $policyPath -Recurse -Force -ErrorAction SilentlyContinue
        New-Item -ItemType Directory -Force -Path $policyPath | Out-Null

        # Unzip policy package.
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::ExtractToDirectory($Path, $policyPath)

        # Get policy name
        $dscDocument = Get-ChildItem -Path $policyPath -Filter *.mof
        if (-not $dscDocument) {
            Throw "Invalid policy package, failed to find dsc document in policy package."
        }
        $policyName = [System.IO.Path]::GetFileNameWithoutExtension($dscDocument)

        # update configuration parameters
        if ($Parameter.Count -gt 0) {
            Update-MofDocumentParameters -Path $dscDocument.FullName -Parameter $Parameter
        }

        # Unzip Guest Configuration binaries
        $gcBinPath = Get-GuestConfigBinaryPath
        $gcBinRootPath = Get-GuestConfigBinaryRootPath
        if (-not (Test-Path $gcBinPath)) {
            # Clean the bin folder
            Remove-Item $gcBinRootPath'\*' -Recurse -Force -ErrorAction SilentlyContinue

            $zippedBinaryPath = Join-Path $(Get-GuestConfigurationModulePath) 'bin'
            if ($(Get-OSPlatform) -eq 'Windows') {
                $zippedBinaryPath = Join-Path $zippedBinaryPath 'DSC_Windows.zip'
            }
            else {
                # Linux zip package contains an additional DSC folder
                # Remove DSC folder from binary path to avoid two nested DSC folders.
                New-Item -ItemType Directory -Force -Path $gcBinPath | Out-Null
                $gcBinPath = (Get-Item $gcBinPath).Parent.FullName
                $zippedBinaryPath = Join-Path $zippedBinaryPath 'DSC_Linux.zip'
            }
            [System.IO.Compression.ZipFile]::ExtractToDirectory($zippedBinaryPath, $gcBinPath)
        }

        # Publish policy package
        Publish-DscConfiguration -ConfigurationName $policyName -Path $policyPath -Verbose:$verbose

        # Set LCM settings to force load powershell module.
        $metaConfigPath = Join-Path $policyPath "$policyName.metaconfig.json"
        "{""debugMode"":""ForceModuleImport""}" | Out-File $metaConfigPath -Encoding ascii
        Set-DscLocalConfigurationManager -ConfigurationName $policyName -Path $policyPath -Verbose:$verbose

        # Clear Inspec profiles
        Remove-Item $(Get-InspecProfilePath) -Recurse -Force -ErrorAction SilentlyContinue

        $testResult = Test-DscConfiguration -ConfigurationName $policyName -Verbose:$verbose
        $getResult = @()
        $getResult = $getResult + (Get-DscConfiguration -ConfigurationName $policyName -Verbose:$verbose)

        $testResult.resources_not_in_desired_state | ForEach-Object {
            $resourceId = $_;
            if ($getResult.count -gt 1) {
                for ($i = 0; $i -lt $getResult.Count; $i++) {
                    if ($getResult[$i].ResourceId -ieq $resourceId) {
                        $getResult[$i] = $getResult[$i] | Select-Object *, @{n = 'complianceStatus'; e = { $false } }
                    }
                }
            }
            elseif ($getResult.ResourceId -ieq $resourceId) {
                $getResult = $getResult | Select-Object *, @{n = 'complianceStatus'; e = { $false } }
            }
        }

        $testResult.resources_in_desired_state | ForEach-Object {
            $resourceId = $_;
            if ($getResult.count -gt 1) {
                for ($i = 0; $i -lt $getResult.Count; $i++) {
                    if ($getResult[$i].ResourceId -ieq $resourceId) {
                        $getResult[$i] = $getResult[$i] | Select-Object *, @{n = 'complianceStatus'; e = { $true } }
                    }
                }
            }
            elseif ($getResult.ResourceId -ieq $resourceId) {
                $getResult = $getResult | Select-Object *, @{n = 'complianceStatus'; e = { $true } }
            }
        }

        $result = New-Object -TypeName PSObject
        $properties = [ordered]@{ complianceStatus = $testResult.compliance_state; resources = $getResult }
        $result | Add-Member -NotePropertyMembers $properties

        return $result;
    }
    Finally {
        $env:PSModulePath = $systemPSModulePath
    }
}

<#
    .SYNOPSIS
        Signs a Guest Configuration policy package using certificate on Windows and Gpg keys on Linux.

    .Parameter Path
        Full path of the Guest Configuration package.

    .Parameter Certificate
        'Code Signing' certificate to sign the package. This is only supported on Windows.

    .Parameter PrivateGpgKeyPath
        Private Gpg key path. This is only supported on Linux.

    .Parameter PublicGpgKeyPath
        Public Gpg key path. This is only supported on Linux.

    .Example
        $Cert = Get-ChildItem -Path Cert:/CurrentUser/AuthRoot -Recurse | Where-Object {($_.Thumbprint -eq "0563b8630d62d75abbc8ab1e4bdfb5a899b65d43") }
        Protect-GuestConfigurationPackage -Path ./custom_policy/WindowsTLS.zip -Certificate $Cert

    .OUTPUTS
        Return name and path of the signed Guest Configuration Policy package.
#>

function Protect-GuestConfigurationPackage {
    [CmdletBinding()]
    param (
        [parameter(Position = 0, Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = "Certificate")]
        [parameter(Position = 0, Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = "GpgKeys")]
        [ValidateNotNullOrEmpty()]
        [string] $Path,

        [parameter(Mandatory = $true, ParameterSetName = "Certificate")]
        [ValidateNotNullOrEmpty()]
        [System.Security.Cryptography.X509Certificates.X509Certificate2] $Certificate,

        [parameter(Mandatory = $true, ParameterSetName = "GpgKeys")]
        [ValidateNotNullOrEmpty()]
        [string] $PrivateGpgKeyPath,

        [parameter(Mandatory = $true, ParameterSetName = "GpgKeys")]
        [ValidateNotNullOrEmpty()]
        [string] $PublicGpgKeyPath
    )

    $Path = Resolve-Path $Path
    if (-not (Test-Path $Path -PathType Leaf)) {
        Throw 'Invalid Guest Configuration package path.'
    }

    Try {
        $packageFileName = ([System.IO.Path]::GetFileNameWithoutExtension($Path))
        $signedPackageFilePath = Join-Path (Get-ChildItem $Path).Directory "$($packageFileName)_signed.zip"
        $tempDir = Join-Path (Get-ChildItem $Path).Directory 'temp'
        Remove-Item $signedPackageFilePath -Force -ErrorAction SilentlyContinue
        New-Item -ItemType Directory -Force -Path $tempDir | Out-Null

        # Unzip policy package.
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::ExtractToDirectory($Path, $tempDir)

        # Get policy name
        $dscDocument = Get-ChildItem -Path $tempDir -Filter *.mof
        if (-not $dscDocument) {
            Throw "Invalid policy package, failed to find dsc document in policy package."
        }
        $policyName = [System.IO.Path]::GetFileNameWithoutExtension($dscDocument)

        $osPlatform = Get-OSPlatform
        if ($PSCmdlet.ParameterSetName -eq "Certificate") {
            if ($osPlatform -eq "Linux") {
                throw 'Certificate signing not supported on Linux.'
            }

            # Create catalog file
            $catalogFilePath = Join-Path $tempDir "$policyName.cat"
            Remove-Item $catalogFilePath -Force -ErrorAction SilentlyContinue
            Write-Verbose "Creating catalog file : $catalogFilePath."
            New-FileCatalog -Path $tempDir -CatalogVersion 2.0 -CatalogFilePath $catalogFilePath | Out-Null

            # Sign catalog file
            Write-Verbose "Signing catalog file : $catalogFilePath."
            $CodeSignOutput = Set-AuthenticodeSignature -Certificate $Certificate -FilePath $catalogFilePath

            $Signature = Get-AuthenticodeSignature $catalogFilePath
            if ($null -ne $Signature.SignerCertificate) {
                if ($Signature.SignerCertificate.Thumbprint -ne $Certificate.Thumbprint) {
                    throw $CodeSignOutput.StatusMessage
                }
            }
            else { throw $CodeSignOutput.StatusMessage }
        }
        else {
            if ($osPlatform -eq "Windows") {
                throw 'Gpg signing not supported on Windows.'
            }

            $PrivateGpgKeyPath = Resolve-Path $PrivateGpgKeyPath
            $PublicGpgKeyPath = Resolve-Path $PublicGpgKeyPath
            $ascFilePath = Join-Path $tempDir "$policyName.asc"
            $hashFilePath = Join-Path $tempDir "$policyName.sha256sums"

            Remove-Item $ascFilePath -Force -ErrorAction SilentlyContinue
            Remove-Item $hashFilePath -Force -ErrorAction SilentlyContinue

            Write-Verbose "Creating file hash : $hashFilePath."
            pushd $tempDir
            bash -c "find ./ -type f -print0 | xargs -0 sha256sum | grep -v sha256sums > $hashFilePath"
            popd

            Write-Verbose "Signing file hash : $hashFilePath."
            gpg --import $PrivateGpgKeyPath
            gpg --no-default-keyring --keyring $PublicGpgKeyPath --output $ascFilePath --armor --detach-sign $hashFilePath
        }

        # Zip the signed Guest Configuration package
        Write-Verbose "Creating signed Guest Configuration package : $signedPackageFilePath."
        [System.IO.Compression.ZipFile]::CreateFromDirectory($tempDir, $signedPackageFilePath)

        $result = [pscustomobject]@{
            Name = $policyName
            Path = $signedPackageFilePath
        }
        return $result
    }
    Finally {
        Remove-Item $tempDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}

<#
    .SYNOPSIS
        Publish a Guest Configuration policy package to Azure blob storage.
        The goal is to simplify the number of steps by scoping to a specific
        task.

        Generates a SAS token with a 3-year lifespan, to mitigate the risk
        of a malicious person discovering the published content.

        Requires a resource group, storage account, and container
        to be pre-staged. For details on how to pre-stage these things see the 
        documentation for the Az Storage cmdlets.
        https://docs.microsoft.com/en-us/azure/storage/blobs/storage-quickstart-blobs-powershell.

    .Parameter Path
        Location of the .zip file containing the Guest Configuration artifacts

    .Parameter ResourceGroupName
        The Azure resource group for the storage account

    .Parameter StorageAccountName
        The name of the storage account for where the package will be published
        Storage account names must be globally unique

    .Parameter StorageContainerName
        Name of the storage container in Azure Storage account (default: "guestconfiguration")

    .Example
        Publish-GuestConfigurationPackage -Path ./package.zip -ResourceGroupName 'resourcegroup' -StorageAccountName 'sa12345'

    .OUTPUTS
        Return a publicly accessible URI containing a SAS token with a 3-year expiration.
#>

function Publish-GuestConfigurationPackage {
    [CmdletBinding()]
    param (
        [parameter(Position = 0, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $Path,

        [parameter(Position = 1, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $ResourceGroupName,

        [parameter(Position = 2, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $StorageAccountName,

        [string] $StorageContainerName = 'guestconfiguration',
        
        [switch] $Force
    )

    # Get Storage Context
    $Context = Get-AzStorageAccount -ResourceGroupName $ResourceGroupName `
        -Name $StorageAccountName | `
        ForEach-Object { $_.Context }

    # Blob name from file name
    $BlobName = Get-Item $Path | ForEach-Object { $_.Name }

    # Upload file
    if ($true -eq $Force) {
        $Blob = Set-AzStorageBlobContent -Context $Context `
            -Container $StorageContainerName `
            -Blob $BlobName `
            -File $Path `
            -Force
    }
    else {
        $Blob = Set-AzStorageBlobContent -Context $Context `
            -Container $StorageContainerName `
            -Blob $BlobName `
            -File $Path
    }

    # Get url with SAS token
    # THREE YEAR EXPIRATION
    $StartTime = Get-Date
    $SAS = New-AzStorageBlobSASToken -Context $Context `
        -Container $StorageContainerName `
        -Blob $BlobName `
        -StartTime $StartTime `
        -ExpiryTime $StartTime.AddYears('3') `
        -Permission 'rl' `
        -FullUri

    # Output
    return $SAS
}

<#
    .SYNOPSIS
        Creates Audit, DeployIfNotExists and Initiative policy definitions on specified Destination Path.

    .Parameter ContentUri
        Public http uri of Guest Configuration content package.

    .Parameter DisplayName
        Policy display name.

    .Parameter Description
        Policy description.

    .Parameter Parameter
        Policy parameters.

    .Parameter Version
        Policy version.

    .Parameter Path
        Destination path.

    .Parameter Platform
        Target platform (Windows/Linux) for Guest Configuration policy and content package.
        Windows is the default platform.

    .Parameter Category
        Policy category.

    .Parameter Tag
        The name and value of a tag used in Azure.

    .Example
        New-GuestConfigurationPolicy `
                                 -ContentUri https://github.com/azure/auditservice/release/AuditService.zip `
                                 -DisplayName 'Monitor Windows Service Policy.' `
                                 -Description 'Policy to monitor service on Windows machine.' `
                                 -Version 1.0.0.0 
                                 -Path ./git/custom_policy
                                 -Category 'Contoso Apps'
                                 -Tag @{Owner = 'WebTeam'}

        $PolicyParameterInfo = @(
            @{
                Name = 'ServiceName'                                       # Policy parameter name (mandatory)
                DisplayName = 'windows service name.'                      # Policy parameter display name (mandatory)
                Description = "Name of the windows service to be audited." # Policy parameter description (optional)
                ResourceType = "Service"                                   # dsc configuration resource type (mandatory)
                ResourceId = 'windowsService'                              # dsc configuration resource property name (mandatory)
                ResourcePropertyName = "Name"                              # dsc configuration resource property name (mandatory)
                DefaultValue = 'winrm'                                     # Policy parameter default value (optional)
                AllowedValues = @('wscsvc','WSearch','wcncsvc','winrm')    # Policy parameter allowed values (optional)
            })

            New-GuestConfigurationPolicy -ContentUri 'https://github.com/azure/auditservice/release/AuditService.zip' `
                                 -DisplayName 'Monitor Windows Service Policy.' `
                                 -Description 'Policy to monitor service on Windows machine.' `
                                 -Version 1.0.0.0 
                                 -Path ./policyDefinitions `
                                 -Parameter $PolicyParameterInfo 

    .OUTPUTS
        Return name and path of the Guest Configuration policy definitions.
#>

function New-GuestConfigurationPolicy {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $ContentUri,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $DisplayName,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $Description,

        [parameter()]
        [Hashtable[]] $Parameter,

        [parameter()]
        [ValidateNotNullOrEmpty()]
        [version] $Version = '1.0.0',

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $Path,

        [Parameter()]
        [ValidateSet('Windows', 'Linux')]
        [string]
        $Platform = 'Windows',

        [parameter()]
        [string] $Category = 'Guest Configuration',

        [parameter()]
        [Hashtable[]] $Tag
    )

    Try {
        $verbose = ($PSBoundParameters.ContainsKey("Verbose") -and ($PSBoundParameters["Verbose"] -eq $true))
        $policyDefinitionsPath = $Path
        $unzippedPkgPath = Join-Path $policyDefinitionsPath 'temp'
        $tempContentPackageFilePath = Join-Path $policyDefinitionsPath 'temp.zip'

        # update parameter info
        $ParameterInfo = Update-PolicyParameter -Parameter $Parameter

        New-Item -ItemType Directory -Force -Path $policyDefinitionsPath | Out-Null

        # Check if ContentUri is a valid web Uri
        $uri = $ContentUri -as [System.URI]
        if (-not ($uri.AbsoluteURI -ne $null -and $uri.Scheme -match '[http|https]')) {
            Throw "Invalid ContentUri : $ContentUri. Please specify a valid http URI in -ContentUri parameter."
        }

        # Generate checksum hash for policy content.
        Invoke-WebRequest -Uri $ContentUri -OutFile $tempContentPackageFilePath
        $tempContentPackageFilePath = Resolve-Path $tempContentPackageFilePath
        $contentHash = (Get-FileHash $tempContentPackageFilePath -Algorithm SHA256).Hash
        Write-Verbose "SHA256 Hash for content '$ContentUri' : $contentHash."

        # Get the policy name from policy content.
        Remove-Item $unzippedPkgPath -Recurse -Force -ErrorAction SilentlyContinue
        New-Item -ItemType Directory -Force -Path $unzippedPkgPath | Out-Null
        $unzippedPkgPath = Resolve-Path $unzippedPkgPath
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::ExtractToDirectory($tempContentPackageFilePath, $unzippedPkgPath)
        $dscDocument = Get-ChildItem -Path $unzippedPkgPath -Filter *.mof -Exclude '*.schema.mof' -Depth 1
        if (-not $dscDocument) {
            Throw "Invalid policy package, failed to find dsc document in policy package."
        }
        $policyName = [System.IO.Path]::GetFileNameWithoutExtension($dscDocument)

        $packageIsSigned = (((Get-ChildItem -Path $unzippedPkgPath -Filter *.cat) -ne $null) -or `
            (((Get-ChildItem -Path $unzippedPkgPath -Filter *.asc) -ne $null) -and ((Get-ChildItem -Path $unzippedPkgPath -Filter *.sha256sums) -ne $null)))

        $AuditIfNotExistsInfo = @{
            FileName                 = 'AuditIfNotExists.json'
            DisplayName              = $DisplayName
            Description              = $Description
            Platform                 = $Platform
            ConfigurationName        = $policyName
            ConfigurationVersion     = $Version
            ContentUri               = $ContentUri
            ContentHash              = $contentHash
            ReferenceId              = "Deploy_$policyName"
            ParameterInfo            = $ParameterInfo
            UseCertificateValidation = $packageIsSigned
            Category                 = $Category
            Tag                      = $Tag
        }
        New-CustomGuestConfigPolicy -PolicyFolderPath $policyDefinitionsPath -AuditIfNotExistsInfo $AuditIfNotExistsInfo -Platform $Platform -Verbose:$verbose | Out-Null
            
        $result = [pscustomobject]@{
            Name = $policyName
            Path = $Path
        }
        return $result
    }
    Finally {
        # Remove temporary content package.
        Remove-Item $tempContentPackageFilePath -Force -ErrorAction SilentlyContinue
        Remove-Item $unzippedPkgPath -Recurse -Force -ErrorAction SilentlyContinue
    }
}

<#
    .SYNOPSIS
        Publishes the Guest Configuration policy in Azure Policy Center.

    .Parameter Path
        Guest Configuration policy path.

    .Example
        Publish-GuestConfigurationPolicy -Path ./git/custom_policy
#>

function Publish-GuestConfigurationPolicy {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $Path,

        [parameter(Mandatory = $false)]
        [string] $ManagementGroupName
    )

    $rmContext = Get-AzContext
    Write-Verbose "Publishing Guest Configuration policy using '$($rmContext.Name)' AzContext."

    # Publish policies
    $subscriptionId = $rmContext.Subscription.Id
    $policyFile = join-path $Path "AuditIfNotExists.json"
    $jsonDefinition = Get-Content $policyFile | ConvertFrom-Json | ForEach-Object { $_ }
    $definitionContent = $jsonDefinition.Properties

    $newAzureRmPolicyDefinitionParameters = @{
        Name        = $jsonDefinition.name
        DisplayName = $($definitionContent.DisplayName | ConvertTo-Json -Depth 20).replace('"', '')
        Description = $($definitionContent.Description | ConvertTo-Json -Depth 20).replace('"', '')
        Policy      = $($definitionContent.policyRule | ConvertTo-Json -Depth 20)
        Metadata    = $($definitionContent.Metadata | ConvertTo-Json -Depth 20)
        ApiVersion  = '2018-05-01'
        Verbose     = $true
    }

    if ($definitionContent.PSObject.Properties.Name -contains 'parameters') {
        $newAzureRmPolicyDefinitionParameters['Parameter'] = ConvertTo-Json -InputObject $definitionContent.parameters -Depth 15
    }

    if ($ManagementGroupName) {
        $newAzureRmPolicyDefinitionParameters['ManagementGroupName'] = $ManagementGroupName
    }

    Write-Verbose "Publishing '$($jsonDefinition.properties.displayName)' ..."
    New-AzPolicyDefinition @newAzureRmPolicyDefinitionParameters
}

Export-ModuleMember -Function @('New-GuestConfigurationPackage', 'Test-GuestConfigurationPackage', 'Protect-GuestConfigurationPackage', 'Publish-GuestConfigurationPackage', 'New-GuestConfigurationPolicy', 'Publish-GuestConfigurationPolicy')
