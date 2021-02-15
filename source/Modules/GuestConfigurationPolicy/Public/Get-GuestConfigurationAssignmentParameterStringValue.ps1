<#
    .SYNOPSIS
        Retrieves the string value of a Guest Configuration Assignment parameter correctly formatted to be passed to the Guest Configuration Assignment as part of the parameter hash.
    .PARAMETER ParameterInfo
        A single hashtable indicating the necessary parameter info from which to retrieve the parameter string value.
    .EXAMPLE
        Get-GuestConfigurationAssignmentParameterStringValue -ParameterInfo $currentParameterInfo
#>
function Get-GuestConfigurationAssignmentParameterStringValue
{
    [CmdletBinding()]
    [OutputType([String])]
    param
    (
        [Parameter()]
        [Hashtable]
        $ParameterInfo
    )
    if ($ParameterInfo.ContainsKey('ConfigurationValue'))
    {
        if ($ParameterInfo.ConfigurationValue.StartsWith('[') -and $ParameterInfo.ConfigurationValue.EndsWith(']'))
        {
            $assignmentParameterStringValue = $ParameterInfo.ConfigurationValue.Substring(1, $ParameterInfo.ConfigurationValue.Length - 2)
        }
        else
        {
            $assignmentParameterStringValue = "'$($ParameterInfo.ConfigurationValue)'"
        }
    }
    else
    {
        $assignmentParameterStringValue = "parameters('$($ParameterInfo.ReferenceName)')"
    }
    return $assignmentParameterStringValue
}
