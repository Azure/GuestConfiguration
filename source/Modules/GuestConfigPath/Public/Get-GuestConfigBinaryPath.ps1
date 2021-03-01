

function Get-GuestConfigBinaryPath
{
    [CmdletBinding()]
    param ()

    return Join-path (Join-path (Join-path $(Get-GuestConfigPath) 'bin') $global:ReleaseVersion) 'GC'
}
