<#
    .SYNOPSIS
        Define the parmameters of a policy for Audit or Deploy.
    .PARAMETER ParameterInfo
        A list of hashtables indicating the necessary info for parameters that need to be passed into this Guest Configuration Assignment.
#>
<<<<<<< HEAD:source/Modules/GuestConfigurationPolicy/Private/Get-ParameterDefinition.ps1
function Get-ParameterDefinition
=======
function Get-ParameterDefinitions
>>>>>>> 32833ae... Add support for paramInfo:source/Modules/GuestConfigurationPolicy/Private/Get-ParameterDefinitions.ps1
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
