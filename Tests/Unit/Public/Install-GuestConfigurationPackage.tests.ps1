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
        $packagePath = Join-Path -Path $testAssetsPath -ChildPath 'TestPackages/testPolicy.zip'
    }

    It 'Validate that unzipping package is as expected on Windows' -Skip:($IsLinux -or $IsMacOS) {
        { Install-GuestConfigurationPackage -Path $packagePath } | Should -Not -Throw
        InModuleScope -ModuleName GuestConfiguration {
            { Get-Item -Path (Get-GuestConfigBinaryPath) } | Should -Not -Throw
        }
    }

    It 'Validate that unzipping package is as expected on Linux' -Skip:($IsWindows -or $IsMacOS) {
        { Install-GuestConfigurationPackage -Path $packagePath } | Should -Not -Throw
        InModuleScope -ModuleName GuestConfiguration {
            { Get-Item -Path (Get-GuestConfigBinaryPath) } | Should -Not -Throw
        }
    }
}
