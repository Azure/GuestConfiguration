BeforeDiscovery {
    $null = Import-Module -Name 'GuestConfiguration' -Force

    $testsFolderPath = Split-Path -Path $PSScriptRoot -Parent
    $projectPath = Split-Path -Path $testsFolderPath -Parent
    $sourcePath = Join-Path -Path $projectPath -ChildPath 'source'
    $privateFunctionsPath = Join-Path -Path $sourcePath -ChildPath 'Private'
    $osFunctionScriptPath = Join-Path -Path $privateFunctionsPath -ChildPath 'Get-OSPlatform.ps1'
    $null = Import-Module -Name $osFunctionScriptPath -Force
    $script:os = Get-OSPlatform
}

Describe 'Test-GuestConfigurationPackage' {
    BeforeAll {
        Set-StrictMode -Version 'latest'

        $testsFolderPath = Split-Path -Path $PSScriptRoot -Parent
        $script:testAssetsPath = Join-Path -Path $testsFolderPath -ChildPath 'assets'
        $script:testMofsFolderPath = Join-Path -Path $testAssetsPath -ChildPath 'TestMofs'

        $script:testOutputPath = Join-Path -Path $TestDrive -ChildPath 'output'
    }

    Context 'Windows TimeZone package' -Skip:($os -ine 'Windows') {
        BeforeAll {
            $newGuestConfigurationPackageParameters = @{
                Name = 'testWindowsTimeZone'
                Configuration = Join-Path -Path $script:testMofsFolderPath -ChildPath 'DSC_Config.mof'
                Path = Join-Path -Path $script:testOutputPath -ChildPath 'Package'
                Force = $true
            }

            $package = New-GuestConfigurationPackage @newGuestConfigurationPackageParameters
            $packageHash = Get-FileHash -Path $package.Path

            $currentTimeZone = Get-TimeZone
        }

        It 'Should return the expected output with compliance status as false with no parameters' {
            $testPackageResult = Test-GuestConfigurationPackage -Path $package.Path

            $testPackageResult | Should -Not -Be $null
            $testPackageResult.complianceStatus | Should -Be $false

            $testPackageResult.resources.Count | Should -Be 1
            $testPackageResult.resources[0].properties.ModuleName | Should -Be 'ComputerManagementDsc'
            $testPackageResult.resources[0].complianceStatus | Should -Be $false
            $testPackageResult.resources[0].properties.ConfigurationName | Should -Be 'DSCConfig'
            $testPackageResult.resources[0].properties.IsSingleInstance | Should -Be 'Yes'
        }

        It 'Should return the expected output with compliance status as true with parameters' {
            $parameterValue = @{
                ResourceType = 'TimeZone'
                ResourceId = 'TimeZoneExample'
                ResourcePropertyName = 'TimeZone'
                ResourcePropertyValue = $currentTimeZone.Id
            }

            $testPackageResult = Test-GuestConfigurationPackage -Path $package.Path -Parameter $parameterValue

            $testPackageResult | Should -Not -Be $null
            $testPackageResult.complianceStatus | Should -Be $true

            $testPackageResult.resources.Count | Should -Be 1
            $testPackageResult.resources[0].properties.ModuleName | Should -Be 'ComputerManagementDsc'
            $testPackageResult.resources[0].complianceStatus | Should -Be $true
            $testPackageResult.resources[0].properties.ConfigurationName | Should -Be 'DSCConfig'
            $testPackageResult.resources[0].properties.IsSingleInstance | Should -Be 'Yes'
            $testPackageResult.resources[0].properties.TimeZone | Should -Be $currentTimeZone.Id
        }

        It 'Should return the expected output with compliance status as false with parameters' {
            $allTimeZones = @( Get-TimeZone -ListAvailable )
            $otherTimeZones = @( $allTimeZones | Where-Object { $_.Id -ine $currentTimeZone.Id } )
            $otherTimeZone = $otherTimeZones[0]

            $parameterValue = @{
                ResourceType = 'TimeZone'
                ResourceId = 'TimeZoneExample'
                ResourcePropertyName = 'TimeZone'
                ResourcePropertyValue = $otherTimeZone.Id
            }

            $testPackageResult = Test-GuestConfigurationPackage -Path $package.Path -Parameter $parameterValue

            $testPackageResult | Should -Not -Be $null
            $testPackageResult.complianceStatus | Should -Be $false

            $testPackageResult.resources.Count | Should -Be 1
            $testPackageResult.resources[0].properties.ModuleName | Should -Be 'ComputerManagementDsc'
            $testPackageResult.resources[0].complianceStatus | Should -Be $false
            $testPackageResult.resources[0].properties.ConfigurationName | Should -Be 'DSCConfig'
            $testPackageResult.resources[0].properties.IsSingleInstance | Should -Be 'Yes'
            $testPackageResult.resources[0].properties.TimeZone | Should -Be $currentTimeZone.Id
        }

        It 'Should not have installed Guest Configuration under the system path' {
            $systemGuestConfigurationPath = 'C:\ProgramData\GuestConfig'
            Test-Path -Path $systemGuestConfigurationPath | Should -BeFalse
        }

        It 'Package should not have changed after running all tests' {
            $currentPackageHash = Get-FileHash -Path $package.Path
            $currentPackageHash.Hash | Should -Be $packageHash.Hash
        }
    }

    Context 'Cross-platform TestFile package' {
        BeforeAll {
            $testPackagesFolderPath = Join-Path -Path $script:testAssetsPath -ChildPath 'TestPackages'
            $script:testFilePackagePath = Join-Path -Path $testPackagesFolderPath -ChildPath 'TestFilePackage_1.0.0.0.zip'
        }

        Context 'No parameters' {
            BeforeAll {
                $testFilePath = "$($env:SystemDrive)test.txt"
                $expectedContent = 'default'
            }

            AfterAll {
                if (Test-Path -Path $testFilePath)
                {
                    $null = Remove-Item -Path $testFilePath -Force
                }
            }

            It 'Should return the expected result object when compliance status is false' {
                if (Test-Path -Path $testFilePath)
                {
                    $null = Remove-Item -Path $testFilePath -Force
                }

                $result = Test-GuestConfigurationPackage -Path $script:testFilePackagePath

                $result.assignmentName | Should -Be 'TestFilePackage'
                $result.complianceStatus | Should -BeFalse
                $result.operationtype | Should -Be 'Consistency'
                $result.resources.Count | Should -Be 1
                $result.resources[0].ComplianceStatus | Should -BeFalse
                $result.resources[0].Reasons.Count | Should -Be 1
                $result.resources[0].Reasons[0].Code | Should -Not -BeNullOrEmpty
                $result.resources[0].Reasons[0].Phrase | Should -Not -BeNullOrEmpty
            }

            It 'Should return the expected result object when compliance status is true' {
                $null = Set-Content -Path $testFilePath -Value $expectedContent -NoNewline -Force

                $result = Test-GuestConfigurationPackage -Path $script:testFilePackagePath

                $result.assignmentName | Should -Be 'TestFilePackage'
                $result.complianceStatus | Should -BeTrue
                $result.operationtype | Should -Be 'Consistency'
                $result.resources.Count | Should -Be 1
                $result.resources[0].ComplianceStatus | Should -BeTrue
            }
        }

        Context 'With parameters' {
            BeforeAll {
                $testFilePath = Join-Path -Path $TestDrive -ChildPath 'Hogwarts.txt'
                $expectedContent = 'Harry Potter'

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

            AfterAll {
                if (Test-Path -Path $testFilePath)
                {
                    $null = Remove-Item -Path $testFilePath -Force
                }
            }

            It 'Should return the expected result object when compliance is false' {
                if (Test-Path -Path $testFilePath)
                {
                    $null = Remove-Item -Path $testFilePath -Force
                }

                $result = Test-GuestConfigurationPackage -Path $script:testFilePackagePath -Parameter $parameters

                $result.assignmentName | Should -Be 'TestFilePackage'
                $result.complianceStatus | Should -BeFalse
                $result.operationtype | Should -Be 'Consistency'
                $result.resources.Count | Should -Be 1
                $result.resources[0].ComplianceStatus | Should -BeFalse
                $result.resources[0].Reasons.Count | Should -Be 1
                $result.resources[0].Reasons[0].Code | Should -Not -BeNullOrEmpty
                $result.resources[0].Reasons[0].Phrase | Should -Not -BeNullOrEmpty
            }

            It 'Should return the expected result object when compliance is true' {
                $null = Set-Content -Path $testFilePath -Value $expectedContent -NoNewline -Force

                $result = Test-GuestConfigurationPackage -Path $script:testFilePackagePath -Parameter $parameters

                $result.assignmentName | Should -Be 'TestFilePackage'
                $result.complianceStatus | Should -BeTrue
                $result.operationtype | Should -Be 'Consistency'
                $result.resources.Count | Should -Be 1
                $result.resources[0].ComplianceStatus | Should -BeTrue
            }
        }
    }
}
