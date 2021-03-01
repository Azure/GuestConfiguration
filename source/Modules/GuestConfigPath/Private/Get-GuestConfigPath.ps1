function Get-GuestConfigPath
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param ()

    $platform = Get-OSPlatform

    if ($platform -eq 'Windows')
    {
        Join-path -Path $env:ProgramData -ChildPath 'GuestConfig'
    }
    else
    {
        '/var/lib/GuestConfig'
    }
}
