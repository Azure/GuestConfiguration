

<#
    .SYNOPSIS
        Define the policy parameter mapping to the parameters of the MOF file.
        Expected output should follow the following format:
            {
                "name": "[MyFile]createFoobarTestFile;path",
                "value": "[parameters('path')]"
            },
            {
                "name": "[MyFile]createFoobarTestFile;ensure",
                "value": "[parameters('ensure')]"
            },
            {
                "name": "[MyFile]createFoobarTestFile;content",
                "value": "[parameters('content')]"
            }

    .PARAMETER ParameterInfo
        A list of hashtables indicating the necessary info for parameters that need to be passed into this Guest Configuration Assignment.
#>
function Get-ParameterMappingForDINE
{
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param
    (
        [Parameter(Mandatory = $true)]
        [array]
        $ParameterInfo
    )

    $paramMapping = @()
    foreach ($item in $ParameterInfo)
    {
        $parameterPair = @{
            "name" = ("{0};{1}" -f $item.MofResourceReference, $item.MofParameterName)
            "value" = ("[parameters('{0}')]" -f $item.ReferenceName)
        }
        $paramMapping += $parameterPair
    }

    return $paramMapping
}
