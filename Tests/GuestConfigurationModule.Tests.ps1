
######################################################
#  End to end guest configuration reporting test
#  Verify repot is sent for every consistency run of a 
#  configuration assignement.
######################################################

# Requires environment variable "BuildTempFolder" to be set before running.
# The best place for this folder is an arbitrary file location outside the project folder
# where the build service has write access.
if (!$Env:BuildTempFolder) {
    if ($IsWindows) {$Env:BuildTempFolder = $Env:Temp}
    else {throw 'Please set environment variable "BuildTempFolder"'}
}

# Setting this to $true will retain the temp folders to review policy files and the package
# after tests have completed.  This is good for running locally on a workstation.
$keepTempFolders = $true

$ErrorActionPreference = 'Stop'

Describe "Test Guest Configuration Custom Policy cmdlets" {

    BeforeAll {

        Install-Module -Name 'ComputerManagementDsc' -Repository 'PSGallery' -Force
        if ($IsWindows) {
            Install-Module -Name 'PSPKI' -Repository 'PSGallery' -Force
        }
        Import-Module "$PSScriptRoot/../GuestConfiguration.psd1" -Force
        Import-Module "$PSScriptRoot/ProxyFunctions.psm1" -Force

        if ($IsWindows) {$delimiter = ';'} else {$delimiter = ':'}
        $GuestConfigurationFolder = Resolve-Path -Path "$PSScriptRoot/../"
        $Env:PSModulePath = $Env:PSModulePath + $delimiter + $GuestConfigurationFolder

        $d = Get-DscResource | % Name
        Write-Warning "DSC Modules: $d"

        if (!$(Test-Path $Env:BuildTempFolder)) {New-Item -ItemType Directory -Path $Env:BuildTempFolder}

        Remove-Item "$Env:BuildTempFolder/guestconfigurationtest" -Force -Recurse -ErrorAction SilentlyContinue
        $outputFolder = New-Item "$Env:BuildTempFolder/guestconfigurationtest" -ItemType 'directory' -Force | ForEach-Object FullName
        
        Import-Module 'PSDesiredStateConfiguration' -Force
  
#region Windows DSC config
        $dscConfigWindows = @"
Configuration DSCConfigWindows
{
    Import-DSCResource -ModuleName ComputerManagementDsc

    Node DSCConfigWindows
    {
        TimeZone TimeZoneExample
        {
            IsSingleInstance = 'Yes'
            TimeZone         = 'Tonga Standard Time'
        }

        
    }
}
DSCConfigWindows -OutputPath "$outputFolder"
"@
        
        Set-Content -Path "$outputFolder/DSCConfigWindows.ps1" -Value $dscConfigWindows
            
        & "$outputFolder/DSCConfigWindows.ps1"
#endregion

#region Linux DSC config
        $dscConfigLinux = @"
Configuration DSCConfigLinux
{
    Import-DscResource -ModuleName 'GuestConfiguration'

    Node DSCConfigLinux
    {
        ChefInSpecResource 'Audit Linux path exists'
        {
            Name = 'linux-path'
        }
    }
}
DSCConfigLinux -OutputPath "$outputFolder"
"@
        $inSpecProfileYml = @"
name: linux-path
title: Linux path
maintainer: Test
summary: Test profile
license: MIT
version: 1.0.0
supports:
    - os-family: unix
"@
        $inSpecProfileRB = @"
describe file('/tmp') do
    it { should exist }
end
"@
        
        Set-Content -Path "$outputFolder/DSCConfigLinux.ps1" -Value $dscConfigLinux
        New-Item -ItemType Directory -Path "$outputFolder/linux-path"
        Set-Content -Path "$outputFolder/linux-path/inspec.yml" -Value $inSpecProfileYml
        New-Item -ItemType Directory -Path "$outputFolder/linux-path/controls"
        Set-Content -Path "$outputFolder/linux-path/controls/linux-path.rb" -Value $inSpecProfileRB
            
        & "$outputFolder/DSCConfigLinux.ps1"
#endregion

        If ($IsWindows) {
            Import-Module PSPKI -Force
            
            # Create self signed certificate
            New-SelfsignedCertificateEx `
                -Subject "CN=testcert" `
                -EKU 'Code Signing' `
                -KeyUsage 'nonRepudiation, DigitalSignature' `
                -FriendlyName 'DSC Credential Encryption certificate' `
                -Exportable `
                -StoreLocation 'LocalMachine' `
                -KeyLength 2048 `
                -ProviderName 'Microsoft Enhanced Cryptographic Provider v1.0' `
                -AlgorithmName 'RSA' `
                -SignatureAlgorithm 'SHA256'

            $command = @'
New-Item "$env:BuildFolder/guestconfigurationtest/cert" -type 'directory' -Force
$Cert = Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object { ($_.Subject -eq 'CN=testcert') } | Select-Object -First 1
Export-Certificate -FilePath "$env:BuildFolder/guestconfigurationtest/cert/exported.cer" -Cert $Cert
Import-Certificate -FilePath "$env:BuildFolder/guestconfigurationtest/cert/exported.cer" -CertStoreLocation Cert:\LocalMachine\Root
'@                
            powershell.exe -NoProfile -NonInteractive -Command $command       
        }

        # Extract agent files (used by Test-GuestConfigurationPackage)
        If ($IsWindows) {
            Expand-Archive $PSScriptRoot/../bin/DSC_Windows.zip "$outputFolder/bin/" -Force
        }
        else {
            Expand-Archive $PSScriptRoot/../bin/DSC_Linux.zip "$outputFolder/bin/" -Force
        }

    }
    AfterEach {
        if ($false -eq $keepTempFolders) {
            foreach ($OS in @('Windows','Linux')) {
                if (Test-Path "$outputFolder/package_$OS/") {
                    Remove-Item "$outputFolder/package_$OS/" -Force -Recurse
                }
                if (Test-Path "$outputFolder/verifyPackage_$OS/") {
                    Remove-Item "$outputFolder/verifyPackage_$OS/" -Force -Recurse
                }
            }
        }
    }
    AfterAll {
        if ($false -eq $keepTempFolders) {
            if (Test-Path "$outputFolder") {
                Remove-Item "$outputFolder" -Force -Recurse
            }
        }
    }

    InModuleScope -ModuleName 'GuestConfiguration' {

        $publicFunctions = 'New-GuestConfigurationPackage', `
            'Test-GuestConfigurationPackage', `
            'Protect-GuestConfigurationPackage', `
            'New-GuestConfigurationPolicy', `
            'Publish-GuestConfigurationPolicy'

        $outputFolder = "$Env:BuildTempFolder/guestconfigurationtest"
        $policyName = 'testPolicy'
        
        Context 'Module Quality' {
            It 'Has a PowerShell module manifest that meets functional requirements' {
                Test-ModuleManifest -Path $PSScriptRoot/../GuestConfiguration.psd1 | Should Not BeNullOrEmpty
                $? | Should -Be $true
            }

            It 'Imported the module successfully' {
                Get-Module GuestConfiguration | ForEach-Object {$_.Name} | Should -Be 'GuestConfiguration'
            }

            It 'Does not throw while running Script Analyzer' {
                $scriptanalyzer = Invoke-ScriptAnalyzer -path $PSScriptRoot/../ -Severity Error -Recurse -IncludeDefaultRules
                $scriptanalyzer | Should -Be $Null
            }

            It 'Has text in help examples' {
                foreach ($function in $publicFunctions) {
                    Get-Help $function | ForEach-Object {$_.Examples} | Should -Not -BeNullOrEmpty
                }
            }
        }
        <# BYPASS TEST ISSUE UNTIL 1.20 CAN BE MERGED, BECAUSE DAILY PRIVATE BUILDS WILL ADDRESS THE TEST CASE
        It 'Verify Test-GuestConfigurationPackage can validate the package generated by New-GuestConfigurationPackage (Windows only)' {
            if ($isWindows) {
                Mock -CommandName 'Get-GuestConfigBinaryPath' -MockWith { "$env:BuildFolder/guestconfigurationtest/bin/DSC/" } -Verifiable
                
                Mock -CommandName 'Publish-DscConfiguration' -Verifiable
                Mock -CommandName 'Set-DscLocalConfigurationManager' -Verifiable
                Mock -CommandName 'Test-DscConfiguration' -MockWith { New-Object -type psobject -Property @{compliance_state=$false;resources_in_desired_state = @();resources_not_in_desired_state=@('TimeZoneExample')} } -Verifiable
                Mock -CommandName 'Get-DscConfiguration' -MockWith { New-Object -type psobject -Property @{ResourceId='TimeZoneExample'} } -Verifiable

                $result = New-GuestConfigurationPackage -Configuration $mofPath -Name $policyName -Path "$outputFolder/package" | Test-GuestConfigurationPackage -Verbose
                $result.complianceStatus | Should -Be $false

                Assert-VerifiableMock
            }
        }
        #>
        
        <#
        Comment out until PKI issues resolved

                        Mock -CommandName 'Publish-DscConfiguration' -Verifiable
                        Mock -CommandName 'Set-DscLocalConfigurationManager' -Verifiable
                        Mock -CommandName 'Test-DscConfiguration' -MockWith { New-Object -type psobject -Property @{compliance_state=$false;resources_in_desired_state = @();resources_not_in_desired_state=@('TimeZoneExample')} } -Verifiable
                        Mock -CommandName 'Get-DscConfiguration' -MockWith { New-Object -type psobject -Property @{ResourceId='TimeZoneExample'} } -Verifiable

                        if ('Windows' -eq $OS) {
                            $result = New-GuestConfigurationPackage -Configuration $mofPath -Name $policyName -Path "$outputFolder/package_$OS" | Test-GuestConfigurationPackage -Verbose
                        }
                        if ('Linux' -eq $OS) {
                            $result = New-GuestConfigurationPackage -Configuration $mofPath -Name $policyName -Path "$outputFolder/package_$OS" -ChefInspecProfilePath $outputFolder | Test-GuestConfigurationPackage -Verbose
                        }
                        $result.complianceStatus | Should -Be $false

                        Assert-VerifiableMock
                }
            }
        }
        
        <#
            Comment out until PKI test cert resolved

            It 'Verify Protect-GuestConfigurationPackage cmdlet can sign policy package (Windows Only)' {
                if ($IsWindows) {
                    $Cert = Get-ChildItem -Path cert:/LocalMachine/My | Where-Object { ($_.Subject -eq "CN=testcert") } | Select-Object -First 1
                    if ($null -eq $Cert) {write-warning 'no certificate was available for the test environment'}
                    if ($null -eq $Cert.thumbprint) {write-warning 'the certificate does not have a thumbprint'}

                    $package = New-GuestConfigurationPackage -Configuration $mofPath -Name $policyName -Path $outputFolder/package
                    
                    # issue with test cert
                    try {
                        Protect-GuestConfigurationPackage -Path $package.Path -Certificate $Cert
                    }
                    catch {
                        Write-Warning 'Unable to test Protect-GuestConfigurationPackage.  Verify the certificate is valid and trusted.'
                    }
                    $signedPackagePath = Join-Path (Get-ChildItem $package.Path).DirectoryName "$($policyName)_signed.zip"
                    
                    if (Test-Path $signedPackagePath -ErrorAction SilentlyContinue) {
                        $signedPackageContents = "$outputFolder/signedPackageContents"
                        Add-Type -AssemblyName System.IO.Compression.FileSystem
                        [System.IO.Compression.ZipFile]::ExtractToDirectory($signedPackagePath, $signedPackageContents)

                        $catFilePath = Join-Path $signedPackageContents "$policyName.cat"
                        Test-Path $catFilePath | Should -Be $true
                        $signature = Get-AuthenticodeSignature $catFilePath

                        $signerCert = $signature.SignerCertificate
                        if ($null -ne $signerCert) {
                            $signerThumbprint = $signerCert | ForEach-Object {$_.Thumbprint}
                            $signerThumbprint | Should -Be $cert.Thumbprint
                        } else {
                            write-warning 'the package was created but the signature does not have cert details.'
                        }
                    } else {
                        write-warning 'the environment was not able to produce a signed package for testing.'
                    }
                }
            }
        #>

        Context 'Policy cmdlets' {

            It 'Verify New-GuestConfigurationPolicy cmdlet can create custom policy definitions' {
                Mock Get-AzPolicyDefinition

                $testpolicyName = 'AuditWindowsService'
                $contentURI = 'https://github.com/microsoft/PowerShell-DSC-for-Linux/raw/amits/custompolicy/new_gc_policy/AuditWindowsService.zip'
                $policyPath = "$outputFolder/policyDefinitions"
                $displayName = '[unittest] Audit Windows Service.'
                $description = 'Policy to audit Windows service state.'
                $category = 'Test'

                New-GuestConfigurationPolicy -ContentUri $contentURI `
                    -DisplayName $displayName `
                    -Description $description `
                    -Category $category `
                    -Path $policyPath `
                    -Version 1.0.0.0

                # Bug: New-GuestConfigurationPolicy should return the path where policy are generated.
                # Test Audit policy definition
                $policyFile = join-path $policyPath 'AuditIfNotExists.json'
                $jsonDefinition = Get-Content $policyFile | ConvertFrom-Json | ForEach-Object { $_ }
            
                $jsonDefinition.properties.displayName.Contains($displayName) | Should -Be $true
                $jsonDefinition.properties.description.Contains($description) | Should -Be $true
                $jsonDefinition.properties.metadata.category | Should -Be $category
                $jsonDefinition.properties.policyType | Should -Be 'Custom'
                $jsonDefinition.properties.policyRule.then.details.name | Should -Be $testpolicyName
                
                $resourceTypes = $jsonDefinition.properties.policyRule.if.anyOf.allOf | Where-Object {$_.equals -like "Microsoft.*"} | ForEach-Object {$_.equals}
                $resourceTypes | Should -Contain 'Microsoft.Compute/virtualMachines'
                $resourceTypes | Should -Contain 'Microsoft.HybridCompute/machines'
            
                # Test DeployIfNotExist policy definition
                $policyFile = join-path $policyPath 'DeployIfNotExists.json'
                $jsonDefinition = Get-Content $policyFile | ConvertFrom-Json | ForEach-Object { $_ }
                $jsonDefinition.properties.displayName.Contains($displayName) | Should -Be $true
                $jsonDefinition.properties.description.Contains($description) | Should -Be $true
                $jsonDefinition.properties.metadata.category | Should -Be $category
                $jsonDefinition.properties.policyType | Should -Be 'Custom'
                $jsonDefinition.properties.policyRule.then.details.deployment.properties.parameters.configurationName.value | Should -Be $testpolicyName
                $jsonDefinition.properties.policyRule.then.details.deployment.properties.parameters.contentHash.value | Should -Be 'D421E3C8BB2298AEC5CFD95607B91241B7D5A2C88D54262ED304CA1FD01370F3'
                $jsonDefinition.properties.policyRule.then.details.deployment.properties.parameters.contentUri.value | Should -Be $contentURI
                
                $resourceTypes = $jsonDefinition.properties.policyRule.if.anyOf.allOf | Where-Object {$_.equals -like "Microsoft.*"} | ForEach-Object {$_.equals}
                $resourceTypes | Should -Contain 'Microsoft.Compute/virtualMachines'
                $resourceTypes | Should -Contain 'Microsoft.HybridCompute/machines'
            }

            It 'Verify Publish-GuestConfigurationPolicy cmdlet can publish the custom policy generated by New-GuestConfigurationPolicy cmdlets' {
                Mock Get-AzContext -MockWith {@{Name = 'Subscription';Subscription=@{Id='Id'}}}            
                Mock Get-AzPolicyDefinition
                Mock Get-AzPolicySetDefinition
                Mock New-AzPolicyDefinition -Verifiable
                Mock New-AzPolicySetDefinition -Verifiable
                
                $contentURI = 'https://github.com/microsoft/PowerShell-DSC-for-Linux/raw/amits/custompolicy/new_gc_policy/AuditWindowsService.zip'
                $policyPath = "$outputFolder/policyDefinitions"
                $displayName = '[unittest] Audit Windows Service.'
                $description = 'Policy to audit Windows service state.'

                New-GuestConfigurationPolicy -ContentUri $contentURI `
                    -DisplayName $displayName `
                    -Description $description `
                    -Path $policyPath `
                    -Version 1.0.0.0 | Publish-GuestConfigurationPolicy

                Assert-MockCalled -CommandName New-AzPolicyDefinition -Times 2
                Assert-MockCalled -CommandName New-AzPolicySetDefinition -Times 1

            }
        }
    }
}
