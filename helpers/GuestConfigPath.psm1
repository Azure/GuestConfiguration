Set-StrictMode -Version latest
$ErrorActionPreference = 'Stop'
$ReleaseVersion = '0.0.0'

function InitReleaseVersionInfo
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true, Position=0)]
        [string] $Version
    )

    $global:ReleaseVersion = $Version
}

function Get-GuestConfigurationModulePath
{
    [CmdletBinding()]
    Param()

    return (Get-Item $PSScriptRoot).Parent.FullName
}

function Get-InspecProfilePath
{
    [CmdletBinding()]
    param()

    return Join-path $(Get-GuestConfigBinaryPath) 'inspec'
}

function Get-GuestConfigBinaryRootPath
{
    [CmdletBinding()]
    param()

    return Join-path $(Get-GuestConfigPath) 'bin'
}

function Get-GuestConfigBinaryPath
{
    [CmdletBinding()]
    param()

    return Join-path (Join-path (Join-path $(Get-GuestConfigPath) 'bin') $global:ReleaseVersion) 'GC'
}

function Get-GuestConfigPolicyPath
{
    [CmdletBinding()]
    param()

    return Join-path $(Get-GuestConfigPath) 'policy'
}

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

function Get-DscLibPath
{
    $gcBinPath = Get-GuestConfigBinaryPath
    if($(Get-OSPlatform) -eq 'Windows') {
        return Join-Path $gcBinPath 'gclib.dll'
    }

    return Join-Path $gcBinPath 'libgclib.so'
}

function Get-OSPlatform
{
    [CmdletBinding()]
    param()

    $platform = 'Windows'

    if($PSVersionTable.PSEdition -eq 'Desktop') {
        $platform = 'Windows'
    }
    elseif($PSVersionTable.PSEdition -eq 'Core') {
        if($IsWindows) {
            $platform = 'Windows'
        }
        elseif($IsLinux) {
            $platform = 'Linux'
        }
        elseif($IsMacOS) {
            $platform = 'MacOS'
        }
    }

    return $platform
}
