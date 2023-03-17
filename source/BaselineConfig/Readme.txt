This provides a mechanism to define which settings should be audited and customize the value of the expectedValue for the setting.
ASMConfig.ps1 should be treated as source code and shouldn't be changed. Only ConfigData.psd1 should be changed as per the need.

Building project:
build.ps1
# Some tests may fail but the GuestConfiguration Module created as part of the build is fine.
cd output
# copy GuestConfiguration folder to 'C:\program Files\WindowsPowerShell\Modules' folder.
# Before copying make sure that there is no other version of GuestConfiguration Module in the system.

Alternative to building project:
copy the following files to latest version of installed Guest Configuration Module:
1) copy the following folders from source directory
	BaselineConfig
	DscResources
	GuestConfiguration.psm1

usage:
. ./ASMConfig.ps1
AzureOSBaseline -configurationData ConfigData.psd1
Add-Type -AssemblyName System.IO.Compression.FileSystem
New-GuestConfigurationPackage -Name AzureOSBaseline -Configuration .\AzureOSBaseline\localhost.mof -Type Audit -FrequencyMinutes 60 -verbose -force
Get-GuestConfigurationPackageComplianceStatus -Path AzureOSBaseline.zip
