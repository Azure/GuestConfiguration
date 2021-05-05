function Get-GuestConfigurationPackageMetaConfig
{
    [CmdletBinding()]
    [OutputType([PSObject])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $PackagePath
    )

    $packageName = [System.IO.Path]::GetFileNameWithoutExtension($PackagePath)
    $metaConfigFile = Get-Item -Path (Join-Path -Path $PackagePath -ChildPath "$packageName.metaconfig.json") -ErrorAction Stop
    return (Get-Content -Raw -Path $metaConfigFile | ConvertFrom-Json)
}
