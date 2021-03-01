

function Get-GuestConfigPolicyPath
{
    [CmdletBinding()]
    param()

    return Join-path $(Get-GuestConfigPath) 'policy'
}
