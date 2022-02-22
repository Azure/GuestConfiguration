BeforeDiscovery {

    $projectPath = "$PSScriptRoot/../../.." | Convert-Path
    $projectName = Get-SamplerProjectName -BuildRoot $projectPath

    Get-Module $projectName | Remove-Module -Force -ErrorAction SilentlyContinue
    $importedModule = Import-Module $projectName -Force -PassThru -ErrorAction 'Stop'

    $IsRunningAsAdmin = $false

    if ($IsWindows)
    {
        $currentPrincipal = [Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent())
        $IsRunningAsAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    }
}

Describe 'Protect-GuestConfigurationPackage' -ForEach @{
    ProjectPath    = $projectPath
    projectName    = $projectName
    importedModule = $importedModule
} {

    BeforeAll {
        $testHelpersPath = Join-Path -Path $projectPath -ChildPath 'Tests/helpers'
        Get-ChildItem -Path $testHelpersPath -Filter *.ps1 -Recurse | Foreach-Object {
            # dot sourcing the helpers files
            Write-Host -Object "`tImporting helper file $($_.Name)"
            . $_.FullName
        }

        # test Assets path
        $testAssetsPath = Join-Path -Path $PSScriptRoot -ChildPath '../assets'
        # Test Config Package MOF
        $mofPath = Join-Path -Path $testAssetsPath -ChildPath 'DSC_Config.mof'
        $policyName = 'testPolicy'
        $testOutputPath = Join-Path -Path $TestDrive -ChildPath 'output'
        $testPackagePath = Join-Path -Path $testOutputPath -ChildPath 'Package'
        $signedPackageExtractionPath = Join-Path $testOutputPath -ChildPath 'SignedPackage'
    }

    It 'Signed package should exist at output path' -Skip:($IsLinux -or $IsMacOS -or -not $IsRunningAsAdmin) {
        $package = New-GuestConfigurationPackage -Configuration $mofPath -Name $policyName -Path $testPackagePath -Force
        New-TestCertificate
        $certificatePath = "Cert:\LocalMachine\My" # only have access when running elevated
        $certificate = Get-ChildItem -Path $certificatePath | Where-Object { ($_.Subject -eq "CN=testcert") } | Select-Object -First 1
        $protectPackageResult = Protect-GuestConfigurationPackage -Path $package.Path -Certificate $certificate
        Test-Path -Path $protectPackageResult.Path | Should -BeTrue
    }

    It 'Signed package should be extractable' -Skip:($IsLinux -or $IsMacOS -or -not $IsRunningAsAdmin) {
        $signedFileName = $policyName + "_signed.zip"
        $package = Get-Item "$testPackagePath/$signedFileName"
        # Set up type needed for package extraction
        $null = Add-Type -AssemblyName System.IO.Compression.FileSystem
        { [System.IO.Compression.ZipFile]::ExtractToDirectory($package.FullName, $signedPackageExtractionPath) } | Should -Not -Throw
    }

    It '.cat file should exist in the extracted package' -Skip:($IsLinux -or $IsMacOS -or -not $IsRunningAsAdmin) {
        $catFilePath = Join-Path -Path $signedPackageExtractionPath -ChildPath "$policyName.cat"
        Test-Path -Path $catFilePath | Should -BeTrue
    }

    It 'Extracted .cat file thumbprint should match certificate thumbprint' -Skip:($IsLinux -or $IsMacOS -or -not $IsRunningAsAdmin) {
        $certificatePath = "Cert:\LocalMachine\My"
        $certificate = Get-ChildItem -Path $certificatePath | Where-Object { ($_.Subject -eq "CN=testcert") } | Select-Object -First 1
        $catFilePath = Join-Path -Path $signedPackageExtractionPath -ChildPath "$policyName.cat"
        $authenticodeSignature = Get-AuthenticodeSignature -FilePath $catFilePath
        $authenticodeSignature.SignerCertificate.Thumbprint | Should -Be $certificate.Thumbprint
    }
}
