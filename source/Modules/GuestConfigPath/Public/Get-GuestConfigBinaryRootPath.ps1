

function Get-GuestConfigBinaryRootPath
{
    [CmdletBinding()]
    param()

    return Join-path $(Get-GuestConfigPath) 'bin'
}
