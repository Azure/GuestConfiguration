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
    try
    {
        $metaConfigFile = Get-Item -Path (Join-Path -Path $PackagePath -ChildPath "$packageName.metaconfig.json") -ErrorAction Stop
        return (Get-Content -Raw -Path $metaConfigFile | ConvertFrom-Json)
    }
    catch
    {
        Write-Verbose -Message "No metaconfig file found at $PackagePath. Returning empty object."
        return {}
    }
}
