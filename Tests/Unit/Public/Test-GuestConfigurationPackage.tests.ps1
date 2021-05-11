BeforeDiscovery {

    $projectPath = "$PSScriptRoot/../../.." | Convert-Path
    $projectName = Get-SamplerProjectName -BuildRoot $projectPath

    Get-Module $projectName | Remove-Module -Force -ErrorAction SilentlyContinue
    $importedModule = Import-Module $projectName -Force -PassThru -ErrorAction 'Stop'
}

Describe 'Test-GuestConfigurationPackage' -ForEach @{
    ProjectPath    = $projectPath
    projectName    = $projectName
    importedModule = $importedModule
} {
    BeforeAll {
        # test Assets path
        $testAssetsPath = Join-Path -Path $PSScriptRoot -ChildPath '../assets'
        # Test Config Package MOF
        $mofPath = Join-Path -Path $testAssetsPath -ChildPath 'DSC_Config.mof'
        $policyName = 'testPolicy'
        $testOutputPath = Join-Path -Path $TestDrive -ChildPath 'output'
        $testPackagePath = Join-Path -Path $testOutputPath -ChildPath 'Package'
    }

    It 'Validate that the resource compliance results are as expected on Windows' -Skip:($IsLinux -or $IsMacOS) {
        $package = New-GuestConfigurationPackage -Configuration $mofPath -Name $policyName -Path $testPackagePath -Force
        $testPackageResult = Test-GuestConfigurationPackage -Path $package.Path
        $testPackageResult.complianceStatus | Should -Be $false
        $testPackageResult.resources[0].ModuleName | Should -Be 'ComputerManagementDsc'
        $testPackageResult.resources[0].complianceStatus | Should -Be $false
        $testPackageResult.resources[0].ConfigurationName | Should -Be 'DSCConfig'
        $testPackageResult.resources[0].IsSingleInstance | Should -Be 'Yes'
    }

    It 'Validate that the resource compliance results are as expected on Linux' -Skip:($IsWindows -or $IsMacOS) -Tag bugLinuxGCAgent {
        $inSpecFolderPath = Join-Path -Path $testAssetsPath -ChildPath 'InspecConfig'
        $inspecMofPath = Join-Path -Path $inSpecFolderPath -ChildPath 'InSpec_Config.mof'
        $inspecPackagePath = Join-Path -Path $testOutputPath -ChildPath 'InspecPackage'

        $package = New-GuestConfigurationPackage -Configuration $inspecMofPath -Name $policyName -Path $inspecPackagePath -ChefInspecProfilePath $inSpecFolderPath -Force
        Write-Host "Package Created '$($package.Path)'."
        $testPackageResult = $null
        try
        {
            $VerbosePreference = 'Continue'
            $DebugPreference = 'Continue'
            $testPackageResult = Test-GuestConfigurationPackage -Path $package.Path -ErrorAction Stop -Verbose -Debug
        }
        catch
        {
            Write-Host -ForegroundColor 'Red' -Object "Error running 'Test-GuestConfigurationPackage': $($_.Exception.Message)."
            throw $_
        }

        $testPackageResult.complianceStatus | Should -Be $true
        $testPackageResult.resources[0].ModuleName | Should -Be 'GuestConfiguration'
        $testPackageResult.resources[0].complianceStatus | Should -Be $true
        $testPackageResult.resources[0].ConfigurationName | Should -Be 'DSCConfig'
    }

    It 'Supports Pester as a language abstraction' -Skip:($IsMacOS -or $IsLinux) {
        # folder with the test pester file
        $pesterScriptsAsset = Join-Path -Path $testAssetsPath -ChildPath 'pesterScripts'
        $pesterMofFilePath = Join-Path -Path $testOutputPath -ChildPath "PesterConfig.mof"
        $pesterPackagePath = Join-Path -Path $testOutputPath -ChildPath 'PesterPackage'

        $testPackageResult = New-GuestConfigurationFile -Name $policyName -Source $pesterScriptsAsset -Path $pesterMofFilePath -Force |
            New-GuestConfigurationPackage -Path $pesterPackagePath -FilesToInclude $pesterScriptsAsset -Force |
            Test-GuestConfigurationPackage

        $testPackageResult.complianceStatus | Should -Be $true
        $testPackageResult.resources[0].ModuleName | Should -Be 'GuestConfiguration'
        $testPackageResult.resources[0].complianceStatus | Should -Be $true
        $testPackageResult.resources[0].ConfigurationName | Should -Be 'testPolicy'
        $testPackageResult.resources[0].PesterFileName | Should -Be 'EnvironmentVariables.tests'
    }
}
