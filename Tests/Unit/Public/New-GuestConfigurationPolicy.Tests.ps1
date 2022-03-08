BeforeDiscovery {
    $unitTestsFolderPath = Split-Path -Path $PSScriptRoot -Parent
    $testsFolderPath = Split-Path -Path $unitTestsFolderPath -Parent

    $projectPath = Split-Path -Path $testsFolderPath -Parent
    $projectName = Get-SamplerProjectName -BuildRoot $projectPath

    Get-Module $projectName | Remove-Module -Force -ErrorAction SilentlyContinue
    $importedModule = Import-Module $projectName -Force -PassThru -ErrorAction 'Stop'
}

Describe 'New-GuestConfigurationPolicy' -ForEach @{
    ProjectPath    = $projectPath
    ProjectName    = $projectName
    ImportedModule = $importedModule
} {
    function Assert-GuestConfigurationPolicyDefinitionFileValid
    {
        [CmdletBinding()]
        param
        (
            [Parameter(Mandatory = $true)]
            [String]
            $expectedFilePath,

            [Parameter(Mandatory = $true)]
            [String]
            $expectedDisplayName,

            [Parameter(Mandatory = $true)]
            [String]
            $expectedDescription,

            [Parameter(Mandatory = $true)]
            [String]
            $expectedContentUri,

            [Parameter(Mandatory = $true)]
            [String]
            $expectedContentHash,

            [Parameter(Mandatory = $true)]
            [String]
            $expectedConfigurationName,

            [Parameter(Mandatory = $true)]
            [String]
            $expectedConfigurationVersion
        )

        Test-Path -Path $expectedFilePath -PathType 'Leaf' | Should -BeTrue
        $fileContent = Get-Content -Path $expectedFilePath -Raw
        $fileContent | Should -Not -BeNullOrEmpty

        $fileContentJson = $fileContent | ConvertFrom-Json
        $fileContentJson | Should -Not -BeNullOrEmpty
        $fileContentJson.properties | Should -Not -BeNullOrEmpty

        $fileContentJson.properties.displayName | Should -Be $expectedDisplayName
        $fileContentJson.properties.description | Should -Be $expectedDescription
        $fileContentJson.properties.policyType | Should -Be 'Custom'
        $fileContentJson.properties.mode | Should -Be 'Indexed'

        $fileContentJson.properties.metadata | Should -Not -BeNullOrEmpty
        $fileContentJson.properties.metadata.version | Should -Be '1.0.0'
        $fileContentJson.properties.metadata.category | Should -Be 'Guest Configuration'

        $fileContentJson.properties.metadata.guestConfiguration | Should -Not -BeNullOrEmpty
        $fileContentJson.properties.metadata.guestConfiguration.name | Should -Not -Be $expectedConfigurationName
        $fileContentJson.properties.metadata.guestConfiguration.version | Should -Not -Be $expectedConfigurationVersion
        $fileContentJson.properties.metadata.guestConfiguration.contentType | Should -Be 'Custom'
        $fileContentJson.properties.metadata.guestConfiguration.contentUri | Should -Be $expectedContentUri
        $fileContentJson.properties.metadata.guestConfiguration.contentHash | Should -Be $expectedContentHash
        { $fileContentJson.properties.metadata.guestConfiguration.configurationParameter | Should -BeNullOrEmpty } | Should -Throw

        $fileContentJson.properties.parameters | Should -Not -BeNullOrEmpty
        $fileContentJson.properties.parameters.Count | Should -Be 1
        $fileContentJson.properties.parameters.IncludeArcMachines | Should -Not -BeNullOrEmpty
        $fileContentJson.properties.parameters.IncludeArcMachines.type | Should -Be 'boolean'
        $fileContentJson.properties.parameters.IncludeArcMachines.defaultValue | Should -Be $false
        $fileContentJson.properties.parameters.IncludeArcMachines.metadata | Should -Not -BeNullOrEmpty
        $fileContentJson.properties.parameters.IncludeArcMachines.metadata.displayName | Should -Be 'Include Arc connected machines'
        $fileContentJson.properties.parameters.IncludeArcMachines.metadata.description | Should -Be 'By selecting this option, you agree to be charged monthly per Arc connected machine.'

        $fileContentJson.properties.policyRule | Should -Not -BeNullOrEmpty
        $fileContentJson.properties.policyRule.if | Should -Not -BeNullOrEmpty
        $fileContentJson.properties.policyRule.then | Should -Not -BeNullOrEmpty
        $fileContentJson.properties.policyRule.then.effect | Should -Be 'auditIfNotExists'

        $fileContentJson.properties.policyRule.then.details | Should -Not -BeNullOrEmpty
        $fileContentJson.properties.policyRule.then.details.type | Should -Be 'Microsoft.GuestConfiguration/guestConfigurationAssignments'
        $fileContentJson.properties.policyRule.then.details.name | Should -Be $expectedConfigurationName
        $fileContentJson.properties.policyRule.then.details.existenceCondition | Should -Not -BeNullOrEmpty
        $fileContentJson.properties.policyRule.then.details.existenceCondition.field | Should -Be 'Microsoft.GuestConfiguration/guestConfigurationAssignments/complianceStatus'
        $fileContentJson.properties.policyRule.then.details.existenceCondition.equals | Should -Be $true

        { $null = [System.Guid]$fileContentJson.name } | Should -Not -Throw
    }

    BeforeAll {
        <#
        $testAssetsPath = Join-Path -Path $PSScriptRoot -ChildPath '../assets'
        $testOutputPath = Join-Path -Path $TestDrive -ChildPath 'output'
        $testAINEOutputPathWindows = Join-Path -Path $testOutputPath -ChildPath 'Policy/Windows/AINE_NO_PARAM'
        $testAINEOutputPathLinux = Join-Path -Path $testOutputPath -ChildPath 'Policy/Linux/AINE_NO_PARAM'
        $testDINEOutputPathWindows = Join-Path -Path $testOutputPath -ChildPath 'Policy/Windows/DINE_NO_PARAM'
        $testDINEOutputPathLinux = Join-Path -Path $testOutputPath -ChildPath 'Policy/Linux/DINE_NO_PARAM'

        $testAINEOutputPathWindows_WithParam = Join-Path -Path $testOutputPath -ChildPath 'Policy/Windows/AINE_PARAM'
        $testAINEOutputPathLinux_WithParam = Join-Path -Path $testOutputPath -ChildPath 'Policy/Linux/AINE_PARAM'
        $testDINEOutputPathWindows_WithParam = Join-Path -Path $testOutputPath -ChildPath 'Policy/Windows/DINE_PARAM'
        $testDINEOutputPathLinux_WithParam = Join-Path -Path $testOutputPath -ChildPath 'Policy/Linux/DINE_PARAM'

        $testAINEOutputPathWindows_WithOneParam = Join-Path -Path $testOutputPath -ChildPath 'Policy/Windows/AINE_PARAM_ONE'
        $testAINEOutputPathLinux_WithOneParam = Join-Path -Path $testOutputPath -ChildPath 'Policy/Linux/AINE_PARAM_ONE'
        $testDINEOutputPathWindows_WithOneParam = Join-Path -Path $testOutputPath -ChildPath 'Policy/Windows/DINE_PARAM_ONE'
        $testDINEOutputPathLinux_WithOneParam = Join-Path -Path $testOutputPath -ChildPath 'Policy/Linux/DINE_PARAM_ONE'

        $currentDateString = Get-Date -Format "yyyy-MM-dd HH:mm"
        $contentURI_MyFile = 'https://github.com/microsoft/PowerShell-DSC-for-Linux/raw/micy/custompolicy/new_gc_policy/MyFile.zip'
        $contentURI_AuditWindowService = 'https://github.com/microsoft/PowerShell-DSC-for-Linux/raw/amits/custompolicy/new_gc_policy/AuditWindowsService.zip'

        $defaultAineFormatConfigParam_path = '[MyFile]createFoobarTestFile;path'
        $defaultAineFormatConfigParam_content = '[MyFile]createFoobarTestFile;content'
        $defaultAineFormatConfigParam_ensure = '[MyFile]createFoobarTestFile;ensure'

        $policyID_Windows = [Guid]::NewGuid()
        $policyID_Linux = [Guid]::NewGuid()
        $foo_policyId = "foobar"

        if ($IsWindows -or $PSVersionTable.PSVersion.Major -le 5)
        {
            $computerInfo = Get-ComputerInfo
            $currentWindowsOSString = $computerInfo.WindowsProductName
        }
        else
        {
            $currentWindowsOSString = 'Non-Windows'
        }

        $defaultEnsure = 'Present'
        $defaultPath = ' '
        $defaultContent = 'foo_content'
        $policyParameterInfo = @(
            @{
                Name = 'ensure'
                DisplayName = 'Presence.'
                Description = 'Whether or not the file is present.'
                ResourceType = "MyFile"
                ResourceId = 'createFoobarTestFile'
                ResourcePropertyName = 'ensure'
                DefaultValue = $defaultEnsure
                AllowedValues = @('Present','Absent')
            },
            @{
                Name = 'path'
                DisplayName = 'path'
                Description = "Where file should be present."
                ResourceType = "MyFile"
                ResourceId = 'createFoobarTestFile'
                ResourcePropertyName = "path"
                DefaultValue = $defaultPath
            },
            @{
                Name = 'content'
                DisplayName = 'Content.'
                Description = "Where file should be present."
                ResourceType = "MyFile"
                ResourceId = 'createFoobarTestFile'
                ResourcePropertyName = 'content'
                DefaultValue = $defaultContent
            })

        $singlePolicyParamInfo = @(
            @{
                Name = 'ensure'
                DisplayName = 'Presence.'
                Description = 'Whether or not the file is present.'
                ResourceType = "MyFile"
                ResourceId = 'createFoobarTestFile'
                ResourcePropertyName = 'ensure'
                DefaultValue = $defaultEnsure
                AllowedValues = @('Present','Absent')
            })

        # AINE Parameters
        $newGCPolicyAINEParametersWindows = @{
            ContentUri  = $contentURI_AuditWindowService
            DisplayName = "[ModuleTestCI] Audit Windows Service - Date: $currentDateString OS: $currentWindowsOSString"
            Description = 'Policy to audit a Windows service'
            Path        = $testAINEOutputPathWindows
            Version     = '1.0.0.0'
            Platform    = 'Windows'
            PolicyId    = $policyID_Windows
        }

        $newGCPolicyAINEParametersLinux = @{
            ContentUri  = $contentURI_AuditWindowService
            DisplayName = "[ModuleTestCI] Audit Linux Path - Date: $currentDateString OS: $currentWindowsOSString"
            Description = 'Policy to audit a Linux path'
            Path        = $testAINEOutputPathLinux
            Version     = '1.0.0.0'
            Platform    = 'Linux'
            PolicyId    = $policyID_Linux
        }

        $newGCPolicyAINEParametersWindows_WithParam = @{
            ContentUri  = $contentURI_MyFile
            DisplayName = "[ModuleTestCI] MyFile Date: $currentDateString OS: $currentWindowsOSString"
            Description = 'Policy to audit a Windows service'
            Path        = $testAINEOutputPathWindows_WithParam
            Version     = '1.0.0.0'
            Platform    = 'Windows'
            PolicyId    = $policyID_Windows
            Parameter   = $policyParameterInfo
        }

        $newGCPolicyAINEParametersLinux_WithParam = @{
            ContentUri  = $contentURI_MyFile
            DisplayName = "[ModuleTestCI] MyFile Date: $currentDateString OS: $currentWindowsOSString"
            Description = 'Policy to audit a Linux path'
            Path        = $testAINEOutputPathLinux_WithParam
            Version     = '1.0.0.0'
            Platform    = 'Linux'
            PolicyId    = $policyID_Linux
            Parameter   = $policyParameterInfo
        }

        # DINE Parameters
        $newGCPolicyDINEParametersWindows = @{
            ContentUri  = $contentURI_AuditWindowService
            DisplayName = "[ModuleTestCI] Audit Windows Service - Date: $currentDateString OS: $currentWindowsOSString"
            Description = 'Policy to audit a Windows service'
            Path        = $testDINEOutputPathWindows
            Version     = '1.0.0.0'
            Platform    = 'Windows'
            PolicyId    = $policyID_Windows
            Mode        = 'ApplyAndMonitor'
        }

        $newGCPolicyDINEParametersLinux = @{
            ContentUri  = $contentURI_AuditWindowService
            DisplayName = "[ModuleTestCI] Audit Linux Path - Date: $currentDateString OS: $currentWindowsOSString"
            Description = 'Policy to audit a Linux path'
            Path        = $testDINEOutputPathLinux
            Version     = '1.0.0.0'
            Platform    = 'Linux'
            PolicyId    = $policyID_Linux
            Mode        = 'ApplyAndMonitor'
        }

        $newGCPolicyDINEParametersWindows_WithParam = @{
            ContentUri  = $contentURI_MyFile
            DisplayName = "[ModuleTestCI] MyFile Date: $currentDateString OS: $currentWindowsOSString"
            Description = 'Policy to audit a Windows service'
            Path        = $testDINEOutputPathWindows_WithParam
            Version     = '1.0.0.0'
            Platform    = 'Windows'
            Mode        = 'ApplyAndMonitor'
            PolicyId    = $policyID_Windows
            Parameter   = $policyParameterInfo
        }

        $newGCPolicyDINEParametersLinux_WithParam = @{
            ContentUri  = $contentURI_MyFile
            DisplayName = "[ModuleTestCI] MyFile Date: $currentDateString OS: $currentWindowsOSString"
            Description = 'Policy to audit a Linux path'
            Path        = $testDINEOutputPathLinux_WithParam
            Version     = '1.0.0.0'
            Platform    = 'Linux'
            Mode        = 'ApplyAndMonitor'
            PolicyId    = $policyID_Linux
            Parameter   = $policyParameterInfo
        }
        #>

        $testPackageInfo = @{
            ContentUri = 'https://github.com/microsoft/PowerShell-DSC-for-Linux/raw/micy/custompolicy/new_gc_policy/MyFile.zip'
            ContentHash = '59AEA0877406175CB4069F301880BEF0A21BBABCF492CE8476DA047B2FBEA8B6'
            ConfigurationName = 'MyFile'
            ConfigurationVersion = '1.0.0'
        }

        $gcModule = Get-Module -Name 'GuestConfiguration'
        $psm1Path = $gcModule.Path
        $gcModuleRootPath = Split-Path -Path $psm1Path -Parent
        $gcWorkerRoot = Join-Path -Path $gcModuleRootPath -ChildPath 'gcworker'
        $defaultDefinitionsPath = Join-Path -Path $gcWorkerRoot -ChildPath 'definitions'
    }

    # Windows AINE No parameters

    # Windows AINE 1 parameter

    # Windows AINE 2 parameters

    # Windows DINE No parameters

    # Windows DINE 1 parameter

    # Windows DINE 2 parameters

    # Linux AINE No parameters

    # Linux AINE 1 parameter

    # Linux AINE 2 parameters

    # Linux DINE No parameters

    # Linux DINE 1 parameter

    # Linux DINE 2 parameters

    # Windows Tags

    # Linux Tags

    # Update policy

    Context 'Windows' {
        BeforeAll {
            $newPolicyParameters = @{
                DisplayName = 'Windows Test Policy'
                Description = 'This is a test policy on Windows.'
                ContentUri = $testPackageInfo.ContentUri
            }
        }

        Context 'Default parameter values' {
            BeforeAll {
                $expectedFileName = '{0}_AuditIfNotExists.json' -f $testPackageInfo.ConfigurationName
                $assertionParameters = @{
                    expectedFilePath = Join-Path -Path $defaultDefinitionsPath -ChildPath $expectedFileName
                    expectedDisplayName = $newPolicyParameters.DisplayName
                    expectedDescription = $newPolicyParameters.Description
                    expectedContentUri = $newPolicyParameters.ContentUri
                    expectedContentHash = $testPackageInfo.ContentHash
                    expectedConfigurationName = $testPackageInfo.ConfigurationName
                    expectedConfigurationVersion = $testPackageInfo.ConfigurationVersion
                }
            }
            # Create the policy
            It 'Should return the expected result object' {
                $result = New-GuestConfigurationPolicy @newPolicyParameters
                $result | Should -Not -BeNull
                $result.Name | Should -Be $assertionParameters.expectedConfigurationName
                $result.Path | Should -Be $assertionParameters.expectedFilePath
                $result.PolicyId | Should -Not -BeNullOrEmpty
                $result.PolicyId.GetType().Name | Should -Be 'Guid'
            }

            It 'Should have created expected policy definition file' {
                Assert-GuestConfigurationPolicyDefinitionFileValid @assertionParameters
            }
        }

        Context 'Monitor/AINE' -Skip {
            BeforeAll {
                $newPolicyParameters += @{
                    Mode = 'Audit'
                }
            }

            Context 'No parameters' {
                # Create the policy
                It 'Should return the expected result object' {
                    $result = New-GuestConfigurationPolicy @newPolicyParameters
                }
            }
        }

        Context 'Set/DINE' -Skip {

        }
    }

    Context 'Linux' -Skip {
        Context 'Monitor/AINE' -Skip {

        }

        Context 'Set/DINE' -Skip {

        }
    }

    Context 'Old tests' -Skip {
        # AINE Tests - No Parameters
        It 'New-GuestConfigurationPolicy should output path to generated policies with no parameters with more than one parameter' {
            $newGCPolicyResultWindows = New-GuestConfigurationPolicy @newGCPolicyAINEParametersWindows
            $newGCPolicyResultWindows.Path | Should -Not -BeNullOrEmpty
            Test-Path -Path $newGCPolicyResultWindows.Path | Should -BeTrue

            $newGCPolicyResultLinux = New-GuestConfigurationPolicy @newGCPolicyAINEParametersLinux
            $newGCPolicyResultLinux.Path | Should -Not -BeNullOrEmpty
            Test-Path -Path $newGCPolicyResultLinux.Path | Should -BeTrue
        }

        It 'Generated Audit policy file should exist with no parameters' {
            $auditPolicyFileWindows = Join-Path -Path $testAINEOutputPathWindows -ChildPath 'AuditIfNotExists.json'
            Test-Path -Path $auditPolicyFileWindows | Should -BeTrue

            $auditPolicyFileLinux = Join-Path -Path $testAINEOutputPathLinux -ChildPath 'AuditIfNotExists.json'
            Test-Path -Path $auditPolicyFileLinux | Should -BeTrue
        }

        It 'Audit policy with no parameters should contain expected content' {
            $auditPolicyFileWindows = Join-Path -Path $testAINEOutputPathWindows -ChildPath 'AuditIfNotExists.json'
            $auditPolicyContentWindows = Get-Content $auditPolicyFileWindows | ConvertFrom-Json | ForEach-Object { $_ }
            $auditPolicyContentWindows.properties.displayName.Contains($newGCPolicyAINEParametersWindows.DisplayName) | Should -BeTrue
            $auditPolicyContentWindows.properties.description.Contains($newGCPolicyAINEParametersWindows.Description) | Should -BeTrue
            $auditPolicyContentWindows.properties.parameters.IncludeArcMachines | Should -Not -BeNullOrEmpty
            $auditPolicyContentWindows.properties.policyType | Should -Be 'Custom'
            $auditPolicyContentWindows.properties.policyRule.then.details.name | Should -Be 'AuditWindowsService'
            $auditPolicyContentWindows.properties.policyRule.if.anyOf.allOf[1].anyOf[1].allOf | Where-Object field -eq 'Microsoft.Compute/imagePublisher' | ForEach-Object 'equals' | Should -Be 'MicrosoftWindowsServer'
            $auditPolicyContentWindows.name | Should -Be $policyID_Windows

            $auditPolicyFileLinux = Join-Path -Path $testAINEOutputPathLinux -ChildPath 'AuditIfNotExists.json'
            $auditPolicyContentLinux = Get-Content $auditPolicyFileLinux | ConvertFrom-Json | ForEach-Object { $_ }
            $auditPolicyContentLinux.properties.displayName.Contains($newGCPolicyAINEParametersLinux.DisplayName) | Should -BeTrue
            $auditPolicyContentLinux.properties.description.Contains($newGCPolicyAINEParametersLinux.Description) | Should -BeTrue
            $auditPolicyContentLinux.properties.parameters.IncludeArcMachines | Should -Not -BeNullOrEmpty
            $auditPolicyContentLinux.properties.policyType | Should -Be 'Custom'
            $auditPolicyContentLinux.properties.policyRule.then.details.name | Should -Be 'AuditWindowsService'
            $auditPolicyContentLinux.properties.policyRule.if.anyOf.allOf[1].anyOf[1].allOf | Where-Object field -eq 'Microsoft.Compute/imagePublisher' | ForEach-Object 'equals' | Should -Be 'OpenLogic'
            $auditPolicyContentLinux.name | Should -Be $policyID_Linux
        }

        # AINE - With more than one parameter
        It 'New-GuestConfigurationPolicy should output path to generated policies' {
            $newGCPolicyResultWindows_WithParam = New-GuestConfigurationPolicy @newGCPolicyAINEParametersWindows_WithParam
            $newGCPolicyResultWindows_WithParam.Path | Should -Not -BeNullOrEmpty
            Test-Path -Path $newGCPolicyResultWindows_WithParam.Path | Should -BeTrue

            $newGCPolicyResultLinux_WithParam = New-GuestConfigurationPolicy @newGCPolicyAINEParametersLinux_WithParam
            $newGCPolicyResultLinux_WithParam.Path | Should -Not -BeNullOrEmpty
            Test-Path -Path $newGCPolicyResultLinux_WithParam.Path | Should -BeTrue
        }

        It 'Generated Audit policy file should exist with more than one parameter' {
            $auditPolicyFileWindows_WithParam = Join-Path -Path $testAINEOutputPathWindows_WithParam -ChildPath 'AuditIfNotExists.json'
            Test-Path -Path $auditPolicyFileWindows_WithParam | Should -BeTrue

            $auditPolicyFileLinux_WithParam = Join-Path -Path $testAINEOutputPathLinux_WithParam -ChildPath 'AuditIfNotExists.json'
            Test-Path -Path $auditPolicyFileLinux_WithParam | Should -BeTrue
        }

        It 'Audit policy with more than one parameter should contain expected content' {
            $auditPolicyFileWindows_WithParam = Join-Path -Path $testAINEOutputPathWindows_WithParam -ChildPath 'AuditIfNotExists.json'
            $auditPolicyContentWindows_WithParam = Get-Content $auditPolicyFileWindows_WithParam | ConvertFrom-Json | ForEach-Object { $_ }
            $auditPolicyContentWindows_WithParam.properties.displayName.Contains($newGCPolicyAINEParametersWindows_WithParam.DisplayName) | Should -BeTrue
            $auditPolicyContentWindows_WithParam.properties.description.Contains($newGCPolicyAINEParametersWindows_WithParam.Description) | Should -BeTrue
            $auditPolicyContentWindows_WithParam.properties.parameters.IncludeArcMachines | Should -Not -BeNullOrEmpty
            $auditPolicyContentWindows_WithParam.properties.policyType | Should -Be 'Custom'
            $auditPolicyContentWindows_WithParam.properties.policyRule.then.details.name | Should -Be 'MyFile'
            $auditPolicyContentWindows_WithParam.properties.policyRule.if.anyOf.allOf[1].anyOf[1].allOf | Where-Object field -eq 'Microsoft.Compute/imagePublisher' | ForEach-Object 'equals' | Should -Be 'MicrosoftWindowsServer'
            $auditPolicyContentWindows_WithParam.properties.parameters.ensure.defaultValue | Should -Be $defaultEnsure
            $auditPolicyContentWindows_WithParam.properties.parameters.path.defaultValue | Should -Be $defaultPath
            $auditPolicyContentWindows_WithParam.properties.parameters.content.defaultValue | Should -Be $defaultContent
            $auditPolicyContentWindows_WithParam.properties.metadata.guestConfiguration.configurationParameter.content | Should -Be $defaultAineFormatConfigParam_content
            $auditPolicyContentWindows_WithParam.properties.metadata.guestConfiguration.configurationParameter.ensure | Should -Be $defaultAineFormatConfigParam_ensure
            $auditPolicyContentWindows_WithParam.properties.metadata.guestConfiguration.configurationParameter.path | Should -Be $defaultAineFormatConfigParam_path
            $auditPolicyContentWindows_WithParam.name | Should -Be $policyID_Windows

            $auditPolicyFileLinux_WithParam = Join-Path -Path $testAINEOutputPathLinux_WithParam -ChildPath 'AuditIfNotExists.json'
            $auditPolicyContentLinux_WithParam = Get-Content $auditPolicyFileLinux_WithParam | ConvertFrom-Json | ForEach-Object { $_ }
            $auditPolicyContentLinux_WithParam.properties.displayName.Contains($newGCPolicyAINEParametersLinux_WithParam.DisplayName) | Should -BeTrue
            $auditPolicyContentLinux_WithParam.properties.description.Contains($newGCPolicyAINEParametersLinux_WithParam.Description) | Should -BeTrue
            $auditPolicyContentLinux_WithParam.properties.parameters.IncludeArcMachines | Should -Not -BeNullOrEmpty
            $auditPolicyContentLinux_WithParam.properties.policyType | Should -Be 'Custom'
            $auditPolicyContentLinux_WithParam.properties.policyRule.then.details.name | Should -Be 'MyFile'
            $auditPolicyContentLinux_WithParam.properties.policyRule.if.anyOf.allOf[1].anyOf[1].allOf | Where-Object field -eq 'Microsoft.Compute/imagePublisher' | ForEach-Object 'equals' | Should -Be 'OpenLogic'
            $auditPolicyContentLinux_WithParam.properties.parameters.ensure.defaultValue | Should -Be $defaultEnsure
            $auditPolicyContentLinux_WithParam.properties.parameters.path.defaultValue | Should -Be $defaultPath
            $auditPolicyContentLinux_WithParam.properties.parameters.content.defaultValue | Should -Be $defaultContent
            $auditPolicyContentLinux_WithParam.properties.metadata.guestConfiguration.configurationParameter.content | Should -Be $defaultAineFormatConfigParam_content
            $auditPolicyContentLinux_WithParam.properties.metadata.guestConfiguration.configurationParameter.ensure | Should -Be $defaultAineFormatConfigParam_ensure
            $auditPolicyContentLinux_WithParam.properties.metadata.guestConfiguration.configurationParameter.path | Should -Be $defaultAineFormatConfigParam_path
            $auditPolicyContentLinux_WithParam.name | Should -Be $policyID_Linux
        }


        # AINE - With only one parameter
        It 'New-GuestConfigurationPolicy should output path to generated policies with only one parameter' {
            # Modify object to only have one parameter
            $newGCPolicyAINEParametersWindows_WithParam.Parameter = $singlePolicyParamInfo
            $newGCPolicyAINEParametersLinux_WithParam.Parameter = $singlePolicyParamInfo
            $newGCPolicyAINEParametersWindows_WithParam.Path = $testAINEOutputPathWindows_WithOneParam
            $newGCPolicyAINEParametersLinux_WithParam.Path = $testAINEOutputPathLinux_WithOneParam

            $newGCPolicyResultWindows_WithOneParam = New-GuestConfigurationPolicy @newGCPolicyAINEParametersWindows_WithParam
            $newGCPolicyResultWindows_WithOneParam.Path | Should -Not -BeNullOrEmpty
            Test-Path -Path $newGCPolicyResultWindows_WithOneParam.Path | Should -BeTrue

            $newGCPolicyResultLinux_WithOneParam = New-GuestConfigurationPolicy @newGCPolicyAINEParametersLinux_WithParam
            $newGCPolicyResultLinux_WithOneParam.Path | Should -Not -BeNullOrEmpty
            Test-Path -Path $newGCPolicyResultLinux_WithOneParam.Path | Should -BeTrue
        }

        It 'Generated Audit policy file should exist with only one parameter' {
            $auditPolicyFileWindows_WithOneParam = Join-Path -Path $testAINEOutputPathWindows_WithOneParam -ChildPath 'AuditIfNotExists.json'
            Test-Path -Path $auditPolicyFileWindows_WithOneParam | Should -BeTrue

            $auditPolicyFileLinux_WithOneParam = Join-Path -Path $testAINEOutputPathLinux_WithOneParam -ChildPath 'AuditIfNotExists.json'
            Test-Path -Path $auditPolicyFileLinux_WithOneParam | Should -BeTrue
        }

        It 'Audit policy with only one parameter should contain expected content' {
            $auditPolicyFileWindows_WithOneParam = Join-Path -Path $testAINEOutputPathWindows_WithOneParam -ChildPath 'AuditIfNotExists.json'
            $auditPolicyContentWindows_WithOneParam = Get-Content $auditPolicyFileWindows_WithOneParam | ConvertFrom-Json | ForEach-Object { $_ }
            $auditPolicyContentWindows_WithOneParam.properties.displayName.Contains($newGCPolicyAINEParametersWindows_WithParam.DisplayName) | Should -BeTrue
            $auditPolicyContentWindows_WithOneParam.properties.description.Contains($newGCPolicyAINEParametersWindows_WithParam.Description) | Should -BeTrue
            $auditPolicyContentWindows_WithOneParam.properties.parameters.IncludeArcMachines | Should -Not -BeNullOrEmpty
            $auditPolicyContentWindows_WithOneParam.properties.policyType | Should -Be 'Custom'
            $auditPolicyContentWindows_WithOneParam.properties.policyRule.then.details.name | Should -Be 'MyFile'
            $auditPolicyContentWindows_WithOneParam.properties.policyRule.if.anyOf.allOf[1].anyOf[1].allOf | Where-Object field -eq 'Microsoft.Compute/imagePublisher' | ForEach-Object 'equals' | Should -Be 'MicrosoftWindowsServer'
            $auditPolicyContentWindows_WithOneParam.properties.parameters.ensure.defaultValue | Should -Be $defaultEnsure
            $auditPolicyContentWindows_WithOneParam.properties.parameters.path.defaultValue | Should -Be $null
            $auditPolicyContentWindows_WithOneParam.properties.parameters.content.defaultValue | Should -Be $null
            $auditPolicyContentWindows_WithOneParam.properties.metadata.guestConfiguration.configurationParameter.ensure | Should -Be $defaultAineFormatConfigParam_ensure
            $auditPolicyContentWindows_WithOneParam.properties.metadata.guestConfiguration.configurationParameter.path | Should -Be $null
            $auditPolicyContentWindows_WithOneParam.properties.metadata.guestConfiguration.configurationParameter.content | Should -Be $null
            $auditPolicyContentWindows_WithOneParam.name | Should -Be $policyID_Windows

            $auditPolicyFileLinux_WithOneParam = Join-Path -Path $testAINEOutputPathLinux_WithOneParam -ChildPath 'AuditIfNotExists.json'
            $auditPolicyContentLinux_WithOneParam = Get-Content $auditPolicyFileLinux_WithOneParam | ConvertFrom-Json | ForEach-Object { $_ }
            $auditPolicyContentLinux_WithOneParam.properties.displayName.Contains($newGCPolicyAINEParametersLinux_WithParam.DisplayName) | Should -BeTrue
            $auditPolicyContentLinux_WithOneParam.properties.description.Contains($newGCPolicyAINEParametersLinux_WithParam.Description) | Should -BeTrue
            $auditPolicyContentLinux_WithOneParam.properties.parameters.IncludeArcMachines | Should -Not -BeNullOrEmpty
            $auditPolicyContentLinux_WithOneParam.properties.policyType | Should -Be 'Custom'
            $auditPolicyContentLinux_WithOneParam.properties.policyRule.then.details.name | Should -Be 'MyFile'
            $auditPolicyContentLinux_WithOneParam.properties.policyRule.if.anyOf.allOf[1].anyOf[1].allOf | Where-Object field -eq 'Microsoft.Compute/imagePublisher' | ForEach-Object 'equals' | Should -Be 'OpenLogic'
            $auditPolicyContentLinux_WithOneParam.properties.parameters.ensure.defaultValue | Should -Be $defaultEnsure
            $auditPolicyContentLinux_WithOneParam.properties.parameters.path.defaultValue | Should -Be $null
            $auditPolicyContentLinux_WithOneParam.properties.parameters.content.defaultValue | Should -Be $null
            $auditPolicyContentLinux_WithOneParam.properties.metadata.guestConfiguration.configurationParameter.ensure | Should -Be $defaultAineFormatConfigParam_ensure
            $auditPolicyContentLinux_WithOneParam.properties.metadata.guestConfiguration.configurationParameter.path | Should -Be $null
            $auditPolicyContentLinux_WithOneParam.properties.metadata.guestConfiguration.configurationParameter.content | Should -Be $null
            $auditPolicyContentLinux_WithOneParam.name | Should -Be $policyID_Linux
        }

        # DINE Tests - no parameters
        It 'New-GuestConfigurationPolicy -Type ApplyAndMonitor should output path to generated policies with no parameters' {
            $newGCPolicyResultWindows = New-GuestConfigurationPolicy @newGCPolicyDINEParametersWindows
            $newGCPolicyResultWindows.Path | Should -Not -BeNullOrEmpty
            Test-Path -Path $newGCPolicyResultWindows.Path | Should -BeTrue

            $newGCPolicyResultLinux = New-GuestConfigurationPolicy @newGCPolicyDINEParametersLinux
            $newGCPolicyResultLinux.Path | Should -Not -BeNullOrEmpty
            Test-Path -Path $newGCPolicyResultLinux.Path | Should -BeTrue
        }

        It 'Generated Deploy policy file should exist with no parameters' {
            $deployPolicyFileWindows = Join-Path -Path $testDINEOutputPathWindows -ChildPath 'DeployIfNotExists.json'
            Test-Path -Path $deployPolicyFileWindows | Should -BeTrue

            $deployPolicyFileLinux = Join-Path -Path $testDINEOutputPathLinux -ChildPath 'DeployIfNotExists.json'
            Test-Path -Path $deployPolicyFileLinux | Should -BeTrue
        }

        It 'Deploy policy with no parameters should contain expected content' {
            $deployPolicyFileWindows = Join-Path -Path $testDINEOutputPathWindows -ChildPath 'DeployIfNotExists.json'
            $deployPolicyContentWindows = Get-Content $deployPolicyFileWindows | ConvertFrom-Json | ForEach-Object { $_ }
            $deployPolicyContentWindows.properties.displayName.Contains($newGCPolicyDINEParametersWindows.DisplayName) | Should -BeTrue
            $deployPolicyContentWindows.properties.description.Contains($newGCPolicyDINEParametersWindows.Description) | Should -BeTrue
            $deployPolicyContentWindows.properties.parameters.IncludeArcMachines | Should -Not -BeNullOrEmpty
            $deployPolicyContentWindows.properties.policyType | Should -Be 'Custom'
            $deployPolicyContentWindows.properties.policyRule.then.details.name | Should -Be 'AuditWindowsService'
            $deployPolicyContentWindows.properties.policyRule.if.anyOf.allOf[1].anyOf[1].allOf | Where-Object field -eq 'Microsoft.Compute/imagePublisher' | ForEach-Object 'equals' | Should -Be 'MicrosoftWindowsServer'
            $deployPolicyContentWindows.properties.policyRule.then.details.deployment.properties.template.resources[0].properties.guestConfiguration.configurationParameter.GetType().BaseType.Name | Should -Be 'Array'
            $deployPolicyContentWindows.name | Should -Be $policyID_Windows

            $deployPolicyFileLinux = Join-Path -Path $testDINEOutputPathLinux -ChildPath 'DeployIfNotExists.json'
            $deployPolicyContentLinux = Get-Content $deployPolicyFileLinux | ConvertFrom-Json | ForEach-Object { $_ }
            $deployPolicyContentLinux.properties.displayName.Contains($newGCPolicyDINEParametersLinux.DisplayName) | Should -BeTrue
            $deployPolicyContentLinux.properties.description.Contains($newGCPolicyDINEParametersLinux.Description) | Should -BeTrue
            $deployPolicyContentLinux.properties.parameters.IncludeArcMachines | Should -Not -BeNullOrEmpty
            $deployPolicyContentLinux.properties.policyType | Should -Be 'Custom'
            $deployPolicyContentLinux.properties.policyRule.then.details.name | Should -Be 'AuditWindowsService'
            $deployPolicyContentLinux.properties.policyRule.if.anyOf.allOf[1].anyOf[1].allOf | Where-Object field -eq 'Microsoft.Compute/imagePublisher' | ForEach-Object 'equals' | Should -Be 'OpenLogic'
            $deployPolicyContentLinux.properties.policyRule.then.details.deployment.properties.template.resources[0].properties.guestConfiguration.configurationParameter.GetType().BaseType.Name | Should -Be 'Array'
            $deployPolicyContentLinux.name | Should -Be $policyID_Linux
        }

        # DINE Tests - With more than one parameter
        It 'New-GuestConfigurationPolicy -Type ApplyAndMonitor should output path to generated policies with more than one parameter' {
            $newGCPolicyResultWindows_WithParam = New-GuestConfigurationPolicy @newGCPolicyDINEParametersWindows_WithParam
            $newGCPolicyResultWindows_WithParam.Path | Should -Not -BeNullOrEmpty
            Test-Path -Path $newGCPolicyResultWindows_WithParam.Path | Should -BeTrue

            $newGCPolicyResultLinux_WithParam = New-GuestConfigurationPolicy @newGCPolicyDINEParametersLinux_WithParam
            $newGCPolicyResultLinux_WithParam.Path | Should -Not -BeNullOrEmpty
            Test-Path -Path $newGCPolicyResultLinux_WithParam.Path | Should -BeTrue
        }

        It 'Generated Deploy policy file should exist with more than one parameter' {
            $deployPolicyFileWindows_WithParam = Join-Path -Path $testDINEOutputPathWindows_WithParam -ChildPath 'DeployIfNotExists.json'
            Test-Path -Path $deployPolicyFileWindows_WithParam | Should -BeTrue

            $deployPolicyFileLinux_WithParam = Join-Path -Path $testDINEOutputPathLinux_WithParam -ChildPath 'DeployIfNotExists.json'
            Test-Path -Path $deployPolicyFileLinux_WithParam | Should -BeTrue
        }

        It 'Deploy policy with more than one parameter should contain expected content' {
            $deployPolicyFileWindows_WithParam = Join-Path -Path $testDINEOutputPathWindows_WithParam -ChildPath 'DeployIfNotExists.json'
            $deployPolicyContentWindows_WithParam = Get-Content $deployPolicyFileWindows_WithParam | ConvertFrom-Json | ForEach-Object { $_ }
            $deployPolicyContentWindows_WithParam.properties.displayName.Contains($newGCPolicyDINEParametersWindows_WithParam.DisplayName) | Should -BeTrue
            $deployPolicyContentWindows_WithParam.properties.description.Contains($newGCPolicyDINEParametersWindows_WithParam.Description) | Should -BeTrue
            $deployPolicyContentWindows_WithParam.properties.parameters.IncludeArcMachines | Should -Not -BeNullOrEmpty
            $deployPolicyContentWindows_WithParam.properties.policyType | Should -Be 'Custom'
            $deployPolicyContentWindows_WithParam.properties.policyRule.then.details.name | Should -Be 'MyFile'
            $deployPolicyContentWindows_WithParam.properties.policyRule.if.anyOf.allOf[1].anyOf[1].allOf | Where-Object field -eq 'Microsoft.Compute/imagePublisher' | ForEach-Object 'equals' | Should -Be 'MicrosoftWindowsServer'
            $deployPolicyContentWindows_WithParam.properties.policyRule.then.details.deployment.properties.template.resources[0].properties.guestConfiguration.configurationParameter.GetType().BaseType.Name | Should -Be 'Array'
            $deployPolicyContentWindows_WithParam.properties.parameters.ensure.defaultValue | Should -Be $defaultEnsure
            $deployPolicyContentWindows_WithParam.properties.parameters.path.defaultValue | Should -Be $defaultPath
            $deployPolicyContentWindows_WithParam.properties.parameters.content.defaultValue | Should -Be $defaultContent
            $deployPolicyContentWindows_WithParam.properties.metadata.guestConfiguration.configurationParameter.content | Should -Be $defaultAineFormatConfigParam_content
            $deployPolicyContentWindows_WithParam.properties.metadata.guestConfiguration.configurationParameter.ensure | Should -Be $defaultAineFormatConfigParam_ensure
            $deployPolicyContentWindows_WithParam.properties.metadata.guestConfiguration.configurationParameter.path | Should -Be $defaultAineFormatConfigParam_path
            $deployPolicyContentWindows_WithParam.name | Should -Be $policyID_Windows

            $deployPolicyFileLinux_WithParam = Join-Path -Path $testDINEOutputPathLinux_WithParam -ChildPath 'DeployIfNotExists.json'
            $deployPolicyContentLinux_WithParam = Get-Content $deployPolicyFileLinux_WithParam | ConvertFrom-Json | ForEach-Object { $_ }
            $deployPolicyContentLinux_WithParam.properties.displayName.Contains($newGCPolicyDINEParametersLinux_WithParam.DisplayName) | Should -BeTrue
            $deployPolicyContentLinux_WithParam.properties.description.Contains($newGCPolicyDINEParametersLinux_WithParam.Description) | Should -BeTrue
            $deployPolicyContentLinux_WithParam.properties.parameters.IncludeArcMachines | Should -Not -BeNullOrEmpty
            $deployPolicyContentLinux_WithParam.properties.policyType | Should -Be 'Custom'
            $deployPolicyContentLinux_WithParam.properties.policyRule.then.details.name | Should -Be 'MyFile'
            $deployPolicyContentLinux_WithParam.properties.policyRule.if.anyOf.allOf[1].anyOf[1].allOf | Where-Object field -eq 'Microsoft.Compute/imagePublisher' | ForEach-Object 'equals' | Should -Be 'OpenLogic'
            $deployPolicyContentLinux_WithParam.properties.policyRule.then.details.deployment.properties.template.resources[0].properties.guestConfiguration.configurationParameter.GetType().BaseType.Name | Should -Be 'Array'
            $deployPolicyContentLinux_WithParam.properties.parameters.ensure.defaultValue | Should -Be $defaultEnsure
            $deployPolicyContentLinux_WithParam.properties.parameters.path.defaultValue | Should -Be $defaultPath
            $deployPolicyContentLinux_WithParam.properties.parameters.content.defaultValue | Should -Be $defaultContent
            $deployPolicyContentLinux_WithParam.properties.metadata.guestConfiguration.configurationParameter.content | Should -Be $defaultAineFormatConfigParam_content
            $deployPolicyContentLinux_WithParam.properties.metadata.guestConfiguration.configurationParameter.ensure | Should -Be $defaultAineFormatConfigParam_ensure
            $deployPolicyContentLinux_WithParam.properties.metadata.guestConfiguration.configurationParameter.path | Should -Be $defaultAineFormatConfigParam_path
            $deployPolicyContentLinux_WithParam.name | Should -Be $policyID_Linux
        }

        # DINE Tests - With only one parameter
        It 'New-GuestConfigurationPolicy -Type ApplyAndMonitor should output path to generated policies for only one parameter' {
            # Modify object to only have one parameter
            $newGCPolicyDINEParametersWindows_WithParam.Parameter = $singlePolicyParamInfo
            $newGCPolicyDINEParametersLinux_WithParam.Parameter = $singlePolicyParamInfo
            $newGCPolicyDINEParametersWindows_WithParam.Path = $testDINEOutputPathWindows_WithOneParam
            $newGCPolicyDINEParametersLinux_WithParam.Path = $testDINEOutputPathLinux_WithOneParam

            # Create policy
            $newGCPolicyResultWindows_WithOneParam = New-GuestConfigurationPolicy @newGCPolicyDINEParametersWindows_WithParam
            $newGCPolicyResultWindows_WithOneParam.Path | Should -Not -BeNullOrEmpty
            Test-Path -Path $newGCPolicyResultWindows_WithOneParam.Path | Should -BeTrue

            $newGCPolicyResultLinux_WithOneParam = New-GuestConfigurationPolicy @newGCPolicyDINEParametersLinux_WithParam
            $newGCPolicyResultLinux_WithOneParam.Path | Should -Not -BeNullOrEmpty
            Test-Path -Path $newGCPolicyResultLinux_WithOneParam.Path | Should -BeTrue
        }

        It 'Generated Deploy policy file with one param should exist for only one parameter' {
            $deployPolicyFileWindows_WithOneParam = Join-Path -Path $testDINEOutputPathWindows_WithOneParam -ChildPath 'DeployIfNotExists.json'
            Test-Path -Path $deployPolicyFileWindows_WithOneParam | Should -BeTrue

            $deployPolicyFileLinux_WithOneParam = Join-Path -Path $testDINEOutputPathLinux_WithOneParam -ChildPath 'DeployIfNotExists.json'
            Test-Path -Path $deployPolicyFileLinux_WithOneParam | Should -BeTrue
        }

        It 'Deploy policy with only one parameter should contain expected content ' {
            $deployPolicyFileWindows_WithOneParam = Join-Path -Path $testDINEOutputPathWindows_WithOneParam -ChildPath 'DeployIfNotExists.json'
            $deployPolicyContentWindows_WithOneParam = Get-Content $deployPolicyFileWindows_WithOneParam | ConvertFrom-Json | ForEach-Object { $_ }
            $deployPolicyContentWindows_WithOneParam.properties.displayName.Contains($newGCPolicyDINEParametersWindows_WithParam.DisplayName) | Should -BeTrue
            $deployPolicyContentWindows_WithOneParam.properties.description.Contains($newGCPolicyDINEParametersWindows_WithParam.Description) | Should -BeTrue
            $deployPolicyContentWindows_WithOneParam.properties.parameters.IncludeArcMachines | Should -Not -BeNullOrEmpty
            $deployPolicyContentWindows_WithOneParam.properties.policyType | Should -Be 'Custom'
            $deployPolicyContentWindows_WithOneParam.properties.policyRule.then.details.name | Should -Be 'MyFile'
            $deployPolicyContentWindows_WithOneParam.properties.policyRule.if.anyOf.allOf[1].anyOf[1].allOf | Where-Object field -eq 'Microsoft.Compute/imagePublisher' | ForEach-Object 'equals' | Should -Be 'MicrosoftWindowsServer'
            $deployPolicyContentWindows_WithOneParam.properties.policyRule.then.details.deployment.properties.template.resources[0].properties.guestConfiguration.configurationParameter.GetType().BaseType.Name | Should -Be 'Array'
            $deployPolicyContentWindows_WithOneParam.properties.parameters.ensure.defaultValue | Should -Be $defaultEnsure
            $deployPolicyContentWindows_WithOneParam.properties.parameters.path.defaultValue | Should -Be $null
            $deployPolicyContentWindows_WithOneParam.properties.parameters.content.defaultValue | Should -Be $null
            $deployPolicyContentWindows_WithOneParam.properties.metadata.guestConfiguration.configurationParameter.ensure | Should -Be $defaultAineFormatConfigParam_ensure
            $deployPolicyContentWindows_WithOneParam.properties.metadata.guestConfiguration.configurationParameter.path | Should -Be $null
            $deployPolicyContentWindows_WithOneParam.properties.metadata.guestConfiguration.configurationParameter.content | Should -Be $null
            $deployPolicyContentWindows_WithOneParam.name | Should -Be $policyID_Windows


            $deployPolicyFileLinux_WithOneParam = Join-Path -Path $testDINEOutputPathLinux_WithOneParam -ChildPath 'DeployIfNotExists.json'
            $deployPolicyContentLinux_WithOneParam = Get-Content $deployPolicyFileLinux_WithOneParam | ConvertFrom-Json | ForEach-Object { $_ }
            $deployPolicyContentLinux_WithOneParam.properties.displayName.Contains($newGCPolicyDINEParametersLinux_WithParam.DisplayName) | Should -BeTrue
            $deployPolicyContentLinux_WithOneParam.properties.description.Contains($newGCPolicyDINEParametersLinux_WithParam.Description) | Should -BeTrue
            $deployPolicyContentLinux_WithOneParam.properties.parameters.IncludeArcMachines | Should -Not -BeNullOrEmpty
            $deployPolicyContentLinux_WithOneParam.properties.policyType | Should -Be 'Custom'
            $deployPolicyContentLinux_WithOneParam.properties.policyRule.then.details.name | Should -Be 'MyFile'
            $deployPolicyContentLinux_WithOneParam.properties.policyRule.if.anyOf.allOf[1].anyOf[1].allOf | Where-Object field -eq 'Microsoft.Compute/imagePublisher' | ForEach-Object 'equals' | Should -Be 'OpenLogic'
            $deployPolicyContentLinux_WithOneParam.properties.policyRule.then.details.deployment.properties.template.resources[0].properties.guestConfiguration.configurationParameter.GetType().BaseType.Name | Should -Be 'Array'
            $deployPolicyContentLinux_WithOneParam.properties.parameters.ensure.defaultValue | Should -Be $defaultEnsure
            $deployPolicyContentLinux_WithOneParam.properties.parameters.path.defaultValue | Should -Be $null
            $deployPolicyContentLinux_WithOneParam.properties.parameters.content.defaultValue | Should -Be $null
            $deployPolicyContentLinux_WithOneParam.properties.metadata.guestConfiguration.configurationParameter.ensure | Should -Be $defaultAineFormatConfigParam_ensure
            $deployPolicyContentLinux_WithOneParam.properties.metadata.guestConfiguration.configurationParameter.path | Should -Be $null
            $deployPolicyContentLinux_WithOneParam.properties.metadata.guestConfiguration.configurationParameter.content | Should -Be $null
            $deployPolicyContentLinux_WithOneParam.name | Should -Be $policyID_Linux
        }


        # PolicyID Tests
        It 'New-GuestConfigurationPolicy with random policyID should still generate - AINE' {
            $newGCPolicyAINEParametersWindows.PolicyId = $foo_policyId
            $newGCPolicyAINEParametersLinux.PolicyId = $foo_policyId

            $newGCPolicyResultWindows = New-GuestConfigurationPolicy @newGCPolicyAINEParametersWindows
            $newGCPolicyResultWindows.Path | Should -Not -BeNullOrEmpty
            Test-Path -Path $newGCPolicyResultWindows.Path | Should -BeTrue
            $auditPolicyFileWindows = Join-Path -Path $testAINEOutputPathWindows -ChildPath 'AuditIfNotExists.json'
            $auditPolicyContentWindows = Get-Content $auditPolicyFileWindows | ConvertFrom-Json | ForEach-Object { $_ }
            $auditPolicyContentWindows.name | Should -Be $foo_policyId

            $newGCPolicyResultLinux = New-GuestConfigurationPolicy @newGCPolicyAINEParametersLinux
            $newGCPolicyResultLinux.Path | Should -Not -BeNullOrEmpty
            Test-Path -Path $newGCPolicyResultLinux.Path | Should -BeTrue
            $auditPolicyFileLinux = Join-Path -Path $testAINEOutputPathLinux -ChildPath 'AuditIfNotExists.json'
            $auditPolicyContentLinux = Get-Content $auditPolicyFileLinux | ConvertFrom-Json | ForEach-Object { $_ }
            $auditPolicyContentLinux.name | Should -Be $foo_policyId
        }

        It 'New-GuestConfigurationPolicy with random policyID should still generate - DINE' {
            $newGCPolicyDINEParametersWindows.PolicyId = $foo_policyId
            $newGCPolicyDINEParametersLinux.PolicyId = $foo_policyId

            $newGCPolicyResultWindows = New-GuestConfigurationPolicy @newGCPolicyDINEParametersWindows
            $newGCPolicyResultWindows.Path | Should -Not -BeNullOrEmpty
            Test-Path -Path $newGCPolicyResultWindows.Path | Should -BeTrue
            $deployPolicyFileWindows = Join-Path -Path $testDINEOutputPathWindows -ChildPath 'DeployIfNotExists.json'
            $deployPolicyContentWindows = Get-Content $deployPolicyFileWindows | ConvertFrom-Json | ForEach-Object { $_ }
            $deployPolicyContentWindows.name | Should -Be $foo_policyId


            $newGCPolicyResultLinux = New-GuestConfigurationPolicy @newGCPolicyDINEParametersLinux
            $newGCPolicyResultLinux.Path | Should -Not -BeNullOrEmpty
            Test-Path -Path $newGCPolicyResultLinux.Path | Should -BeTrue
            $deployPolicyFileLinux = Join-Path -Path $testDINEOutputPathLinux -ChildPath 'DeployIfNotExists.json'
            $deployPolicyContentLinux = Get-Content $deployPolicyFileLinux | ConvertFrom-Json | ForEach-Object { $_ }
            $deployPolicyContentLinux.name | Should -Be $foo_policyId
        }
    }
}
