BeforeDiscovery {
    $unitTestsFolderPath = Split-Path -Path $PSScriptRoot -Parent
    $testsFolderPath = Split-Path -Path $unitTestsFolderPath -Parent

    $projectPath = Split-Path -Path $testsFolderPath -Parent
    $projectName = Get-SamplerProjectName -BuildRoot $projectPath

    $projectModule = Get-Module -Name $projectName
    $null = $projectModule | Remove-Module -Force -ErrorAction 'SilentlyContinue'
    $importedModule = Import-Module -Name $projectName -Force -PassThru -ErrorAction 'Stop'
}

Describe 'Start-GuestConfigurationPackageRemediation' -ForEach @{
    ProjectPath    = $projectPath
    ProjectName    = $projectName
    ImportedModule = $importedModule
} {
    BeforeAll {
        Set-StrictMode -Version 'latest'

        $unitTestsFolderPath = Split-Path -Path $PSScriptRoot -Parent
        $testAssetsPath = Join-Path -Path $unitTestsFolderPath -ChildPath 'assets'

        $testPackagesFolderPath = Join-Path -Path $testAssetsPath -ChildPath 'TestPackages'
        $script:testFilePackagePath = Join-Path -Path $testPackagesFolderPath -ChildPath 'TestFilePackage.zip'

        $testOutputPath = Join-Path -Path $TestDrive -ChildPath 'output'
        Push-Location -Path $testOutputPath
    }

    AfterAll {
        Pop-Location
    }

    Context 'TestFile package with no parameters' {
        BeforeAll {
            $testFilePath = 'test.txt'
            $expectedContent = 'default'

            if (Test-Path -Path $testFilePath)
            {
                $null = Remove-Item -Path $testFilePath -Force
            }
        }

        It 'Set should run without throwing' {
            { Start-GuestConfigurationPackageRemediation -Path $script:testFilePackagePath -Force } | Should -Not -Throw
        }

        It 'Test file should exist at expected path' {
            Test-Path -Path $testFilePath | Should -Be $True
        }

        It 'Test file should have expected content' {
            $fileContent = Get-Content -Path $testFilePath -Raw
            $fileContent | Should -Be $expectedContent
        }
    }

    Context 'TestFile package with parameters' {
        BeforeAll {
            $testFilePath = Join-Path -Path $TestDrive -ChildPath 'Hogwarts.txt'
            $expectedContent = 'Harry Potter'

            if (Test-Path -Path $testFilePath)
            {
                $null = Remove-Item -Path $testFilePath -Force
            }

            $parameters = @(
            @{
                ResourceType = 'TestFile'
                ResourceId = 'MyTestFile'
                ResourcePropertyName = 'Ensure'
                ResourcePropertyValue = 'Present'
            },
            @{
                ResourceType = 'MyFile'
                ResourceId = 'MyTestFile'
                ResourcePropertyName = 'Path'
                ResourcePropertyValue = $testFilePath
            },
            @{
                ResourceType = 'MyFile'
                ResourceId = 'MyTestFile'
                ResourcePropertyName = 'Content'
                ResourcePropertyValue = $expectedContent
            })
        }

        It 'Set should run without throwing' {
            { Start-GuestConfigurationPackageRemediation -Path $script:testFilePackagePath -Parameter $parameters -Verbose } | Should -Not -Throw
        }

        It 'Test file should exist at expected path' {
            Test-Path -Path $testFilePath | Should -Be $True
        }

        It 'Test file should have expected content' {
            $fileContent = Get-Content -Path $testFilePath -Raw
            $fileContent | Should -Be $expectedContent
        }
    }
}
