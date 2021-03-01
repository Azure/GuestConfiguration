function Get-GuestConfigurationModulePath
{
    [CmdletBinding()]
    Param()

    return (Get-Item $PSScriptRoot).Parent.FullName
}
