
<#
    .SYNOPSIS
        Creates a policy definition to monitor and remediate settings on machines through
        Azure Guest Configuration and Azure Policy.

    .PARAMETER DisplayName
        The display name of the policy to create.
        The display name has a maximum length of 128 characters.

    .PARAMETER Description
        The description of the policy to create.
        The display name has a maximum length of 512 characters.

    .PARAMETER PolicyId
        The unique GUID of the policy definition.
        If you are trying to update an existing policy definition, then this ID must match the 'name'
        field in the existing definition.

        You can run New-Guid to generate a new GUID.

    .PARAMETER PolicyVersion
        The version of the policy definition.
        If you are updating an existing policy definition, then this version should be greater than
        the value in the 'metadata.version' field in the existing definition.

        Note: This is NOT the version of the Guest Configuration package.
        You can validate the Guest Configuration package version via the ContentVersion parameter.

    .PARAMETER ContentUri
        The public HTTP or HTTPS URI of the Guest Configuration package (.zip) to run via the created policy.
        Example: https://github.com/azure/auditservice/release/AuditService.zip

        Note: If you are using an Azure storage account to store the custom machine configuration package artifact, you have two options for access:
        1. Generate a blob shared access signature (SAS) token with read access and provide the full blob URI with the SAS token for the ContentUri parameter.
        2. Create a user-assigned managed identity with read access to the storage account blob containing the package.
            Provide the resource ID of the managed identity, a local path to the zipped package, a URI to the package without a SAS token and the ExcludeArcMachines parameter.
            With this option, once the generated policy is applied, the managed identity will be used to download the package onto the target machine.

    .PARAMETER ManagedIdentityResourceId
        This is the identity that is used to download the package from storage account container instead of using SaS url.
        The value for this parameter needs to be the resource id of the managed identity.
        This is an option to use when the package is stored in a storage account and the storage account is protected by a managed identity.

        Note: optional parameter. If this is specified, LocalContentPath and ExcludeArcMachines must also be specified.

    .PARAMETER UseSystemAssignmentIdentity
        This is the option to use the system assigned identity for downloading package from storage account container instead of using SaS url.
        When this option is enabled you cannot use the ManagedIdentityResourceId. Only one of the options should be used at a time.
        You can use this parameter without ExcludeArcMachines option as the system assigned identity is available for Arc machines.
        This is an option to use when the package is stored in a storage account and the storage account is protected by a managed identity.

        Note: optional parameter. If this is specified, LocalContentPath must also be specified but ManagedIdentityResourceId should not be specified.

    .PARAMETER LocalContentPath
        This is the path to the local package zip file. This is used to calculate the hash of the package.
        The value of this parameter is not used in the policy definition.

        Note: optional parameter. If this is specified, ManagedIdentityResourceId must also be specified.

    .PARAMETER ContentVersion
        If specified, the version of the Guest Configuration package (.zip) downloaded via the
        content URI must match this value.
        This is for validation only.

        Note: This is NOT the version of the policy definition.
        You can define the policy definition version via the PolicyVersion parameter.

    .PARAMETER Path
        The path to the folder under which to create the new policy definition file.
        The default value is the 'definitions' folder under your GuestConfiguration module path.

    .PARAMETER Platform
        The target platform (Windows or Linux) for the policy.
        The default value is Windows.

    .PARAMETER Parameter
        The parameters to expose on the policy.
        All parameters passed to the policy must be single string values.

        Example:
            $policyParameters = @(
                @{
                    Name = 'ServiceName'                                       # Required
                    DisplayName = 'Windows Service Name'                       # Required
                    Description = 'Name of the windows service to be audited.' # Required
                    ResourceType = 'Service'                                   # Required
                    ResourceId = 'windowsService'                              # Required
                    ResourcePropertyName = 'Name'                              # Required
                    DefaultValue = 'winrm'                                     # Optional
                    AllowedValues = @('wscsvc', 'WSearch', 'wcncsvc', 'winrm') # Optional
                },
                @{
                    Name = 'ServiceState'                                       # Required
                    DisplayName = 'Windows Service State'                       # Required
                    Description = 'State of the windows service to be audited.' # Required
                    ResourceType = 'Service'                                    # Required
                    ResourceId = 'windowsService'                               # Required
                    ResourcePropertyName = 'State'                              # Required
                    DefaultValue = 'Running'                                    # Optional
                    AllowedValues = @('Running', 'Disabled')                    # Optional
                }
            )

    .PARAMETER Mode
        Defines the mode under which this policy should run the package on the machine.

        Allowed modes:
            Audit: Monitors the machine only. Will not make modifications to the machine.
            ApplyAndMonitor: Modifies the machine once if it does not match the expected state.
              Then monitors the machine only until another remediation task is triggered via Azure Policy.
              Will make modifications to the machine.
            ApplyAndAutoCorrect: Modifies the machine any time it does not match the expected state.
              You will need trigger a remediation task via Azure Policy to start modifications the first time.
              Will make modifications to the machine.

        The default value is Audit.

        If the package has been created as Audit-only, you cannot create an Apply policy with that package.
        The package will need to be re-created in AuditAndSet mode.

    .PARAMETER Tag
        A hashtable of the tags that should be on machines to apply this policy on.
        If this is specified, the created policy will only be applied to machines with all the specified tags.


    .PARAMETER ExcludeArcMachines
        This parameter needs to be specified if the New-GuestConfigurationPolicy is using a User Assigned Identity.
        Enabling this parameter will signal that users are aware of exclusion of Arc enabled servers in the definition.

    .EXAMPLE
        New-GuestConfigurationPolicy `
            -ContentUri https://github.com/azure/auditservice/release/AuditService.zip `
            -DisplayName 'Monitor Windows Service Policy.' `
            -Description 'Policy to monitor service on Windows machine.' `
            -PolicyVersion 1.1.0 `
            -Path ./git/custom_policy `
            -Tag @{ Owner = 'WebTeam' }

    .EXAMPLE
        $PolicyParameterInfo = @(
            @{
                Name = 'ServiceName'                                       # Policy parameter name (mandatory)
                DisplayName = 'windows service name.'                      # Policy parameter display name (mandatory)
                Description = "Name of the windows service to be audited." # Policy parameter description (mandatory)
                ResourceType = "Service"                                   # configuration resource type (mandatory)
                ResourceId = 'windowsService'                              # configuration resource property name (mandatory)
                ResourcePropertyName = "Name"                              # configuration resource property name (mandatory)
                DefaultValue = 'winrm'                                     # Policy parameter default value (optional)
                AllowedValues = @('wscsvc','WSearch','wcncsvc','winrm')    # Policy parameter allowed values (optional)
            }
        )

        New-GuestConfigurationPolicy -ContentUri 'https://github.com/azure/auditservice/release/AuditService.zip' `
            -DisplayName 'Monitor Windows Service Policy.' `
            -Description 'Policy to monitor service on Windows machine.' `
            -PolicyId $myPolicyGuid `
            -PolicyVersion 2.4.0 `
            -Path ./policyDefinitions `
            -Parameter $PolicyParameterInfo

    .OUTPUTS
        Returns the name and path of the Guest Configuration policy definition.
        This output can then be piped into New-AzPolicyDefinition.

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

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Guid]
        $PolicyId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Version]
        $PolicyVersion,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [System.Uri]
        $ContentUri,

        [Parameter(ParameterSetName='ManagedIdentity')]
        [System.String]
        $ManagedIdentityResourceId,

        [Parameter(ParameterSetName='ManagedIdentity')]
        [System.String]
        $LocalContentPath,

        [Parameter(ParameterSetName='ManagedIdentity')]
        [Switch]
        $UseSystemAssignmentIdentity,

        [Parameter()]
        [System.Version]
        $ContentVersion,

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
        $Tag,

        [Parameter()]
        [System.Boolean]
        $IncludeVMSS = $true,

        [Parameter()]
        [Switch]
        $ExcludeArcMachines
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

    if ($PSCmdlet.ParameterSetName -eq 'ManagedIdentity')
    {
        if (-not [string]::IsNullOrWhiteSpace($LocalContentPath))
        {
            if ([string]::IsNullOrWhiteSpace($ManagedIdentityResourceId) -and -not $UseSystemAssignmentIdentity)
            {
                throw "If LocalContentPath is provided then please include either ManagedIdentityResourceId with ExcludeArcMachine or UseSystemAssignmentIdentity."
            }
            elseif (-not [string]::IsNullOrWhiteSpace($ManagedIdentityResourceId) -and $UseSystemAssignmentIdentity)
            {
                throw "Both ManagedIdentityResourceId and UseSystemAssignmentIdentity cannot be provided together."
            }
        }
        else
        {
            if ($ManagedIdentityResourceId -or $UseSystemAssignmentIdentity)
            {
                throw "If ManagedIdentityResourceId with ExcludeArcMachine or UseSystemAssignmentIdentity is enabled please include the LocalContentPath with the path to the local package."
            }
        }
    }

    $requiredParameterProperties = @('Name', 'DisplayName', 'Description', 'ResourceType', 'ResourceId', 'ResourcePropertyName')
    $defaultValueParameterProperty = 'DefaultValue'
    $allowedValuesParameterProperty = 'AllowedValues'

    foreach ($parameterInfo in $Parameter)
    {
        foreach ($requiredParameterProperty in $requiredParameterProperties)
        {
            if (-not ($parameterInfo.Keys -contains $requiredParameterProperty))
            {
                $requiredParameterPropertyString = $requiredParameterProperties -join ', '
                throw "One of the specified policy parameters is missing the mandatory property '$requiredParameterProperty'. The mandatory properties for parameters are: $requiredParameterPropertyString"
            }

            if ($parameterInfo[$requiredParameterProperty] -isnot [string])
            {
                throw "The mandatory property '$requiredParameterProperty' of one of the specified parameters is not a string. All mandatory property values of a parameter must be strings."
            }
        }

        $parameterName = $parameterInfo['Name']
        if ($parameterInfo.Keys -contains $defaultValueParameterProperty)
        {
            if ($parameterInfo[$defaultValueParameterProperty] -isnot [string] -and
                $parameterInfo[$defaultValueParameterProperty] -isnot [boolean] -and
                $parameterInfo[$defaultValueParameterProperty] -isnot [int] -and
                $parameterInfo[$defaultValueParameterProperty] -isnot [double])
            {
                throw "The property '$defaultValueParameterProperty' of parameter '$parameterName' is not a string, boolean, integer, or double."
            }
        }

        if ($parameterInfo.Keys -contains $allowedValuesParameterProperty)
        {
            if ($parameterInfo[$allowedValuesParameterProperty] -isnot [array])
            {
                throw "The property '$allowedValuesParameterProperty' of parameter '$parameterName' is not an array."
            }

            foreach ($allowedValue in $parameterInfo[$allowedValuesParameterProperty])
            {
                if ($allowedValue -isnot [string] -and
                    $allowedValue -isnot [boolean] -and
                    $allowedValue -isnot [int] -and
                    $allowedValue -isnot [double])
                {
                    throw "One of the values in the array for property '$allowedValuesParameterProperty' of parameter '$parameterName' is not a string, boolean, integer, or double."
                }
            }
        }
    }

    # Download package
    $tempPath = Reset-GCWorkerTempDirectory
    $packagePath = Join-Path -Path $tempPath -ChildPath 'extracted'

    # This means the customer wants to use either identity to download the package.
    if (-not [string]::IsNullOrWhiteSpace($LocalContentPath))
    {
        # This means the customer wants to use the User-Defined id.
        if (-not [string]::IsNullOrWhiteSpace($ManagedIdentityResourceId))
        {
            if (-not $ExcludeArcMachines)
            {
                throw "The ManagedIdentityResourceId (user-assigned identity) and LocalContentPath parameters are defined but the -ExcludeArcMachines parameter is not. User assigned Managed identities cannot be used with Azure Arc machines. Please provide the -ExcludeArcMachines parameter to exclude Azure Arc machines and use a managed identity with this policy."
            }

            $packageFileDownloadPath = $LocalContentPath
        }
        # This means the customer wants to use the System-Assigned id.
        elseif ($UseSystemAssignmentIdentity)
        {
            $packageFileDownloadPath = $LocalContentPath
        }
        else
        {
            throw "The LocalContentPath is defined but either of the identity is not given. Please provide ManagedIdentityResourceId along with ExcludeArcMachine or use flag UseSystemAssignmentIdentity."
        }
    }
    else
    {
        $packageFileDownloadName = 'temp.zip'
        $packageFileDownloadPath = Join-Path -Path $tempPath -ChildPath $packageFileDownloadName

        if (Test-Path -Path $packageFileDownloadPath)
        {
            $null = Remove-Item -Path $packageFileDownloadPath -Force
        }

        $null = Invoke-WebRequest -Uri $ContentUri -OutFile $packageFileDownloadPath
    }

    if ($null -eq (Get-Command -Name 'Get-FileHash' -ErrorAction 'SilentlyContinue'))
    {
        $null = Import-Module -Name 'Microsoft.PowerShell.Utility'
    }
    $contentHash = (Get-FileHash -Path $packageFileDownloadPath -Algorithm 'SHA256').Hash

    # Extract package
    $null = Expand-Archive -Path $packageFileDownloadPath -DestinationPath $packagePath -Force

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
        $metaconfig = Get-Content -Path $metaconfigFilePath -Raw | ConvertFrom-Json | ConvertTo-OrderedHashtable

        if ($metaconfig.Keys -contains 'Version')
        {
            $packageVersion = $metaconfig['Version']
            Write-Verbose -Message "Downloaded package has the version $packageVersion"

            if ($null -ne $ContentVersion -and $ContentVersion -ne $packageVersion)
            {
                throw "Downloaded package version ($packageVersion) does not match specfied content version ($ContentVersion)."
            }
        }
        else
        {
            if ($null -eq $ContentVersion)
            {
                Write-Warning -Message "Failed to determine the package version from the metaconfig file '$metaconfigFileName' in the downloaded package. Please use the latest version of the New-GuestConfigurationPackage cmdlet to construct your package."
            }
            else
            {
                throw "Failed to determine the package version from the metaconfig file '$metaconfigFileName' in the downloaded package. Package version does not match specfied content version ($ContentVersion). Please use the latest version of the New-GuestConfigurationPackage cmdlet to construct your package."
            }
        }

        if ($metaconfig.Keys -contains 'Type')
        {
            $packageType = $metaconfig['Type']
            Write-Verbose -Message "Downloaded package has the type $packageType"

            if ($packageType -eq 'Audit' -and $Mode -ne 'Audit')
            {
                throw 'The specified package has been marked as Audit-only. You cannot create an Apply policy with an Audit-only package. Please change the mode of the policy or the type of the package.'
            }
        }
        else
        {
            Write-Warning -Message "Failed to determine the package type from the metaconfig file '$metaconfigFileName' in the downloaded package. Please use the latest version of the New-GuestConfigurationPackage cmdlet to construct your package."
        }
    }
    else
    {
        Write-Warning -Message "Failed to find the metaconfig file '$metaconfigFileName' in the downloaded package. Please use the latest version of the New-GuestConfigurationPackage cmdlet to construct your package."
    }

    # Determine paths
    if ([String]::IsNullOrEmpty($Path))
    {
        $Path = Get-Location
    }

    $Path = Resolve-RelativePath -Path $Path

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
        PolicyVersion = $PolicyVersion
        ConfigurationName = $packageName
        ConfigurationVersion = $packageVersion
        ContentUri = $ContentUri
        ContentHash = $contentHash
        Platform = $Platform
        AssignmentType = $Mode
        PolicyId = $PolicyId
        Parameter = $Parameter
        Tag = $Tag
        IncludeVMSS = $IncludeVMSS
    }

    if (-not [string]::IsNullOrWhiteSpace($ManagedIdentityResourceId))
    {
        $policyDefinitionContentParameters.ManagedIdentityResourceId = $ManagedIdentityResourceId
    }
    elseif ($UseSystemAssignmentIdentity)
    {
        $policyDefinitionContentParameters.ManagedIdentityResourceId = "system"
    }

    $policyDefinitionContent = New-GuestConfigurationPolicyContent @policyDefinitionContentParameters -ExcludeArcMachines:$ExcludeArcMachines

    # Convert definition hashtable to JSON
    $policyDefinitionContentJson = (ConvertTo-Json -InputObject $policyDefinitionContent -Depth 100).Replace('\u0027', "'")
    $formattedPolicyDefinitionContentJson = Format-PolicyDefinitionJson -Json $policyDefinitionContentJson

    # Write JSON to file
    $null = Set-Content -Path $filePath -Value $formattedPolicyDefinitionContentJson -Encoding 'UTF8' -Force

    # Return policy information
    $result = [PSCustomObject]@{
        PSTypeName = 'GuestConfiguration.Policy'
        Name = $packageName
        Path = $filePath
        PolicyId = $PolicyId
    }

    return $result
}
