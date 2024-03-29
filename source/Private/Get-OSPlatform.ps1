function Get-OSPlatform
{
    [CmdletBinding()]
    [OutputType([String])]
    param ()

    $platform = 'Windows'

    if ($PSVersionTable.PSEdition -eq 'Desktop')
    {
        $platform = 'Windows'
    }
    elseif ($PSVersionTable.PSEdition -eq 'Core')
    {
        if ($IsWindows)
        {
            $platform = 'Windows'
        }
        elseif ($IsLinux)
        {
            $platform = 'Linux'
        }
        elseif ($IsMacOS)
        {
            $platform = 'MacOS'
        }
    }

    $platform
}
