function Get-GuestConfigurationModulePath
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param ()

    (Get-Item -Path $PSScriptRoot).Parent.FullName
}
