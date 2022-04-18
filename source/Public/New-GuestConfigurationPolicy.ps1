
<#
    .SYNOPSIS
        Creates a policy definition to run code on machines through Azure Guest Configuration and Azure Policy.

    .PARAMETER DisplayName
        The display name of the policy to create.
        The display name has a maximum length of 128 characters.

    .PARAMETER Description
        The description of the policy to create.
        The display name has a maximum length of 512 characters.

    .PARAMETER ContentUri
        The public HTTP or HTTPS URI of the Guest Configuration package (.zip) to run via the created policy.
        Example: https://github.com/azure/auditservice/release/AuditService.zip

    .PARAMETER PolicyId
        The unique ID of the policy definition.
        If you are trying to update an existing policy definition, then this ID must match the 'name' field in the existing defintiion.
        This field is normally a GUID.
        The default value is a new GUID.

    .PARAMETER Version
        The version of the policy definition.
        If you are trying to update an existing policy definition, then this version must be greater than the value in the 'metadata.version' field in the existing defintiion.
        Note: This is NOT the version of the Guest Configuration package.
        The default value is '1.0.0'.

    .PARAMETER Path
        The path to the folder under which to create the new policy definition file.
        The default value is the 'definitions' folder under your GuestConfiguration module path.

    .PARAMETER Platform
        The target platform (Windows or Linux) for the policy.
        The default value is Windows.

    .PARAMETER Parameter
        The parameters to expose on the policy.
        All parameters passed to the policy must be single strings.

        Example:
            $policyParameters = @(
                @{
                    Name = 'ServiceName'                                       # Required
                    DisplayName = 'Windows Service Name'                       # Required
                    Description = 'Name of the windows service to be audited.' # Optional
                    ResourceType = 'Service'                                   # Required
                    ResourceId = 'windowsService'                              # Required
                    ResourcePropertyName = 'Name'                              # Required
                    DefaultValue = 'winrm'                                     # Optional
                    AllowedValues = @('wscsvc', 'WSearch', 'wcncsvc', 'winrm') # Optional
                }
            )

    .PARAMETER Mode
        Defines the modification mode under which this policy should run code from the package to modify the machine.

        Allowed modes:
            Audit: Monitors the machine only. Will not make modifications to the machine.
            ApplyAndMonitor: Modifies the machine once if it does not match the expected state. Then monitors the machine only until another remediation task is triggered via Azure Policy. Will make modifications to the machine.
            ApplyAndAutoCorrect: Modifies the machine any time it does not match the expected state. You will need trigger a remediation task via Azure Policy to start modifications the first time. Will make modifications to the machine.

        The default value is Audit.

    .PARAMETER Tag
        The tags that should be on machines to apply this policy on.

    .EXAMPLE
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
            }
        )

        New-GuestConfigurationPolicy -ContentUri 'https://github.com/azure/auditservice/release/AuditService.zip' `
            -DisplayName 'Monitor Windows Service Policy.' `
            -Description 'Policy to monitor service on Windows machine.' `
            -Version 1.0.0.0
            -Path ./policyDefinitions `
            -Parameter $PolicyParameterInfo

    .OUTPUTS
        Return name and path of the Guest Configuration policy definitions.
        @{
            PSTypeName = 'GuestConfiguration.Policy'
            Name = $policyName
            Path = $Path
        }
#>

