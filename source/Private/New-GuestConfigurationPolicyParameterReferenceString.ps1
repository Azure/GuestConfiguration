function New-GuestConfigurationPolicyParameterReferenceString
{
    [CmdletBinding()]
    [OutputType([String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [Hashtable]
        $Parameter
    )

    return "[$($Parameter['ResourceType'])]$($Parameter['ResourceId']);$($Parameter['ResourcePropertyName'])"
}
