
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
        The name and value of a tag on the policy definition.

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
    $policyDefinitionContent = New-GuestConfigurationPolicyDefinitionContent @policyDefinitionContentParameters

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

    # Check if the package is signed:
    # $packageIsSigned = (($null -ne (Get-ChildItem -Path $unzippedPkgPath -Filter *.cat)) -or
    # (($null -ne (Get-ChildItem -Path $unzippedPkgPath -Filter *.asc)) -and ($null -ne (Get-ChildItem -Path $unzippedPkgPath -Filter *.sha256sums))))
}

function New-GuestConfigurationPolicyDefinitionContent
{
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $DisplayName,

        [Parameter(Mandatory = $true)]
        [String]
        $Description,

        [Parameter(Mandatory = $true)]
        [String]
        $Version,

        [Parameter(Mandatory = $true)]
        [String]
        $ConfigurationName,

        [Parameter(Mandatory = $true)]
        [String]
        $ConfigurationVersion,

        [Parameter(Mandatory = $true)]
        [String]
        $ContentUri,

        [Parameter(Mandatory = $true)]
        [String]
        $ContentHash,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Windows', 'Linux')]
        [String]
        $Platform,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Audit', 'ApplyAndMonitor', 'ApplyAndAutoCorrect')]
        [String]
        $AssignmentType,

        [Parameter(Mandatory = $true)]
        [ValidateNotNull()]
        [String]
        $PolicyId,

        [Parameter()]
        [Hashtable[]]
        $Parameter,

        [Parameter()]
        [Hashtable]
        $Tag
    )

    $guestConfigurationMetadataParameters = @{
        ConfigurationName = $ConfigurationName
        ConfigurationVersion = $ConfigurationVersion
        ContentUri = $ContentUri
        ContentHash = $ContentHash
        Parameter = $Parameter
    }
    $guestConfigurationMetadata = New-GuestConfigurationPolicyDefinitionMetadata @guestConfigurationMetadataParameters

    $policyParameters = New-GuestConfigurationPolicyDefinitionParameters -Parameter $Parameter

    $policyRuleParameters = @{
        Platform = $Platform
        ConfigurationName = $ConfigurationName
        ConfigurationVersion = $ConfigurationVersion
        ContentUri = $ContentUri
        ContentHash = $ContentHash
        AssignmentType = $AssignmentType
        Parameter = $Parameter
        Tag = $Tag
    }
    $policyRule = New-GuestConfigurationPolicyDefinitionPolicyRule @policyRuleParameters

    $policyDefinition = [Ordered]@{
        properties = [Ordered]@{
            displayName = $DisplayName
            policyType = 'Custom'
            mode = 'Indexed'
            description = $Description
            metadata = [Ordered]@{
                category = 'Guest Configuration'
                version = $Version
                requiredProviders = @('Microsoft.GuestConfiguration')
                guestConfiguration = $guestConfigurationMetadata
            }
            parameters  = $policyParameters
            policyRule = $policyRule
        }
        name = $PolicyId # Do we need this for new policies?
    }

    return $policyDefinition
}

function New-GuestConfigurationPolicyDefinitionMetadata
{
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ConfigurationName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ConfigurationVersion,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ContentUri,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ContentHash,

        [Parameter()]
        [Hashtable[]]
        $Parameter
    )

    $metadata = [Ordered]@{
        name = $ConfigurationName
        version = $ConfigurationVersion
        contentType = 'Custom'
        contentUri = $ContentUri
        contentHash = $ContentHash
    }

    if ($null -ne $Parameter -and $Parameter.Count -gt 0)
    {
        $parameters = @()

        foreach ($currentParameter in $Parameter)
        {
            $configurationParameterDefinition = [Ordered]@{
                $currentParameter['Name'] = New-GuestConfigurationPolicyDefinitionParameterReferenceString -Parameter $currentParameter
            }
            $parameters += $configurationParameterDefinition
        }

        $metadata['configurationParameter'] = $parameters
    }

    return $metadata
}

