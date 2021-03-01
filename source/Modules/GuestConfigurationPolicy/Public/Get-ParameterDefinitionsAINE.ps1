<#
    .SYNOPSIS
        Define the parmameters of AINE policy for AuditWithout DINE scenario.
    .PARAMETER ParameterInfo
        A list of hashtables indicating the necessary info for parameters that need to be passed into this Guest Configuration Assignment.
#>
function Get-ParameterDefinitionsAINE
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [Hashtable[]]$ParameterInfo
    )

    $paramDefinition = [Ordered]@{}
    foreach ($item in $ParameterInfo)
    {
        $paramDefinition[$($item.ReferenceName)] = @{
            type = $item.Type
            metadata = [Ordered]@{
                displayName = $item.DisplayName
                description = $item.Description
            }
         }

         if ($item.ContainsKey('AllowedValues'))
         {
            $paramDefinition[$($item.ReferenceName)]['allowedValues'] = $item.AllowedValues
         }

         if ($item.ContainsKey('DefaultValue'))
         {
            $paramDefinition[$($item.ReferenceName)]['defaultValue'] = $item.DefaultValue
         }
    }

    return $paramDefinition
}
