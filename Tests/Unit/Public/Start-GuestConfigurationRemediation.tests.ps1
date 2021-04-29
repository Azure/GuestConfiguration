BeforeDiscovery {
    $script:projectPath = "$PSScriptRoot/../../.." | Convert-Path
    $script:projectName = Get-SamplerProjectName -BuildRoot $script:projectPath

    Get-Module $script:projectName | Remove-Module -Force -ErrorAction SilentlyContinue
    $script:importedModule = Import-Module $script:projectName -Force -PassThru -ErrorAction 'Stop'

    $IsNotAzureDevOps = [string]::IsNullOrEmpty($env:ADO)
    $IsNotWindowsAndIsAzureDevOps = ($IsLinux -or $IsMacOS) -AND $env:ADO
}

Context 'Start-GuestConfigurationPackageRemediation' {
    BeforeAll {
        $testAssetsPath = Join-Path -Path $PSScriptRoot -ChildPath '../assets'
        $packagePath = Join-Path -Path $testAssetsPath -ChildPath 'TestPackages/testStartPolicy-MyFile.zip'

        # Path to temp files
        $Env:MyTestPath = $TestDrive
        $tempWithParameterFile = Join-Path -Path $TestDrive -ChildPath 'test_gen.txt'
        $tempDefaultFile = Join-Path -Path $TestDrive -ChildPath 'test.txt'

        # Contents of temp file
        $tempFileDefaultContents = 'foobar'
        $tempWithParameterContents = 'barfoo'
    }

    It 'Validate that start scenario is working as expected on Windows without parameters' -Skip:($IsLinux -or $IsMacOS) {
        # Validate that dummy file does not exist
        Test-Path -Path $tempDefaultFile | Should -Be $False

        # Run start, validate it does not throw
        { Start-GuestConfigurationPackageRemediation -Path $packagePath -Force } | Should -Not -Throw

        # Validate temp file exists
        Test-Path -Path $tempDefaultFile | Should -Be $True

        # Validate contents of temp file
        Get-Content -Path $tempDefaultFile -Raw | Should -Be $tempFileDefaultContents
    }


    It 'Validate that start scenario is working as expected on Windows with parameters' -Skip:($IsLinux -or $IsMacOS) {
        # Validate that dummy file does not exist
        Test-Path -Path $tempWithParameterFile | Should -Be $False

        # Run start, validate it does not throw
        $Parameter = @(
            @{
                ResourceType = 'MyFile'
                ResourceId = 'createFoobarTestFile'
                ResourcePropertyName = 'Ensure'
                ResourcePropertyValue = 'Present'
            },
            @{
                ResourceType = 'MyFile'
                ResourceId = 'createFoobarTestFile'
                ResourcePropertyName = 'path'
                ResourcePropertyValue = $tempWithParameterFile
            },
            @{
                ResourceType = 'MyFile'
                ResourceId = 'createFoobarTestFile'
                ResourcePropertyName = 'content'
                ResourcePropertyValue = $tempWithParameterContents
            })
        { Start-GuestConfigurationPackageRemediation -Path $packagePath -Parameter $Parameter -Force } | Should -Not -Throw

        # Validate temp file exists
        Test-Path -Path $tempWithParameterFile | Should -Be $True

        # Validate contents of temp file
        Get-Content -Path $tempWithParameterFile -Raw | Should -Be $tempWithParameterContents
    }

    It 'Validate that start scenario is working as expected on Linux' -Skip:($IsWindows -or $IsMacOS) {
        # { Install-GuestConfigurationPackage -Path $packagePath } | Should -Not -Throw
        # InModuleScope -ModuleName GuestConfiguration {
        #     { Get-Item -Path (Get-GuestConfigBinaryPath) } | Should -Not -Throw
        # }
    }

}