function New-GuestConfigurationPolicyDefinitionParameters
{
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param
    (
        [Parameter()]
        [Hashtable[]]
        $Parameter
    )

    $parameters = [Ordered]@{
        IncludeArcMachines = [Ordered]@{
            type = 'boolean'
            metadata = [Ordered]@{
                displayName = 'Include Arc connected machines'
                description = 'By selecting this option, you agree to be charged monthly per Arc connected machine.'
            }
            defaultValue = $false
        }
    }

    if ($null -ne $Parameter -and $Parameter.Count -gt 0)
    {
        $optionalFields = @('AllowedValues', 'DefaultValue')

        foreach ($currentParameter in $Parameter)
        {
            $configurationParameterDefinition = [Ordered]@{
                type = 'string'
                metadata = [Ordered]@{
                    displayName = $currentParameter['DisplayName']
                    description = $currentParameter['Description']
                }
            }

            foreach ($optionalField in $optionalFields)
            {
                $fieldName = $optionalField.Substring(0, 1).ToLower() + $optionalField.Substring(1)
                if ($currentParameter.ContainsKey($optionalField))
                {
                    $configurationParameterDefinition[$fieldName] = $currentParameter[$optionalField]
                }
            }

            $parameters[$currentParameter['Name']] = $configurationParameterDefinition
        }
    }

    return $parameters
}

function New-GuestConfigurationPolicyDefinitionPolicyRule
{
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Windows', 'Linux')]
        [String]
        $Platform,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ConfigurationName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ConfigurationVersion,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ContentUri,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ContentHash,

        [Parameter()]
        [ValidateSet('Audit', 'ApplyAndAutoCorrect', 'ApplyAndMonitor')]
        [String]
        $AssignmentType = 'Audit',

        [Parameter()]
        [Hashtable[]]
        $Parameter,

        [Parameter()]
        [System.Collections.Hashtable]
        $Tag
    )

    $conditions = New-GuestConfigurationPolicyRuleConditions -Platform $Platform -Tag $Tag

    $actionParameters = @{
        ConfigurationName = $ConfigurationName
        ConfigurationVersion = $ConfigurationVersion
        ContentUri = $ContentUri
        ContentHash = $ContentHash
        AssignmentType = $AssignmentType
        Parameter = $Parameter
    }
    $action = New-GuestConfigurationPolicyRuleAction @actionParameters

    $policyRuleHashtable = [Ordered]@{
        if = $conditions
        then = $action
    }

    return $policyRuleHashtable
}

#region Policy Rule Conditions
function New-GuestConfigurationPolicyRuleConditions
{
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Windows', 'Linux')]
        [String]
        $Platform,

        [Parameter()]
        [System.Collections.Hashtable]
        $Tag
    )

    $virtualMachineConditions = New-GuestConfigurationPolicyRuleVirtualMachineConditions -Platform $Platform
    $hybridMachineConditions = New-GuestConfigurationPolicyRuleHybridMachineConditions -Platform $Platform

    $machineConditions = [Ordered]@{
        anyOf = @(
            $virtualMachineConditions,
            $hybridMachineConditions
        )
    }

    if ($null -eq $Tag -or $Tag.Count -eq 0)
    {
        $conditions = $machineConditions
    }
    else
    {
        $tagCondition = New-GuestConfigurationPolicyRuleTagConditions -Tag $Tag

        $conditions = [Ordered]@{
            allOf = @(
                $machineConditions,
                $tagCondition
            )
        }
    }

    return $conditions
}

function New-GuestConfigurationPolicyRuleTagConditions
{
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param
    (
        [Parameter()]
        [System.Collections.Hashtable]
        $Tag
    )

    $tagConditionList = @()

    foreach ($tagName in $Tag.Keys)
    {
        $tagConditionList += [Ordered]@{
            field  = "tags['$tagName']"
            equals = $($Tag[$tagName])
        }
    }

    if ($tagConditionList.Count -eq 1)
    {
        $tagConditions = $tagConditionList[0]
    }
    elseif ($tagConditionList.Count -gt 1)
    {
        $tagConditions = [Ordered]@{
            allOf = $tagConditionList
        }
    }
    else
    {
        $tagConditions = $null
    }

    return $tagConditions
}

