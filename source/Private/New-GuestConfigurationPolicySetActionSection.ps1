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
        $Parameter,

        [Parameter()]
        [System.Boolean]
        $IncludeVMSS = $true
    )

    $templateFileName = "4-Action-Set.json"

    if ($IncludeVMSS)
    {
        $templateFileName = "4-Action-Set-VMSS.json"
    }
    $setActionSection = Get-GuestConfigurationPolicySectionFromTemplate -FileName $templateFileName

    $assignmentName = New-GuestConfigurationPolicyGuestAssignmentNameReference -ConfigurationName $ConfigurationName

    $setActionSection.details.name = $assignmentName

    $setActionSection.details.deployment.properties.parameters.assignmentName.value = $assignmentName

    foreach ($currentParameter in $Parameter)
    {
        $parameterName = $currentParameter['Name']
        $setActionSection.details.deployment.properties.parameters.$parameterName = [Ordered]@{
            value = "[parameters('$parameterName')]"
        }
        $setActionSection.details.deployment.properties.template.parameters.$parameterName = [Ordered]@{
            type = "string"
        }
    }

    $guestConfigMetadataSection = [Ordered]@{
        name = $ConfigurationName
        version = $ConfigurationVersion
        contentType = 'Custom'
        contentUri = $ContentUri
        contentHash = $ContentHash
        assignmentType = $AssignmentType
    }

    if ($null -ne $Parameter -and $Parameter.Count -gt 0)
    {
        $guestConfigMetadataSection.configurationParameter = @()

        foreach ($currentParameter in $Parameter)
        {
            $parameterName = $currentParameter['Name']
            $parameterReferenceString = New-GuestConfigurationPolicyParameterReferenceString -Parameter $currentParameter

            $guestConfigMetadataSection.configurationParameter += [Ordered]@{
                name = $parameterReferenceString
                value = "[parameters('$parameterName')]"
            }
        }
    }

    $setActionSection.details.deployment.properties.template.resources[0].properties.guestConfiguration = $guestConfigMetadataSection
    $setActionSection.details.deployment.properties.template.resources[1].properties.guestConfiguration = $guestConfigMetadataSection
    $setActionSection.details.deployment.properties.template.resources[2].properties.guestConfiguration = $guestConfigMetadataSection

    return $setActionSection
}
