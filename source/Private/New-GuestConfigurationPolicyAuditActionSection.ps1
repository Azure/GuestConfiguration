function New-GuestConfigurationPolicyAuditActionSection
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

    $templateFileName = "4-Action-Audit.json"
    $auditActionSection = Get-GuestConfigurationPolicySectionFromTemplate -FileName $templateFileName

    $assignmentName = New-GuestConfigurationPolicyGuestAssignmentNameReference -ConfigurationName $ConfigurationName

    $auditActionSection.details.name = $assignmentName

    return $auditActionSection
}