function New-GuestConfigurationPolicyRuleHybridMachineConditions
{
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Windows', 'Linux')]
        [String]
        $Platform
    )

    $platformString = $Platform.ToLower()

    $hybridMachineConditions = [Ordered]@{
        allOf = @(
            [Ordered]@{
                value  = "[parameters('IncludeArcMachines')]"
                equals = $true
            },
            [Ordered]@{
                anyOf = @(
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{
                                field = 'type'
                                equals = 'Microsoft.HybridCompute/machines'
                            },
                            [Ordered]@{
                                field = 'Microsoft.HybridCompute/imageOffer'
                                like = '{0}*' -f $platformString
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{
                                field = 'type'
                                equals = 'Microsoft.ConnectedVMwarevSphere/virtualMachines'
                            },
                            [Ordered]@{
                                field = 'Microsoft.ConnectedVMwarevSphere/virtualMachines/osProfile.osType'
                                like = '{0}*' -f $platformString
                            }
                        )
                    }
                )
            }
        )
    }

    return $hybridMachineConditions
}

function New-GuestConfigurationPolicyRuleVirtualMachineConditions
{
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Windows', 'Linux')]
        [String]
        $Platform
    )

    $imageConditions = New-GuestConfigurationPolicyRuleVirtualMachineImageConditions -Platform $Platform

    $virtualMachineConditions = [Ordered]@{
        allOf = @(
            [Ordered]@{
                field  = 'type'
                equals = 'Microsoft.Compute/virtualMachines'
            },
            $imageConditions
        )
    }

    return $virtualMachineConditions
}

function New-GuestConfigurationPolicyRuleVirtualMachineImageConditions
{
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Windows', 'Linux')]
        [String]
        $Platform
    )

    if ($Platform -eq 'Windows')
    {
        $imageConditions = Get-GuestConfigurationPolicyRuleVirtualMachineWindowsImageConditions
    }
    else
    {
        $imageConditions = Get-GuestConfigurationPolicyRuleVirtualMachineLinuxImageConditions
    }

    $policyRuleImageConditions = Format-GuestConfigurationPolicyRuleVirtualMachineImageConditions -ImageConditions $imageConditions

    return $policyRuleImageConditions
}

function Get-GuestConfigurationPolicyRuleVirtualMachineWindowsImageConditions
{
    [CmdletBinding()]
    [OutputType([Hashtable])]
    param ()

    $imageConditions = @{
        Conditions = @(
            @{
                PublisherIn = @(
                    'esri',
                    'incredibuild',
                    'MicrosoftDynamicsAX',
                    'MicrosoftSharepoint',
                    'MicrosoftVisualStudio',
                    'MicrosoftWindowsDesktop',
                    'MicrosoftWindowsServerHPCPack'
                )
            }
            @{
                PublisherEquals = 'MicrosoftWindowsServer'
                SKUNotLike = '2008*'
            },
            @{
                PublisherEquals = 'MicrosoftSQLServer'
                OfferNotLike = 'SQL2008*'
            },
            @{
                PublisherEquals = 'microsoft-dsvm'
                OfferLike = 'dsvm-win*'
            },
            @{
                PublisherEquals = 'microsoft-ads'
                OfferIn = @(
                    'standard-data-science-vm',
                    'windows-data-science-vm'
                )
            },
            @{
                PublisherEquals = 'batch'
                OfferEquals = 'rendering-windows2016'
            },
            @{
                PublisherEquals = 'center-for-internet-security-inc'
                OfferLike = 'cis-windows-server-201*'
            },
            @{
                PublisherEquals = 'pivotal'
                OfferLike = 'bosh-windows-server*'
            },
            @{
                PublisherEquals = 'cloud-infrastructure-services'
                OfferLike = 'ad*'
            }
        )
        UnknownImageConditions = @{
            OSProfileFieldExists = 'windowsConfiguration'
            StorageProfileOSTypeLike = 'Windows*'
            UnknownFieldConditions = @(
                @{
                    SKUExists = $false
                },
                @{
                    OfferNotLike = 'SQL2008*'
                    SKUNotLike = '2008*'
                }
            )
        }
    }

    return $imageConditions
}

