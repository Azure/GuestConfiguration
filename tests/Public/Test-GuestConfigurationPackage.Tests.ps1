BeforeDiscovery {
    $testsFolderPath = Split-Path -Path $PSScriptRoot -Parent

    $projectPath = Split-Path -Path $testsFolderPath -Parent
    $projectName = Get-SamplerProjectName -BuildRoot $projectPath

    $projectModule = Get-Module -Name $projectName
    $null = $projectModule | Remove-Module -Force -ErrorAction 'SilentlyContinue'
    $null = Import-Module -Name $projectName -Force

    $sourcePath = Join-Path -Path $projectPath -ChildPath 'source'
    $privateFunctionsPath = Join-Path -Path $sourcePath -ChildPath 'Private'
    $osFunctionScriptPath = Join-Path -Path $privateFunctionsPath -ChildPath 'Get-OSPlatform.ps1'
    $null = Import-Module -Name $osFunctionScriptPath -Force
    $script:os = Get-OSPlatform
}

Describe 'Test-GuestConfigurationPackage' {
    BeforeAll {
        Set-StrictMode -Version 'latest'

        if ($null -eq (Get-Command -Name 'Get-FileHash' -ErrorAction 'SilentlyContinue'))
        {
            $null = Import-Module -Name 'Microsoft.PowerShell.Utility'
        }

        $testsFolderPath = Split-Path -Path $PSScriptRoot -Parent
        $testAssetsPath = Join-Path -Path $testsFolderPath -ChildPath 'assets'
        $script:testMofsFolderPath = Join-Path -Path $testAssetsPath -ChildPath 'TestMofs'

        $script:testOutputPath = Join-Path -Path $TestDrive -ChildPath 'output'
    }

    Context 'Windows TimeZone package' -Skip:($script:os -ine 'Windows') {
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
            $testPackageResult = Test-GuestConfigurationPackage -Path $package.Path -Verbose

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

            $testPackageResult = Test-GuestConfigurationPackage -Path $package.Path -Parameter $parameterValue -Verbose

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

    Context 'Linux native InSpec path check package' {
        It 'Validate that the resource compliance results are as expected on Linux' -Skip:($script:os -ine 'Linux') {
            $inSpecTestAssetsPath = Join-Path -Path $testAssetsPath -ChildPath 'InspecConfig'

            $newGuestConfigurationPackageParameters = @{
                Name = 'testLinuxNativeInSpec'
                Configuration = Join-Path -Path $inSpecTestAssetsPath -ChildPath 'InSpec_Config.mof'
                Path = Join-Path -Path $script:testOutputPath -ChildPath 'Package'
                ChefInspecProfilePath = $inSpecTestAssetsPath
                Force = $true
            }

            $package = New-GuestConfigurationPackage @newGuestConfigurationPackageParameters

            $testPackageResult = Test-GuestConfigurationPackage -Path $package.Path -ErrorAction 'Stop' -Verbose -Debug

            $testPackageResult | Should -Not -Be $null
            $testPackageResult.complianceStatus | Should -Be $true

            $testPackageResult.resources.Count | Should -Be 1
            $testPackageResult.resources[0].properties.ModuleName | Should -Be 'GuestConfiguration'
            $testPackageResult.resources[0].complianceStatus | Should -Be $true
            $testPackageResult.resources[0].properties.ConfigurationName | Should -Be 'DSCConfig'
        }

        It 'Should not have installed Guest Configuration under the system path' {
            $systemGuestConfigurationPath = '/var/lib/GuestConfig'
            Test-Path -Path $systemGuestConfigurationPath | Should -BeFalse
        }
    }

    Context 'Windows Script package' -Skip:($script:os -ine 'Windows') {
        BeforeAll {
            $newGuestConfigurationPackageParameters = @{
                Name = 'testScript'
                Configuration = Join-Path -Path $script:testMofsFolderPath -ChildPath 'TestScript.mof'
                Path = Join-Path -Path $script:testOutputPath -ChildPath 'Package'
                Force = $true
            }

            $package = New-GuestConfigurationPackage @newGuestConfigurationPackageParameters
            $packageHash = Get-FileHash -Path $package.Path
        }

        It 'Should return the expected output with compliance status as false with no parameters' {
            $testPackageResult = Test-GuestConfigurationPackage -Path $package.Path -Verbose

            $testPackageResult | Should -Not -Be $null
            $testPackageResult.complianceStatus | Should -Be $false

            $testPackageResult.resources.Count | Should -Be 1
            $testPackageResult.resources[0].properties.ModuleName | Should -Be 'PSDscResources'
            $testPackageResult.resources[0].complianceStatus | Should -Be $false
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
}
