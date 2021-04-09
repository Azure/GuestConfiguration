BeforeDiscovery {
    $script:projectPath = "$PSScriptRoot/../../.." | Convert-Path
    $script:projectName = Get-SamplerProjectName -BuildRoot $script:projectPath

    Get-Module $script:projectName | Remove-Module -Force -ErrorAction SilentlyContinue
    $script:importedModule = Import-Module $script:projectName -Force -PassThru -ErrorAction 'Stop'

    $IsNotAzureDevOps = [string]::IsNullOrEmpty($env:ADO)
    $IsNotWindowsAndIsAzureDevOps = ($IsLinux -or $IsMacOS) -AND $env:ADO
}

Context 'Install-GuestConfigurationPackage' {
    BeforeAll {
        # test Assets path
        $testAssetsPath = Join-Path -Path $PSScriptRoot -ChildPath '../assets'
        # Test Config Package MOF
        $mofPath = Join-Path -Path $testAssetsPath -ChildPath 'DSC_Config.mof'
        $policyName = 'testPolicy'
        $testOutputPath = Join-Path -Path $TestDrive -ChildPath 'output'
        $testPackagePath = Join-Path -Path $testOutputPath -ChildPath 'Package'

    }

    It 'Validate that unzipping package is as expected on Windows' -Skip:($IsLinux -or $IsMacOS) {
        $package = New-GuestConfigurationPackage -Configuration $mofPath -Name $policyName -Path $testPackagePath -Force
        { Install-GuestConfigurationPackage -Path $package.Path } | Should -Not -Throw
        InModuleScope -ModuleName GuestConfiguration {
            { Get-Item -Path (Get-GuestConfigBinaryPath) } | Should -Not -Throw
        }

    }

    It 'Validate that unzipping package is as expected on Linux' -Skip:($IsWindows -or $IsMacOS) {
        $inSpecFolderPath = Join-Path -Path $testAssetsPath -ChildPath 'InspecConfig'
        $inspecMofPath = Join-Path -Path $inSpecFolderPath -ChildPath 'InSpec_Config.mof'
        $inspecPackagePath = Join-Path -Path $testOutputPath -ChildPath 'InspecPackage'

        $package = New-GuestConfigurationPackage -Configuration $inspecMofPath -Name $policyName -Path $inspecPackagePath -ChefInspecProfilePath $inSpecFolderPath -Force
        { Install-GuestConfigurationPackage -Path $package.Path } | Should -Not -Throw
        InModuleScope -ModuleName GuestConfiguration {
            { Get-Item -Path (Get-GuestConfigBinaryPath) } | Should -Not -Throw
        }
    }
}
