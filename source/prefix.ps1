Set-StrictMode -Version latest
$ErrorActionPreference = 'Stop'

Import-Module $PSScriptRoot/Modules/GuestConfigPath -Force
Import-Module $PSScriptRoot/Modules/DscOperations -Force
Import-Module $PSScriptRoot/Modules/GuestConfigurationPolicy -Force
Import-LocalizedData -BaseDirectory $PSScriptRoot -FileName GuestConfiguration.psd1 -BindingVariable GuestConfigurationManifest

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
