BeforeDiscovery {
    $null = Import-Module -Name 'GuestConfiguration' -Force
}

Describe 'GuestConfiguration module validation' {
    BeforeAll {
        $module = Get-Module -Name 'GuestConfiguration'
        $modulePath = $module.ModuleBase

        $script:binPath = Join-Path -Path $modulePath -ChildPath 'bin'
        $script:dscResourcesPath = Join-Path -Path $modulePath -ChildPath 'DscResources'
    }

    It 'Should contain a valid module manifest' {
        $manifestPath = Join-Path -Path $modulePath -ChildPath 'GuestConfiguration.psd1'

        $moduleInfo = Test-ModuleManifest -Path $manifestPath
        $moduleInfo | Should -Not -BeNullOrEmpty
    }

    It 'Should contain a bin folder' {
        Test-Path -Path $script:binPath -PathType 'Container' | Should -BeTrue
    }

    It 'Should contain the Linux agent binaries' {
        $linuxAgentPath = Join-Path -Path $script:binPath -ChildPath 'DSC_Linux.zip'
        Test-Path -Path $linuxAgentPath -PathType 'Leaf' | Should -BeTrue
    }

    It 'Should contain the Windows agent binaries' {
        $windowsAgentPath = Join-Path -Path $script:binPath -ChildPath 'DSC_Windows.zip'
        Test-Path -Path $windowsAgentPath -PathType 'Leaf' | Should -BeTrue
    }

    It 'Should contain a DscResources folder' {
        Test-Path -Path $script:dscResourcesPath -PathType 'Container' | Should -BeTrue
    }

    It 'Should contain the native InSpec resource' {
        $inSpecResourcePath = Join-Path -Path $script:dscResourcesPath -ChildPath 'MSFT_ChefInSpecResource'
        Test-Path -Path $inSpecResourcePath -PathType 'Container' | Should -BeTrue

        $inSpecResourceLibraryPath = Join-Path -Path $inSpecResourcePath -ChildPath 'libMSFT_ChefInSpecResource.so'
        Test-Path -Path $inSpecResourceLibraryPath -PathType 'Leaf' | Should -BeTrue

        $inSpecResourceSchemaPath = Join-Path -Path $inSpecResourcePath -ChildPath 'MSFT_ChefInSpecResource.schema.mof'
        Test-Path -Path $inSpecResourceSchemaPath -PathType 'Leaf' | Should -BeTrue

        $inSpecInstallScriptPath = Join-Path -Path $inSpecResourcePath -ChildPath 'install_inspec.sh'
        Test-Path -Path $inSpecInstallScriptPath -PathType 'Leaf' | Should -BeTrue
    }

    It 'Should be able to retrieve imported module' {
        $module = Get-Module -Name 'GuestConfiguration'

        $module | Should -Not -BeNullOrEmpty
        $module | ForEach-Object { $_.Name } | Should -Be 'GuestConfiguration'
    }

    It 'Help text should have examples' {
        foreach ($function in $publicFunctions)
        {
            Get-Help -Name $function | ForEach-Object { $_.Examples } | Should -Not -BeNullOrEmpty
        }
    }
}