function Get-GuestConfigurationPolicyRuleVirtualMachineLinuxImageConditions
{
    [CmdletBinding()]
    [OutputType([Hashtable])]
    param ()

    $imageConditions = @{
        Conditions = @(
            @{
                PublisherIn = @(
                    'microsoft-aks',
                    'qubole-inc',
                    'datastax',
                    'couchbase',
                    'scalegrid',
                    'checkpoint',
                    'paloaltonetworks'
                )
            },
            @{
                PublisherEquals = 'OpenLogic'
                OfferLike = 'CentOS*'
                SKUNotLike = '6*'
            },
            @{
                PublisherEquals = 'Oracle'
                OfferEquals = 'Oracle-Linux'
                SKUNotLike = '6*'
            },
            @{
                PublisherEquals = 'RedHat'
                OfferIn = @(
                    'RHEL',
                    'RHEL-HA'
                    'RHEL-SAP',
                    'RHEL-SAP-APPS',
                    'RHEL-SAP-HA',
                    'RHEL-SAP-HANA'
                )
                SKUNotLike = '6*'
            },
            @{
                PublisherEquals = 'RedHat'
                OfferIn = @(
                    'osa',
                    'rhel-byos'
                )
            },
            @{
                PublisherEquals = 'center-for-internet-security-inc'
                OfferIn = @(
                    'cis-centos-7-l1',
                    'cis-centos-7-v2-1-1-l1'
                    'cis-centos-8-l1',
                    'cis-debian-linux-8-l1',
                    'cis-debian-linux-9-l1',
                    'cis-nginx-centos-7-v1-1-0-l1',
                    'cis-oracle-linux-7-v2-0-0-l1',
                    'cis-oracle-linux-8-l1',
                    'cis-postgresql-11-centos-linux-7-level-1',
                    'cis-rhel-7-l2',
                    'cis-rhel-7-v2-2-0-l1',
                    'cis-rhel-8-l1',
                    'cis-suse-linux-12-v2-0-0-l1',
                    'cis-ubuntu-linux-1604-v1-0-0-l1',
                    'cis-ubuntu-linux-1804-l1'
                )
            },
            @{
                PublisherEquals = 'credativ'
                OfferEquals = 'Debian'
                SKUNotLike = '7*'
            },
            @{
                PublisherEquals = 'Suse'
                OfferLike = 'SLES*'
                SKUNotLike = '11*'
            },
            @{
                PublisherEquals = 'Canonical'
                OfferEquals = 'UbuntuServer'
                SKUNotLike = '12*'
            },
            @{
                PublisherEquals = 'microsoft-dsvm'
                OfferIn = @(
                    'linux-data-science-vm-ubuntu',
                    'azureml'
                )
            },
            @{
                PublisherEquals = 'cloudera'
                OfferEquals = 'cloudera-centos-os'
                SKUNotLike = '6*'
            },
            @{
                PublisherEquals = 'cloudera'
                OfferEquals = 'cloudera-altus-centos-os'
            },
            @{
                PublisherEquals = 'microsoft-ads'
                OfferLike = 'linux*'
            }
        )
        UnknownImageConditions = @{
            OSProfileFieldExists = 'linuxConfiguration'
            StorageProfileOSTypeLike = 'Linux*'
            UnknownFieldConditions = @(
                @{
                    PublisherExists = $false
                },
                @{
                    PublisherNotIn = @(
                        "OpenLogic",
                        "RedHat",
                        "credativ",
                        "Suse",
                        "Canonical",
                        "microsoft-dsvm",
                        "cloudera",
                        "microsoft-ads",
                        "center-for-internet-security-inc",
                        "Oracle",
                        "AzureDatabricks",
                        "azureopenshift"
                    )
                }
            )
        }
    }

    return $imageConditions
}