function New-GuestConfigurationPolicy
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $DisplayName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Uri]
        $ContentUri,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.Guid]
        $PolicyId = [System.Guid]::NewGuid(),

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.Version]
        $Version = '1.0.0',

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Path,

        [Parameter()]
        [ValidateSet('Windows', 'Linux')]
        [System.String]
        $Platform = 'Windows',

        [Parameter()]
        [System.Collections.Hashtable[]]
        $Parameter,

        [Parameter()]
        [ValidateSet('Audit', 'ApplyAndAutoCorrect', 'ApplyAndMonitor')]
        [System.String]
        $Mode = 'Audit',

        [Parameter()]
        [System.Collections.Hashtable]
        $Tag
    )

    # Validate parameters
    if ($DisplayName.Length -gt 128)
    {
        throw "The specified display name is more than the limit of 128 characters. Please specify a shorter display name."
    }

    if ($Description.Length -gt 512)
    {
        throw "The specified description is more than the limit of 512 characters. Please specify a shorter description."
    }

    if ($null -eq $ContentUri.AbsoluteURI)
    {
        throw "The specified package URI is not an absolute URI. Please specify a valid HTTP or HTTPS URI with the ContentUri parameter."
    }

    if ($ContentUri.Scheme -notmatch '[http|https]')
    {
        throw "The specified package URI does not follow the HTTP or HTTPS scheme. Please specify a valid HTTP or HTTPS URI with the ContentUri parameter."
    }

    $requiredParameterProperties = @('Name', 'DisplayName', 'Description', 'ResourceType', 'ResourceId', 'ResourcePropertyName')

    foreach ($parameterInfo in $Parameter)
    {
        foreach ($requiredParameterProperty in $requiredParameterProperties)
        {
            if (-not ($parameterInfo.ContainsKey($requiredParameterProperty)))
            {
                $requiredParameterPropertyString = $requiredParameterProperties -join ', '
                throw "One of the specified policy parameters is missing the mandatory property '$requiredParameterProperty'. The mandatory properties for parameters are: $requiredParameterPropertyString"
            }
        }
    }

    # Download package
    $gcWorkerPath = Get-GCWorkerRootPath
    $gcWorkerPackagesFolderPath = Join-Path -Path $gcWorkerPath -ChildPath 'packages'

    if (-not (Test-Path -Path $gcWorkerPackagesFolderPath))
    {
        $null = New-Item -Path $gcWorkerPackagesFolderPath -ItemType 'Directory' -Force
    }

    $packageFileDownloadName = 'temp.zip'
    $packageFileDownloadPath = Join-Path -Path $gcWorkerPackagesFolderPath -ChildPath $packageFileDownloadName

    if (Test-Path -Path $packageFileDownloadPath)
    {
        $null = Remove-Item -Path $packageFileDownloadPath -Force
    }

    $null = Invoke-WebRequest -Uri $ContentUri -OutFile $packageFileDownloadPath

    $contentHash = (Get-FileHash -Path $packageFileDownloadPath -Algorithm 'SHA256').Hash

    # Extract package
    $packageFolderName = 'temp'
    $packagePath = Join-Path -Path $gcWorkerPackagesFolderPath -ChildPath $packageFolderName

    if (Test-Path -Path $packagePath)
    {
        $null = Remove-Item -Path $packagePath -Recurse -Force
    }

    $null = Expand-Archive -Path $packageFileDownloadPath -DestinationPath $packagePath -Force

    # Validate package?

    # Get configuration name
    $mofFilePattern = '*.mof'
    $mofChildItems = @( Get-ChildItem -Path $packagePath -Filter $mofFilePattern -File )

    if ($mofChildItems.Count -eq 0)
    {
        throw "No .mof file found in the extracted Guest Configuration package at '$packagePath'. The Guest Configuration package must include a compiled DSC configuration (.mof) with the same name as the package. Please use the New-GuestConfigurationPackage cmdlet to generate a valid package."
    }
    elseif ($mofChildItems.Count -gt 1)
    {
        throw "Found more than one .mof file in the extracted Guest Configuration package at '$packagePath'. Please remove any extra .mof files from the root of the package. Please use the New-GuestConfigurationPackage cmdlet to generate a valid package."
    }

    $mofFile = $mofChildItems[0]
    $packageName = $mofFile.BaseName

    # Get package version
    $packageVersion = '1.0.0'
    $metaconfigFileName = "{0}.metaconfig.json" -f $packageName
    $metaconfigFilePath =Join-Path -Path $packagePath -ChildPath $metaconfigFileName

    if (Test-Path -Path $metaconfigFilePath)
    {
        $metaconfig = Get-Content -Path $metaconfigFilePath -Raw | ConvertFrom-Json -AsHashtable

        if ($metaconfig.ContainsKey('Version'))
        {
            $packageVersion = $metaconfig['Version']
        }
    }

    # Determine paths
    if ([String]::IsNullOrEmpty($Path))
    {
        $Path = Join-Path -Path $gcWorkerPath -ChildPath 'definitions'
    }

    $currentLocation = Get-Location
    $Path = [System.IO.Path]::GetFullPath($Path, $currentLocation)

    if (-not (Test-Path -Path $Path))
    {
        $null = New-Item -Path $Path -ItemType 'Directory' -Force
    }

    # Determine if policy is AINE or DINE
    if ($Mode -eq 'Audit')
    {
        $fileName = '{0}_AuditIfNotExists.json' -f $packageName
    }
    else
    {
        $fileName = '{0}_DeployIfNotExists.json' -f $packageName
    }

    $filePath = Join-Path -Path $Path -ChildPath $fileName

    if (Test-Path -Path $filePath)
    {
        $null = Remove-Item -Path $filePath -Force
    }

    # Generate definition
    $policyDefinitionContentParameters = @{
        DisplayName = $DisplayName
        Description = $Description
        Version = $Version
        ConfigurationName = $packageName
        ConfigurationVersion = $packageVersion
        ContentUri = $ContentUri
        ContentHash = $contentHash
        Platform = $Platform
        AssignmentType = $Mode
        PolicyId = $PolicyId
        Parameter = $Parameter
        Tag = $Tag
    }
    $policyDefinitionContent = New-GuestConfigurationPolicyContent @policyDefinitionContentParameters

    # Convert definition hashtable to JSON
    $policyDefinitionContentJson = ConvertTo-Json -InputObject $policyDefinitionContent -Depth 100
    $formattedPolicyDefinitionContentJson = Format-PolicyDefinitionJson -Json $policyDefinitionContentJson

    # Write JSON to file
    $null = Set-Content -Path $filePath -Value $formattedPolicyDefinitionContentJson -Force

    # Return policy information
    $result = [PSCustomObject]@{
        PSTypeName = 'GuestConfiguration.Policy'
        Name = $packageName
        Path = $filePath
        PolicyId = $PolicyId
    }

    return $result

    # Check if the package is signed (nothing is using this right now)
    # $packageIsSigned = (($null -ne (Get-ChildItem -Path $unzippedPkgPath -Filter *.cat)) -or
    # (($null -ne (Get-ChildItem -Path $unzippedPkgPath -Filter *.asc)) -and ($null -ne (Get-ChildItem -Path $unzippedPkgPath -Filter *.sha256sums))))
}
