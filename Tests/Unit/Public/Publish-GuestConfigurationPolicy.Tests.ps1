BeforeDiscovery {
    $script:projectPath = "$PSScriptRoot/../../.." | Convert-Path
    $script:projectName = Get-SamplerProjectName -BuildRoot $script:projectPath

    Get-Module $script:projectName | Remove-Module -Force -ErrorAction SilentlyContinue
    $script:importedModule = Import-Module $script:projectName -Force -PassThru -ErrorAction 'Stop'

    $IsNotAzureDevOps = [string]::IsNullOrEmpty($env:ADO)
    $IsNotWindowsAndIsAzureDevOps = ($IsLinux -or $IsMacOS) -AND $env:ADO
}

Context 'Publish-GuestConfigurationPolicy' {
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

        $newGCPolicyParametersWindows = @{
            ContentUri  = 'https://github.com/microsoft/PowerShell-DSC-for-Linux/raw/amits/custompolicy/new_gc_policy/AuditWindowsService.zip'
            DisplayName = "[ModuleTestCI] Audit Windows Service - Date: $currentDateString OS: $currentWindowsOSString"
            Description = 'Policy to audit a Windows service'
            Path        = $testOutputPathWindows
            Version     = '1.0.0.0'
            Platform    = 'Windows'
        }

        function Get-AzContext {}
        Mock Get-AzContext -MockWith { @{Name = 'Subscription'; Subscription = @{Id = 'Id' } } } -Verifiable
        Mock Get-AzPolicyDefinition -Verifiable
        Mock New-AzPolicyDefinition -Verifiable
        Mock Get-AzPolicySetDefinition -Verifiable
        Mock New-AzPolicySetDefinition -Verifiable
    }

    It 'Should be able to publish policies' {

        $newGCPolicyResult = New-GuestConfigurationPolicy @newGCPolicyParametersWindows
        { $publishGCPolicyResult = $newGCPolicyResult | Publish-GuestConfigurationPolicy } | Should -Not -Throw
        Assert-MockCalled -ModuleName GuestConfiguration -CommandName Get-AzContext
        Assert-MockCalled -ModuleName GuestConfiguration -CommandName New-AzPolicyDefinition
    }
}
