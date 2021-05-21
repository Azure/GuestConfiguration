
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

function New-GuestConfigurationPolicy
{
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Uri]
        $ContentUri,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $DisplayName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Collections.Hashtable[]]
        $Parameter,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.Version]
        $Version = '1.0.0',

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Path,

        [Parameter()]
        [ValidateSet('Windows', 'Linux')]
        [System.String]
        $Platform = 'Windows',

        [Parameter()]
        [System.Collections.Hashtable[]]
        $Tag
    )

    # This value must be static for AINE policies due to service configuration
    $Category = 'Guest Configuration'

    try
    {
        $verbose = ($PSBoundParameters.ContainsKey("Verbose") -and ($PSBoundParameters["Verbose"] -eq $true))
        $policyDefinitionsPath = $Path
        $unzippedPkgPath = Join-Path -Path $policyDefinitionsPath -ChildPath 'temp'
        $tempContentPackageFilePath = Join-Path -Path $policyDefinitionsPath -ChildPath 'temp.zip'

        # Update parameter info
        $ParameterInfo = Update-PolicyParameter -Parameter $Parameter

        $null = New-Item -ItemType Directory -Force -Path $policyDefinitionsPath

        # Check if ContentUri is a valid web URI
        if (-not ($null -ne $ContentUri.AbsoluteURI -and $ContentUri.Scheme -match '[http|https]'))
        {
            throw "Invalid ContentUri : $ContentUri. Please specify a valid http URI in -ContentUri parameter."
        }

        # Generate checksum hash for policy content.
        Invoke-WebRequest -Uri $ContentUri -OutFile $tempContentPackageFilePath -SslProtocol Tls12 -Verbose
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
        if (-not $dscDocument)
        {
            throw "Invalid policy package, failed to find dsc document in policy package."
        }

        $policyName = [System.IO.Path]::GetFileNameWithoutExtension($dscDocument)

        $packageIsSigned = (($null -ne (Get-ChildItem -Path $unzippedPkgPath -Filter *.cat)) -or
            (($null -ne (Get-ChildItem -Path $unzippedPkgPath -Filter *.asc)) -and ($null -ne (Get-ChildItem -Path $unzippedPkgPath -Filter *.sha256sums))))

        # Design 2: Create a PolicyInfo and change file name as needed. Use File name to determine what type of file it is later on.
        # TODO: Determine if AINE or DINE
        $PolicyInfo = @{
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
        # TODO: Potentially change name of parameter
        $null = New-CustomGuestConfigPolicy -PolicyFolderPath $policyDefinitionsPath -PolicyInfo $PolicyInfo -Verbose:$verbose

        [pscustomobject]@{
            PSTypeName = 'GuestConfiguration.Policy'
            Name = $policyName
            Path = $Path
        }
    }
    finally
    {
        # Remove staging content package.
        Remove-Item -Path $tempContentPackageFilePath -Force -ErrorAction SilentlyContinue
        Remove-Item -Path $unzippedPkgPath -Recurse -Force -ErrorAction SilentlyContinue
    }
}
