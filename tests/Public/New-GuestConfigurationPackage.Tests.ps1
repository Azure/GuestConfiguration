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

Describe 'New-GuestConfigurationPackage' {
    BeforeAll {
        Set-StrictMode -Version 'latest'

        $testsFolderPath = Split-Path -Path $PSScriptRoot -Parent
        $testAssetsPath = Join-Path -Path $testsFolderPath -ChildPath 'assets'
        $script:testMofsFolderPath = Join-Path -Path $testAssetsPath -ChildPath 'TestMofs'
        $testModulesFolderPath = Join-Path -Path $testAssetsPath -ChildPath 'TestModules'

        $script:testOutputPath = Join-Path -Path $TestDrive -ChildPath 'output'

        $script:originalPSModulePath = $env:PSModulePath
        $env:PSModulePath = $env:PSModulePath + ";" + $testModulesFolderPath
    }

    AfterAll {
        $env:PSModulePath = $script:originalPSModulePath
    }

    Context 'Test module with submodule' {
        BeforeAll {
            $newGuestConfigurationPackageParameters = @{
                Name = 'testCustom'
                Configuration = Join-Path -Path $script:testMofsFolderPath -ChildPath 'TestCustom.mof'
                Path = Join-Path -Path $script:testOutputPath -ChildPath 'Custom'
                Force = $true
            }

            $compressedPackageName = "$($newGuestConfigurationPackageParameters.Name).zip"
            $compressedPackagePath = Join-Path -Path $newGuestConfigurationPackageParameters.Path -ChildPath $compressedPackageName

            $expandedPackageName = "$($newGuestConfigurationPackageParameters.Name)-Expanded"
            $expandedPackagePath = Join-Path -Path $script:testOutputPath -ChildPath $expandedPackageName

            $expandedPackageModulesPath = Join-Path -Path $expandedPackagePath -ChildPath 'Modules'
        }

        It 'Should be able to create a custom package with the expected output object' {
            $package = New-GuestConfigurationPackage @newGuestConfigurationPackageParameters
            $package | Should -Not -BeNull
            $package.Name | Should -Be $newGuestConfigurationPackageParameters.Name
            $package.Path | Should -Be $compressedPackagePath
        }

        It 'Compressed package should exist at expected output path' {
            Test-Path -Path $compressedPackagePath -PathType 'Leaf' | Should -BeTrue
        }

        It 'Should be able to expand the new package' {
            $null = Expand-Archive -Path $compressedPackagePath -DestinationPath $expandedPackagePath -Force
            Test-Path -Path $expandedPackagePath -PathType 'Container' | Should -BeTrue
        }

        It 'Mof file should exist in expanded package' {
            $expectedMofName = "$($newGuestConfigurationPackageParameters.Name).mof"
            $expandedPackageMofFilePath = Join-Path -Path $expandedPackagePath -ChildPath $expectedMofName
            Test-Path -Path $expandedPackageMofFilePath -PathType 'Leaf' | Should -BeTrue
        }

        It 'Metaconfig should exist with default Type (Audit) and Version (1.0.0) in expanded package' {
            $expectedMetaconfigName = "$($newGuestConfigurationPackageParameters.Name).metaconfig.json"
            $expectedMetaconfigPath = Join-Path -Path $expandedPackagePath -ChildPath $expectedMetaconfigName
            Test-Path -Path $expectedMetaconfigPath -PathType 'Leaf' | Should -BeTrue

            $metaconfigContent = Get-Content -Path $expectedMetaconfigPath -Raw
            $metaconfigJson = $metaconfigContent | ConvertFrom-Json

            $metaconfigJson | Should -Not -BeNullOrEmpty
            $metaconfigJson.Type | Should -Be 'Audit'
            $metaconfigJson.Version | Should -Be '1.0.0'
        }

        It 'Expanded package should include the TestModule module dependency' {
            $expectedResourceModulePath = Join-Path -Path $expandedPackageModulesPath -ChildPath 'TestModule'
            Test-Path -Path $expectedResourceModulePath -PathType 'Container' | Should -BeTrue
        }

        It 'Expanded package should include the SubModule module dependency' {
            $expectedResourceModulePath = Join-Path -Path $expandedPackageModulesPath -ChildPath 'SubModule'
            Test-Path -Path $expectedResourceModulePath -PathType 'Container' | Should -BeTrue
        }
    }

    Context 'Windows package with community PowerShell TimeZone resource' -skip:($script:os -ine 'Windows') {
        BeforeAll {
            $newGuestConfigurationPackageParameters = @{
                Name = 'testWindowsTimeZone'
                Configuration = Join-Path -Path $script:testMofsFolderPath -ChildPath 'DSC_Config.mof'
                Path = Join-Path -Path $script:testOutputPath -ChildPath 'Package'
                Force = $true
            }

            $compressedPackageName = "$($newGuestConfigurationPackageParameters.Name).zip"
            $compressedPackagePath = Join-Path -Path $newGuestConfigurationPackageParameters.Path -ChildPath $compressedPackageName

            $expandedPackageName = "$($newGuestConfigurationPackageParameters.Name)-Expanded"
            $expandedPackagePath = Join-Path -Path $script:testOutputPath -ChildPath $expandedPackageName

            $expandedPackageModulesPath = Join-Path -Path $expandedPackagePath -ChildPath 'Modules'

            $extraDirectorySourcePath = Join-Path -Path $testAssetsPath -ChildPath 'FilesToInclude'
        }

        It 'Should be able to create a custom Windows package with the expected output object' {
            $package = New-GuestConfigurationPackage @newGuestConfigurationPackageParameters
            $package | Should -Not -BeNull
            $package.Name | Should -Be $newGuestConfigurationPackageParameters.Name
            $package.Path | Should -Be $compressedPackagePath
        }

        It 'Compressed package should exist at expected output path' {
            Test-Path -Path $compressedPackagePath -PathType 'Leaf' | Should -BeTrue
        }

        It 'Should be able to expand the new package' {
            $null = Expand-Archive -Path $compressedPackagePath -DestinationPath $expandedPackagePath -Force
            Test-Path -Path $expandedPackagePath -PathType 'Container' | Should -BeTrue
        }

        It 'Mof file should exist in expanded package' {
            $expectedMofName = "$($newGuestConfigurationPackageParameters.Name).mof"
            $expandedPackageMofFilePath = Join-Path -Path $expandedPackagePath -ChildPath $expectedMofName
            Test-Path -Path $expandedPackageMofFilePath -PathType 'Leaf' | Should -BeTrue
        }

        It 'Metaconfig should exist with default Type (Audit) and Version (1.0.0) in expanded package' {
            $expectedMetaconfigName = "$($newGuestConfigurationPackageParameters.Name).metaconfig.json"
            $expectedMetaconfigPath = Join-Path -Path $expandedPackagePath -ChildPath $expectedMetaconfigName
            Test-Path -Path $expectedMetaconfigPath -PathType 'Leaf' | Should -BeTrue

            $metaconfigContent = Get-Content -Path $expectedMetaconfigPath -Raw
            $metaconfigJson = $metaconfigContent | ConvertFrom-Json

            $metaconfigJson | Should -Not -BeNullOrEmpty
            $metaconfigJson.Type | Should -Be 'Audit'
            $metaconfigJson.Version | Should -Be '1.0.0'
        }

        It 'Expanded package should include the ComputerManagementDsc module dependency' {
            $expectedResourceModulePath = Join-Path -Path $expandedPackageModulesPath -ChildPath 'ComputerManagementDsc'
            Test-Path -Path $expectedResourceModulePath -PathType 'Container' | Should -BeTrue
        }

        It 'Should include extra directory when FilesToInclude parameter is specified' {
            $itSpecificParameters = $newGuestConfigurationPackageParameters + @{
                FilesToInclude = $extraDirectorySourcePath
            }

            $null = New-GuestConfigurationPackage @itSpecificParameters

            $itSpecificExpandedPackagePath = "$expandedPackagePath-DirectoryIncluded"

            $null = Expand-Archive -Path $compressedPackagePath -DestinationPath $itSpecificExpandedPackagePath -Force

            $itSpecificExpandedPackageModulesPath = Join-Path -Path $itSpecificExpandedPackagePath -ChildPath 'Modules'
            $expectedExtraDirectoryPath = Join-Path -Path $itSpecificExpandedPackageModulesPath -ChildPath 'FilesToInclude'
            Test-Path -Path $expectedExtraDirectoryPath -PathType 'Container' | Should -BeTrue

            $expectedExtraFilePath = Join-Path -Path $expectedExtraDirectoryPath -ChildPath 'file.txt'
            Test-Path -Path $expectedExtraFilePath | Should -BeTrue

            $expandedExtraFileContent = Get-Content -Path $expectedExtraFilePath
            $expandedExtraFileContent | Should -Be 'test'
        }

        It 'Should include extra file when FilesToInclude parameter is specified' {
            $extraFileSourcePath = Join-Path -Path $extraDirectorySourcePath -ChildPath 'file.txt'

            $itSpecificParameters = $newGuestConfigurationPackageParameters + @{
                FilesToInclude = $extraFileSourcePath
            }

            $null = New-GuestConfigurationPackage @itSpecificParameters

            $itSpecificExpandedPackagePath = "$expandedPackagePath-FileIncluded"

            $null = Expand-Archive -Path $compressedPackagePath -DestinationPath $itSpecificExpandedPackagePath -Force

            $itSpecificExpandedPackageModulesPath = Join-Path -Path $itSpecificExpandedPackagePath -ChildPath 'Modules'
            $expectedExtraFilePath = Join-Path -Path $itSpecificExpandedPackageModulesPath -ChildPath 'file.txt'
            Test-Path -Path $expectedExtraFilePath | Should -BeTrue

            $expandedExtraFileContent = Get-Content -Path $expectedExtraFilePath
            $expandedExtraFileContent | Should -Be 'test'
        }

        It 'Should not include any extra files after updating package without FilesToInclude parameter' {
            $null = New-GuestConfigurationPackage @newGuestConfigurationPackageParameters

            $itSpecificExpandedPackagePath = "$expandedPackagePath-NoFileIncluded"
            $null = Expand-Archive -Path $compressedPackagePath -DestinationPath $itSpecificExpandedPackagePath -Force

            $itSpecificExpandedPackageModulesPath = Join-Path -Path $itSpecificExpandedPackagePath -ChildPath 'Modules'

            $expectedExtraDirectoryPath = Join-Path -Path $itSpecificExpandedPackageModulesPath -ChildPath 'FilesToInclude'
            Test-Path -Path $expectedExtraDirectoryPath | Should -BeFalse

            $expectedExtraFilePath = Join-Path -Path $itSpecificExpandedPackageModulesPath -ChildPath 'file.txt'
            Test-Path -Path $expectedExtraFilePath | Should -BeFalse
        }

        It 'Should set Type as AuditAndSet and Version as given value in package metaconig when parameters specified' {
            $itSpecificParameters = $newGuestConfigurationPackageParameters + @{
                Type = 'AuditAndSet'
                Version = '3.4.0'
            }

            $null = New-GuestConfigurationPackage @itSpecificParameters

            $itSpecificExpandedPackagePath = "$expandedPackagePath-TypeSetAndVersion"
            $null = Expand-Archive -Path $compressedPackagePath -DestinationPath $itSpecificExpandedPackagePath -Force

            $expectedMetaconfigName = "$($newGuestConfigurationPackageParameters.Name).metaconfig.json"
            $expectedMetaconfigPath = Join-Path -Path $itSpecificExpandedPackagePath -ChildPath $expectedMetaconfigName
            Test-Path -Path $expectedMetaconfigPath -PathType 'Leaf' | Should -BeTrue

            $metaconfigContent = Get-Content -Path $expectedMetaconfigPath -Raw
            $metaconfigJson = $metaconfigContent | ConvertFrom-Json

            $metaconfigJson | Should -Not -BeNullOrEmpty
            $metaconfigJson.Type | Should -Be $itSpecificParameters.Type
            $metaconfigJson.Version | Should -Be $itSpecificParameters.Version
        }

        It 'Should set Type as Audit and Version as given value in package metaconig when parameters specified' {
            $itSpecificParameters = $newGuestConfigurationPackageParameters + @{
                Type = 'Audit'
                Version = '9.23.41'
            }

            $null = New-GuestConfigurationPackage @itSpecificParameters

            $itSpecificExpandedPackagePath = "$expandedPackagePath-TypeSetAndVersion"
            $null = Expand-Archive -Path $compressedPackagePath -DestinationPath $itSpecificExpandedPackagePath -Force

            $expectedMetaconfigName = "$($newGuestConfigurationPackageParameters.Name).metaconfig.json"
            $expectedMetaconfigPath = Join-Path -Path $itSpecificExpandedPackagePath -ChildPath $expectedMetaconfigName
            Test-Path -Path $expectedMetaconfigPath -PathType 'Leaf' | Should -BeTrue

            $metaconfigContent = Get-Content -Path $expectedMetaconfigPath -Raw
            $metaconfigJson = $metaconfigContent | ConvertFrom-Json

            $metaconfigJson | Should -Not -BeNullOrEmpty
            $metaconfigJson.Type | Should -Be $itSpecificParameters.Type
            $metaconfigJson.Version | Should -Be $itSpecificParameters.Version
        }

        It 'Should be able to use the default Path parameter value' {
            Push-Location -Path $newGuestConfigurationPackageParameters.Path

            try
            {
                $itSpecificParameters = $newGuestConfigurationPackageParameters.Clone()
                $itSpecificParameters.Remove('Path')

                $null = New-GuestConfigurationPackage @itSpecificParameters

                $itSpecificExpandedPackagePath = "$expandedPackagePath-PathDefault"
                $null = Expand-Archive -Path $compressedPackagePath -DestinationPath $itSpecificExpandedPackagePath -Force

                Test-Path -Path $itSpecificExpandedPackagePath -PathType 'Container' | Should -BeTrue
            }
            finally
            {
                Pop-Location
            }
        }

        It 'Should be able to use a relative path for Configuration' {
            $itSpecificParameters = $newGuestConfigurationPackageParameters.Clone()
            $itSpecificParameters['Configuration'] = Resolve-Path -Path $newGuestConfigurationPackageParameters.Configuration -Relative

            $null = New-GuestConfigurationPackage @itSpecificParameters

            $itSpecificExpandedPackagePath = "$expandedPackagePath-Relative"
            $null = Expand-Archive -Path $compressedPackagePath -DestinationPath $itSpecificExpandedPackagePath -Force

            Test-Path -Path $itSpecificExpandedPackagePath -PathType 'Container' | Should -BeTrue
        }
    }

    Context 'Windows package with PSDesiredStateConfiguration resource' -skip:($script:os -ine 'Windows') {
        BeforeAll {
            $newGuestConfigurationPackageParameters = @{
                Name = 'testInvalidPSDesiredStateConfiguration'
                Configuration = Join-Path -Path $script:testMofsFolderPath -ChildPath 'InvalidPSDesiredStateConfiguration.mof'
                Path = Join-Path -Path $script:testOutputPath -ChildPath 'Package'
                Force = $true
            }

            $compressedPackageName = "$($newGuestConfigurationPackageParameters.Name).zip"
            $compressedPackagePath = Join-Path -Path $newGuestConfigurationPackageParameters.Path -ChildPath $compressedPackageName
        }

        It 'Should throw when trying to create a custom Windows package with a resource from PSDesiredStateConfiguration' {
            { $null = New-GuestConfigurationPackage @newGuestConfigurationPackageParameters } | Should -Throw
        }

        It 'Should not have created the new package' {
            Test-Path -Path $compressedPackagePath | Should -BeFalse
        }
    }

    Context 'Linux package with native InSpec resource' {
        BeforeAll {
            $inSpecTestAssetsPath = Join-Path -Path $testAssetsPath -ChildPath 'InspecConfig'

            $newGuestConfigurationPackageParameters = @{
                Name = 'testLinuxNativeInSpec'
                Configuration = Join-Path -Path $inSpecTestAssetsPath -ChildPath 'InSpec_Config.mof'
                Path = Join-Path -Path $script:testOutputPath -ChildPath 'Package'
                ChefInspecProfilePath = $inSpecTestAssetsPath
                Force = $true
            }

            $compressedPackageName = "$($newGuestConfigurationPackageParameters.Name).zip"
            $compressedPackagePath = Join-Path -Path $newGuestConfigurationPackageParameters.Path -ChildPath $compressedPackageName

            $expandedPackageName = "$($newGuestConfigurationPackageParameters.Name)-Expanded"
            $expandedPackagePath = Join-Path -Path $script:testOutputPath -ChildPath $expandedPackageName

            $expectedMofName = "$($newGuestConfigurationPackageParameters.Name).mof"
            $expandedPackageMofFilePath = Join-Path -Path $expandedPackagePath -ChildPath $expectedMofName

            $expandedPackageModulesPath = Join-Path -Path $expandedPackagePath -ChildPath 'Modules'
            $expandedPackageNativeResourcesPath = Join-Path $expandedPackageModulesPath -ChildPath 'DscNativeResources'
            $expectedInSpecResourceFolderPath = Join-Path -Path $expandedPackageNativeResourcesPath -ChildPath 'MSFT_ChefInSpecResource'

            $expectedInSpecResourceLibraryPath = Join-Path -Path $expectedInSpecResourceFolderPath -ChildPath 'libMSFT_ChefInSpecResource.so'
            $expectedInSpecResourceSchemaPath = Join-Path -Path $expectedInSpecResourceFolderPath -ChildPath 'MSFT_ChefInSpecResource.schema.mof'
            $expectedInSpecInstallScriptPath = Join-Path -Path $expandedPackageModulesPath -ChildPath 'install_inspec.sh'

            $inspecProfileName = 'linux-path'
        }

        It 'Should be able to create a custom Linux package with the expected output object' {
            $package = New-GuestConfigurationPackage @newGuestConfigurationPackageParameters
            $package | Should -Not -BeNull
            $package.Name | Should -Be $newGuestConfigurationPackageParameters.Name
            $package.Path | Should -Be $compressedPackagePath
        }

        It 'Compressed package should exist at expected output path' {
            Test-Path -Path $compressedPackagePath -PathType 'Leaf' | Should -BeTrue
        }

        It 'Should be able to expand the new package' {
            $null = Expand-Archive -Path $compressedPackagePath -DestinationPath $expandedPackagePath -Force
            Test-Path -Path $expandedPackagePath -PathType 'Container' | Should -BeTrue
        }

        It 'Mof file should exist in expanded package' {
            Test-Path -Path $expandedPackageMofFilePath -PathType 'Leaf' | Should -BeTrue
        }

        It 'Mof file should contain an InSpec resource with the expected profile in the GitHubPath property' {
            $mofInstances = [Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache]::ImportInstances($expandedPackageMofFilePath, 4)

            $chefInSpecMofInstance = $mofInstances | Where-Object { $_.CimClass.CimClassName -ieq 'MSFT_ChefInSpecResource'}
            $chefInSpecMofInstance | Should -Not -Be $null
            @( $chefInSpecMofInstance ).Count | Should -Be 1

            $gitHubPath = $chefInSpecMofInstance.CimInstanceProperties.Item('GithubPath')
            $gitHubPath | Should -Not -Be $null

            $gitHubPath.Value | Should -Be "$($newGuestConfigurationPackageParameters.Name)/Modules/$inspecProfileName/"
        }

        It 'Metaconfig should exist with default Type (Audit) and Version (1.0.0) in expanded package' {
            $expectedMetaconfigName = "$($newGuestConfigurationPackageParameters.Name).metaconfig.json"
            $expectedMetaconfigPath = Join-Path -Path $expandedPackagePath -ChildPath $expectedMetaconfigName
            Test-Path -Path $expectedMetaconfigPath -PathType 'Leaf' | Should -BeTrue

            $metaconfigContent = Get-Content -Path $expectedMetaconfigPath -Raw
            $metaconfigJson = $metaconfigContent | ConvertFrom-Json

            $metaconfigJson | Should -Not -BeNullOrEmpty
            $metaconfigJson.Type | Should -Be 'Audit'
            $metaconfigJson.Version | Should -Be '1.0.0'
        }

        It 'Expanded package should include the native InSpec resource folder' {
            Test-Path -Path $expectedInSpecResourceFolderPath -PathType 'Container' | Should -BeTrue
        }

        It 'Expanded package should include the native InSpec resource library' {
            Test-Path -Path $expectedInSpecResourceLibraryPath -PathType 'Leaf' | Should -BeTrue
        }

        It 'Expanded package should include the native InSpec resource schema' {
            Test-Path -Path $expectedInSpecResourceSchemaPath -PathType 'Leaf' | Should -BeTrue
        }

        It 'Expanded package should include the InSpec install script' {
            Test-Path -Path $expectedInSpecInstallScriptPath -PathType 'Leaf' | Should -BeTrue
        }

        It 'Included InSpec install script should have Linux line endings' {
            $inspecInstallScriptContent = Get-Content -Path $expectedInSpecInstallScriptPath -Raw
            $inspecInstallScriptContent -match "`r`n" | Should -BeFalse
        }

        It 'Expanded package should include expected InSpec profile' {
            $expectedInSpecProfilePath = Join-Path -Path $expandedPackageModulesPath -ChildPath $inspecProfileName
            Test-Path -Path $expectedInSpecProfilePath -PathType 'Container' | Should -BeTrue

            $inspecYmlExpectedPath = Join-Path -Path $expectedInSpecProfilePath -ChildPath 'inspec.yml'
            Test-Path -Path $inspecYmlExpectedPath -PathType 'Leaf' | Should -BeTrue

            $inspecControlsExpectedPath = Join-Path -Path $expectedInSpecProfilePath -ChildPath 'controls'
            Test-Path -Path $inspecControlsExpectedPath -PathType 'Container' | Should -BeTrue

            $inspecControlsRbExpectedPath = Join-Path -Path $inspecControlsExpectedPath -ChildPath 'linux-path.rb'
            Test-Path -Path $inspecControlsRbExpectedPath -PathType 'Leaf' | Should -BeTrue
        }

        It 'Should not overwrite a custom policy package when -Force is not specified' {
            $itSpecificParameters = $newGuestConfigurationPackageParameters.Clone()
            $itSpecificParameters['Force'] = $false

            { $null = New-GuestConfigurationPackage @itSpecificParameters } | Should -Throw
        }

        It 'Should overwrite a custom policy package when -Force is specified' {
            { $null = New-GuestConfigurationPackage @newGuestConfigurationPackageParameters } | Should -Not -Throw
        }

        It 'Should be able to use the default Path parameter value' {
            Push-Location -Path $newGuestConfigurationPackageParameters.Path

            try
            {
                $itSpecificParameters = $newGuestConfigurationPackageParameters.Clone()
                $itSpecificParameters.Remove('Path')

                $null = New-GuestConfigurationPackage @itSpecificParameters

                $itSpecificExpandedPackagePath = "$expandedPackagePath-PathDefault"
                $null = Expand-Archive -Path $compressedPackagePath -DestinationPath $itSpecificExpandedPackagePath -Force

                Test-Path -Path $itSpecificExpandedPackagePath -PathType 'Container' | Should -BeTrue
            }
            finally
            {
                Pop-Location
            }
        }

        It 'Should be able to use a relative path for Configuration' {
            $itSpecificParameters = $newGuestConfigurationPackageParameters.Clone()
            $itSpecificParameters['Configuration'] = Resolve-Path -Path $newGuestConfigurationPackageParameters.Configuration -Relative

            $null = New-GuestConfigurationPackage @itSpecificParameters

            $itSpecificExpandedPackagePath = "$expandedPackagePath-RelativeConfigurationPath"
            $null = Expand-Archive -Path $compressedPackagePath -DestinationPath $itSpecificExpandedPackagePath -Force

            Test-Path -Path $itSpecificExpandedPackagePath -PathType 'Container' | Should -BeTrue
        }
    }

    Context 'Cross-platform package with PSDscResources Script resource' {
        BeforeAll {
            $testName = 'testScript'

            $testPath = Join-Path -Path $script:testOutputPath -ChildPath 'My Package Path'
            $testMofName = 'TestScript.mof'
            $testMofPath = Join-Path -Path $script:testMofsFolderPath -ChildPath $testMofName
            $testPackagePath = Join-Path -Path $testPath -ChildPath $testName
            $null = New-Item -Path $testPackagePath -ItemType 'Directory' -Force

            $testMofDestinationPath = Join-Path -Path $testPackagePath -ChildPath $testMofName
            $null = Copy-Item -Path $testMofPath -Destination $testMofDestinationPath -Force

            $newGuestConfigurationPackageParameters = @{
                Name = $testName
                Configuration = $testMofDestinationPath
                Path = $testPath
                FrequencyMinutes = 45
                Force = $true
            }

            $compressedPackageName = "$($newGuestConfigurationPackageParameters.Name).zip"
            $compressedPackagePath = Join-Path -Path $newGuestConfigurationPackageParameters.Path -ChildPath $compressedPackageName

            $expandedPackageName = "$($newGuestConfigurationPackageParameters.Name)-Expanded"
            $expandedPackagePath = Join-Path -Path $script:testOutputPath -ChildPath $expandedPackageName

            $expandedPackageModulesPath = Join-Path -Path $expandedPackagePath -ChildPath 'Modules'
        }

        It 'Should be able to create a custom Windows package with the expected output object' {
            $package = New-GuestConfigurationPackage @newGuestConfigurationPackageParameters
            $package | Should -Not -BeNull
            $package.Name | Should -Be $newGuestConfigurationPackageParameters.Name
            $package.Path | Should -Be $compressedPackagePath
        }

        It 'Compressed package should exist at expected output path' {
            Test-Path -Path $compressedPackagePath -PathType 'Leaf' | Should -BeTrue
        }

        It 'Should be able to expand the new package' {
            $null = Expand-Archive -Path $compressedPackagePath -DestinationPath $expandedPackagePath -Force
            Test-Path -Path $expandedPackagePath -PathType 'Container' | Should -BeTrue
        }

        It 'Mof file should exist in expanded package' {
            $expectedMofName = "$($newGuestConfigurationPackageParameters.Name).mof"
            $expandedPackageMofFilePath = Join-Path -Path $expandedPackagePath -ChildPath $expectedMofName
            Test-Path -Path $expandedPackageMofFilePath -PathType 'Leaf' | Should -BeTrue
        }

        It 'Metaconfig should exist with default Type (Audit) and Version (1.0.0) in expanded package' {
            $expectedMetaconfigName = "$($newGuestConfigurationPackageParameters.Name).metaconfig.json"
            $expectedMetaconfigPath = Join-Path -Path $expandedPackagePath -ChildPath $expectedMetaconfigName
            Test-Path -Path $expectedMetaconfigPath -PathType 'Leaf' | Should -BeTrue

            $metaconfigContent = Get-Content -Path $expectedMetaconfigPath -Raw
            $metaconfigJson = $metaconfigContent | ConvertFrom-Json

            $metaconfigJson | Should -Not -BeNullOrEmpty
            $metaconfigJson.Type | Should -Be 'Audit'
            $metaconfigJson.Version | Should -Be '1.0.0'
        }

        It 'Expanded package should include the PSDscResources module dependency' {
            $expectedResourceModulePath = Join-Path -Path $expandedPackageModulesPath -ChildPath 'PSDscResources'
            Test-Path -Path $expectedResourceModulePath -PathType 'Container' | Should -BeTrue
        }

        It 'Original mof should still exist under package path' {
            Test-Path -Path $testMofDestinationPath | Should -BeTrue
        }
    }

    Context 'Cross-platform package with fake GuestConfiguration native resource' {
        BeforeAll {
            $newGuestConfigurationPackageParameters = @{
                Name = 'testNative'
                Configuration = Join-Path -Path $script:testMofsFolderPath -ChildPath 'GuestConfigurationResource.mof'
                Path = Join-Path -Path $script:testOutputPath -ChildPath 'Native'
                Verbose = $true
            }

            $compressedPackageName = "$($newGuestConfigurationPackageParameters.Name).zip"
            $compressedPackagePath = Join-Path -Path $newGuestConfigurationPackageParameters.Path -ChildPath $compressedPackageName

            $expandedPackageName = "$($newGuestConfigurationPackageParameters.Name)-Expanded"
            $expandedPackagePath = Join-Path -Path $script:testOutputPath -ChildPath $expandedPackageName

            $expandedPackageModulesPath = Join-Path -Path $expandedPackagePath -ChildPath 'Modules'
        }

        It 'Should be able to create a custom package with the expected output object' {
            $package = New-GuestConfigurationPackage @newGuestConfigurationPackageParameters
            $package | Should -Not -BeNull
            $package.Name | Should -Be $newGuestConfigurationPackageParameters.Name
            $package.Path | Should -Be $compressedPackagePath
        }

        It 'Compressed package should exist at expected output path' {
            Test-Path -Path $compressedPackagePath -PathType 'Leaf' | Should -BeTrue
        }

        It 'Should be able to expand the new package' {
            $null = Expand-Archive -Path $compressedPackagePath -DestinationPath $expandedPackagePath -Force
            Test-Path -Path $expandedPackagePath -PathType 'Container' | Should -BeTrue
        }

        It 'Mof file should exist in expanded package' {
            $expectedMofName = "$($newGuestConfigurationPackageParameters.Name).mof"
            $expandedPackageMofFilePath = Join-Path -Path $expandedPackagePath -ChildPath $expectedMofName
            Test-Path -Path $expandedPackageMofFilePath -PathType 'Leaf' | Should -BeTrue
        }

        It 'Metaconfig should exist with default Type (Audit) and Version (1.0.0) in expanded package' {
            $expectedMetaconfigName = "$($newGuestConfigurationPackageParameters.Name).metaconfig.json"
            $expectedMetaconfigPath = Join-Path -Path $expandedPackagePath -ChildPath $expectedMetaconfigName
            Test-Path -Path $expectedMetaconfigPath -PathType 'Leaf' | Should -BeTrue

            $metaconfigContent = Get-Content -Path $expectedMetaconfigPath -Raw
            $metaconfigJson = $metaconfigContent | ConvertFrom-Json

            $metaconfigJson | Should -Not -BeNullOrEmpty
            $metaconfigJson.Type | Should -Be 'Audit'
            $metaconfigJson.Version | Should -Be '1.0.0'
        }

        It 'Expanded package should have an empty Modules folder' {
            Test-Path -Path $expandedPackageModulesPath -PathType 'Container' | Should -BeTrue
            $resourceDependencies = @( Get-ChildItem -Path $expandedPackageModulesPath )
            $resourceDependencies.Count | Should -Be 0
        }
    }

    It 'Should not throw when the MOF has one dependency' {
        $newGuestConfigurationPackageParameters = @{
            Name = "testSingleDependency"
            Configuration = Join-Path -Path $script:testMofsFolderPath -ChildPath 'SingleDependency.mof'
            Path = Join-Path -Path $script:testOutputPath -ChildPath 'Package'
            Force = $true
        }
        { New-GuestConfigurationPackage @newGuestConfigurationPackageParameters } | Should -Not -Throw
    }

    It 'Should not throw when the MOF has multiple dependencies' {
        $newGuestConfigurationPackageParameters = @{
            Name = "testMultipleDependencies"
            Configuration = Join-Path -Path $script:testMofsFolderPath -ChildPath 'MultipleDependencies.mof'
            Path = Join-Path -Path $script:testOutputPath -ChildPath 'Package'
            Force = $true
        }
        { New-GuestConfigurationPackage @newGuestConfigurationPackageParameters } | Should -Not -Throw
    }

    it 'Should throw when the MOF has zero dependencies' {
        $newGuestConfigurationPackageParameters = @{
            Name = "testZeroDependencies"
            Configuration = Join-Path -Path $script:testMofsFolderPath -ChildPath 'ZeroDependencies.mof'
            Path = Join-Path -Path $script:testOutputPath -ChildPath 'Package'
            Force = $true
        }
        { New-GuestConfigurationPackage @newGuestConfigurationPackageParameters } | Should -Throw -ExpectedMessage "Failed to determine resource dependencies*"
    }
}
