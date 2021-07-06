BeforeDiscovery {

    $projectPath = "$PSScriptRoot/../../.." | Convert-Path
    $projectName = Get-SamplerProjectName -BuildRoot $projectPath

    Get-Module $projectName | Remove-Module -Force -ErrorAction SilentlyContinue
    $importedModule = Import-Module $projectName -Force -PassThru -ErrorAction 'Stop'
}

Describe 'New-GuestConfigurationPackage' -ForEach @{
    ProjectPath    = $projectPath
    projectName    = $projectName
    importedModule = $importedModule
} -Fixture {
    BeforeAll {
        # Test Assets path
        $testAssetsPath = Join-Path -Path $PSScriptRoot -ChildPath '../assets'

        # Test Config Package MOF
        $mofPath = Join-Path -Path $testAssetsPath -ChildPath 'DSC_Config.mof'
        $policyName = 'testPolicy'
        $testOutputPath = Join-Path -Path $TestDrive -ChildPath 'output'
        $testPackagePath = Join-Path -Path $testOutputPath -ChildPath 'Package'

        # Test extraction
        $unsignedPackageExtractionPath = Join-Path -Path $testOutputPath -ChildPath 'UnsignedPackage'
        $mofFilePath = Join-Path -Path $unsignedPackageExtractionPath -ChildPath "$policyName.mof"
    }

    It 'Creates custom Windows policy package' -skip:(-not $IsWindows) {
        $package = New-GuestConfigurationPackage -Configuration $mofPath -Name $policyName -Path $testPackagePath -Force
        Test-Path -Path $package.Path | Should -BeTrue
        $package.Name | Should -Be $policyName
    }

    It 'Creates custom Linux policy package' -skip:(-not $IsLinux) {
        $inSpecFolderPath = Join-Path -Path $testAssetsPath -ChildPath 'InspecConfig'
        $inspecMofPath = Join-Path -Path $inSpecFolderPath -ChildPath 'InSpec_Config.mof'
        $inspecPackagePath = Join-Path -Path $testOutputPath -ChildPath 'InspecPackage'

        $package = New-GuestConfigurationPackage -Configuration $inspecMofPath -Name $policyName -Path $inspecPackagePath -ChefInspecProfilePath $inSpecFolderPath -Force
        Test-Path -Path $package.Path | Should -BeTrue
        $package.Name | Should -Be $policyName
    }

    It 'Does not overwrite a custom policy package when -Force is not specified' {
        { New-GuestConfigurationPackage -Configuration $mofPath -Name $policyName -Path $testPackagePath -ErrorAction Stop } | Should -Throw
    }

    It 'Overwrites a custom policy package when -Force is specified' {
        { New-GuestConfigurationPackage -Configuration $mofPath -Name $policyName -Path $testPackagePath -Force -ErrorAction Stop } | Should -Not -Throw
    }

    It 'Verify the package can be extracted' {
        $package = Get-Item "$testPackagePath/$policyName/$policyName.zip"

        # Set up type needed for package extraction
        $null = Add-Type -AssemblyName System.IO.Compression.FileSystem
        { [System.IO.Compression.ZipFile]::ExtractToDirectory($package.FullName, $unsignedPackageExtractionPath) } | Should -Not -Throw
        Test-Path $unsignedPackageExtractionPath | Should -BeTrue
    }

    It 'Verify extracted mof document exists' {
        Test-Path -Path $mofFilePath | Should -BeTrue
    }

    # We are not planning on supporting creating inspec packages on Linux machines
    It 'Has Linux-friendly line endings in InSpec install script' -skip:(-not $IsLinux) {
        $inspecInstallScriptPath = Join-Path -Path $unsignedPackageExtractionPath -ChildPath 'Modules/install_inspec.sh'
        $fileContent = Get-Content -Path $inspecInstallScriptPath -Raw
        $fileContent -match "`r`n" | Should -BeFalse
    }

    It 'Verify all required modules are included in the package' {
        $extractedModulesPath = Join-Path -Path $unsignedPackageExtractionPath -ChildPath 'Modules'
        $resourcesInMofDocument = [Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache]::ImportInstances($mofFilePath, 4)
        for ($numResources = 0; $numResources -lt $resourcesInMofDocument.Count; $numResources++)
        {
            if ($resourcesInMofDocument[$numResources].CimInstanceProperties.Name -contains 'ModuleName')
            {
                $resourceModuleName = $resourcesInMofDocument[$numResources].ModuleName
                $resourceModulePath = Join-Path -Path $extractedModulesPath -ChildPath $resourceModuleName
                Test-Path -Path $resourceModulePath | Should -BeTrue
            }
        }
    }

    It 'Should not include -FilesToInclude by default' {
        $filesToIncludeExtractionPath = Join-Path $testOutputPath -ChildPath 'FilesToIncludeUnsignedPackage'
        $extractedFilesToIncludePath = Join-Path -Path (Join-Path -Path $filesToIncludeExtractionPath -ChildPath 'Modules') -ChildPath 'FilesToInclude'

        Test-Path -Path $extractedFilesToIncludePath | Should -BeFalse
    }

    It 'Implements -FilesToInclude parameter' {

        $FilesToIncludeFolderPath = Join-Path -Path $testAssetsPath -ChildPath 'FilesToInclude'

        if (Test-Path $testPackagePath)
        {
            Remove-Item -Path $testPackagePath -Force -Recurse
        }

        $package = New-GuestConfigurationPackage -Configuration $mofPath -Name $policyName -Path $testPackagePath -FilesToInclude $FilesToIncludeFolderPath -Force
        $null = Add-Type -AssemblyName System.IO.Compression.FileSystem
        { [System.IO.Compression.ZipFile]::ExtractToDirectory($package.Path, $testPackagePath) } | Should -Not -Throw
        $includedFilesFolder = Join-Path -Path $testPackagePath -ChildPath (Join-Path -Path 'Modules' -ChildPath 'FilesToInclude')
        Test-Path -Path $includedFilesFolder | Should -BeTrue
        $extractedFile = Join-Path -Path $includedFilesFolder -ChildPath 'file.txt'
        Test-Path -Path $extractedFile | Should -BeTrue
        Get-Content -Path $extractedFile | Should -Be 'test'
    }

    It 'Implements -ChefInspecProfilePath parameter' {
        $inSpecFolderPath = Join-Path -Path $testAssetsPath -ChildPath 'InspecConfig'
        $inspecMofPath = Join-Path -Path $inSpecFolderPath -ChildPath 'InSpec_Config.mof'
        $inspecPackagePath = Join-Path -Path $testOutputPath -ChildPath 'InspecPackage'
        $inspecExtractionPath = Join-Path $testOutputPath -ChildPath 'InspecUnsignedPackage'
        $inspecProfileName = 'linux-path'
        $extractedInSpecPath = Join-Path -Path $inspecExtractionPath -ChildPath (Join-Path 'Modules' $inspecProfileName)

        $package = New-GuestConfigurationPackage -Configuration $inspecMofPath -Name $policyName -Path $inspecPackagePath -ChefInspecProfilePath $inSpecFolderPath -Force
        $null = Add-Type -AssemblyName System.IO.Compression.FileSystem
        { [System.IO.Compression.ZipFile]::ExtractToDirectory($package.Path, $inspecExtractionPath) } | Should -Not -Throw
        $extractedInspecPath | Should -Exist
        $inspecYmlExtractedFile = Join-Path $extractedInspecPath 'inspec.yml'
        $inspecYmlExtractedFile | Should -Exist
        $inspecControlsExtractedFile = Join-Path $extractedInspecPath 'controls'
        $inspecControlsExtractedFile | Should -Exist
        $inspecRbExtractedFile = Join-Path $inspecControlsExtractedFile 'linux-path.rb'
        $inspecRbExtractedFile | Should -Exist
    }

    It 'Verify default value from -Type is Audit in meta file' -skip:(-not $IsWindows) {
        $package = New-GuestConfigurationPackage -Configuration $mofPath -Name $policyName -Path $testPackagePath -Force
        $packageName = $package.Name

        # Extract package to read metaconfig file
        $extractionPath = Join-Path -Path $testOutputPath -ChildPath 'defaultType'
        $null = Add-Type -AssemblyName System.IO.Compression.FileSystem
        { [System.IO.Compression.ZipFile]::ExtractToDirectory($package.Path, $extractionPath) } | Should -Not -Throw

        $metaConfigPath = Join-Path -Path $extractionPath -ChildPath "extra.$packageName.metaconfig.json"
        Test-Path -Path $metaConfigPath | Should -BeTrue
        (Get-Content -Path $metaConfigPath -Raw) -replace '\s+','' | Should -Match '{"Type":"Audit"}'
    }

    It 'Verify passing in -Type AuditAndSet modifies metaconfig to AuditAndSet' {
        $package = New-GuestConfigurationPackage -Configuration $mofPath -Name $policyName -Path $testPackagePath -Type 'AuditAndSet' -Force
        $packageName = $package.Name

        # Extract package to read metaconfig file
        $extractionPath = Join-Path -Path $testOutputPath -ChildPath 'AuditAndSet'
        $null = Add-Type -AssemblyName System.IO.Compression.FileSystem
        { [System.IO.Compression.ZipFile]::ExtractToDirectory($package.Path, $extractionPath) } | Should -Not -Throw

        $metaConfigPath = Join-Path -Path $extractionPath -ChildPath "extra.$packageName.metaconfig.json"
        Test-Path -Path $metaConfigPath | Should -BeTrue
        (Get-Content -Path $metaConfigPath -Raw) -replace '\s+','' | Should -Match '{"Type":"AuditAndSet"}'
    }

    It 'Verify passing in -Type Audit modifies metaconfig to Audit' {
        $package = New-GuestConfigurationPackage -Configuration $mofPath -Name $policyName -Path $testPackagePath -Type 'Audit' -Force
        $packageName = $package.Name

        # Extract package to read metaconfig file
        $extractionPath = Join-Path -Path $testOutputPath -ChildPath 'Audit'
        $null = Add-Type -AssemblyName System.IO.Compression.FileSystem
        { [System.IO.Compression.ZipFile]::ExtractToDirectory($package.Path, $extractionPath) } | Should -Not -Throw

        $metaConfigPath = Join-Path -Path $extractionPath -ChildPath "extra.$packageName.metaconfig.json"
        Test-Path -Path $metaConfigPath | Should -BeTrue
        (Get-Content -Path $metaConfigPath -Raw) -replace '\s+','' | Should -Match '{"Type":"Audit"}'
    }
}
