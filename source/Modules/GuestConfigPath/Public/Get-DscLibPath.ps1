function Get-DscLibPath
{
    $gcBinPath = Get-GuestConfigBinaryPath
    if($(Get-OSPlatform) -eq 'Windows') {
        return Join-Path $gcBinPath 'gclib.dll'
    }

    return Join-Path $gcBinPath 'libgclib.so'
}
