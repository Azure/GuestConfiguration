

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

    .Parameter Tag
        The name and value of a tag used in Azure.

    .Example
        New-GuestConfigurationPolicy `
                                 -ContentUri https://github.com/azure/auditservice/release/AuditService.zip `
                                 -DisplayName 'Monitor Windows Service Policy.' `
                                 -Description 'Policy to monitor service on Windows machine.' `
                                 -Version 1.0.0.0
                                 -Path ./git/custom_policy
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
        [parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
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
        [Hashtable[]] $Tag
    )

    # This value must be static for AINE policies due to service configuration
    $Category = 'Guest Configuration'

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
        New-CustomGuestConfigPolicy -PolicyFolderPath $policyDefinitionsPath -AuditIfNotExistsInfo $AuditIfNotExistsInfo -Verbose:$verbose | Out-Null

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