function Format-GuestConfigurationPolicyRuleVirtualMachineImageConditions
{
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param
    (
        [Parameter(Mandatory = $true)]
        [Hashtable]
        $ImageConditions
    )

    $formattedImageConditions = @()
    foreach ($condition in $ImageConditions['Conditions'])
    {
        $conditionBlock = Format-GuestConfigurationPolicyRuleVirtualMachineImageConditionBlock -ImageCondition $condition

        if ($null -ne $conditionBlock)
        {
            $formattedImageConditions += $conditionBlock
        }
    }

    $unknownImageConditions = @()
    foreach ($condition in $ImageConditions['UnknownImageConditions']['UnknownFieldConditions'])
    {
        $conditionBlock = Format-GuestConfigurationPolicyRuleVirtualMachineImageConditionBlock -ImageCondition $condition

        if ($null -ne $conditionBlock)
        {
            $unknownImageConditions += $conditionBlock
        }
    }

    $policyRuleImageConditions = [Ordered]@{
        anyOf = $formattedImageConditions + [Ordered]@{
            allOf = @(
                [Ordered]@{
                    anyOf = @(
                        [Ordered]@{
                            field = "Microsoft.Compute/virtualMachines/osProfile.{0}" -f $ImageConditions['UnknownImageConditions']['OSProfileFieldExists']
                            exists = $true
                        },
                        [Ordered]@{
                            field = 'Microsoft.Compute/virtualMachines/storageProfile.osDisk.osType'
                            like = $ImageConditions['UnknownImageConditions']['StorageProfileOSTypeLike']
                        }
                    )
                },
                [Ordered]@{
                    anyOf = $unknownImageConditions
                }
            )
        }
    }

    return $policyRuleImageConditions
}

function Format-GuestConfigurationPolicyRuleVirtualMachineImageConditionBlock
{
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Hashtable]
        $ImageCondition
    )

    $formattedBlock = $null
    $conditionList = @()

    foreach ($conditionKey in $ImageCondition.Keys)
    {
        $condition = Format-GuestConfigurationPolicyRuleVirtualMachineImageConditionEntry -Key $conditionKey -Value $ImageCondition[$conditionKey]

        if ($null -ne $condition)
        {
            $conditionList += $condition
        }
    }

    if ($conditionList.Count -gt 1)
    {
        $formattedBlock = [Ordered]@{
            allOf = $conditionList
        }
    }
    elseif ($conditionList.Count -eq 1)
    {
        $formattedBlock = $conditionList[0]
    }

    return $formattedBlock
}

function Format-GuestConfigurationPolicyRuleVirtualMachineImageConditionEntry
{
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Key,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $Value
    )

    $validFields = @('SKU', 'Offer', 'Publisher')

    foreach ($validField in $validFields)
    {
        if ($Key.StartsWith($validField))
        {
            $fieldName = 'Microsoft.Compute/image{0}' -f $validField

            $operationBase = $Key.Substring($validField.Length)
            $operationName = $operationBase.Substring(0, 1).ToLower() + $operationBase.Substring(1)

            $imageCondition = [Ordered]@{
                field = $fieldName
                $operationName = $Value
            }

            return $imageCondition
        }
    }

    return $null
}
#endregion

function New-GuestConfigurationPolicyRuleAction
{
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ConfigurationName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ConfigurationVersion,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ContentUri,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ContentHash,

        [Parameter()]
        [ValidateSet('Audit', 'ApplyAndAutoCorrect', 'ApplyAndMonitor')]
        [String]
        $AssignmentType = 'Audit',

        [Parameter()]
        [Hashtable[]]
        $Parameter
    )

    if ($AssignmentType -eq 'Audit')
    {
        $action = [Ordered]@{
            effect  = 'auditIfNotExists'
            details = New-GuestConfigurationPolicyRuleActionAINEDetails -ConfigurationName $ConfigurationName -Parameter $Parameter
        }
    }
    else
    {
        $dineDetailsParameters = @{
            ConfigurationName = $ConfigurationName
            ConfigurationVersion = $ConfigurationVersion
            ContentUri = $ContentUri
            ContentHash = $ContentHash
            AssignmentType = $AssignmentType
            Parameter = $Parameter
        }
        $dineDetails = New-GuestConfigurationPolicyRuleActionDINEDetails @dineDetailsParameters

        $action = [Ordered]@{
            effect  = 'deployIfNotExists'
            details = $dineDetails
        }
    }

    return $action
}

