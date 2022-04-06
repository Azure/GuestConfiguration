function New-GuestConfigurationPolicySetActionSection
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

    $templateFileName = "4-Action-Set.json"
    $setActionSection = Get-GuestConfigurationPolicySectionFromTemplate -FileName $templateFileName

    $assignmentName = New-GuestConfigurationPolicyGuestAssignmentNameReference -ConfigurationName $ConfigurationName

    $setActionSection.details.name = $assignmentName

    $setActionSection.details.deployment.properties.parameters.assignmentName.value = $assignmentName

    foreach ($currentParameter in $Parameter)
    {
        $parameterName = $currentParameter['Name']
        $setActionSection.details.deployment.properties.parameters.$parameterName = [Ordered]@{
            value = "[parameter('$parameterName')]"
        }
        $setActionSection.details.deployment.properties.template.parameters.$parameterName = [Ordered]@{
            type = "string"
        }
    }

    $guestConfigruationMetadataSectionParameters = @{
        ConfigurationName = $ConfigurationName
        ConfigurationVersion = $ConfigurationVersion
        ContentUri = $ContentUri
        ContentHash = $ContentHash
        Parameter = $Parameter
    }

    $guestConfigMetadataSection = New-GuestConfigurationPolicyMetadataSection @guestConfigruationMetadataSectionParameters
    $guestConfigMetadataSection['assignmentType'] = $AssignmentType

    $setActionSection.details.deployment.properties.template.resources[0].properties.guestConfiguration = $guestConfigMetadataSection
    $setActionSection.details.deployment.properties.template.resources[1].properties.guestConfiguration = $guestConfigMetadataSection

    return $setActionSection
}
