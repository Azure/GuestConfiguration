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

Describe 'New-GuestConfigurationPolicy' {
    BeforeAll {
        $script:testDriveCreated = $false
        # Pester is intermittently not creating the test drive path :(
        if (-not (Test-Path -Path $TestDrive))
        {
            $null = New-Item -Path $TestDrive -ItemType 'Directory' -Force
            $script:testDriveCreated = $true
        }

        Push-Location -Path $TestDrive
        $defaultDefinitionsPath = Get-Location

        function Assert-GuestConfigurationPolicyDefinitionFileValid
        {
            [CmdletBinding()]
            param
            (
                [Parameter(Mandatory = $true)]
                [String]
                $ExpectedFilePath,

                [Parameter(Mandatory = $true)]
                [String]
                $ExpectedPolicyVersion,

                [Parameter(Mandatory = $true)]
                [String]
                $ExpectedDisplayName,

                [Parameter(Mandatory = $true)]
                [String]
                $ExpectedDescription,

                [Parameter(Mandatory = $true)]
                [String]
                $ExpectedContentUri,

                [Parameter(Mandatory = $true)]
                [String]
                $ExpectedContentHash,

                [Parameter(Mandatory = $true)]
                [String]
                $ExpectedConfigurationName,

                [Parameter(Mandatory = $true)]
                [String]
                $ExpectedConfigurationVersion,

                [Parameter()]
                [String]
                $ExpectedMode = 'Audit',

                [Parameter()]
                [String]
                $ExpectedPlatform = 'Windows',

                [Parameter()]
                [String]
                $ExpectedPolicyId,

                [Parameter()]
                [Hashtable[]]
                $ExpectedParameters = @(),

                [Parameter()]
                [Hashtable]
                $ExpectedTags = @{}
            )

            $expectedMAFormatConfigurationName = "[concat('$ExpectedConfigurationName`$pid', uniqueString(policy().assignmentId, policy().definitionReferenceId))]"

            Test-Path -Path $ExpectedFilePath -PathType 'Leaf' | Should -BeTrue
            $fileContent = Get-Content -Path $ExpectedFilePath -Raw
            $fileContent | Should -Not -BeNullOrEmpty
            $fileContent.Contains('\u0027') | Should -BeFalse

            $fileContentJson = $fileContent | ConvertFrom-Json
            $fileContentJson | Should -Not -BeNullOrEmpty
            $fileContentJson.properties | Should -Not -BeNullOrEmpty

            $fileContentJson.properties.displayName | Should -Be $ExpectedDisplayName
            $fileContentJson.properties.description | Should -Be $ExpectedDescription
            $fileContentJson.properties.policyType | Should -Be 'Custom'
            $fileContentJson.properties.mode | Should -Be 'Indexed'

            $fileContentJson.properties.metadata | Should -Not -BeNullOrEmpty
            $fileContentJson.properties.metadata.version | Should -Be $ExpectedPolicyVersion
            $fileContentJson.properties.metadata.category | Should -Be 'Guest Configuration'

            $fileContentJson.properties.metadata.guestConfiguration | Should -Not -BeNullOrEmpty
            $fileContentJson.properties.metadata.guestConfiguration.name | Should -Be $ExpectedConfigurationName
            $fileContentJson.properties.metadata.guestConfiguration.version | Should -Be $ExpectedConfigurationVersion
            $fileContentJson.properties.metadata.guestConfiguration.contentType | Should -Be 'Custom'
            $fileContentJson.properties.metadata.guestConfiguration.contentUri | Should -Be $ExpectedContentUri
            $fileContentJson.properties.metadata.guestConfiguration.contentHash | Should -Be $ExpectedContentHash

            $fileContentJson.properties.parameters | Should -Not -BeNullOrEmpty
            $fileContentJson.properties.parameters.IncludeArcMachines | Should -Not -BeNullOrEmpty
            $fileContentJson.properties.parameters.IncludeArcMachines.type | Should -Be 'boolean'
            $fileContentJson.properties.parameters.IncludeArcMachines.defaultValue | Should -Be $false
            $fileContentJson.properties.parameters.IncludeArcMachines.metadata | Should -Not -BeNullOrEmpty
            $fileContentJson.properties.parameters.IncludeArcMachines.metadata.displayName | Should -Be 'Include Arc connected machines'
            $fileContentJson.properties.parameters.IncludeArcMachines.metadata.description | Should -Be 'By selecting this option, you agree to be charged monthly per Arc connected machine.'

            $fileContentJson.properties.policyRule | Should -Not -BeNullOrEmpty
            $fileContentJson.properties.policyRule.if | Should -Not -BeNullOrEmpty
            $fileContentJson.properties.policyRule.then | Should -Not -BeNullOrEmpty

            $fileContentJson.properties.policyRule.then.details | Should -Not -BeNullOrEmpty
            $fileContentJson.properties.policyRule.then.details.type | Should -Be 'Microsoft.GuestConfiguration/guestConfigurationAssignments'
            $fileContentJson.properties.policyRule.then.details.name | Should -Be $expectedMAFormatConfigurationName
            $fileContentJson.properties.policyRule.then.details.existenceCondition | Should -Not -BeNullOrEmpty

            { $null = [System.Guid]$fileContentJson.name } | Should -Not -Throw

            if (-not [String]::IsNullOrEmpty($ExpectedPolicyId))
            {
                $fileContentJson.name | Should -Be $ExpectedPolicyId
            }

            # Parameters
            if ($ExpectedParameters.Count -eq 0)
            {
                $fileContentJson.properties.metadata.guestConfiguration.configurationParameter | Should -BeNullOrEmpty

                $fileContentJson.properties.policyRule.then.details.existenceCondition.field | Should -Be 'Microsoft.GuestConfiguration/guestConfigurationAssignments/complianceStatus'
                $fileContentJson.properties.policyRule.then.details.existenceCondition.equals | Should -Be $true
            }
            else
            {
                $fileContentJson.properties.policyRule.then.details.existenceCondition.allOf | Should -Not -BeNullOrEmpty
                $fileContentJson.properties.policyRule.then.details.existenceCondition.allOf.Count | Should -Be 2
                $fileContentJson.properties.policyRule.then.details.existenceCondition.allOf[0].field | Should -Be 'Microsoft.GuestConfiguration/guestConfigurationAssignments/complianceStatus'
                $fileContentJson.properties.policyRule.then.details.existenceCondition.allOf[0].equals | Should -Be $true

                $parameterHashItems = @()

                foreach ($parameter in $ExpectedParameters)
                {
                    $parameterName = $parameter['Name']

                    $fileContentJson.properties.parameters.$parameterName | Should -Not -BeNullOrEmpty
                    $fileContentJson.properties.parameters.$parameterName.type | Should -Be 'string'
                    $fileContentJson.properties.parameters.$parameterName.metadata | Should -Not -BeNullOrEmpty
                    $fileContentJson.properties.parameters.$parameterName.metadata.displayName | Should -Be $parameter['DisplayName']
                    $fileContentJson.properties.parameters.$parameterName.metadata.description | Should -Be $parameter['Description']

                    if ($parameter.ContainsKey('AllowedValues'))
                    {
                        $fileContentJson.properties.parameters.$parameterName.allowedValues | Should -Be $parameter['AllowedValues']
                    }

                    if ($parameter.ContainsKey('DefaultValue'))
                    {
                        $fileContentJson.properties.parameters.$parameterName.defaultValue | Should -Be $parameter['DefaultValue']
                    }

                    $resourceReferenceString = "[$($parameter['ResourceType'])]$($parameter['ResourceId']);$($parameter['ResourcePropertyName'])"
                    $fileContentJson.properties.metadata.guestConfiguration.configurationParameter.$parameterName | Should -Not -BeNullOrEmpty $resourceReferenceString

                    $parameterHashItems += "'$resourceReferenceString', '=', parameters('$parameterName')"
                }

                $parameterHashItemString = $parameterHashItems -join ", ',', "
                $expectedParameterHashString = "[base64(concat($parameterHashItemString))]"
                $fileContentJson.properties.policyRule.then.details.existenceCondition.allOf[1].field | Should -Be 'Microsoft.GuestConfiguration/guestConfigurationAssignments/parameterHash'
                $fileContentJson.properties.policyRule.then.details.existenceCondition.allOf[1].equals | Should -Be $expectedParameterHashString
            }

            # Tags
            if ($ExpectedTags.Keys.Count -eq 0)
            {
                $imageConditionList = $fileContentJson.properties.policyRule.if.anyOf
            }
            else
            {
                $fileContentJson.properties.policyRule.if.allOf | Should -Not -BeNullOrEmpty
                $fileContentJson.properties.policyRule.if.allOf.Count | Should -Be 2

                $imageConditionList = $fileContentJson.properties.policyRule.if.allOf[0].anyOf

                if ($ExpectedTags.Keys.Count -gt 1)
                {
                    $tagList = $fileContentJson.properties.policyRule.if.allOf[1].allOf
                }
                else
                {
                    $tagList = @( $fileContentJson.properties.policyRule.if.allOf[1] )
                }

                $tagList | Should -Not -BeNullOrEmpty
                $tagList.Count | Should -Be $ExpectedTags.Keys.Count

                foreach ($expectedTagName in $ExpectedTags.Keys)
                {
                    $matchingField = $tagList | Where-Object { $_.field -eq "tags['$expectedTagName']" }
                    $matchingField | Should -Not -BeNullOrEmpty
                    $matchingField.equals | Should -Be $ExpectedTags[$expectedTagName]
                }
            }

            $imageConditionList | Should -Not -BeNullOrEmpty
            $imageConditionList.Count | Should -Be 2

            $imageConditionList[0] | Should -Not -BeNullOrEmpty
            $imageConditionList[0].allOf | Should -Not -BeNullOrEmpty
            $imageConditionList[0].allOf.Count | Should -Be 2

            # Compute section
            $imageConditionList[0].allOf[0] | Should -Not -BeNullOrEmpty
            $imageConditionList[0].allOf[0].field | Should -Be 'type'
            $imageConditionList[0].allOf[0].equals | Should -Be 'Microsoft.Compute/virtualMachines'

            $imageConditionList[0].allOf[1] | Should -Not -BeNullOrEmpty
            $imageConditionList[0].allOf[1].anyOf | Should -Not -BeNullOrEmpty
            $imageConditionList[0].allOf[1].anyOf.Count | Should -BeGreaterThan 2

            $imageConditionList[0].allOf[1].anyOf[0].field | Should -Be 'Microsoft.Compute/imagePublisher'
            $imageConditionList[0].allOf[1].anyOf[0].in | Should -Not -BeNullOrEmpty

            $imageConditionList[0].allOf[1].anyOf[-1] | Should -Not -BeNullOrEmpty
            $imageConditionList[0].allOf[1].anyOf[-1].allOf | Should -Not -BeNullOrEmpty
            $imageConditionList[0].allOf[1].anyOf[-1].allOf.Count | Should -Be 2

            $imageConditionList[0].allOf[1].anyOf[-1].allOf[0].anyOf | Should -Not -BeNullOrEmpty
            $imageConditionList[0].allOf[1].anyOf[-1].allOf[0].anyOf.Count | Should -Be 2
            $imageConditionList[0].allOf[1].anyOf[-1].allOf[0].anyOf[0].field | Should -Be "Microsoft.Compute/virtualMachines/osProfile.$($ExpectedPlatform.ToLower())Configuration"
            $imageConditionList[0].allOf[1].anyOf[-1].allOf[0].anyOf[0].exists | Should -Be $true
            $imageConditionList[0].allOf[1].anyOf[-1].allOf[0].anyOf[1].field | Should -Be "Microsoft.Compute/virtualMachines/storageProfile.osDisk.osType"
            $imageConditionList[0].allOf[1].anyOf[-1].allOf[0].anyOf[1].like | Should -Be "$ExpectedPlatform*"

            $imageConditionList[0].allOf[1].anyOf[-1].allOf[1].anyOf | Should -Not -BeNullOrEmpty
            $imageConditionList[0].allOf[1].anyOf[-1].allOf[1].anyOf.Count | Should -Be 2
            $imageConditionList[0].allOf[1].anyOf[-1].allOf[1].anyOf[0].field.StartsWith("Microsoft.Compute/image") | Should -BeTrue
            $imageConditionList[0].allOf[1].anyOf[-1].allOf[1].anyOf[0].exists | Should -Be $false
            $imageConditionList[0].allOf[1].anyOf[-1].allOf[1].anyOf[1] | Should -Not -BeNullOrEmpty

            # Hybrid section
            $imageConditionList[1].allOf | Should -Not -BeNullOrEmpty
            $imageConditionList[1].allOf.Count | Should -Be 2
            $imageConditionList[1].allOf[0].value | Should -Be "[parameters('IncludeArcMachines')]"
            $imageConditionList[1].allOf[0].equals | Should -Be $true
            $imageConditionList[1].allOf[1].anyOf | Should -Not -BeNullOrEmpty
            $imageConditionList[1].allOf[1].anyOf.Count | Should -Be 2

            $imageConditionList[1].allOf[1].anyOf[0].allOf | Should -Not -BeNullOrEmpty
            $imageConditionList[1].allOf[1].anyOf[0].allOf.Count | Should -Be 2
            $imageConditionList[1].allOf[1].anyOf[0].allOf[0].field | Should -Be 'type'
            $imageConditionList[1].allOf[1].anyOf[0].allOf[0].equals | Should -Be 'Microsoft.HybridCompute/machines'
            $imageConditionList[1].allOf[1].anyOf[0].allOf[1].field | Should -Be 'Microsoft.HybridCompute/imageOffer'
            $imageConditionList[1].allOf[1].anyOf[0].allOf[1].like | Should -Be "$($ExpectedPlatform.ToLower())*"

            $imageConditionList[1].allOf[1].anyOf[1].allOf | Should -Not -BeNullOrEmpty
            $imageConditionList[1].allOf[1].anyOf[1].allOf.Count | Should -Be 2
            $imageConditionList[1].allOf[1].anyOf[1].allOf[0].field | Should -Be 'type'
            $imageConditionList[1].allOf[1].anyOf[1].allOf[0].equals | Should -Be 'Microsoft.ConnectedVMwarevSphere/virtualMachines'
            $imageConditionList[1].allOf[1].anyOf[1].allOf[1].field | Should -Be 'Microsoft.ConnectedVMwarevSphere/virtualMachines/osProfile.osType'
            $imageConditionList[1].allOf[1].anyOf[1].allOf[1].like | Should -Be "$($ExpectedPlatform.ToLower())*"

            # Set
            if ($ExpectedMode -ieq 'Audit')
            {
                $fileContentJson.properties.policyRule.then.effect | Should -Be 'auditIfNotExists'
            }
            else
            {
                $fileContentJson.properties.policyRule.then.effect | Should -Be 'deployIfNotExists'
                $fileContentJson.properties.policyRule.then.details.roleDefinitionIds.Count | Should -Be 1
                $fileContentJson.properties.policyRule.then.details.roleDefinitionIds[0] | Should -Be '/providers/Microsoft.Authorization/roleDefinitions/088ab73d-1256-47ae-bea9-9de8e7131f31'
                $fileContentJson.properties.policyRule.then.details.deployment | Should -Not -BeNullOrEmpty
                $fileContentJson.properties.policyRule.then.details.deployment.properties.mode | Should -Be 'incremental'
                $fileContentJson.properties.policyRule.then.details.deployment.properties.parameters.vmName.value | Should -Be "[field('name')]"
                $fileContentJson.properties.policyRule.then.details.deployment.properties.parameters.location.value | Should -Be "[field('location')]"
                $fileContentJson.properties.policyRule.then.details.deployment.properties.parameters.type.value | Should -Be "[field('type')]"
                $fileContentJson.properties.policyRule.then.details.deployment.properties.parameters.assignmentName.value | Should -Be  $expectedMAFormatConfigurationName

                $fileContentJson.properties.policyRule.then.details.deployment.properties.template.'$schema' | Should -Be 'https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#'
                $fileContentJson.properties.policyRule.then.details.deployment.properties.template.contentVersion | Should -Be '1.0.0.0'

                $fileContentJson.properties.policyRule.then.details.deployment.properties.template.parameters.vmName.type | Should -Be 'string'
                $fileContentJson.properties.policyRule.then.details.deployment.properties.template.parameters.location.type | Should -Be 'string'
                $fileContentJson.properties.policyRule.then.details.deployment.properties.template.parameters.type.type | Should -Be 'string'
                $fileContentJson.properties.policyRule.then.details.deployment.properties.template.parameters.assignmentName.type | Should -Be 'string'

                foreach ($parameter in $ExpectedParameters)
                {
                    $parameterName = $parameter['Name']
                    $fileContentJson.properties.policyRule.then.details.deployment.properties.parameters.$parameterName.value | Should -Be "[parameters('$parameterName')]"
                    $fileContentJson.properties.policyRule.then.details.deployment.properties.template.parameters.$parameterName.type | Should -Be 'string'
                }

                $fileContentJson.properties.policyRule.then.details.deployment.properties.template.resources.Count | Should -Be 2

                $fileContentJson.properties.policyRule.then.details.deployment.properties.template.resources[0].condition | Should -Be "[equals(toLower(parameters('type')), toLower('Microsoft.Compute/virtualMachines'))]"
                $fileContentJson.properties.policyRule.then.details.deployment.properties.template.resources[0].type | Should -Be "Microsoft.Compute/virtualMachines/providers/guestConfigurationAssignments"

                $fileContentJson.properties.policyRule.then.details.deployment.properties.template.resources[1].condition | Should -Be "[equals(toLower(parameters('type')), toLower('microsoft.hybridcompute/machines'))]"
                $fileContentJson.properties.policyRule.then.details.deployment.properties.template.resources[1].type | Should -Be "Microsoft.HybridCompute/machines/providers/guestConfigurationAssignments"

                foreach ($deploymentResource in $fileContentJson.properties.policyRule.then.details.deployment.properties.template.resources)
                {
                    $deploymentResource.apiVersion | Should -Be "2018-11-20"
                    $deploymentResource.name | Should -Be "[concat(parameters('vmName'), '/Microsoft.GuestConfiguration/', parameters('assignmentName'))]"
                    $deploymentResource.location | Should -Be "[parameters('location')]"

                    $deploymentResource.properties.guestConfiguration.name | Should -Be $ExpectedConfigurationName
                    $deploymentResource.properties.guestConfiguration.version | Should -Be $ExpectedConfigurationVersion
                    $deploymentResource.properties.guestConfiguration.assignmentType | Should -Be $ExpectedMode
                    $deploymentResource.properties.guestConfiguration.contentType | Should -Be 'Custom'
                    $deploymentResource.properties.guestConfiguration.contentUri | Should -Be $ExpectedContentUri
                    $deploymentResource.properties.guestConfiguration.contentHash | Should -Be $ExpectedContentHash

                    if ($ExpectedParameters.Count -gt 0)
                    {
                        $deploymentResource.properties.guestConfiguration.configurationParameter | Should -Not -BeNullOrEmpty
                        $deploymentResource.properties.guestConfiguration.configurationParameter.Count | Should -Be $ExpectedParameters.Count

                        foreach ($parameter in $ExpectedParameters)
                        {
                            $parameterName = $parameter['Name']
                            $resourceReferenceString = "[$($parameter['ResourceType'])]$($parameter['ResourceId']);$($parameter['ResourcePropertyName'])"

                            $resourceParameter = $deploymentResource.properties.guestConfiguration.configurationParameter | Where-Object { $_.value -eq "[parameters('$parameterName')]" }
                            $resourceParameter | Should -Not -BeNullOrEmpty
                            $resourceParameter.name | Should -Be $resourceReferenceString
                        }
                    }
                }
            }
        }
    }

    AfterAll {
        Pop-Location

        if ($script:testDriveCreated)
        {
            $null = Remove-Item -Path $TestDrive -Recurse
        }
    }

    Context '<DisplayName>' -ForEach @(
        @{
            Platform = @('Windows', 'Linux')
            DisplayName = 'MyFile Test Policy'
            Description = 'This is a test policy for the MyFile package at C:/pretend/path/here or \more\slashes\path'
            PolicyId = [Guid]::NewGuid()
            PolicyVersion = '1.0.0'
            ContentUri = 'https://github.com/microsoft/PowerShell-DSC-for-Linux/raw/micy/custompolicy/new_gc_policy/MyFile.zip'
            ContentHash = '59AEA0877406175CB4069F301880BEF0A21BBABCF492CE8476DA047B2FBEA8B6'
            ConfigurationName = 'MyFile'
            ConfigurationVersion = '1.0.0'
            ParameterSets = @(
                @(
                    @{
                        Name = 'FilePath'
                        DisplayName = 'File Path'
                        Description = 'A file path'
                        ResourceType = 'MyFile'
                        ResourceId = 'createFoobarTestFile'
                        ResourcePropertyName = 'Path'
                    }
                ),
                @(
                    @{
                        Name = 'FilePath'
                        DisplayName = 'File Path'
                        Description = 'A file path'
                        ResourceType = 'MyFile'
                        ResourceId = 'createFoobarTestFile'
                        ResourcePropertyName = 'Path'
                    },
                    @{
                        Name = 'FileState'
                        DisplayName = 'File State'
                        Description = 'Whether the file should be present or absent'
                        ResourceType = 'MyFile'
                        ResourceId = 'createFoobarTestFile'
                        ResourcePropertyName = 'ensure'
                        AllowedValues = @('Present', 'Absent')
                        DefaultValue = 'Present'
                    }
                )
            )
        },
        @{
            Platform = @('Windows')
            DisplayName = 'Windows Service Test Policy'
            Description = 'This is a test policy for the Windows Service package.'
            PolicyId = [Guid]::NewGuid()
            PolicyVersion = '1.1.0'
            ContentUri = 'https://github.com/microsoft/PowerShell-DSC-for-Linux/raw/amits/custompolicy/new_gc_policy/AuditWindowsService.zip'
            ContentHash = 'D421E3C8BB2298AEC5CFD95607B91241B7D5A2C88D54262ED304CA1FD01370F3'
            ConfigurationName = 'AuditWindowsService'
            ConfigurationVersion = '1.0.0'
            ParameterSets = @(
                @(
                    @{
                        Name = 'ServiceName'
                        DisplayName = 'Service Name'
                        Description = 'A service name'
                        ResourceType = 'Service'
                        ResourceId = 'windowsService'
                        ResourcePropertyName = 'Name'
                    }
                ),
                @(
                    @{
                        Name = 'ServiceName'
                        DisplayName = 'Service Name'
                        Description = 'A service name'
                        ResourceType = 'Service'
                        ResourceId = 'windowsService'
                        ResourcePropertyName = 'Name'
                    },
                    @{
                        Name = 'ServiceState'
                        DisplayName = 'Service State'
                        Description = 'A service state'
                        ResourceType = 'Service'
                        ResourceId = 'windowsService'
                        ResourcePropertyName = 'State'
                        AllowedValues = @('Running', 'Stopped', 'Disabled')
                        DefaultValue = 'Running'
                    }
                )
            )
        }
    ) {
        Context '<platformString>' -ForEach @($Platform) -Skip:($_ -ieq 'Windows' -and $script:os -ine 'Windows') {
            BeforeAll {
                $platformString = $_

                # Required Parameters
                $basePolicyParameters = @{
                    DisplayName = $DisplayName
                    Description = $Description
                    ContentUri = $ContentUri
                    PolicyId = $PolicyId
                    PolicyVersion = $PolicyVersion
                }

                $expectedFileName = '{0}_AuditIfNotExists.json' -f $ConfigurationName

                $baseAssertionParameters = @{
                    ExpectedDisplayName = $DisplayName
                    ExpectedPolicyVersion = $PolicyVersion
                    ExpectedPolicyId = $PolicyId
                    ExpectedDescription = $Description
                    ExpectedContentUri = $ContentUri
                    ExpectedContentHash = $ContentHash
                    ExpectedConfigurationName = $ConfigurationName
                    ExpectedConfigurationVersion = $ConfigurationVersion
                    ExpectedFilePath = Join-Path -Path $defaultDefinitionsPath -ChildPath $expectedFileName
                }

                if ($platformString -ine 'Windows')
                {
                    $basePolicyParameters['Platform'] = $platformString
                    $baseAssertionParameters['ExpectedPlatform'] = $platformString
                }
            }

            # Default Parameters
            Context 'Default parameters' {
                It 'Should return the expected result object' {
                    $result = New-GuestConfigurationPolicy @basePolicyParameters

                    $result | Should -Not -BeNull

                    $result.Name | Should -Be $baseAssertionParameters.ExpectedConfigurationName
                    $result.Path | Should -Be $baseAssertionParameters.ExpectedFilePath

                    $result.PolicyId | Should -Not -BeNullOrEmpty
                    $result.PolicyId.GetType().Name | Should -Be 'Guid'
                }

                It 'Should have created the expected policy definition file' {
                    Assert-GuestConfigurationPolicyDefinitionFileValid @baseAssertionParameters
                }
            }

            Context '<Mode>' -ForEach @(
                @{ Mode = 'Audit' },
                @{ Mode = 'ApplyAndMonitor' },
                @{ Mode = 'ApplyAndAutoCorrect' }
            ) {
                BeforeAll {
                    $basePolicyParameters['Mode'] = $Mode
                    $baseAssertionParameters['ExpectedMode'] = $Mode

                    if ($Mode -ieq 'Audit')
                    {
                        $expectedFileName = '{0}_AuditIfNotExists.json' -f $ConfigurationName
                    }
                    else
                    {
                        $expectedFileName = '{0}_DeployIfNotExists.json' -f $ConfigurationName
                    }

                    $baseAssertionParameters['ExpectedFilePath'] = Join-Path -Path $defaultDefinitionsPath -ChildPath $expectedFileName
                }

                # Parameter Sets
                Context '<_.Count> parameters' -ForEach $ParameterSets {
                    BeforeAll {
                        $newPolicyParameters = $basePolicyParameters + @{
                            Parameter = $_
                        }

                        $assertionParameters = $baseAssertionParameters + @{
                            ExpectedParameters = $_
                        }
                    }

                    It 'Should return the expected result object' {
                        $result = New-GuestConfigurationPolicy @newPolicyParameters

                        $result | Should -Not -BeNull

                        $result.Name | Should -Be $assertionParameters.ExpectedConfigurationName
                        $result.Path | Should -Be $assertionParameters.ExpectedFilePath

                        $result.PolicyId | Should -Not -BeNullOrEmpty
                        $result.PolicyId.GetType().Name | Should -Be 'Guid'
                    }

                    It 'Should have created the expected policy definition file' {
                        Assert-GuestConfigurationPolicyDefinitionFileValid @assertionParameters
                    }
                }

                # Optional Parameters
                Context 'Optional parameters: <OptionalParameters.Keys>' -ForEach @(
                    @{ OptionalParameters = @{ Path = './relativepath' }},
                    @{ OptionalParameters = @{ Path = './path with spaces' }},
                    @{ OptionalParameters = @{ Tag = @{ Location = 'Redmond' } }},
                    @{ OptionalParameters = @{ Tag = @{ Location = 'Redmond'; County = 'King' } }},
                    @{ OptionalParameters = @{
                        Path = './path with spaces'
                        Tag = @{ Location = 'Redmond'; County = 'King'}
                    }}
                ) {
                    BeforeAll {
                        $newPolicyParameters = $basePolicyParameters + $OptionalParameters
                        $assertionParameters = $baseAssertionParameters.Clone()

                        if ($OptionalParameters.ContainsKey('Path'))
                        {
                            $optionalPath = $OptionalParameters['Path']
                            if ($optionalPath.StartsWith('.'))
                            {
                                $optionalPath = Join-Path -Path $TestDrive -ChildPath $optionalPath
                            }

                            $filePath = Join-Path -Path $optionalPath -ChildPath $expectedFileName
                            $assertionParameters['ExpectedFilePath'] = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($filePath)
                        }

                        if ($OptionalParameters.ContainsKey('Tag'))
                        {
                            $assertionParameters['ExpectedTags'] = $OptionalParameters['Tag']
                        }
                    }

                    It 'Should return the expected result object' {
                        $result = New-GuestConfigurationPolicy @newPolicyParameters

                        $result | Should -Not -BeNull

                        $result.Name | Should -Be $assertionParameters.ExpectedConfigurationName
                        $result.Path | Should -Be $assertionParameters.ExpectedFilePath

                        $result.PolicyId | Should -Not -BeNullOrEmpty
                        $result.PolicyId.GetType().Name | Should -Be 'Guid'
                    }

                    It 'Should have created the expected policy definition file' {
                        Assert-GuestConfigurationPolicyDefinitionFileValid @assertionParameters
                    }
                }
            }
        }
    }
}
