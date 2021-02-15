function Get-InspecProfilePath
{
    [CmdletBinding()]
    param()

    return Join-path $(Get-GuestConfigBinaryPath) 'inspec'
}
