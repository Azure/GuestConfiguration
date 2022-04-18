BeforeDiscovery {
    $projectPath = "$PSScriptRoot/../../.." | Convert-Path
    $projectName = Get-SamplerProjectName -BuildRoot $projectPath

    Get-Module $projectName | Remove-Module -Force -ErrorAction SilentlyContinue
    $importedModule = Import-Module $projectName -Force -PassThru -ErrorAction 'Stop'
}

Describe 'Publish-GuestConfigurationPolicy' -ForEach @{
    ProjectPath    = $projectPath
    projectName    = $projectName
    importedModule = $importedModule
} {
    BeforeAll {
        $testAssetsPath = Join-Path -Path $PSScriptRoot -ChildPath '../assets'
        $testOutputPath = Join-Path -Path $TestDrive -ChildPath 'output'
        $testOutputPathWindows = Join-Path -Path $testOutputPath -ChildPath 'Policy/Windows'
        $testPackagePath = Join-Path -Path $testOutputPath -ChildPath 'Package'
        $currentDateString = Get-Date -Format "yyyy-MM-dd HH:mm"

        if ($IsWindows -or $PSVersionTable.PSVersion.Major -le 5)
        {
            $computerInfo = Get-ComputerInfo
            $currentWindowsOSString = $computerInfo.WindowsProductName
        }
        else
        {
            $currentWindowsOSString = 'Non-Windows'
        }

        $policyID = [Guid]::NewGuid()
        $newGCPolicyParametersWindows = @{
            ContentUri  = 'https://github.com/microsoft/PowerShell-DSC-for-Linux/raw/amits/custompolicy/new_gc_policy/AuditWindowsService.zip'
            DisplayName = "[ModuleTestCI] Audit Windows Service - Date: $currentDateString OS: $currentWindowsOSString"
            Description = 'Policy to audit a Windows service'
            Path        = $testOutputPathWindows
            Version     = '1.0.0.0'
            Platform    = 'Windows'
            PolicyId    = $policyID
        }

        Mock Get-AzContext -MockWith { @{Name = 'Subscription'; Subscription = @{Id = 'Id' } } } -ModuleName GuestConfiguration -Verifiable
        Mock New-AzPolicyDefinition -Verifiable -ModuleName GuestConfiguration
    }

    It 'Should be able to publish policies' {

        $newGCPolicyResult = New-GuestConfigurationPolicy @newGCPolicyParametersWindows
        { $publishGCPolicyResult = $newGCPolicyResult | Publish-GuestConfigurationPolicy } | Should -Not -Throw
        Assert-MockCalled -ModuleName GuestConfiguration -CommandName Get-AzContext
        Assert-MockCalled -ModuleName GuestConfiguration -CommandName New-AzPolicyDefinition
    }
}
