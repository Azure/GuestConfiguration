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

    $metadataSectionParameters = @{
        DisplayName = $DisplayName
        Description = $Description
        PolicyVersion = $Version
        ConfigurationName = $ConfigurationName
        ConfigurationVersion = $ConfigurationVersion
        ContentUri = $ContentUri
        ContentHash = $ContentHash
        Parameter = $Parameter
    }

    $metadataSection = New-GuestConfigurationPolicyMetadataSection @metadataSectionParameters

    $parametersSection = New-GuestConfigurationPolicyParametersSection -Parameter $Parameter

    $conditionsSection = New-GuestConfigurationPolicyConditionsSection -Platform $Platform -Tag $Tag

    $actionSectionParameters = @{
        ConfigurationName = $ConfigurationName
        ConfigurationVersion = $ConfigurationVersion
        ContentUri = $ContentUri
        ContentHash = $ContentHash
        AssignmentType = $AssignmentType
        Parameter = $Parameter
    }

    $actionSection = New-GuestConfigurationPolicyActionSection @actionSectionParameters

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
