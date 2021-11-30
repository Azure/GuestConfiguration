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

    It 'Validate that the resource compliance results are as expected on Windows' -Skip:(-not $IsWindows) {
        $package = New-GuestConfigurationPackage -Configuration $mofPath -Name $policyName -Path $testPackagePath -Force
        $testPackageResult = Test-GuestConfigurationPackage -Path $package.Path
        $testPackageResult.complianceStatus | Should -Be $false
        $testPackageResult.resources[0].properties.ModuleName | Should -Be 'ComputerManagementDsc'
        $testPackageResult.resources[0].complianceStatus | Should -Be $false
        $testPackageResult.resources[0].properties.ConfigurationName | Should -Be 'DSCConfig'
        $testPackageResult.resources[0].properties.IsSingleInstance | Should -Be 'Yes'
    }

    It 'Validate that the resource compliance results are as expected on Linux' -Skip:(-not $IsLinux) {
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
        $testPackageResult.resources[0].properties.ModuleName | Should -Be 'GuestConfiguration'
        $testPackageResult.resources[0].complianceStatus | Should -Be $true
        $testPackageResult.resources[0].properties.ConfigurationName | Should -Be 'DSCConfig'
    }
}
