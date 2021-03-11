BeforeDiscovery {

    $script:projectPath = "$PSScriptRoot\..\..\.." | Convert-Path
    $script:projectName = Get-SamplerProjectName -BuildRoot $script:projectPath

    $script:moduleName = Get-Module $script:projectName -ListAvailable | Select-Object -First 1
    Remove-Module -Name $script:moduleName -Force -ErrorAction 'SilentlyContinue'
    $script:importedModule = Import-Module $script:moduleName -Force -PassThru -ErrorAction 'Stop'

    $IsNotAzureDevOps = [string]::IsNullOrEmpty($env:ADO)
    $IsNotWindowsAndIsAzureDevOps = ($IsLinux -or $IsMacOS) -AND $env:ADO
}

Context 'New-GuestConfigurationPackage' {
    BeforeAll {
        $mofPath
        $policyName
        $testPackagePath
    }

    It 'creates custom policy package' {
        $package = New-GuestConfigurationPackage -Configuration $mofPath -Name $policyName -Path $testPackagePath -Force
        Test-Path -Path $package.Path | Should -BeTrue
        $package.Name | Should -Be $policyName
    }

    It 'does not overwrite a custom policy package when -Force is not specified' {
        { New-GuestConfigurationPackage -Configuration $mofPath -Name $policyName -Path $testPackagePath -ErrorAction Stop } | Should -Throw
    }

    It 'overwrites a custom policy package when -Force is specified' {
        { New-GuestConfigurationPackage -Configuration $mofPath -Name $policyName -Path $testPackagePath -Force -ErrorAction Stop } | Should -Not -Throw
    }

    It 'Verify the package can be extracted' {
        $package = Get-Item "$testPackagePath/$policyName/$policyName.zip"

        # Set up type needed for package extraction
        $null = Add-Type -AssemblyName System.IO.Compression.FileSystem
        { [System.IO.Compression.ZipFile]::ExtractToDirectory($package.FullName, $unsignedPackageExtractionPath) } | Should -Not -Throw
    }

    It 'Verify extracted mof document exists' {
        Test-Path -Path $mofFilePath | Should -BeTrue
    }

    It 'has Linux-friendly line endings in InSpec install script' {
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
        Test-Path -Path $extractedFilesToIncludePath | Should -BeFalse
    }

    It 'Implements -FilesToInclude parameter' {
        if (Test-CurrentMachineIsWindows)
        {
            $outputPath = Join-Path $env:SystemDrive 'output'
        }
        else
        {
            $outputPath = Join-Path $env:HOME 'output'
        }

        if (Test-Path $outputPath)
        {
            Remove-Item $outputPath -Force -Recurse
        }

        $package = New-GuestConfigurationPackage -Configuration $mofPath -Name $policyName -Path $outputPath -FilesToInclude $FilesToIncludeFolderPath -Force
        $null = Add-Type -AssemblyName System.IO.Compression.FileSystem
        { [System.IO.Compression.ZipFile]::ExtractToDirectory($package.Path, $outputPath) } | Should -Not -Throw
        $includedFilesFolder = Join-Path $outputPath (Join-Path 'Modules' 'FilesToInclude')
        Test-Path -Path $includedFilesFolder | Should -BeTrue
        $extractedFile = Join-Path $includedFilesFolder 'file.txt'
        Test-Path -Path $extractedFile | Should -BeTrue
        Get-Content $extractedFile | Should -Be 'test'
    }

    It 'Implements -ChefInspecProfilePath parameter' {
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
}
