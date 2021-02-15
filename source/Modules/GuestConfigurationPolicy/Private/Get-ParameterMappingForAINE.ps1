

<#
    .SYNOPSIS
        Define the policy parameter mapping to the parameters of the MOF file.
    .PARAMETER ParameterInfo
        A list of hashtables indicating the necessary info for parameters that need to be passed into this Guest Configuration Assignment.
#>
function  Get-ParameterMappingForAINE
{
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param
    (
        [Parameter(Mandatory = $true)]
        [array]
        $ParameterInfo
    )
    $paramMapping =  @{}
    foreach($item in $ParameterInfo)
    {
        $paramMapping[$item.ReferenceName] = ("{0};{1}" -f $item.MofResourceReference, $item.MofParameterName)
    }
    return $paramMapping
}
