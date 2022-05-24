function Set-GuestConfigurationPackageMetaconfigProperty
{
    [CmdletBinding()]
    [OutputType([Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $MetaconfigPath,

        [Parameter(Mandatory = $true)]
        [Hashtable]
        $Property
    )

    if (Test-Path -Path $MetaconfigPath)
    {
        $metaconfigContent = Get-Content -Path $MetaconfigPath -Raw
        $metaconfig = $metaconfigContent | ConvertFrom-Json | ConvertTo-OrderedHashtable
    }
    else
    {
        $metaconfig = [Ordered]@{}
    }

    foreach ($propertyName in $Property.Keys)
    {
        $metaconfig[$propertyName] = $Property[$propertyName]
    }

    $metaconfigJson = $metaconfig | ConvertTo-Json

    Write-Verbose -Message "Setting the content of the package metaconfig at the path '$MetaconfigPath'..."
    $null = Set-Content -Path $MetaconfigPath -Value $metaconfigJson -Encoding 'ascii' -Force
}
