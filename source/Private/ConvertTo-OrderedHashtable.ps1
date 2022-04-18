function ConvertTo-OrderedHashtable
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        $InputObject
    )

    if ($null -eq $InputObject)
    {
        $output = $null
    }
    elseif ($InputObject -is [PSCustomObject])
    {
        $output = [Ordered]@{}

        foreach ($property in $InputObject.PSObject.Properties)
        {
            $propertyValue = ConvertTo-OrderedHashtable -InputObject $property.Value
            if ($property.Value -is [System.Collections.IEnumerable] -and $property.Value -isnot [string])
            {
                $output[$property.Name] = @( $propertyValue )
            }
            else
            {
                $output[$property.Name] = $propertyValue
            }
        }
    }
    elseif ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string])
    {
        $output = @()

        foreach ($object in $InputObject)
        {
            $output += ConvertTo-OrderedHashtable -InputObject $object
        }
    }
    else
    {
        $output = $InputObject
    }

    return $output
}
