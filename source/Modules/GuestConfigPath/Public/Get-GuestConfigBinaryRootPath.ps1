
function Get-GuestConfigBinaryRootPath
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param ()

    Join-Path -Path (Get-GuestConfigPath) -ChildPath 'bin'
}
