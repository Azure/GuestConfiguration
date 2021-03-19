function Get-GuestConfigurationModulePath
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param ()

    (Get-Item -Path (Join-Path -Path $PSScriptRoot -ChildPath '..')).Parent.FullName
}
