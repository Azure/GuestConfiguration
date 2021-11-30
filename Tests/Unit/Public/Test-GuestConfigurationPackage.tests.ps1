BeforeDiscovery {
    $unitTestsFolderPath = Split-Path -Path $PSScriptRoot -Parent
    $testsFolderPath = Split-Path -Path $unitTestsFolderPath -Parent

    $projectPath = Split-Path -Path $testsFolderPath -Parent
    $projectName = Get-SamplerProjectName -BuildRoot $projectPath

    Get-Module $projectName | Remove-Module -Force -ErrorAction SilentlyContinue
    $importedModule = Import-Module $projectName -Force -PassThru -ErrorAction 'Stop'
}

Describe 'Test-GuestConfigurationPackage' -ForEach @{
    ProjectPath    = $projectPath
    ProjectName    = $projectName
    ImportedModule = $importedModule
} {
    BeforeAll {
        Set-StrictMode -Version 'latest'

        $unitTestsFolderPath = Split-Path -Path $PSScriptRoot -Parent
        $testAssetsPath = Join-Path -Path $unitTestsFolderPath -ChildPath 'assets'

        $testOutputPath = Join-Path -Path $TestDrive -ChildPath 'output'
    }

    It 'Validate that the resource compliance results are as expected on Windows' -Skip:(-not $IsWindows) {
        $newGuestConfigurationPackageParameters = @{
            Name = 'testWindowsTimeZone'
            Configuration = Join-Path -Path $testAssetsPath -ChildPath 'DSC_Config.mof'
            Path = Join-Path -Path $testOutputPath -ChildPath 'Package'
            Force = $true
        }

        $package = New-GuestConfigurationPackage @newGuestConfigurationPackageParameters

        $testPackageResult = Test-GuestConfigurationPackage -Path $package.Path

        $testPackageResult | Should -Not -Be $null
        $testPackageResult.complianceStatus | Should -Be $false

        $testPackageResult.resources.Count | Should -Be 1
        $testPackageResult.resources[0].properties.ModuleName | Should -Be 'ComputerManagementDsc'
        $testPackageResult.resources[0].complianceStatus | Should -Be $false
        $testPackageResult.resources[0].properties.ConfigurationName | Should -Be 'DSCConfig'
        $testPackageResult.resources[0].properties.IsSingleInstance | Should -Be 'Yes'
    }

    It 'Validate that the resource compliance results are as expected on Linux' -Skip:(-not $IsLinux) {
        $inSpecTestAssetsPath = Join-Path -Path $testAssetsPath -ChildPath 'InspecConfig'

        $newGuestConfigurationPackageParameters = @{
            Name = 'testLinuxNativeInSpec'
            Configuration = Join-Path -Path $inSpecTestAssetsPath -ChildPath 'InSpec_Config.mof'
            Path = Join-Path -Path $testOutputPath -ChildPath 'Package'
            ChefInspecProfilePath = $inSpecTestAssetsPath
            Force = $true
        }

        $package = New-GuestConfigurationPackage @newGuestConfigurationPackageParameters

        $testPackageResult = Test-GuestConfigurationPackage -Path $package.Path -ErrorAction 'Stop' -Verbose -Debug

        $testPackageResult | Should -Not -Be $null
        $testPackageResult.complianceStatus | Should -Be $true

        $testPackageResult.resources.Count | Should -Be 1
        $testPackageResult.resources[0].properties.ModuleName | Should -Be 'GuestConfiguration'
        $testPackageResult.resources[0].complianceStatus | Should -Be $true
        $testPackageResult.resources[0].properties.ConfigurationName | Should -Be 'DSCConfig'
    }
}
