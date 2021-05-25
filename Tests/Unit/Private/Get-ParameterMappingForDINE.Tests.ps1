BeforeDiscovery {
    $projectPath = "$PSScriptRoot/../../.." | Convert-Path
    $projectName = Get-SamplerProjectName -BuildRoot $projectPath

    Get-Module $projectName | Remove-Module -Force -ErrorAction SilentlyContinue
    $importedModule = Import-Module $projectName -Force -PassThru -ErrorAction 'Stop'
}

Describe ' Get-ParameterMappingForDINE.ps1' -ForEach @{
    ProjectPath    = $projectPath
    projectName    = $projectName
    importedModule = $importedModule
} {
    BeforeAll {
        # test Assets path
        $testAssetsPath = Join-Path -Path $PSScriptRoot -ChildPath '../assets'
        # Test Config Package MOF
        $packagePath = Join-Path -Path $testAssetsPath -ChildPath 'TestPackages/testPolicy.zip'
    }

    It 'Validate output contents' -Skip:($IsLinux -or $IsMacOS) {
        $ParameterInfo = @(
            @{
                Name = 'ensure'
                DisplayName = 'ensure_display_name'
                Description = "ensure_description"
                ResourceType = 'MyFile'
                ResourceId = 'createFoobarTestFile'
                ResourcePropertyName = 'ensure'
                DefaultValue = 'Present'
                AllowedValues = @('Present','Absent')
            },
            @{
                Name = 'path'
                DisplayName = 'path_display_name'
                Description = "path_description"
                ResourceType = 'MyFile'
                ResourceId = 'createFoobarTestFile'
                ResourcePropertyName = 'path'
            },
            @{
                Name = 'content'
                DisplayName = 'content_display_name'
                Description = "content_description"
                ResourceType = 'MyFile'
                ResourceId = 'createFoobarTestFile'
                ResourcePropertyName = 'content'
                DefaultValue = 'Example content'
            })

        $correctOutput = @(
            @{
                'name'= "[MyFile]createFoobarTestFile;path"
                'value'= "[parameters('path')]"
            },
            @{
                'name'= "[MyFile]createFoobarTestFile;ensure"
                'value'= "[parameters('ensure')]"
            },
            @{
                'name'= "[MyFile]createFoobarTestFile;content"
                'value'= "[parameters('content')]"
            }
        )
        Get-ParameterMappingForDINE $ParameterInfo | Should -be $correctOutput
    }
}
