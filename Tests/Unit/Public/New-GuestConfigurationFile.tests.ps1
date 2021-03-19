BeforeDiscovery {

    $script:projectPath = "$PSScriptRoot/../../.." | Convert-Path
    $script:projectName = Get-SamplerProjectName -BuildRoot $script:projectPath

    Get-Module $script:projectName | Remove-Module -Force -ErrorAction SilentlyContinue
    $script:importedModule = Import-Module $script:projectName -Force -PassThru -ErrorAction 'Stop'

    $IsNotAzureDevOps = [string]::IsNullOrEmpty($env:ADO)
    $IsNotWindowsAndIsAzureDevOps = ($IsLinux -or $IsMacOS) -AND $env:ADO
}

Context 'New-GuestConfigurationFile' {

    BeforeAll {
        # test Assets path
        $testAssetsPath = Join-Path -Path $PSScriptRoot -ChildPath '../assets'
        # folder with the test pester file
        $pesterScriptsAsset = Join-Path -Path $testAssetsPath -ChildPath 'pesterScripts'
        # test drive output folder
        $testOutputPath = Join-Path -Path $TestDrive -ChildPath 'output'
        $pesterMofFilePath = Join-Path -Path $testOutputPath -ChildPath "PesterConfig.mof"
    }

    It 'Generates MOF for Pester script files' {
        if (($PesterFeature = Get-ExperimentalFeature -Name GuestConfiguration.Pester) -and -not $PesterFeature.Enabled)
        {
            Set-ItResult -Skipped -Because 'The ''GuestConfiguration.Pester'' Experimental feature is not enabled and need a restart of pwsh.'
        }

        $null = New-Item -Path $testOutputPath -ItemType Directory -Force
        $pesterMof = New-GuestConfigurationFile -Name 'PesterConfig' -Source $pesterScriptsAsset -Path $pesterMofFilePath -Force

        Test-Path -Path $pesterMof.Configuration | Should -BeTrue
        $resourcesInMofDocument = [Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache]::ImportInstances($pesterMof.Configuration, 4)
        $resourcesInMofDocument | Should -Not -BeNullOrEmpty
        $resourcesInMofDocument[0].ConfigurationName | Should -Be 'PesterConfig'
        $resourcesInMofDocument[0].ModuleName | Should -Be 'GuestConfiguration'
        $resourcesInMofDocument[0].PesterFileName | Should -Be 'EnvironmentVariables.tests'
    }
}
