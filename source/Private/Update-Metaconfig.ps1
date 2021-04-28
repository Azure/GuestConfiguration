function Update-Metaconfig
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $metaConfigPath,

        [Parameter(Mandatory = $true)]
        [System.String]
        $key,

        [Parameter(Mandatory = $true)]
        [System.String]
        $value
    )

    if (Test-Path $metaConfigPath)
    {
        $metaConfigObject = Get-Content -Path $metaConfigPath | ConvertFrom-Json -AsHashTable
        $metaConfigObject[$key] = $value
        $metaConfigObject | ConvertTo-Json | Out-File $metaConfigPath -Encoding ascii -Force
    }
    else
    {
        "{""$key"":""$value""}" | Out-File $metaConfigPath -Encoding ascii
    }

}
