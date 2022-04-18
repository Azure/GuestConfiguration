BeforeDiscovery {
    $projectPath = "$PSScriptRoot/../../.." | Convert-Path
    $projectName = Get-SamplerProjectName -BuildRoot $projectPath

    Get-Module $projectName | Remove-Module -Force -ErrorAction SilentlyContinue
    $importedModule = Import-Module $projectName -Force -PassThru -ErrorAction 'Stop'

    $IsNotAzureDevOps = [string]::IsNullOrEmpty($env:ADO)
    $IsNotWindowsAndIsAzureDevOps = ($IsLinux -or $IsMacOS) -AND $env:ADO
}

Describe 'Publish-GuestConfigurationPackage' -ForEach @{
    ProjectPath    = $projectPath
    projectName    = $projectName
    importedModule = $importedModule
} {

    BeforeAll {
        # test Assets path
        $testAssetsPath = Join-Path -Path $PSScriptRoot -ChildPath '../assets'
        $testMofsFolderPath = Join-Path -Path $testAssetsPath -ChildPath 'TestMofs'
        # folder with the test pester file
        $pesterScriptsAsset = Join-Path -Path $testAssetsPath -ChildPath 'pesterScripts'
        # test drive output folder
        $testOutputPath = Join-Path -Path $TestDrive -ChildPath 'output'
        $pesterMofFilePath = Join-Path -Path $testOutputPath -ChildPath "PesterConfig.mof"

        $Date = Get-Date
        $DateStamp = "$($Date.Hour)_$($Date.Minute)_$($Date.Second)_$($Date.Month)-$($Date.Day)-$($Date.Year)"
        $randomString = (get-date).ticks.tostring().Substring(12)

        $mofPath = Join-Path -Path $testMofsFolderPath -ChildPath 'DSC_Config.mof'
        $policyName = 'testPolicy'
        $testPackagePath = Join-Path -Path $testOutputPath -ChildPath 'Package'
    }

    It 'Should be able to publish packages and return a valid Uri' { # -Skip:($notReleaseBuild -or $IsNotWindowsAndIsAzureDevOps) {
        mock -CommandName Set-AzStorageBlobContent -MockWith {
            param ($Context, $Container, $Blob, $File, $Force)

            return @{
                Context   = $Context
                Container = $Container
                Blob      = $Blob
                File      = $File
                Force     = $Force
            }
        } -Verifiable -Module GuestConfiguration

        mock -CommandName Get-AzStorageAccount -MockWith {
            param ($ResourceGroupName, $StorageAccountName)

        } -Verifiable -Module GuestConfiguration

        mock -CommandName New-AzStorageBlobSasToken -MockWith {
            param ($Context, $Container, $Blob, $StartTime, $ExpiryTime, $Permission, $FullUri)
            return 'https://this.is.my.uri/'
        } -Verifiable -Module GuestConfiguration

        # Login-ToTestAzAccount
        $package = New-GuestConfigurationPackage -Configuration $mofPath -Name $policyName -Path $testPackagePath -Force
        $publishGCPackageParameters = @{
            Path               = $package.Path
            ResourceGroupName  = "GC_Module_$DateStamp"
            StorageAccountName = "sa$randomString"
        }

        # New-PublishGCPackageParameters -Path $package.Path -DateStamp $DateStamp
        $Uri = Publish-GuestConfigurationPackage @publishGCPackageParameters

        Assert-MockCalled -CommandName Get-AzStorageAccount -Times 1 -ModuleName GuestConfiguration
        Assert-MockCalled -CommandName New-AzStorageBlobSASToken -Times 1 -ModuleName GuestConfiguration
        Assert-MockCalled  -CommandName Set-AzStorageBlobContent -Times 1 -ModuleName GuestConfiguration
        $Uri.ContentUri | Should -Not -BeNullOrEmpty
        $Uri.ContentUri | Should -BeOfType 'String'
        $Uri.ContentUri | Should -Not -Contain '@'
        # { Invoke-WebRequest -Uri $Uri.ContentUri -OutFile $TestDrive/downloadedPackage.zip } | Should -Not -Throw
    }
}
