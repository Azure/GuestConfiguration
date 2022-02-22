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
        $script:testFilePackagePath = Join-Path -Path $testPackagesFolderPath -ChildPath 'TestFilePackage_1.0.0.0.zip'

        $testOutputPath = Join-Path -Path $TestDrive -ChildPath 'output'

        if (-not (Test-Path -Path $testOutputPath))
        {
            $null = New-Item -Path $testOutputPath -ItemType 'Directory' -Force
        }

        Push-Location -Path $testOutputPath
    }

    AfterAll {
        Pop-Location
    }

    Context 'TestFile package with no parameters' {
        BeforeAll {
            $testFilePath = "$($env:SystemDrive)test.txt"
            $expectedContent = 'default'

            if (Test-Path -Path $testFilePath)
            {
                $null = Remove-Item -Path $testFilePath -Force
            }
        }

        AfterAll {
            if (Test-Path -Path $testFilePath)
            {
                $null = Remove-Item -Path $testFilePath -Force
            }
        }

        It 'Set should run without throwing' {
            { Start-GuestConfigurationPackageRemediation -Path $script:testFilePackagePath -Verbose } | Should -Not -Throw
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
                    ResourcePropertyName = 'Path'
                    ResourcePropertyValue = $testFilePath
                },
                @{
                    ResourceType = 'TestFile'
                    ResourceId = 'MyTestFile'
                    ResourcePropertyName = 'Content'
                    ResourcePropertyValue = $expectedContent
                }
            )
        }

        It 'Set should run without throwing' {
            { Start-GuestConfigurationPackageRemediation -Path $script:testFilePackagePath -Parameter $parameters } | Should -Not -Throw
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
