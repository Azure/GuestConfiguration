BeforeAll {

    $projectPath = "$PSScriptRoot/../../.." | Convert-Path
    $projectName = Get-SamplerProjectName -BuildRoot $projectPath

    Get-Module $projectName | Remove-Module -Force -ErrorAction SilentlyContinue
    $importedModule = Import-Module $projectName -Force -PassThru -ErrorAction 'Stop'
}

Describe 'GuestConfiguration Module validation' {

    Context 'Module fundamentals' {

        It 'has the Linux agent binaries from the project feed' -Skip:(-not (Test-Path "$($importedModule.ModuleBase)/bin/DSC_Linux.zip")) {
            Test-Path "$($importedModule.ModuleBase)/bin/DSC_Linux.zip" | Should -BeTrue
        }

        It 'has the Windows agent binaries from the project feed' -Skip:(-not (Test-Path "$($importedModule.ModuleBase)/bin/DSC_Windows.zip")) {
            Test-Path "$($importedModule.ModuleBase)/bin/DSC_Windows.zip" | Should -BeTrue
        }

        It 'has a PowerShell module manifest that meets functional requirements' {
            Test-ModuleManifest -Path "$($importedModule.ModuleBase)/GuestConfiguration.psd1" | Should -Not -BeNullOrEmpty
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
