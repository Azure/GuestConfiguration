
######################################################
#  End to end guest configuration reporting test
#  Verify repot is sent for every consistency run of a 
#  configuration assignement.
######################################################
$ErrorActionPreference = 'Stop'

Install-Module -Name 'ComputerManagementDsc' -Repository 'PSGallery' -Force
Install-Module -Name 'PSPKI' -Repository 'PSGallery' -Force

Import-Module "$PSScriptRoot/../GuestConfiguration.psd1" -Force
Import-Module "$PSScriptRoot/ProxyFunctions.psm1" -Force

Describe 'Test Guest Configuration Custom Policy cmdlets' {

    BeforeAll {

        if ($false -eq $IsWindows) {
            $env:Temp = $env:TMPDIR
        }
        Import-Module 'PSDesiredStateConfiguration' -Force

        $outputFolder = New-Item "$env:Temp/guestconfigurationtest" -ItemType 'directory' -Force | ForEach-Object FullName

        $dscConfig = @"
Configuration DSCConfig
{
    Import-DSCResource -ModuleName ComputerManagementDsc

    Node localhost
    {
        TimeZone TimeZoneExample
        {
            IsSingleInstance = 'Yes'
            TimeZone         = 'Tonga Standard Time'
        }

        
    }
}
DSCConfig -OutputPath "$outputFolder"
"@
        Set-Content -Path "$outputFolder/DSCConfig.ps1" -Value $dscConfig
        & "$outputFolder/DSCConfig.ps1"

        
        
        <#
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
New-Item "$env:Temp/guestconfigurationtest/cert" -type 'directory' -Force
$Cert = Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object { ($_.Subject -eq 'CN=testcert') } | Select-Object -First 1
Export-Certificate -FilePath "$env:Temp/guestconfigurationtest/cert/exported.cer" -Cert $Cert
Import-Certificate -FilePath "$env:Temp/guestconfigurationtest/cert/exported.cer" -CertStoreLocation Cert:\LocalMachine\Root
'@                
            powershell.exe -NoProfile -NonInteractive -Command $command       
        }
        #>

        # Extract agent files (used by Test-GuestConfigurationPackage)
        If ($IsWindows) {
            Expand-Archive $PSScriptRoot/../bin/DSC_Windows.zip "$outputFolder/bin/DSC/" -Force
        }
        else {
            Expand-Archive $PSScriptRoot/../bin/DSC_Linux.zip "$outputFolder/bin/DSC/" -Force
        }

    }
    
    BeforeEach {
        Remove-Item "$outputFolder/package/" -Force -Recurse -ErrorAction SilentlyContinue
        Remove-Item "$outputFolder/verifyPackage/" -Force -Recurse -ErrorAction SilentlyContinue
    }
    AfterAll {
        Remove-Item "$outputFolder" -Force -Recurse -ErrorAction SilentlyContinue
    }

    InModuleScope -ModuleName 'GuestConfiguration' {

        $publicFunctions = 'New-GuestConfigurationPackage', `
            'Test-GuestConfigurationPackage', `
            'Protect-GuestConfigurationPackage', `
            'New-GuestConfigurationPolicy', `
            'Publish-GuestConfigurationPolicy'

        if ($false -eq $IsWindows) { $env:Temp = $env:TMPDIR }
        $outputFolder = "$env:Temp/guestconfigurationtest"
        $mofPath = "$outputFolder/localhost.mof"
        $policyName = 'testPolicy'

        It 'Has a PowerShell module manifest that meets functional requirements' {
            Test-ModuleManifest -Path $PSScriptRoot/../GuestConfiguration.psd1 | Should Not BeNullOrEmpty
            $? | Should -Be $true
        }

        It 'Imported the module successfully' {
            Get-Module GuestConfiguration | ForEach-Object {$_.Name} | Should -Be 'GuestConfiguration'
        }

        It 'Does not throw while running Script Analyzer' {
            $scriptanalyzer = Invoke-ScriptAnalyzer -path $PSScriptRoot/../ -Severity Error -Recurse -IncludeDefaultRules -EnableExit
            $scriptanalyzer | Should -Be $Null
        }

        It 'Has text in help examples' {
            foreach ($function in $publicFunctions) {
                Get-Help $function | ForEach-Object {$_.Examples} | Should -Not -BeNullOrEmpty
            }
        }

        It 'Create Custom policy package and test its contents' {
            $package = New-GuestConfigurationPackage -Configuration $mofPath -Name $policyName -Path "$outputFolder/package"

            # Verify package exists
            Test-Path $package.Path | Should -Be $true
            # Verify package name
            $package.Name | Should -Be $policyName

            # Verify package contents
            Add-Type -AssemblyName System.IO.Compression.FileSystem
            [System.IO.Compression.ZipFile]::ExtractToDirectory($package.Path, "$outputFolder/verifyPackage")
            # Verify mof document exists.
            Test-Path "$outputFolder/verifyPackage/$policyName.mof" | Should -Be $true

            # Test required modules are included in the package
            $resourcesInMofDocument = [Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache]::ImportInstances("$outputFolder/verifyPackage/$policyName.mof", 4) 
            for ($i = 0; $i -lt $resourcesInMofDocument.Count; $i++) {
                if ($resourcesInMofDocument[$i].CimInstanceProperties.Name -contains 'ModuleName') {
                    Test-Path "$outputFolder/verifyPackage/Modules/$($resourcesInMofDocument[$i].ModuleName)" | Should -Be $true
                }
            }
        }

        It 'Verify Test-GuestConfigurationPackage can validate the package generated by New-GuestConfigurationPackage (Windows only)' {
            if ($isWindows) {
                Mock -CommandName 'Get-GuestConfigBinaryPath' -MockWith { "$env:Temp/guestconfigurationtest/bin/DSC/" } -Verifiable
                
                Mock -CommandName 'Publish-DscConfiguration' -Verifiable
                Mock -CommandName 'Set-DscLocalConfigurationManager' -Verifiable
                Mock -CommandName 'Test-DscConfiguration' -MockWith { New-Object -type psobject -Property @{compliance_state=$false;resources_in_desired_state = @();resources_not_in_desired_state=@('TimeZoneExample')} } -Verifiable
                Mock -CommandName 'Get-DscConfiguration' -MockWith { New-Object -type psobject -Property @{ResourceId='TimeZoneExample'} } -Verifiable

                $result = New-GuestConfigurationPackage -Configuration $mofPath -Name $policyName -Path "$outputFolder/package" | Test-GuestConfigurationPackage -Verbose
                $result.complianceStatus | Should -Be $false

                Assert-VerifiableMock
            }
        }
        
        <#
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
            $resourceTypes = $jsonDefinition.properties.policyRule.if.allOf | Where-Object {$_.field -eq 'type'} | ForEach-Object {$_.equals}
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