function New-GuestConfigurationPolicyRuleActionDINEDetails
{
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $ConfigurationName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ConfigurationVersion,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ContentUri,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ContentHash,

        [Parameter(Mandatory = $true)]
        [ValidateSet('ApplyAndMonitor', 'ApplyAndAutoCorrect')]
        [String]
        $AssignmentType,

        [Parameter()]
        [Hashtable[]]
        $Parameter
    )

    $existenceCondition = New-GuestConfigurationPolicyRuleActionDetailsExistenceCondition -Parameter $Parameter

    $deploymentDefinitionParameters = @{
        ConfigurationName = $ConfigurationName
        ConfigurationVersion = $ConfigurationVersion
        ContentUri = $ContentUri
        ContentHash = $ContentHash
        AssignmentType = $AssignmentType
        Parameter = $Parameter
    }
    $deploymentDefinition = New-GuestConfigurationPolicyRuleActionDINEDetailsDeploymentDefinition @deploymentDefinitionParameters

    $details = [Ordered]@{
        roleDefinitionIds = @(
            '/providers/Microsoft.Authorization/roleDefinitions/088ab73d-1256-47ae-bea9-9de8e7131f31'
        )
        type = 'Microsoft.GuestConfiguration/guestConfigurationAssignments'
        name = New-GuestConfigurationPolicyRuleGuestAssignmentName -ConfigurationName $ConfigurationName
        existenceCondition = $existenceCondition
        deployment = $deploymentDefinition
    }

    return $details
}

function New-GuestConfigurationPolicyRuleActionDINEDetailsDeploymentDefinition
{
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ConfigurationName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ConfigurationVersion,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ContentUri,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ContentHash,

        [Parameter(Mandatory = $true)]
        [ValidateSet('ApplyAndMonitor', 'ApplyAndAutoCorrect')]
        [String]
        $AssignmentType,

        [Parameter()]
        [Hashtable[]]
        $Parameter
    )

    $newParametersDefinitionParameters = @{
        ConfigurationName = $ConfigurationName
        ConfigurationVersion = $ConfigurationVersion
        ContentUri = $ContentUri
        ContentHash = $ContentHash
        Parameter = $Parameter
    }
    $parametersDefinition = New-GuestConfigurationPolicyRuleActionDINEDetailsDeploymentParametersDefinition @newParametersDefinitionParameters

    $template = New-GuestConfigurationPolicyRuleActionDINEDetailsDeploymentTemplate @PSBoundParameters

    $deploymentDefinition = [Ordered]@{
        properties = [Ordered]@{
            mode = 'incremental'
            parameters = $parametersDefinition
            template = $template
        }
    }

    return $deploymentDefinition
}

function New-GuestConfigurationPolicyRuleActionDINEDetailsDeploymentTemplate
{
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $ConfigurationName,

        [Parameter(Mandatory = $true)]
        [String]
        $ConfigurationVersion,

        [Parameter(Mandatory = $true)]
        [ValidateSet('ApplyAndMonitor', 'ApplyAndAutoCorrect')]
        [String]
        $AssignmentType,

        [Parameter(Mandatory = $true)]
        [String]
        $ContentUri,

        [Parameter(Mandatory = $true)]
        [String]
        $ContentHash,

        [Parameter()]
        [Hashtable[]]
        $Parameter
    )

    $parametersDefinition = New-GuestConfigurationPolicyRuleActionDINEDetailsDeploymentTemplateParametersDefinition -Parameter $Parameter

    $virtualMachineReference = 'Microsoft.Compute/virtualMachines'
    $hybridMachineReference = 'Microsoft.HybridCompute/machines'

    $virtualMachineTemplate  = New-GuestConfigurationPolicyRuleActionDINEDetailsDeploymentTemplateResources -MachineReference $virtualMachineReference @PSBoundParameters
    $hybridMachineTemplate = New-GuestConfigurationPolicyRuleActionDINEDetailsDeploymentTemplateResources -MachineReference $hybridMachineReference @PSBoundParameters

    $template = [Ordered]@{
        '$schema' = 'https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#'
        contentVersion = '1.0.0.0'
        parameters = $parametersDefinition
        resources = @(
            $virtualMachineTemplate,
            $hybridMachineTemplate
        )
    }

    return $template
}

