BeforeDiscovery {
    $unitTestsFolderPath = Split-Path -Path $PSScriptRoot -Parent
    $testsFolderPath = Split-Path -Path $unitTestsFolderPath -Parent

    $projectPath = Split-Path -Path $testsFolderPath -Parent
    $projectName = Get-SamplerProjectName -BuildRoot $projectPath

    $projectModule = Get-Module -Name $projectName
    $null = $projectModule | Remove-Module -Force -ErrorAction 'SilentlyContinue'
    $importedModule = Import-Module -Name $projectName -Force -PassThru -ErrorAction 'Stop'
}

Describe 'Get-GuestConfigurationPackageComplianceStatus' -ForEach @{
    ProjectPath    = $projectPath
    ProjectName    = $projectName
    ImportedModule = $importedModule
} {
    BeforeAll {
        Set-StrictMode -Version 'latest'

        $unitTestsFolderPath = Split-Path -Path $PSScriptRoot -Parent
        $testAssetsPath = Join-Path -Path $unitTestsFolderPath -ChildPath 'assets'
        $testMofsFolderPath = Join-Path -Path $testAssetsPath -ChildPath 'TestMofs'

        $testOutputPath = Join-Path -Path $TestDrive -ChildPath 'output'
    }

    Context 'Windows TimeZone package' -Skip:(-not $IsWindows) {
        BeforeAll {
            $newGuestConfigurationPackageParameters = @{
                Name = 'testWindowsTimeZone'
                Configuration = Join-Path -Path $testMofsFolderPath -ChildPath 'DSC_Config.mof'
                Path = Join-Path -Path $testOutputPath -ChildPath 'Package'
                Force = $true
            }

            $package = New-GuestConfigurationPackage @newGuestConfigurationPackageParameters
            $packageHash = Get-FileHash -Path $package.Path

            $currentTimeZone = Get-TimeZone
        }

        It 'Should return the expected output with compliance status as false with no parameters' {
            $testPackageResult = Get-GuestConfigurationPackageComplianceStatus -Path $package.Path -Verbose

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

            $testPackageResult = Get-GuestConfigurationPackageComplianceStatus -Path $package.Path -Parameter $parameterValue -Verbose

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

            $testPackageResult = Get-GuestConfigurationPackageComplianceStatus -Path $package.Path -Parameter $parameterValue

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
        It 'Validate that the resource compliance results are as expected on Linux' -Skip:(-not $IsLinux) {
            $inSpecTestAssetsPath = Join-Path -Path $testAssetsPath -ChildPath 'InspecConfig'

            $newGuestConfigurationPackageParameters = @{
                Name = 'testLinuxNativeInSpec'
                Configuration = Join-Path -Path $inSpecTestAssetsPath -ChildPath 'InSpec_Config.mof'
                Path = Join-Path -Path $testOutputPath -ChildPath 'Package'
                ChefInspecProfilePath = $inSpecTestAssetsPath
                Force = $true
            }

            $package = New-GuestConfigurationPackage @newGuestConfigurationPackageParameters

            $testPackageResult = Get-GuestConfigurationPackageComplianceStatus -Path $package.Path -ErrorAction 'Stop' -Verbose -Debug

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
}
