BeforeDiscovery {
    $projectPath = "$PSScriptRoot/../../.." | Convert-Path
    $projectName = Get-SamplerProjectName -BuildRoot $projectPath

    Get-Module $projectName | Remove-Module -Force -ErrorAction SilentlyContinue
    $importedModule = Import-Module $projectName -Force -PassThru -ErrorAction 'Stop'
}

Describe 'Start-GuestConfigurationPackageRemediation' -ForEach @{
    ProjectPath    = $projectPath
    projectName    = $projectName
    importedModule = $importedModule
} {
    BeforeAll {
        $testAssetsPath = Join-Path -Path $PSScriptRoot -ChildPath '../assets'
        $packagePath = Join-Path -Path $testAssetsPath -ChildPath 'TestPackages/testStartPolicy-MyFile.zip'

        # Path to temp files
        $Env:MyTestPath = $TestDrive
        if ($IsWindows)
        {
            $tempDefaultFile = Join-Path -Path $TestDrive -ChildPath 'test.txt'
        }
        else
        {
            $tempDefaultFile = "/tmp/test.txt"
        }
        $tempWithParameterFile = Join-Path -Path $TestDrive -ChildPath 'test_gen.txt'

        # Contents of temp file
        $tempFileDefaultContents = 'foobar'
        $tempWithParameterContents = 'barfoo'
    }

    It 'Validate that start scenario is working as expected without parameters' {
        # Validate that dummy file does not exist
        Test-Path -Path $tempDefaultFile | Should -Be $False

        # Run start, validate it does not throw
        { Start-GuestConfigurationPackageRemediation -Path $packagePath -Force } | Should -Not -Throw

        # Validate temp file exists
        Test-Path -Path $tempDefaultFile | Should -Be $True

        # Validate contents of temp file
        Get-Content -Path $tempDefaultFile -Raw | Should -Be $tempFileDefaultContents -Because "File '$tempDefaultFile' has not the right content."
    }


    It 'Validate that start scenario is working as expected with parameters' {
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
}
