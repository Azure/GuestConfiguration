
function Get-GuestConfigPath
{
    [CmdletBinding()]
    param()

    $platform = Get-OSPlatform

    if($platform -eq 'Windows') {
        return Join-path $env:ProgramData 'GuestConfig'
    }
    else {
        return '/var/lib/GuestConfig'
    }
}