function New-GuestConfigurationPolicyRuleActionDINEDetailsDeploymentTemplateResources
{
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $MachineReference,

        [Parameter(Mandatory = $true)]
        [String]
        $ConfigurationName,

        [Parameter(Mandatory = $true)]
        [String]
        $ConfigurationVersion,

        [Parameter(Mandatory = $true)]
        [ValidateSet('ApplyAndMonitor', 'ApplyAndAutoCorrect')]
        [String]
        $AssignmentType,

        [Parameter(Mandatory = $true)]
        [String]
        $ContentUri,

        [Parameter(Mandatory = $true)]
        [String]
        $ContentHash,

        [Parameter()]
        [Hashtable[]]
        $Parameter
    )

    $templateResources = [Ordered]@{
        condition = "[equals(toLower(parameters('type')), toLower('$MachineReference'))]"
        apiVersion = '2018-11-20'
        type = "$MachineReference/providers/guestConfigurationAssignments"
        name = "[concat(parameters('vmName'), '/Microsoft.GuestConfiguration/', parameters('assignmentName'))]"
        location = "[parameters('location')]"
        properties = [Ordered]@{
            guestConfiguration = [Ordered]@{
                name = $ConfigurationName
                version = $ConfigurationVersion
                assignmentType = $AssignmentType
                contentUri = $ContentUri
                contentHash = $ContentHash
                contentType = 'Custom'
            }
        }
    }

    if ($null -ne $Parameter -and $Parameter.Count -gt 0)
    {
        $configurationParameters = @()

        foreach ($currentParameter in $Parameter)
        {
            $configurationParameters += [Ordered]@{
                name = New-GuestConfigurationPolicyDefinitionParameterReferenceString -Parameter $currentParameter
                value = "[parameters('$($currentParameter.Name)')]"
            }
        }

        $templateResources['properties']['guestConfiguration']['configurationParameter'] = $configurationParameters
    }

    return $templateResources
}

function New-GuestConfigurationPolicyRuleActionDINEDetailsDeploymentTemplateParametersDefinition
{
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param
    (
        [Parameter()]
        [Hashtable[]]
        $Parameter
    )

    $parametersDefinition = [Ordered]@{
        vmName = [Ordered]@{
            type = 'string'
        }
        location = [Ordered]@{
            type = 'string'
        }
        type = [Ordered]@{
            type = 'string'
        }
        assignmentName = [Ordered]@{
            type = 'string'
        }
        contentUri = [Ordered]@{
            type = 'string'
        }
        contentHash = [Ordered]@{
            type = 'string'
        }
        configurationVersion = [Ordered]@{
            type = 'string'
        }
    }

    foreach ($currentParameter in $Parameter)
    {
        $referenceName = $currentParameter['Name']
        $parametersDefinition[$referenceName] = [Ordered]@{
            type = 'string'
        }
    }

    return $parametersDefinition
}

