[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingConvertToSecureStringWithPlainText", "")]
param ()

BeforeDiscovery {
    $unitTestsFolderPath = Split-Path -Path $PSScriptRoot -Parent
    $testsFolderPath = Split-Path -Path $unitTestsFolderPath -Parent

    $projectPath = Split-Path -Path $testsFolderPath -Parent
    $projectName = Get-SamplerProjectName -BuildRoot $projectPath

    Get-Module $projectName | Remove-Module -Force -ErrorAction SilentlyContinue
    $importedModule = Import-Module $projectName -Force -PassThru -ErrorAction 'Stop'

    $isRunningAsAdmin = $false

    if ($IsWindows)
    {
        $currentPrincipal = [Security.Principal.WindowsPrincipal]::New([Security.Principal.WindowsIdentity]::GetCurrent())
        $isRunningAsAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    }
}

Describe 'Protect-GuestConfigurationPackage' {
    BeforeAll {
        Set-StrictMode -Version 'latest'

        $unitTestsFolderPath = Split-Path -Path $PSScriptRoot -Parent
        $testAssetsPath = Join-Path -Path $unitTestsFolderPath -ChildPath 'assets'
        $testPackagesFolderPath = Join-Path -Path $testAssetsPath -ChildPath 'TestPackages'
    }

    Context 'Sign a Windows package using a test certificate' -Skip:(-not $IsWindows -or -not $isRunningAsAdmin) {
        BeforeAll {
            # Create a code signing cert
            $myCert = New-SelfSignedCertificate -Type 'CodeSigningCert' -DnsName 'GCModuleTestOnly' -HashAlgorithm 'SHA256'

            # Export the certificates
            $myPwd = ConvertTo-SecureString -String 'Password1234' -Force -AsPlainText
            $pfxCertPath = Join-Path -Path $TestDrive -ChildPath 'GCPrivateKey.pfx'
            $myCert | Export-PfxCertificate -FilePath $pfxCertPath -Password $myPwd

            $certFilePath = Join-Path -Path $TestDrive -ChildPath 'GCPublicKey.cer'
            $myCert | Export-Certificate -FilePath $certFilePath -Force

            # Import the certificate
            $null = Import-PfxCertificate -FilePath $pfxCertPath -Password $myPwd -CertStoreLocation 'Cert:\LocalMachine\My'
            $script:testCertificate = Get-ChildItem -Path 'Cert:\LocalMachine\My' | Where-Object { ($_.Subject -eq 'CN=GCModuleTestOnly') }

            $testPackageName = 'TestFilePackage_1.0.0.0.zip'
            $testPackagePath = Join-Path -Path $testPackagesFolderPath -ChildPath $testPackageName

            $expectedConfigurationName = 'TestFilePackage'
            $expectedSignedPackageName = 'TestFilePackage_1.0.0.0_signed.zip'
            $expectedSignedPackagePath = Join-Path -Path $testPackagesFolderPath -ChildPath $expectedSignedPackageName

            $extractionPath = Join-Path -Path $TestDrive -ChildPath 'ExtractedSignedPackage'
            if (Test-Path -Path $extractionPath)
            {
                $null = Remove-Item -Path $extractionPath -Recurse -Force
            }

            $extractedCatFilePath = Join-Path -Path $extractionPath -ChildPath "$expectedConfigurationName.cat"
        }

        AfterAll {
            if (Test-Path -Path $expectedSignedPackagePath)
            {
                $null = Remove-Item -Path $expectedSignedPackagePath -Force
            }

            if ($null -ne $script:testCertificate)
            {
                $null = $script:testCertificate | Remove-Item -Force
            }
        }

        It 'Should be able to sign the package and get expected result' {
            $result = Protect-GuestConfigurationPackage -Path $testPackagePath -Certificate $script:testCertificate

            $result.Name | Should -Be $expectedConfigurationName
            $result.Path | Should -Be $expectedSignedPackagePath
            Test-Path -Path $result.Path | Should -BeTrue
        }

        It 'Signed package should be extractable' {
            { $null = Expand-Archive -Path $expectedSignedPackagePath -DestinationPath $extractionPath -Force } | Should -Not -Throw
        }

        It '.cat file should exist in the extracted package' {
            Test-Path -Path $extractedCatFilePath | Should -BeTrue
        }

        It 'Extracted .cat file thumbprint should match certificate thumbprint' {
            $authenticodeSignature = Get-AuthenticodeSignature -FilePath $extractedCatFilePath
            $authenticodeSignature.SignerCertificate.Thumbprint | Should -Be $script:testCertificate.Thumbprint
        }
    }
}
