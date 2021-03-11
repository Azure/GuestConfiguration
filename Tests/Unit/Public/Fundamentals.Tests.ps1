BeforeDiscovery {

    $script:projectPath = "$PSScriptRoot\..\.." | Convert-Path
    $script:projectName = Get-SamplerProjectName -BuildRoot $script:projectPath

    $script:moduleName = Get-Module $script:projectName -ListAvailable | Select-Object -First 1
    Remove-Module -Name $script:moduleName -Force -ErrorAction 'SilentlyContinue'
    $script:importedModule = Import-Module $script:moduleName -Force -PassThru -ErrorAction 'Stop'

    $IsNotAzureDevOps = [string]::IsNullOrEmpty($env:ADO)
    $IsNotWindowsAndIsAzureDevOps = ($IsLinux -or $IsMacOS) -AND $env:ADO
}

Describe 'GuestConfiguration Module validation' {

    BeforeAll {

    }

    Context 'Module fundamentals' {

        It 'has the agent binaries from the project feed' -Skip:$IsNotAzureDevOps {
            Test-Path "$($script:importedModule.ModuleBase)/bin/DSC_Windows.zip" | Should -BeTrue
            Test-Path "$($script:importedModule.ModuleBase)/bin/DSC_Linux.zip" | Should -BeTrue
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
