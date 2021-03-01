function Get-DscLibPath
{
    [CmdletBinding()]
    param ()

    $gcBinPath = Get-GuestConfigBinaryPath
    if ($(Get-OSPlatform) -eq 'Windows')
    {
        return Join-Path -Path $gcBinPath -Path 'gclib.dll'
    }

    return Join-Path -Path $gcBinPath -Path 'libgclib.so'
}
