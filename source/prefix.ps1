Set-StrictMode -Version latest
$ErrorActionPreference = 'Stop'

Import-Module $PSScriptRoot/Modules/GuestConfigPath -Force
Import-Module $PSScriptRoot/Modules/DscOperations -Force
Import-Module $PSScriptRoot/Modules/GuestConfigurationPolicy -Force
Import-LocalizedData -BaseDirectory $PSScriptRoot -FileName GuestConfiguration.psd1 -BindingVariable GuestConfigurationManifest

if (($env:OS -notmatch "Windows" -and $IsLinux) -and (
    $PSVersionTable.PSVersion.Major -lt 7 -or
    ($PSVersionTable.PSVersion.Major -eq 7 -and $PSVersionTable.PSVersion.Minor -lt 2) -or
    ($PSVersionTable.PSVersion.Major -eq 7 -and ($PSVersionTable.PSVersion.PreReleaseLabel -and ($PSVersionTable.PSVersion.PreReleaseLabel -split '\.')[1] -lt 6))
    ))
{
    throw 'The Linux agent requires at least PowerShell v7.2.preview.6 to support the DSC subsystem.'
}

$currentCulture = [System.Globalization.CultureInfo]::CurrentCulture
if (($currentCulture.Name -eq 'en-US-POSIX') -and ($(Get-OSPlatform) -eq 'Linux'))
{
    Write-Warning "'$($currentCulture.Name)' Culture is not supported, changing it to 'en-US'"
    # Set Culture info to en-US
    [System.Globalization.CultureInfo]::CurrentUICulture = [System.Globalization.CultureInfo]::new('en-US')
    [System.Globalization.CultureInfo]::CurrentCulture = [System.Globalization.CultureInfo]::new('en-US')
}

#inject version info to GuestConfigPath.psm1
InitReleaseVersionInfo $GuestConfigurationManifest.moduleVersion
