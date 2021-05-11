BeforeDiscovery {

    $projectPath = "$PSScriptRoot/../../.." | Convert-Path
    $projectName = Get-SamplerProjectName -BuildRoot $projectPath

    Get-Module $projectName | Remove-Module -Force -ErrorAction SilentlyContinue
    $importedModule = Import-Module $projectName -Force -PassThru -ErrorAction 'Stop'
}

Describe 'New-GuestConfigurationPolicy' -ForEach @{
    ProjectPath    = $projectPath
    projectName    = $projectName
    importedModule = $importedModule
} {

    BeforeAll {
        $testAssetsPath = Join-Path -Path $PSScriptRoot -ChildPath '../assets'
        $testOutputPath = Join-Path -Path $TestDrive -ChildPath 'output'
        $testOutputPathWindows = Join-Path -Path $testOutputPath -ChildPath 'Policy/Windows'
        $testOutputPathLinux = Join-Path -Path $testOutputPath -ChildPath 'Policy/Linux'
        $currentDateString = Get-Date -Format "yyyy-MM-dd HH:mm"

        inModuleScope -ModuleName GuestConfiguration {
            Mock Get-AzPolicyDefinition -Verifiable -ModuleName GuestConfigurationPolicy
        }

        if ($IsWindows -or $PSVersionTable.PSVersion.Major -le 5)
        {
            $computerInfo = Get-ComputerInfo
            $currentWindowsOSString = $computerInfo.WindowsProductName
        }
        else
        {
            $currentWindowsOSString = 'Non-Windows'
        }

        $newGCPolicyParametersWindows = @{
            ContentUri  = 'https://github.com/microsoft/PowerShell-DSC-for-Linux/raw/amits/custompolicy/new_gc_policy/AuditWindowsService.zip'
            DisplayName = "[ModuleTestCI] Audit Windows Service - Date: $currentDateString OS: $currentWindowsOSString"
            Description = 'Policy to audit a Windows service'
            Path        = $testOutputPathWindows
            Version     = '1.0.0.0'
            Platform    = 'Windows'
        }

        $newGCPolicyParametersLinux = @{
            ContentUri  = 'https://github.com/microsoft/PowerShell-DSC-for-Linux/raw/amits/custompolicy/new_gc_policy/AuditWindowsService.zip'
            DisplayName = "[ModuleTestCI] Audit Linux Path - Date: $currentDateString OS: $currentWindowsOSString"
            Description = 'Policy to audit a Linux path'
            Path        = $testOutputPathLinux
            Version     = '1.0.0.0'
            Platform    = 'Linux'
        }
    }

    It 'New-GuestConfigurationPolicy should output path to generated policies' {

        $newGCPolicyResultWindows = New-GuestConfigurationPolicy @newGCPolicyParametersWindows
        $newGCPolicyResultWindows.Path | Should -Not -BeNullOrEmpty
        Test-Path -Path $newGCPolicyResultWindows.Path | Should -BeTrue

        $newGCPolicyResultLinux = New-GuestConfigurationPolicy @newGCPolicyParametersLinux
        $newGCPolicyResultLinux.Path | Should -Not -BeNullOrEmpty
        Test-Path -Path $newGCPolicyResultLinux.Path | Should -BeTrue
    }

    It 'Generated Audit policy file should exist' {
        $auditPolicyFileWindows = Join-Path -Path $testOutputPathWindows -ChildPath 'AuditIfNotExists.json'
        Test-Path -Path $auditPolicyFileWindows | Should -BeTrue

        $auditPolicyFileLinux = Join-Path -Path $testOutputPathLinux -ChildPath 'AuditIfNotExists.json'
        Test-Path -Path $auditPolicyFileLinux | Should -BeTrue
    }

    It 'Audit policy should contain expected content' {

        $auditPolicyFileWindows = Join-Path -Path $testOutputPathWindows -ChildPath 'AuditIfNotExists.json'
        $auditPolicyContentWindows = Get-Content $auditPolicyFileWindows | ConvertFrom-Json | ForEach-Object { $_ }
        $auditPolicyContentWindows.properties.displayName.Contains($newGCPolicyParametersWindows.DisplayName) | Should -BeTrue
        $auditPolicyContentWindows.properties.description.Contains($newGCPolicyParametersWindows.Description) | Should -BeTrue
        $auditPolicyContentWindows.properties.parameters.IncludeArcMachines | Should -Not -BeNullOrEmpty
        $auditPolicyContentWindows.properties.policyType | Should -Be 'Custom'
        $auditPolicyContentWindows.properties.policyRule.then.details.name | Should -Be 'AuditWindowsService'
        $auditPolicyContentWindows.properties.policyRule.if.anyOf.allOf[1].anyOf[1].allOf | Where-Object field -eq 'Microsoft.Compute/imagePublisher' | ForEach-Object 'equals' | Should -Be 'MicrosoftWindowsServer'

        $auditPolicyFileLinux = Join-Path -Path $testOutputPathLinux -ChildPath 'AuditIfNotExists.json'
        $auditPolicyContentLinux = Get-Content $auditPolicyFileLinux | ConvertFrom-Json | ForEach-Object { $_ }
        $auditPolicyContentLinux.properties.displayName.Contains($newGCPolicyParametersLinux.DisplayName) | Should -BeTrue
        $auditPolicyContentLinux.properties.description.Contains($newGCPolicyParametersLinux.Description) | Should -BeTrue
        $auditPolicyContentLinux.properties.parameters.IncludeArcMachines | Should -Not -BeNullOrEmpty
        $auditPolicyContentLinux.properties.policyType | Should -Be 'Custom'
        $auditPolicyContentLinux.properties.policyRule.then.details.name | Should -Be 'AuditWindowsService'
        $auditPolicyContentLinux.properties.policyRule.if.anyOf.allOf[1].anyOf[1].allOf | Where-Object field -eq 'Microsoft.Compute/imagePublisher' | ForEach-Object 'equals' | Should -Be 'OpenLogic'
    }
}
