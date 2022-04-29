BeforeDiscovery {
    $unitTestsFolderPath = Split-Path -Path $PSScriptRoot -Parent
    $testsFolderPath = Split-Path -Path $unitTestsFolderPath -Parent

    $projectPath = Split-Path -Path $testsFolderPath -Parent
    $projectName = Get-SamplerProjectName -BuildRoot $projectPath

    Get-Module $projectName | Remove-Module -Force -ErrorAction SilentlyContinue
    $importedModule = Import-Module $projectName -Force -PassThru -ErrorAction 'Stop'
}

Describe 'Publish-GuestConfigurationPackage' {
    BeforeAll {
        Set-StrictMode -Version 'latest'

        $unitTestsFolderPath = Split-Path -Path $PSScriptRoot -Parent
        $testAssetsPath = Join-Path -Path $unitTestsFolderPath -ChildPath 'assets'
        $testPackagesFolderPath = Join-Path -Path $testAssetsPath -ChildPath 'TestPackages'
    }

    It 'Should be able to publish packages and return a valid Uri' {
        $mockUri = 'https://this.is.my.uri/'

        Mock -CommandName 'Set-AzStorageBlobContent' -Module 'GuestConfiguration' -MockWith {
            param ($Context, $Container, $Blob, $File, $Force)

            return @{
                Context   = $Context
                Container = $Container
                Blob      = $Blob
                File      = $File
                Force     = $Force
            }
        }

        Mock -CommandName 'New-AzStorageContext' -Module 'GuestConfiguration' -MockWith {
            return (New-MockObject -Type 'Microsoft.WindowsAzure.Commands.Storage.AzureStorageContext')
        }

        Mock -CommandName 'New-AzStorageBlobSasToken' -Module 'GuestConfiguration' -MockWith {
            param ($Context, $Container, $Blob, $StartTime, $ExpiryTime, $Permission, $FullUri)
            return $mockUri
        }

        $testPackageName = 'TestFilePackage_1.0.0.0.zip'

        $publishGCPackageParameters = @{
            Path = Join-Path -Path $testPackagesFolderPath -ChildPath $testPackageName
            StorageAccountName = 'storageaccountname'
            StorageContainerName = 'storagecontainername'
        }

        $result = Publish-GuestConfigurationPackage @publishGCPackageParameters

        Assert-MockCalled -CommandName 'New-AzStorageContext' -Module 'GuestConfiguration' -Times 1
        Assert-MockCalled -CommandName 'New-AzStorageBlobSASToken' -Module 'GuestConfiguration' -Times 1
        Assert-MockCalled  -CommandName 'Set-AzStorageBlobContent' -Module 'GuestConfiguration' -Times 1

        $result.ContentUri | Should -Be $mockUri
    }
}
