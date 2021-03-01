function Update-PolicyParameter
{
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [Hashtable[]]
        $parameter
    )

    $updatedParameterInfo = @()

    foreach ($parmInfo in $Parameter)
    {
        $param = @{ }
        $param['Type'] = 'string'

        if ($parmInfo.Contains('Name'))
        {
            $param['ReferenceName'] = $parmInfo.Name
        }
        else
        {
            throw "Policy parameter is missing a mandatory property 'Name'. Please make sure that parameter name is specified in Policy parameter."
        }

        if ($parmInfo.Contains('DisplayName'))
        {
            $param['DisplayName'] = $parmInfo.DisplayName
        }
        else
        {
            throw "Policy parameter is missing a mandatory property 'DisplayName'. Please make sure that parameter display name is specified in Policy parameter."
        }

        if ($parmInfo.Contains('Description'))
        {
            $param['Description'] = $parmInfo.Description
        }

        if (-not $parmInfo.Contains('ResourceType'))
        {
            throw "Policy parameter is missing a mandatory property 'ResourceType'. Please make sure that configuration resource type is specified in Policy parameter."
        }
        elseif (-not $parmInfo.Contains('ResourceId'))
        {
            throw "Policy parameter is missing a mandatory property 'ResourceId'. Please make sure that configuration resource Id is specified in Policy parameter."
        }
        else
        {
            $param['MofResourceReference'] = "[$($parmInfo.ResourceType)]$($parmInfo.ResourceId)"
        }

        if ($parmInfo.Contains('ResourcePropertyName'))
        {
            $param['MofParameterName'] = $parmInfo.ResourcePropertyName
        }
        else
        {
            throw "Policy parameter is missing a mandatory property 'ResourcePropertyName'. Please make sure that configuration resource property name is specified in Policy parameter."
        }

        if ($parmInfo.Contains('DefaultValue'))
        {
            $param['DefaultValue'] = $parmInfo.DefaultValue
        }

        if ($parmInfo.Contains('AllowedValues'))
        {
            $param['AllowedValues'] = $parmInfo.AllowedValues
        }

        $updatedParameterInfo += $param;
    }

    return $updatedParameterInfo
}
