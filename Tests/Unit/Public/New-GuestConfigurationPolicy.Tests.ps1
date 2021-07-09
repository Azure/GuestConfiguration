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
        $testAINEOutputPathWindows = Join-Path -Path $testOutputPath -ChildPath 'Policy/Windows/AINE_NO_PARAM'
        $testAINEOutputPathLinux = Join-Path -Path $testOutputPath -ChildPath 'Policy/Linux/AINE_NO_PARAM'
        $testDINEOutputPathWindows = Join-Path -Path $testOutputPath -ChildPath 'Policy/Windows/DINE_NO_PARAM'
        $testDINEOutputPathLinux = Join-Path -Path $testOutputPath -ChildPath 'Policy/Linux/DINE_NO_PARAM'

        $testAINEOutputPathWindows_WithParam = Join-Path -Path $testOutputPath -ChildPath 'Policy/Windows/AINE_PARAM'
        $testAINEOutputPathLinux_WithParam = Join-Path -Path $testOutputPath -ChildPath 'Policy/Linux/AINE_PARAM'
        $testDINEOutputPathWindows_WithParam = Join-Path -Path $testOutputPath -ChildPath 'Policy/Windows/DINE_PARAM'
        $testDINEOutputPathLinux_WithParam = Join-Path -Path $testOutputPath -ChildPath 'Policy/Linux/DINE_PARAM'

        $testAINEOutputPathWindows_WithOneParam = Join-Path -Path $testOutputPath -ChildPath 'Policy/Windows/AINE_PARAM_ONE'
        $testAINEOutputPathLinux_WithOneParam = Join-Path -Path $testOutputPath -ChildPath 'Policy/Linux/AINE_PARAM_ONE'
        $testDINEOutputPathWindows_WithOneParam = Join-Path -Path $testOutputPath -ChildPath 'Policy/Windows/DINE_PARAM_ONE'
        $testDINEOutputPathLinux_WithOneParam = Join-Path -Path $testOutputPath -ChildPath 'Policy/Linux/DINE_PARAM_ONE'

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

        $defaultEnsure = 'Present'
        $defaultPath = ' '
        $defaultContent = 'foo_content'
        $policyParameterInfo = @(
            @{
                Name = 'ensure'
                DisplayName = 'Presence.'
                Description = 'Whether or not the file is present.'
                ResourceType = "MyFile"
                ResourceId = 'createFoobarTestFile'
                ResourcePropertyName = 'ensure'
                DefaultValue = $defaultEnsure
                AllowedValues = @('Present','Absent')
            },
            @{
                Name = 'path'
                DisplayName = 'path'
                Description = "Where file should be present."
                ResourceType = "MyFile"
                ResourceId = 'createFoobarTestFile'
                ResourcePropertyName = "path"
                DefaultValue = $defaultPath
            },
            @{
                Name = 'content'
                DisplayName = 'Content.'
                Description = "Where file should be present."
                ResourceType = "MyFile"
                ResourceId = 'createFoobarTestFile'
                ResourcePropertyName = 'content'
                DefaultValue = $defaultContent
            })

        $singlePolicyParamInfo = @(
            @{
                Name = 'ensure'
                DisplayName = 'Presence.'
                Description = 'Whether or not the file is present.'
                ResourceType = "MyFile"
                ResourceId = 'createFoobarTestFile'
                ResourcePropertyName = 'ensure'
                DefaultValue = $defaultEnsure
                AllowedValues = @('Present','Absent')
            })

        # AINE Parameters
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

        $newGCPolicyAINEParametersWindows_WithParam = @{
            ContentUri  = 'https://github.com/microsoft/PowerShell-DSC-for-Linux/raw/amits/custompolicy/new_gc_policy/AuditWindowsService.zip'
            DisplayName = "[ModuleTestCI] Audit Windows Service - Date: $currentDateString OS: $currentWindowsOSString"
            Description = 'Policy to audit a Windows service'
            Path        = $testAINEOutputPathWindows_WithParam
            Version     = '1.0.0.0'
            Platform    = 'Windows'
            Parameter   = $policyParameterInfo
        }

        $newGCPolicyAINEParametersLinux_WithParam = @{
            ContentUri  = 'https://github.com/microsoft/PowerShell-DSC-for-Linux/raw/amits/custompolicy/new_gc_policy/AuditWindowsService.zip'
            DisplayName = "[ModuleTestCI] Audit Linux Path - Date: $currentDateString OS: $currentWindowsOSString"
            Description = 'Policy to audit a Linux path'
            Path        = $testAINEOutputPathLinux_WithParam
            Version     = '1.0.0.0'
            Platform    = 'Linux'
            Parameter   = $policyParameterInfo
        }

        # DINE Parameters
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

        $newGCPolicyDINEParametersWindows_WithParam = @{
            ContentUri  = 'https://github.com/microsoft/PowerShell-DSC-for-Linux/raw/amits/custompolicy/new_gc_policy/AuditWindowsService.zip'
            DisplayName = "[ModuleTestCI] Audit Windows Service - Date: $currentDateString OS: $currentWindowsOSString"
            Description = 'Policy to audit a Windows service'
            Path        = $testDINEOutputPathWindows_WithParam
            Version     = '1.0.0.0'
            Platform    = 'Windows'
            Mode        = 'ApplyAndMonitor'
            Parameter   = $policyParameterInfo
        }

        $newGCPolicyDINEParametersLinux_WithParam = @{
            ContentUri  = 'https://github.com/microsoft/PowerShell-DSC-for-Linux/raw/amits/custompolicy/new_gc_policy/AuditWindowsService.zip'
            DisplayName = "[ModuleTestCI] Audit Linux Path - Date: $currentDateString OS: $currentWindowsOSString"
            Description = 'Policy to audit a Linux path'
            Path        = $testDINEOutputPathLinux_WithParam
            Version     = '1.0.0.0'
            Platform    = 'Linux'
            Mode        = 'ApplyAndMonitor'
            Parameter   = $policyParameterInfo
        }
    }

    # AINE Tests - No Parameters
    It 'New-GuestConfigurationPolicy should output path to generated policies with no parameters with more than one parameter' {
        $newGCPolicyResultWindows = New-GuestConfigurationPolicy @newGCPolicyAINEParametersWindows
        $newGCPolicyResultWindows.Path | Should -Not -BeNullOrEmpty
        Test-Path -Path $newGCPolicyResultWindows.Path | Should -BeTrue

        $newGCPolicyResultLinux = New-GuestConfigurationPolicy @newGCPolicyAINEParametersLinux
        $newGCPolicyResultLinux.Path | Should -Not -BeNullOrEmpty
        Test-Path -Path $newGCPolicyResultLinux.Path | Should -BeTrue
    }

    It 'Generated Audit policy file should exist with no parameters' {
        $auditPolicyFileWindows = Join-Path -Path $testAINEOutputPathWindows -ChildPath 'AuditIfNotExists.json'
        Test-Path -Path $auditPolicyFileWindows | Should -BeTrue

        $auditPolicyFileLinux = Join-Path -Path $testAINEOutputPathLinux -ChildPath 'AuditIfNotExists.json'
        Test-Path -Path $auditPolicyFileLinux | Should -BeTrue
    }

    It 'Audit policy with no parameters should contain expected content' {
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


    # AINE - With more than one parameter
    It 'New-GuestConfigurationPolicy should output path to generated policies' {
        $newGCPolicyResultWindows_WithParam = New-GuestConfigurationPolicy @newGCPolicyAINEParametersWindows_WithParam
        $newGCPolicyResultWindows_WithParam.Path | Should -Not -BeNullOrEmpty
        Test-Path -Path $newGCPolicyResultWindows_WithParam.Path | Should -BeTrue

        $newGCPolicyResultLinux_WithParam = New-GuestConfigurationPolicy @newGCPolicyAINEParametersLinux_WithParam
        $newGCPolicyResultLinux_WithParam.Path | Should -Not -BeNullOrEmpty
        Test-Path -Path $newGCPolicyResultLinux_WithParam.Path | Should -BeTrue
    }

    It 'Generated Audit policy file should exist with more than one parameter' {
        $auditPolicyFileWindows_WithParam = Join-Path -Path $testAINEOutputPathWindows_WithParam -ChildPath 'AuditIfNotExists.json'
        Test-Path -Path $auditPolicyFileWindows_WithParam | Should -BeTrue

        $auditPolicyFileLinux_WithParam = Join-Path -Path $testAINEOutputPathLinux_WithParam -ChildPath 'AuditIfNotExists.json'
        Test-Path -Path $auditPolicyFileLinux_WithParam | Should -BeTrue
    }

    It 'Audit policy with more than one parameter should contain expected content' {
        $auditPolicyFileWindows_WithParam = Join-Path -Path $testAINEOutputPathWindows_WithParam -ChildPath 'AuditIfNotExists.json'
        $auditPolicyContentWindows_WithParam = Get-Content $auditPolicyFileWindows_WithParam | ConvertFrom-Json | ForEach-Object { $_ }
        $auditPolicyContentWindows_WithParam.properties.displayName.Contains($newGCPolicyAINEParametersWindows_WithParam.DisplayName) | Should -BeTrue
        $auditPolicyContentWindows_WithParam.properties.description.Contains($newGCPolicyAINEParametersWindows_WithParam.Description) | Should -BeTrue
        $auditPolicyContentWindows_WithParam.properties.parameters.IncludeArcMachines | Should -Not -BeNullOrEmpty
        $auditPolicyContentWindows_WithParam.properties.policyType | Should -Be 'Custom'
        $auditPolicyContentWindows_WithParam.properties.policyRule.then.details.name | Should -Be 'AuditWindowsService'
        $auditPolicyContentWindows_WithParam.properties.policyRule.if.anyOf.allOf[1].anyOf[1].allOf | Where-Object field -eq 'Microsoft.Compute/imagePublisher' | ForEach-Object 'equals' | Should -Be 'MicrosoftWindowsServer'
        $auditPolicyContentWindows_WithParam.properties.parameters.ensure.defaultValue | Should -Be $defaultEnsure
        $auditPolicyContentWindows_WithParam.properties.parameters.path.defaultValue | Should -Be $defaultPath
        $auditPolicyContentWindows_WithParam.properties.parameters.content.defaultValue | Should -Be $defaultContent

        $auditPolicyFileLinux_WithParam = Join-Path -Path $testAINEOutputPathLinux_WithParam -ChildPath 'AuditIfNotExists.json'
        $auditPolicyContentLinux_WithParam = Get-Content $auditPolicyFileLinux_WithParam | ConvertFrom-Json | ForEach-Object { $_ }
        $auditPolicyContentLinux_WithParam.properties.displayName.Contains($newGCPolicyAINEParametersLinux_WithParam.DisplayName) | Should -BeTrue
        $auditPolicyContentLinux_WithParam.properties.description.Contains($newGCPolicyAINEParametersLinux_WithParam.Description) | Should -BeTrue
        $auditPolicyContentLinux_WithParam.properties.parameters.IncludeArcMachines | Should -Not -BeNullOrEmpty
        $auditPolicyContentLinux_WithParam.properties.policyType | Should -Be 'Custom'
        $auditPolicyContentLinux_WithParam.properties.policyRule.then.details.name | Should -Be 'AuditWindowsService'
        $auditPolicyContentLinux_WithParam.properties.policyRule.if.anyOf.allOf[1].anyOf[1].allOf | Where-Object field -eq 'Microsoft.Compute/imagePublisher' | ForEach-Object 'equals' | Should -Be 'OpenLogic'
        $auditPolicyContentLinux_WithParam.properties.parameters.ensure.defaultValue | Should -Be $defaultEnsure
        $auditPolicyContentLinux_WithParam.properties.parameters.path.defaultValue | Should -Be $defaultPath
        $auditPolicyContentLinux_WithParam.properties.parameters.content.defaultValue | Should -Be $defaultContent
    }


    # AINE - With only one parameter
    It 'New-GuestConfigurationPolicy should output path to generated policies with only one parameter' {
        # Modify object to only have one parameter
        $newGCPolicyAINEParametersWindows_WithParam.Parameter = $singlePolicyParamInfo
        $newGCPolicyAINEParametersLinux_WithParam.Parameter = $singlePolicyParamInfo
        $newGCPolicyAINEParametersWindows_WithParam.Path = $testAINEOutputPathWindows_WithOneParam
        $newGCPolicyAINEParametersLinux_WithParam.Path = $testAINEOutputPathLinux_WithOneParam

        $newGCPolicyResultWindows_WithOneParam = New-GuestConfigurationPolicy @newGCPolicyAINEParametersWindows_WithParam
        $newGCPolicyResultWindows_WithOneParam.Path | Should -Not -BeNullOrEmpty
        Test-Path -Path $newGCPolicyResultWindows_WithOneParam.Path | Should -BeTrue

        $newGCPolicyResultLinux_WithOneParam = New-GuestConfigurationPolicy @newGCPolicyAINEParametersLinux_WithParam
        $newGCPolicyResultLinux_WithOneParam.Path | Should -Not -BeNullOrEmpty
        Test-Path -Path $newGCPolicyResultLinux_WithOneParam.Path | Should -BeTrue
    }

    It 'Generated Audit policy file should exist with only one parameter' {
        $auditPolicyFileWindows_WithOneParam = Join-Path -Path $testAINEOutputPathWindows_WithOneParam -ChildPath 'AuditIfNotExists.json'
        Test-Path -Path $auditPolicyFileWindows_WithOneParam | Should -BeTrue

        $auditPolicyFileLinux_WithOneParam = Join-Path -Path $testAINEOutputPathLinux_WithOneParam -ChildPath 'AuditIfNotExists.json'
        Test-Path -Path $auditPolicyFileLinux_WithOneParam | Should -BeTrue
    }

    It 'Audit policy with only one parameter should contain expected content' {
        $auditPolicyFileWindows_WithOneParam = Join-Path -Path $testAINEOutputPathWindows_WithOneParam -ChildPath 'AuditIfNotExists.json'
        $auditPolicyContentWindows_WithOneParam = Get-Content $auditPolicyFileWindows_WithOneParam | ConvertFrom-Json | ForEach-Object { $_ }
        $auditPolicyContentWindows_WithOneParam.properties.displayName.Contains($newGCPolicyAINEParametersWindows_WithParam.DisplayName) | Should -BeTrue
        $auditPolicyContentWindows_WithOneParam.properties.description.Contains($newGCPolicyAINEParametersWindows_WithParam.Description) | Should -BeTrue
        $auditPolicyContentWindows_WithOneParam.properties.parameters.IncludeArcMachines | Should -Not -BeNullOrEmpty
        $auditPolicyContentWindows_WithOneParam.properties.policyType | Should -Be 'Custom'
        $auditPolicyContentWindows_WithOneParam.properties.policyRule.then.details.name | Should -Be 'AuditWindowsService'
        $auditPolicyContentWindows_WithOneParam.properties.policyRule.if.anyOf.allOf[1].anyOf[1].allOf | Where-Object field -eq 'Microsoft.Compute/imagePublisher' | ForEach-Object 'equals' | Should -Be 'MicrosoftWindowsServer'
        $auditPolicyContentWindows_WithOneParam.properties.parameters.ensure.defaultValue | Should -Be $defaultEnsure
        $auditPolicyContentWindows_WithOneParam.properties.parameters.path.defaultValue | Should -Be $null
        $auditPolicyContentWindows_WithOneParam.properties.parameters.content.defaultValue | Should -Be $null

        $auditPolicyFileLinux_WithOneParam = Join-Path -Path $testAINEOutputPathLinux_WithOneParam -ChildPath 'AuditIfNotExists.json'
        $auditPolicyContentLinux_WithOneParam = Get-Content $auditPolicyFileLinux_WithOneParam | ConvertFrom-Json | ForEach-Object { $_ }
        $auditPolicyContentLinux_WithOneParam.properties.displayName.Contains($newGCPolicyAINEParametersLinux_WithParam.DisplayName) | Should -BeTrue
        $auditPolicyContentLinux_WithOneParam.properties.description.Contains($newGCPolicyAINEParametersLinux_WithParam.Description) | Should -BeTrue
        $auditPolicyContentLinux_WithOneParam.properties.parameters.IncludeArcMachines | Should -Not -BeNullOrEmpty
        $auditPolicyContentLinux_WithOneParam.properties.policyType | Should -Be 'Custom'
        $auditPolicyContentLinux_WithOneParam.properties.policyRule.then.details.name | Should -Be 'AuditWindowsService'
        $auditPolicyContentLinux_WithOneParam.properties.policyRule.if.anyOf.allOf[1].anyOf[1].allOf | Where-Object field -eq 'Microsoft.Compute/imagePublisher' | ForEach-Object 'equals' | Should -Be 'OpenLogic'
        $auditPolicyContentLinux_WithOneParam.properties.parameters.ensure.defaultValue | Should -Be $defaultEnsure
        $auditPolicyContentLinux_WithOneParam.properties.parameters.path.defaultValue | Should -Be $null
        $auditPolicyContentLinux_WithOneParam.properties.parameters.content.defaultValue | Should -Be $null
    }

    # DINE Tests - no parameters
    It 'New-GuestConfigurationPolicy -Type ApplyAndMonitor should output path to generated policies with no parameters' {
        $newGCPolicyResultWindows = New-GuestConfigurationPolicy @newGCPolicyDINEParametersWindows
        $newGCPolicyResultWindows.Path | Should -Not -BeNullOrEmpty
        Test-Path -Path $newGCPolicyResultWindows.Path | Should -BeTrue

        $newGCPolicyResultLinux = New-GuestConfigurationPolicy @newGCPolicyDINEParametersLinux
        $newGCPolicyResultLinux.Path | Should -Not -BeNullOrEmpty
        Test-Path -Path $newGCPolicyResultLinux.Path | Should -BeTrue
    }

    It 'Generated Deploy policy file should exist with no parameters' {
        $deployPolicyFileWindows = Join-Path -Path $testDINEOutputPathWindows -ChildPath 'DeployIfNotExists.json'
        Test-Path -Path $deployPolicyFileWindows | Should -BeTrue

        $deployPolicyFileLinux = Join-Path -Path $testDINEOutputPathLinux -ChildPath 'DeployIfNotExists.json'
        Test-Path -Path $deployPolicyFileLinux | Should -BeTrue
    }

    It 'Deploy policy with no parameters should contain expected content' {
        $deployPolicyFileWindows = Join-Path -Path $testDINEOutputPathWindows -ChildPath 'DeployIfNotExists.json'
        $deployPolicyContentWindows = Get-Content $deployPolicyFileWindows | ConvertFrom-Json | ForEach-Object { $_ }
        $deployPolicyContentWindows.properties.displayName.Contains($newGCPolicyDINEParametersWindows.DisplayName) | Should -BeTrue
        $deployPolicyContentWindows.properties.description.Contains($newGCPolicyDINEParametersWindows.Description) | Should -BeTrue
        $deployPolicyContentWindows.properties.parameters.IncludeArcMachines | Should -Not -BeNullOrEmpty
        $deployPolicyContentWindows.properties.policyType | Should -Be 'Custom'
        $deployPolicyContentWindows.properties.policyRule.then.details.name | Should -Be 'AuditWindowsService'
        $deployPolicyContentWindows.properties.policyRule.if.anyOf.allOf[1].anyOf[1].allOf | Where-Object field -eq 'Microsoft.Compute/imagePublisher' | ForEach-Object 'equals' | Should -Be 'MicrosoftWindowsServer'
        $deployPolicyContentWindows.properties.policyRule.then.details.deployment.properties.template.resources[0].properties.guestConfiguration.configurationParameter.GetType().BaseType.Name | Should -Be "Array"

        $deployPolicyFileLinux = Join-Path -Path $testDINEOutputPathLinux -ChildPath 'DeployIfNotExists.json'
        $deployPolicyContentLinux = Get-Content $deployPolicyFileLinux | ConvertFrom-Json | ForEach-Object { $_ }
        $deployPolicyContentLinux.properties.displayName.Contains($newGCPolicyDINEParametersLinux.DisplayName) | Should -BeTrue
        $deployPolicyContentLinux.properties.description.Contains($newGCPolicyDINEParametersLinux.Description) | Should -BeTrue
        $deployPolicyContentLinux.properties.parameters.IncludeArcMachines | Should -Not -BeNullOrEmpty
        $deployPolicyContentLinux.properties.policyType | Should -Be 'Custom'
        $deployPolicyContentLinux.properties.policyRule.then.details.name | Should -Be 'AuditWindowsService'
        $deployPolicyContentLinux.properties.policyRule.if.anyOf.allOf[1].anyOf[1].allOf | Where-Object field -eq 'Microsoft.Compute/imagePublisher' | ForEach-Object 'equals' | Should -Be 'OpenLogic'
        $deployPolicyContentLinux.properties.policyRule.then.details.deployment.properties.template.resources[0].properties.guestConfiguration.configurationParameter.GetType().BaseType.Name | Should -Be "Array"
    }

    # DINE Tests - With more than one parameter
    It 'New-GuestConfigurationPolicy -Type ApplyAndMonitor should output path to generated policies with more than one parameter' {
        $newGCPolicyResultWindows_WithParam = New-GuestConfigurationPolicy @newGCPolicyDINEParametersWindows_WithParam
        $newGCPolicyResultWindows_WithParam.Path | Should -Not -BeNullOrEmpty
        Test-Path -Path $newGCPolicyResultWindows_WithParam.Path | Should -BeTrue

        $newGCPolicyResultLinux_WithParam = New-GuestConfigurationPolicy @newGCPolicyDINEParametersLinux_WithParam
        $newGCPolicyResultLinux_WithParam.Path | Should -Not -BeNullOrEmpty
        Test-Path -Path $newGCPolicyResultLinux_WithParam.Path | Should -BeTrue
    }

    It 'Generated Deploy policy file should exist with more than one parameter' {
        $deployPolicyFileWindows_WithParam = Join-Path -Path $testDINEOutputPathWindows_WithParam -ChildPath 'DeployIfNotExists.json'
        Test-Path -Path $deployPolicyFileWindows_WithParam | Should -BeTrue

        $deployPolicyFileLinux_WithParam = Join-Path -Path $testDINEOutputPathLinux_WithParam -ChildPath 'DeployIfNotExists.json'
        Test-Path -Path $deployPolicyFileLinux_WithParam | Should -BeTrue
    }

    It 'Deploy policy with more than one parameter should contain expected content' {
        $deployPolicyFileWindows_WithParam = Join-Path -Path $testDINEOutputPathWindows_WithParam -ChildPath 'DeployIfNotExists.json'
        $deployPolicyContentWindows_WithParam = Get-Content $deployPolicyFileWindows_WithParam | ConvertFrom-Json | ForEach-Object { $_ }
        $deployPolicyContentWindows_WithParam.properties.displayName.Contains($newGCPolicyDINEParametersWindows_WithParam.DisplayName) | Should -BeTrue
        $deployPolicyContentWindows_WithParam.properties.description.Contains($newGCPolicyDINEParametersWindows_WithParam.Description) | Should -BeTrue
        $deployPolicyContentWindows_WithParam.properties.parameters.IncludeArcMachines | Should -Not -BeNullOrEmpty
        $deployPolicyContentWindows_WithParam.properties.policyType | Should -Be 'Custom'
        $deployPolicyContentWindows_WithParam.properties.policyRule.then.details.name | Should -Be 'AuditWindowsService'
        $deployPolicyContentWindows_WithParam.properties.policyRule.if.anyOf.allOf[1].anyOf[1].allOf | Where-Object field -eq 'Microsoft.Compute/imagePublisher' | ForEach-Object 'equals' | Should -Be 'MicrosoftWindowsServer'
        $deployPolicyContentWindows_WithParam.properties.policyRule.then.details.deployment.properties.template.resources[0].properties.guestConfiguration.configurationParameter.GetType().BaseType.Name | Should -Be "Array"
        $deployPolicyContentWindows_WithParam.properties.parameters.ensure.defaultValue | Should -Be $defaultEnsure
        $deployPolicyContentWindows_WithParam.properties.parameters.path.defaultValue | Should -Be $defaultPath
        $deployPolicyContentWindows_WithParam.properties.parameters.content.defaultValue | Should -Be $defaultContent

        $deployPolicyFileLinux_WithParam = Join-Path -Path $testDINEOutputPathLinux_WithParam -ChildPath 'DeployIfNotExists.json'
        $deployPolicyContentLinux_WithParam = Get-Content $deployPolicyFileLinux_WithParam | ConvertFrom-Json | ForEach-Object { $_ }
        $deployPolicyContentLinux_WithParam.properties.displayName.Contains($newGCPolicyDINEParametersLinux_WithParam.DisplayName) | Should -BeTrue
        $deployPolicyContentLinux_WithParam.properties.description.Contains($newGCPolicyDINEParametersLinux_WithParam.Description) | Should -BeTrue
        $deployPolicyContentLinux_WithParam.properties.parameters.IncludeArcMachines | Should -Not -BeNullOrEmpty
        $deployPolicyContentLinux_WithParam.properties.policyType | Should -Be 'Custom'
        $deployPolicyContentLinux_WithParam.properties.policyRule.then.details.name | Should -Be 'AuditWindowsService'
        $deployPolicyContentLinux_WithParam.properties.policyRule.if.anyOf.allOf[1].anyOf[1].allOf | Where-Object field -eq 'Microsoft.Compute/imagePublisher' | ForEach-Object 'equals' | Should -Be 'OpenLogic'
        $deployPolicyContentLinux_WithParam.properties.policyRule.then.details.deployment.properties.template.resources[0].properties.guestConfiguration.configurationParameter.GetType().BaseType.Name | Should -Be "Array"
        $deployPolicyContentLinux_WithParam.properties.parameters.ensure.defaultValue | Should -Be $defaultEnsure
        $deployPolicyContentLinux_WithParam.properties.parameters.path.defaultValue | Should -Be $defaultPath
        $deployPolicyContentLinux_WithParam.properties.parameters.content.defaultValue | Should -Be $defaultContent
    }

    # DINE Tests - With only one parameter
    It 'New-GuestConfigurationPolicy -Type ApplyAndMonitor should output path to generated policies for only one parameter' {
        # Modify object to only have one parameter
        $newGCPolicyDINEParametersWindows_WithParam.Parameter = $singlePolicyParamInfo
        $newGCPolicyDINEParametersLinux_WithParam.Parameter = $singlePolicyParamInfo
        $newGCPolicyDINEParametersWindows_WithParam.Path = $testDINEOutputPathWindows_WithOneParam
        $newGCPolicyDINEParametersLinux_WithParam.Path = $testDINEOutputPathLinux_WithOneParam

        # Create policy
        $newGCPolicyResultWindows_WithOneParam = New-GuestConfigurationPolicy @newGCPolicyDINEParametersWindows_WithParam
        $newGCPolicyResultWindows_WithOneParam.Path | Should -Not -BeNullOrEmpty
        Test-Path -Path $newGCPolicyResultWindows_WithOneParam.Path | Should -BeTrue

        $newGCPolicyResultLinux_WithOneParam = New-GuestConfigurationPolicy @newGCPolicyDINEParametersLinux_WithParam
        $newGCPolicyResultLinux_WithOneParam.Path | Should -Not -BeNullOrEmpty
        Test-Path -Path $newGCPolicyResultLinux_WithOneParam.Path | Should -BeTrue
    }

    It 'Generated Deploy policy file with one param should exist for only one parameter' {
        $deployPolicyFileWindows_WithOneParam = Join-Path -Path $testDINEOutputPathWindows_WithOneParam -ChildPath 'DeployIfNotExists.json'
        Test-Path -Path $deployPolicyFileWindows_WithOneParam | Should -BeTrue

        $deployPolicyFileLinux_WithOneParam = Join-Path -Path $testDINEOutputPathLinux_WithOneParam -ChildPath 'DeployIfNotExists.json'
        Test-Path -Path $deployPolicyFileLinux_WithOneParam | Should -BeTrue
    }

    It 'Deploy policy with only one parameter should contain expected content ' {
        $deployPolicyFileWindows_WithOneParam = Join-Path -Path $testDINEOutputPathWindows_WithOneParam -ChildPath 'DeployIfNotExists.json'
        $deployPolicyContentWindows_WithOneParam = Get-Content $deployPolicyFileWindows_WithOneParam | ConvertFrom-Json | ForEach-Object { $_ }
        $deployPolicyContentWindows_WithOneParam.properties.displayName.Contains($newGCPolicyDINEParametersWindows_WithParam.DisplayName) | Should -BeTrue
        $deployPolicyContentWindows_WithOneParam.properties.description.Contains($newGCPolicyDINEParametersWindows_WithParam.Description) | Should -BeTrue
        $deployPolicyContentWindows_WithOneParam.properties.parameters.IncludeArcMachines | Should -Not -BeNullOrEmpty
        $deployPolicyContentWindows_WithOneParam.properties.policyType | Should -Be 'Custom'
        $deployPolicyContentWindows_WithOneParam.properties.policyRule.then.details.name | Should -Be 'AuditWindowsService'
        $deployPolicyContentWindows_WithOneParam.properties.policyRule.if.anyOf.allOf[1].anyOf[1].allOf | Where-Object field -eq 'Microsoft.Compute/imagePublisher' | ForEach-Object 'equals' | Should -Be 'MicrosoftWindowsServer'
        $deployPolicyContentWindows_WithOneParam.properties.policyRule.then.details.deployment.properties.template.resources[0].properties.guestConfiguration.configurationParameter.GetType().BaseType.Name | Should -Be "Array"
        $deployPolicyContentWindows_WithOneParam.properties.parameters.ensure.defaultValue | Should -Be $defaultEnsure
        $deployPolicyContentWindows_WithOneParam.properties.parameters.path.defaultValue | Should -Be $null
        $deployPolicyContentWindows_WithOneParam.properties.parameters.content.defaultValue | Should -Be $null

        $deployPolicyFileLinux_WithOneParam = Join-Path -Path $testDINEOutputPathLinux_WithOneParam -ChildPath 'DeployIfNotExists.json'
        $deployPolicyContentLinux_WithOneParam = Get-Content $deployPolicyFileLinux_WithOneParam | ConvertFrom-Json | ForEach-Object { $_ }
        $deployPolicyContentLinux_WithOneParam.properties.displayName.Contains($newGCPolicyDINEParametersLinux_WithParam.DisplayName) | Should -BeTrue
        $deployPolicyContentLinux_WithOneParam.properties.description.Contains($newGCPolicyDINEParametersLinux_WithParam.Description) | Should -BeTrue
        $deployPolicyContentLinux_WithOneParam.properties.parameters.IncludeArcMachines | Should -Not -BeNullOrEmpty
        $deployPolicyContentLinux_WithOneParam.properties.policyType | Should -Be 'Custom'
        $deployPolicyContentLinux_WithOneParam.properties.policyRule.then.details.name | Should -Be 'AuditWindowsService'
        $deployPolicyContentLinux_WithOneParam.properties.policyRule.if.anyOf.allOf[1].anyOf[1].allOf | Where-Object field -eq 'Microsoft.Compute/imagePublisher' | ForEach-Object 'equals' | Should -Be 'OpenLogic'
        $deployPolicyContentLinux_WithOneParam.properties.policyRule.then.details.deployment.properties.template.resources[0].properties.guestConfiguration.configurationParameter.GetType().BaseType.Name | Should -Be "Array"
        $deployPolicyContentLinux_WithOneParam.properties.parameters.ensure.defaultValue | Should -Be $defaultEnsure
        $deployPolicyContentLinux_WithOneParam.properties.parameters.path.defaultValue | Should -Be $null
        $deployPolicyContentLinux_WithOneParam.properties.parameters.content.defaultValue | Should -Be $null
    }
}
