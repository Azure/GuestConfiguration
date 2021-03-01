
<#
    .SYNOPSIS
        Retrieves a policy section check for the existence of a Guest Configuration Assignment with the specified parameters.
    .PARAMETER ParameterInfo
        A list of hashtables indicating the necessary info for parameters that need to be passed into this Guest Configuration Assignment.
    .EXAMPLE
        Get-GuestConfigurationAssignmentParametersExistenceConditionSection -ParameterInfo $parameterInfo
#>
function Get-GuestConfigurationAssignmentParametersExistenceConditionSection
{
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Hashtable[]]
        $ParameterInfo
    )

    $parameterValueConceatenatedStringList = @()
    foreach ($currentParameterInfo in $ParameterInfo)
    {
        $assignmentParameterName = Get-GuestConfigurationAssignmentParameterName -ParameterInfo $currentParameterInfo
        $assignmentParameterStringValue = Get-GuestConfigurationAssignmentParameterStringValue -ParameterInfo $currentParameterInfo
        $currentParameterValueConcatenatedString = "'$assignmentParameterName', '=', $assignmentParameterStringValue"
        $parameterValueConceatenatedStringList += $currentParameterValueConcatenatedString
    }

    $allParameterValueConcantenatedString = $parameterValueConceatenatedStringList -join ", ',', "
    $parameterExistenceConditionEqualsValue = "[base64(concat($allParameterValueConcantenatedString))]"
    $existenceConditionHashtable = [Ordered]@{
        field  = 'Microsoft.GuestConfiguration/guestConfigurationAssignments/parameterHash'
        equals = $parameterExistenceConditionEqualsValue
    }

    return $existenceConditionHashtable
}
