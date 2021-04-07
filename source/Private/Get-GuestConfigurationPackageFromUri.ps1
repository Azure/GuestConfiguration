function Get-GuestConfigurationPackageFromUri
{
    [CmdletBinding()]
    [OutputType([System.Io.FileInfo])]
    param
    (
        [Parameter()]
        [Uri]
        [ValidateScript({([Uri]$_).Scheme -match 'http'})]
        [Alias('Url')]
        $Uri
    )

    # Abstracting this in another function as we may want to support Proxy later.
    $tempFileName = [io.path]::GetTempFileName()
    $null = [System.Net.WebClient]::new().DownloadFile($Uri, $tempFileName)

    # The zip can be PackageName_0.2.3.zip, so we really need to look at the MOF to find its name.
    $packageName = Get-GuestConfigurationPackageNameFromZip -Path $tempFileName

    Move-Item -Path $tempFileName -Destination ('{0}.zip' -f $packageName) -Force -PassThru
}
