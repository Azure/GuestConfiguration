BeforeDiscovery {

    $script:projectPath = "$PSScriptRoot/../../.." | Convert-Path
    $script:projectName = Get-SamplerProjectName -BuildRoot $script:projectPath

    Get-Module $script:projectName | Remove-Module -Force -ErrorAction SilentlyContinue
    $script:importedModule = Import-Module $script:projectName -Force -PassThru -ErrorAction 'Stop'
}

Describe 'GuestConfiguration Module validation' {

    BeforeAll {
        $script:projectPath = "$PSScriptRoot/../../.." | Convert-Path
        $script:projectName = Get-SamplerProjectName -BuildRoot $script:projectPath

        Get-Module $script:projectName | Remove-Module -Force -ErrorAction SilentlyContinue
        $script:importedModule = Import-Module $script:projectName -Force -PassThru -ErrorAction 'Stop'
    }

    Context 'Module fundamentals' {

        It 'has the Linux agent binaries from the project feed' -Skip:(-not (Test-Path "$($script:importedModule.ModuleBase)/bin/DSC_Linux.zip")) {
            Test-Path "$($script:importedModule.ModuleBase)/bin/DSC_Linux.zip" | Should -BeTrue
        }

        It 'has the Windows agent binaries from the project feed' -Skip:(-not (Test-Path "$($script:importedModule.ModuleBase)/bin/DSC_Windows.zip")) {
            Test-Path "$($script:importedModule.ModuleBase)/bin/DSC_Windows.zip" | Should -BeTrue
        }

        It 'has a PowerShell module manifest that meets functional requirements' {
            Test-ModuleManifest -Path "$($script:importedModule.ModuleBase)/GuestConfiguration.psd1" | Should -Not -BeNullOrEmpty
            $? | Should -BeTrue
        }

        It 'imported the module successfully' {
            Get-Module -Name GuestConfiguration | ForEach-Object { $_.Name } | Should -Be 'GuestConfiguration'
        }

        It 'has text in help examples' {
            foreach ($function in $publicFunctions)
            {
                Get-Help $function | ForEach-Object { $_.Examples } | Should -Not -BeNullOrEmpty
            }
        }
    }
}
