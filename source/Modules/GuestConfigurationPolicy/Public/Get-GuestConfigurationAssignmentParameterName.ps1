

<#
    .SYNOPSIS
        Retrieves the name of a Guest Configuration Assignment parameter correctly formatted to be passed to the Guest Configuration Assignment.
    .PARAMETER ParameterInfo
        A single hashtable indicating the necessary parameter info from which to retrieve the parameter name.
    .EXAMPLE
        Get-GuestConfigurationAssignmentParameterName -ParameterInfo $currentParameterInfo
#>
function Get-GuestConfigurationAssignmentParameterName {
    [CmdletBinding()]
    [OutputType([String])]
    param
    (
        [Parameter()]
        [Hashtable]
        $ParameterInfo
    )
    $assignmentParameterName = "$($ParameterInfo.MofResourceReference);$($ParameterInfo.MofParameterName)"
    return $assignmentParameterName
}
