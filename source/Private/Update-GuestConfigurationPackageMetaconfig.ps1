function Update-GuestConfigurationPackageMetaconfig
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $MetaConfigPath,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Key,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Value
    )

    if (Test-Path $MetaConfigPath)
    {
        $metaConfigObject = Get-Content -Raw -Path $MetaConfigPath | ConvertFrom-Json -AsHashtable
        $metaConfigObject[$Key] = $Value
        $metaConfigObject | ConvertTo-Json | Out-File -Path $MetaConfigPath -Encoding ascii -Force
    }
    else
    {
        @{$Key = $Value} | ConvertTo-Json | Out-File -Path $MetaConfigPath -Encoding ascii -Force
    }
}
