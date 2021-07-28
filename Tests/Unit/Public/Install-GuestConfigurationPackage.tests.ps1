BeforeDiscovery {
    $projectPath = "$PSScriptRoot/../../.." | Convert-Path
    $projectName = Get-SamplerProjectName -BuildRoot $projectPath

    Get-Module $projectName | Remove-Module -Force -ErrorAction SilentlyContinue
    $importedModule = Import-Module $projectName -Force -PassThru -ErrorAction 'Stop'
}

Describe 'Install-GuestConfigurationPackage' -ForEach @{
    ProjectPath    = $projectPath
    projectName    = $projectName
    importedModule = $importedModule
} {
    BeforeAll {
        # test Assets path
        $testAssetsPath = Join-Path -Path $PSScriptRoot -ChildPath '../assets'
        # Test Config Package MOF
        $packagePath = Join-Path -Path $testAssetsPath -ChildPath 'TestPackages/testPolicy.zip'
    }

    It 'Validate that unzipping package is as expected on Windows' -Skip:($IsLinux -or $IsMacOS) {
        { Install-GuestConfigurationPackage -Path $packagePath -Force } | Should -Not -Throw
        InModuleScope -ModuleName GuestConfiguration {
            { Get-Item -Path (Get-GuestConfigBinaryPath) } | Should -Not -Throw
        }
    }

    It 'Validate that unzipping package is as expected on Linux' -Skip:($IsWindows -or $IsMacOS) {
        { Install-GuestConfigurationPackage -Path $packagePath -Force } | Should -Not -Throw
        InModuleScope -ModuleName GuestConfiguration {
            { Get-Item -Path (Get-GuestConfigBinaryPath) } | Should -Not -Throw
        }
    }

    It 'Validate passing an invalid path name should throw' {
        { Install-GuestConfigurationPackage -Path "foobar" -Force } | Should -Throw
    }
}
