function Set-GuestConfigurationPackageParameters
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $Path,

        [Parameter()]
        [Hashtable[]]
        $Parameter
    )

    if ($Parameter.Count -eq 0)
    {
        return
    }

    $mofInstances = [Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache]::ImportInstances($Path, 4)

    foreach ($parameterInfo in $Parameter)
    {
        if ($parameterInfo.Keys -notcontains 'ResourceType')
        {
            throw "Policy parameter is missing a mandatory property 'ResourceType'. Please make sure that configuration resource type is specified in configuration parameter."
        }

        if ($parameterInfo.Keys -notcontains 'ResourceId')
        {
            throw "Policy parameter is missing a mandatory property 'ResourceId'. Please make sure that configuration resource Id is specified in configuration parameter."
        }

        if ($parameterInfo.Keys -notcontains 'ResourcePropertyName')
        {
            throw "Policy parameter is missing a mandatory property 'ResourcePropertyName'. Please make sure that configuration resource property name is specified in configuration parameter."
        }

        if ($parameterInfo.Keys -notcontains 'ResourcePropertyValue')
        {
            throw "Policy parameter is missing a mandatory property 'ResourcePropertyValue'. Please make sure that configuration resource property value is specified in configuration parameter."
        }

        $resourceId = "[$($parameterInfo.ResourceType)]$($parameterInfo.ResourceId)"

        $matchingMofInstance = @( $mofInstances | Where-Object {
            ($_.CimInstanceProperties.Name -contains 'ResourceID') -and
            ($_.CimInstanceProperties['ResourceID'].Value -ieq $resourceId) -and
            ($_.CimInstanceProperties.Name -icontains $parameterInfo.ResourcePropertyName)
        })

        if ($null -eq $matchingMofInstance -or $matchingMofInstance.Count -eq 0)
        {
            throw "Failed to find a matching parameter reference with ResourceType:'$($parameterInfo.ResourceType)', ResourceId:'$($parameterInfo.ResourceId)' and ResourcePropertyName:'$($parameterInfo.ResourcePropertyName)' in the configuration. Please ensure that this resource instance exists in the configuration."
        }

        if ($matchingMofInstance.Count -gt 1)
        {
            throw "Found more than one matching parameter reference with ResourceType:'$($parameterInfo.ResourceType)', ResourceId:'$($parameterInfo.ResourceId)' and ResourcePropertyName:'$($parameterInfo.ResourcePropertyName)'. Please ensure that only one resource instance with this information exists in the configuration."
        }

        $mofInstanceParameter = $matchingMofInstance[0].CimInstanceProperties.Item($parameterInfo.ResourcePropertyName)
        $mofInstanceParameter.Value = $parameterInfo.ResourcePropertyValue
    }

    Write-MofContent -MofInstances $mofInstances -OutputPath $Path
}
