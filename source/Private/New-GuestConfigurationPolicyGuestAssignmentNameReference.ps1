function New-GuestConfigurationPolicyGuestAssignmentNameReference
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
