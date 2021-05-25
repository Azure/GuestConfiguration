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
        $testAINEOutputPathWindows = Join-Path -Path $testOutputPath -ChildPath 'Policy/Windows/AINE'
        $testAINEOutputPathLinux = Join-Path -Path $testOutputPath -ChildPath 'Policy/Linux/AINE'
        $testDINEOutputPathWindows = Join-Path -Path $testOutputPath -ChildPath 'Policy/Windows/DINE'
        $testDINEOutputPathLinux = Join-Path -Path $testOutputPath -ChildPath 'Policy/Linux/DINE'
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

        $newGCPolicyAINEParametersWindows = @{
            ContentUri  = 'https://github.com/microsoft/PowerShell-DSC-for-Linux/raw/amits/custompolicy/new_gc_policy/AuditWindowsService.zip'
            DisplayName = "[ModuleTestCI] Audit Windows Service - Date: $currentDateString OS: $currentWindowsOSString"
            Description = 'Policy to audit a Windows service'
            Path        = $testAINEOutputPathWindows
            Version     = '1.0.0.0'
            Platform    = 'Windows'
        }

        $newGCPolicyAINEParametersLinux = @{
            ContentUri  = 'https://github.com/microsoft/PowerShell-DSC-for-Linux/raw/amits/custompolicy/new_gc_policy/AuditWindowsService.zip'
            DisplayName = "[ModuleTestCI] Audit Linux Path - Date: $currentDateString OS: $currentWindowsOSString"
            Description = 'Policy to audit a Linux path'
            Path        = $testAINEOutputPathLinux
            Version     = '1.0.0.0'
            Platform    = 'Linux'
        }

        $newGCPolicyDINEParametersWindows = @{
            ContentUri  = 'https://github.com/microsoft/PowerShell-DSC-for-Linux/raw/amits/custompolicy/new_gc_policy/AuditWindowsService.zip'
            DisplayName = "[ModuleTestCI] Audit Windows Service - Date: $currentDateString OS: $currentWindowsOSString"
            Description = 'Policy to audit a Windows service'
            Path        = $testDINEOutputPathWindows
            Version     = '1.0.0.0'
            Platform    = 'Windows'
            Mode        = 'ApplyAndMonitor'
        }

        $newGCPolicyDINEParametersLinux = @{
            ContentUri  = 'https://github.com/microsoft/PowerShell-DSC-for-Linux/raw/amits/custompolicy/new_gc_policy/AuditWindowsService.zip'
            DisplayName = "[ModuleTestCI] Audit Linux Path - Date: $currentDateString OS: $currentWindowsOSString"
            Description = 'Policy to audit a Linux path'
            Path        = $testDINEOutputPathLinux
            Version     = '1.0.0.0'
            Platform    = 'Linux'
            Mode        = 'ApplyAndMonitor'
        }
    }

    # AINE Tests
    It 'New-GuestConfigurationPolicy should output path to generated policies' {
        $newGCPolicyResultWindows = New-GuestConfigurationPolicy @newGCPolicyAINEParametersWindows
        $newGCPolicyResultWindows.Path | Should -Not -BeNullOrEmpty
        Test-Path -Path $newGCPolicyResultWindows.Path | Should -BeTrue

        $newGCPolicyResultLinux = New-GuestConfigurationPolicy @newGCPolicyAINEParametersLinux
        $newGCPolicyResultLinux.Path | Should -Not -BeNullOrEmpty
        Test-Path -Path $newGCPolicyResultLinux.Path | Should -BeTrue
    }

    It 'Generated Audit policy file should exist' {
        $auditPolicyFileWindows = Join-Path -Path $testAINEOutputPathWindows -ChildPath 'AuditIfNotExists.json'
        Test-Path -Path $auditPolicyFileWindows | Should -BeTrue

        $auditPolicyFileLinux = Join-Path -Path $testAINEOutputPathLinux -ChildPath 'AuditIfNotExists.json'
        Test-Path -Path $auditPolicyFileLinux | Should -BeTrue
    }

    It 'Audit policy should contain expected content' {
        $auditPolicyFileWindows = Join-Path -Path $testAINEOutputPathWindows -ChildPath 'AuditIfNotExists.json'
        $auditPolicyContentWindows = Get-Content $auditPolicyFileWindows | ConvertFrom-Json | ForEach-Object { $_ }
        $auditPolicyContentWindows.properties.displayName.Contains($newGCPolicyAINEParametersWindows.DisplayName) | Should -BeTrue
        $auditPolicyContentWindows.properties.description.Contains($newGCPolicyAINEParametersWindows.Description) | Should -BeTrue
        $auditPolicyContentWindows.properties.parameters.IncludeArcMachines | Should -Not -BeNullOrEmpty
        $auditPolicyContentWindows.properties.policyType | Should -Be 'Custom'
        $auditPolicyContentWindows.properties.policyRule.then.details.name | Should -Be 'AuditWindowsService'
        $auditPolicyContentWindows.properties.policyRule.if.anyOf.allOf[1].anyOf[1].allOf | Where-Object field -eq 'Microsoft.Compute/imagePublisher' | ForEach-Object 'equals' | Should -Be 'MicrosoftWindowsServer'

        $auditPolicyFileLinux = Join-Path -Path $testAINEOutputPathLinux -ChildPath 'AuditIfNotExists.json'
        $auditPolicyContentLinux = Get-Content $auditPolicyFileLinux | ConvertFrom-Json | ForEach-Object { $_ }
        $auditPolicyContentLinux.properties.displayName.Contains($newGCPolicyAINEParametersLinux.DisplayName) | Should -BeTrue
        $auditPolicyContentLinux.properties.description.Contains($newGCPolicyAINEParametersLinux.Description) | Should -BeTrue
        $auditPolicyContentLinux.properties.parameters.IncludeArcMachines | Should -Not -BeNullOrEmpty
        $auditPolicyContentLinux.properties.policyType | Should -Be 'Custom'
        $auditPolicyContentLinux.properties.policyRule.then.details.name | Should -Be 'AuditWindowsService'
        $auditPolicyContentLinux.properties.policyRule.if.anyOf.allOf[1].anyOf[1].allOf | Where-Object field -eq 'Microsoft.Compute/imagePublisher' | ForEach-Object 'equals' | Should -Be 'OpenLogic'
    }

    # DINE Tests
    It 'New-GuestConfigurationPolicy -Type ApplyAndMonitor should output path to generated policies' {
        $newGCPolicyResultWindows = New-GuestConfigurationPolicy @newGCPolicyDINEParametersWindows
        $newGCPolicyResultWindows.Path | Should -Not -BeNullOrEmpty
        Test-Path -Path $newGCPolicyResultWindows.Path | Should -BeTrue

        $newGCPolicyResultLinux = New-GuestConfigurationPolicy @newGCPolicyDINEParametersLinux
        $newGCPolicyResultLinux.Path | Should -Not -BeNullOrEmpty
        Test-Path -Path $newGCPolicyResultLinux.Path | Should -BeTrue
    }

    It 'Generated Deploy policy file should exist' {
        $deployPolicyFileWindows = Join-Path -Path $testDINEOutputPathWindows -ChildPath 'DeployIfNotExists.json'
        Test-Path -Path $deployPolicyFileWindows | Should -BeTrue

        $deployPolicyFileLinux = Join-Path -Path $testDINEOutputPathLinux -ChildPath 'DeployIfNotExists.json'
        Test-Path -Path $deployPolicyFileLinux | Should -BeTrue
    }

    It 'Deploy policy should contain expected content' {
        $deployPolicyFileWindows = Join-Path -Path $testDINEOutputPathWindows -ChildPath 'DeployIfNotExists.json'
        $deployPolicyContentWindows = Get-Content $deployPolicyFileWindows | ConvertFrom-Json | ForEach-Object { $_ }
        $deployPolicyContentWindows.properties.displayName.Contains($newGCPolicyDINEParametersWindows.DisplayName) | Should -BeTrue
        $deployPolicyContentWindows.properties.description.Contains($newGCPolicyDINEParametersWindows.Description) | Should -BeTrue
        $deployPolicyContentWindows.properties.parameters.IncludeArcMachines | Should -Not -BeNullOrEmpty
        $deployPolicyContentWindows.properties.policyType | Should -Be 'Custom'
        $deployPolicyContentWindows.properties.policyRule.then.details.name | Should -Be 'AuditWindowsService'
        $deployPolicyContentWindows.properties.policyRule.if.anyOf.allOf[1].anyOf[1].allOf | Where-Object field -eq 'Microsoft.Compute/imagePublisher' | ForEach-Object 'equals' | Should -Be 'MicrosoftWindowsServer'

        $deployPolicyFileLinux = Join-Path -Path $testDINEOutputPathLinux -ChildPath 'DeployIfNotExists.json'
        $deployPolicyContentLinux = Get-Content $deployPolicyFileLinux | ConvertFrom-Json | ForEach-Object { $_ }
        $deployPolicyContentLinux.properties.displayName.Contains($newGCPolicyDINEParametersLinux.DisplayName) | Should -BeTrue
        $deployPolicyContentLinux.properties.description.Contains($newGCPolicyDINEParametersLinux.Description) | Should -BeTrue
        $deployPolicyContentLinux.properties.parameters.IncludeArcMachines | Should -Not -BeNullOrEmpty
        $deployPolicyContentLinux.properties.policyType | Should -Be 'Custom'
        $deployPolicyContentLinux.properties.policyRule.then.details.name | Should -Be 'AuditWindowsService'
        $deployPolicyContentLinux.properties.policyRule.if.anyOf.allOf[1].anyOf[1].allOf | Where-Object field -eq 'Microsoft.Compute/imagePublisher' | ForEach-Object 'equals' | Should -Be 'OpenLogic'
    }
}
