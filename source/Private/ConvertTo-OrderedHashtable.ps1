function ConvertTo-OrderedHashtable
{
    [CmdletBinding]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]
        $InputObject
    )


}