function New-GuestConfigurationPolicyRuleActionDINEDetailsDeploymentParametersDefinition
{
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ConfigurationName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ConfigurationVersion,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ContentUri,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ContentHash,

        [Parameter()]
        [Hashtable[]]
        $Parameter
    )

    $parametersDefinition = [Ordered]@{
        vmName = [Ordered]@{
            value = "[field('name')]"
        }
        location = [Ordered]@{
            value = "[field('location')]"
        }
        type = [Ordered]@{
            value = "[field('type')]"
        }
        assignmentName = [Ordered]@{
            value = New-GuestConfigurationPolicyRuleGuestAssignmentName -ConfigurationName $ConfigurationName
        }
        contentUri = [Ordered]@{
            value = $ContentUri
        }
        contentHash = [Ordered]@{
            value = $ContentHash
        }
        configurationVersion = [Ordered]@{
            value = $ConfigurationVersion
        }
    }

    foreach ($currentParameter in $Parameter)
    {
        $referenceName = $currentParameter['Name']
        $parametersDefinition[$referenceName] = [Ordered]@{
            value = "[parameters('$referenceName')]"
        }
    }

    return $parametersDefinition
}
function New-GuestConfigurationPolicyRuleActionAINEDetails
{
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $ConfigurationName,

        [Parameter()]
        [Hashtable[]]
        $Parameter
    )

    $existenceCondition = New-GuestConfigurationPolicyRuleActionDetailsExistenceCondition -Parameter $Parameter

    $details = [Ordered]@{
        type = 'Microsoft.GuestConfiguration/guestConfigurationAssignments'
        name = New-GuestConfigurationPolicyRuleGuestAssignmentName -ConfigurationName $ConfigurationName
        existenceCondition = $existenceCondition
    }

    return $details
}

function New-GuestConfigurationPolicyRuleGuestAssignmentName
{
    [CmdletBinding()]
    [OutputType([String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $ConfigurationName
    )

    $guestAssignmentName = "[concat('{0}`$pid', uniqueString(policy().assignmentId, policy().definitionReferenceId))]" -f $ConfigurationName
    return $guestAssignmentName
}

function New-GuestConfigurationPolicyRuleActionDetailsExistenceCondition
{
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param
    (
        [Parameter()]
        [Hashtable[]]
        $Parameter
    )

    $complianceStatusCondition = [Ordered]@{
        field = 'Microsoft.GuestConfiguration/guestConfigurationAssignments/complianceStatus'
        equals = 'Compliant'
    }

    if ($null -eq $Parameter -or $Parameter.Count -eq 0)
    {
        $existenceCondition = $complianceStatusCondition
    }
    else
    {
        $parameterHashString = Get-GuestConfigurationPolicyRuleActionDetailsExistenceConditionParameterHashString -Parameter $Parameter

        $parameterHashCondition = [Ordered]@{
            field = 'Microsoft.GuestConfiguration/guestConfigurationAssignments/parameterHash'
            equals = $parameterHashString
        }

        $existenceCondition = [Ordered]@{
            allOf = @(
                $complianceStatusCondition,
                $parameterHashCondition
            )
        }
    }

    return $existenceCondition
}

function Get-GuestConfigurationPolicyRuleActionDetailsExistenceConditionParameterHashString
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Hashtable[]]
        $Parameter
    )

    $parameterHashStringList = @()

    foreach ($currentParameter in $Parameter)
    {
        $parameterName = New-GuestConfigurationPolicyDefinitionParameterReferenceString -Parameter $currentParameter
        $parameterStringValue = Get-GuestConfigurationAssignmentParameterStringValue -Parameter $currentParameter
        $currentParameterHashString = "'$parameterName', '=', $parameterStringValue"
        $parameterHashStringList += $currentParameterHashString
    }

    $concantenatedParameterHashStrings = $parameterHashStringList -join ", ',', "
    $parameterHashString = "[base64(concat($concantenatedParameterHashStrings))]"

    return $parameterHashString
}

function Get-GuestConfigurationAssignmentParameterStringValue
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Hashtable]
        $Parameter
    )

    $assignmentParameterStringValue = "parameters('$($Parameter['Name'])')"
    return $assignmentParameterStringValue
}

function New-GuestConfigurationPolicyDefinitionParameterReferenceString
{
    [CmdletBinding()]
    [OutputType([String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Hashtable]
        $Parameter
    )

    $parameterReferenceString = "[$($Parameter['ResourceType'])]$($Parameter['ResourceId']);$($Parameter['ResourcePropertyName'])"
    return $parameterReferenceString
}
