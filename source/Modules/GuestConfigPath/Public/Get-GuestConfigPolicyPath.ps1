function Get-GuestConfigPolicyPath
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param ()

    Join-path -Path $(Get-GuestConfigPath) -ChildPath 'policy'
}
