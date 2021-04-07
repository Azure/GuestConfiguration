function Get-InspecProfilePath
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param ()

    Join-Path -Path $(Get-GuestConfigBinaryPath) -ChildPath 'inspec'
}
