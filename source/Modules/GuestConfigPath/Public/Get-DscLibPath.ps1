function Get-DscLibPath
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param ()

    $gcBinPath = Get-GuestConfigBinaryPath
    if ($(Get-OSPlatform) -eq 'Windows')
    {
        Join-Path -Path $gcBinPath -ChildPath 'gclib.dll'
    }
    else
    {
        Join-Path -Path $gcBinPath -ChildPath 'libgclib.so'
    }
}
