function New-GuestConfigurationPolicyContent
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
        $PolicyVersion,

        [Parameter(Mandatory = $true)]
        [String]
        $ConfigurationName,

        [Parameter(Mandatory = $true)]
        [String]
        $ConfigurationVersion,

        [Parameter(Mandatory = $true)]
        [String]
        $ContentUri,

        [Parameter()]
        [String]
        $ManagedIdentityResourceId,

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
        $Tag,

        [Parameter()]
        [System.Boolean]
        $IncludeVMSS = $true,

        [Parameter()]
        [Switch]
        $ExcludeArcMachines
    )

    $metadataSectionParameters = @{
        DisplayName = $DisplayName
        Description = $Description
        PolicyVersion = $PolicyVersion
        ConfigurationName = $ConfigurationName
        ConfigurationVersion = $ConfigurationVersion
        ContentUri = $ContentUri
        ContentHash = $ContentHash
        Parameter = $Parameter
    }

    if (-not [string]::IsNullOrWhiteSpace($ManagedIdentityResourceId))
    {
        $metadataSectionParameters.ManagedIdentityResourceId = $ManagedIdentityResourceId
    }

    $metadataSection = New-GuestConfigurationPolicyMetadataSection @metadataSectionParameters

    $parametersSection = New-GuestConfigurationPolicyParametersSection -Parameter $Parameter -ExcludeArcMachines:$ExcludeArcMachines

    $conditionsSection = New-GuestConfigurationPolicyConditionsSection -Platform $Platform -Tag $Tag -IncludeVMSS $IncludeVMSS -ExcludeArcMachines:$ExcludeArcMachines

    $actionSectionParameters = @{
        ConfigurationName = $ConfigurationName
        ConfigurationVersion = $ConfigurationVersion
        ContentUri = $ContentUri
        ContentHash = $ContentHash
        AssignmentType = $AssignmentType
        Parameter = $Parameter
        IncludeVMSS = $IncludeVMSS
    }

    if (-not [string]::IsNullOrWhiteSpace($ManagedIdentityResourceId))
    {
        $actionSectionParameters.ManagedIdentityResourceId = $ManagedIdentityResourceId
    }

    $actionSection = New-GuestConfigurationPolicyActionSection @actionSectionParameters -ExcludeArcMachines:$ExcludeArcMachines

    $policyDefinitionContent = [Ordered]@{
        properties = $metadataSection + $parametersSection + [Ordered]@{
            policyRule = [Ordered]@{
                if = $conditionsSection
                then = $actionSection
            }
        }
        name = $PolicyId
    }

    return $policyDefinitionContent
}
