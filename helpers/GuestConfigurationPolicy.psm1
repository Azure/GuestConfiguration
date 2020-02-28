Set-StrictMode -Version latest
$ErrorActionPreference = 'Stop'

Import-Module $PSScriptRoot/DscOperations.psm1 -Force

function Update-PolicyParameter {
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $false)]
        [Hashtable[]] $Parameter
    )
    $updatedParameterInfo = @()

    foreach ($parmInfo in $Parameter) {
        $param = @{ }
        $param['Type'] = 'string'

        if ($parmInfo.Contains('Name')) {
            $param['ReferenceName'] = $parmInfo.Name
        }
        else {
            Throw "Policy parameter is missing a mandatory property 'Name'. Please make sure that parameter name is specified in Policy parameter."
        }

        if ($parmInfo.Contains('DisplayName')) {
            $param['DisplayName'] = $parmInfo.DisplayName
        }
        else {
            Throw "Policy parameter is missing a mandatory property 'DisplayName'. Please make sure that parameter display name is specified in Policy parameter."
        }
        
        if ($parmInfo.Contains('Description')) {
            $param['Description'] = $parmInfo.Description
        }

        if (-not $parmInfo.Contains('ResourceType')) {
            Throw "Policy parameter is missing a mandatory property 'ResourceType'. Please make sure that configuration resource type is specified in Policy parameter."
        }
        elseif (-not $parmInfo.Contains('ResourceId')) {
            Throw "Policy parameter is missing a mandatory property 'ResourceId'. Please make sure that configuration resource Id is specified in Policy parameter."
        }
        else {
            $param['MofResourceReference'] = "[$($parmInfo.ResourceType)]$($parmInfo.ResourceId)"
        }

        if ($parmInfo.Contains('ResourcePropertyName')) {
            $param['MofParameterName'] = $parmInfo.ResourcePropertyName
        }
        else {
            Throw "Policy parameter is missing a mandatory property 'ResourcePropertyName'. Please make sure that configuration resource property name is specified in Policy parameter."
        }
        
        if ($parmInfo.Contains('DefaultValue')) {
            $param['DefaultValue'] = $parmInfo.DefaultValue
        }

        if ($parmInfo.Contains('AllowedValues')) {
            $param['AllowedValues'] = $parmInfo.AllowedValues
        }

        $updatedParameterInfo += $param;
    }

    return $updatedParameterInfo
}

function Test-GuestConfigurationMofResourceDependencies {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $Path
    )
    $resourcesInMofDocument = [Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache]::ImportInstances($Path, 4)

    $externalResources = @()
    for ($i = 0; $i -lt $resourcesInMofDocument.Count; $i++) {
        if ($resourcesInMofDocument[$i].CimInstanceProperties.Name -contains 'ModuleName' -and $resourcesInMofDocument[$i].ModuleName -ne 'GuestConfiguration') {
            if ($resourcesInMofDocument[$i].ModuleName -ieq 'PsDesiredStateConfiguration') {
                Throw "'PsDesiredStateConfiguration' module is not supported by GuestConfiguration. Please use 'PSDscResources' module instead of 'PsDesiredStateConfiguration' module in DSC configuration."
            }

            $configurationName = $resourcesInMofDocument[$i].ConfigurationName
            Write-Debug -Message "The configuration '$configurationName' is using one or more resources outside of the GuestConfiguration module. Please make sure these resources work with PowerShell Core"
            break
        }
    }
}

function Copy-DscResources {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $MofDocumentPath,

        [Parameter(Mandatory = $true)]
        [String]
        $Destination
    )
    $resourcesInMofDocument = [Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache]::ImportInstances($MofDocumentPath, 4)

    Write-Verbose "Copy DSC resources ..."
    $modulePath = New-Item -ItemType Directory -Force -Path (Join-Path $Destination 'Modules')
    $guestConfigModulePath = New-Item -ItemType Directory -Force -Path (Join-Path $modulePath 'GuestConfiguration')
    try {
        $latestModule = @()
        $latestModule += Get-Module GuestConfiguration
        $latestModule += Get-Module GuestConfiguration -ListAvailable
        $latestModule = ($latestModule | Sort-Object Version)[0]
    }
    catch {
        write-error 'unable to find the GuestConfiguration module either as an imported module or in $env:PSModulePath'
    }
    Copy-Item "$($latestModule.ModuleBase)/DscResources/" "$guestConfigModulePath/DscResources/" -Recurse
    Copy-Item "$($latestModule.ModuleBase)/helpers/" "$guestConfigModulePath/helpers/" -Recurse
    Copy-Item "$($latestModule.ModuleBase)/GuestConfiguration.psd1" "$guestConfigModulePath/GuestConfiguration.psd1"
    Copy-Item "$($latestModule.ModuleBase)/GuestConfiguration.psm1" "$guestConfigModulePath/GuestConfiguration.psm1"

    # Copies DSC resource modules
    $modulesToCopy = @{ }
    $resourcesInMofDocument | ForEach-Object {
        if ($_.CimInstanceProperties.Name -contains 'ModuleName' -and $_.CimInstanceProperties.Name -contains 'ModuleVersion') {
            if ($_.ModuleName -ne 'GuestConfiguration') {
                $modulesToCopy[$_.CimClass.CimClassName] = @{ModuleName = $_.ModuleName; ModuleVersion = $_.ModuleVersion }
            }
        }
    }

    # PowerShell modules required by DSC resource module
    $powershellModulesToCopy = @{ }
    $modulesToCopy.Values | ForEach-Object {
        if ($_.ModuleName -ne 'GuestConfiguration') {
            $requiredModule = Get-Module -FullyQualifiedName @{ModuleName = $_.ModuleName; RequiredVersion = $_.ModuleVersion } -ListAvailable
            $requiredModule.RequiredModules | ForEach-Object {
                if ($null -ne $_.Version) {
                    $powershellModulesToCopy[$_.Name] = @{ModuleName = $_.Name; ModuleVersion = $_.Version }
                    Write-Verbose "$($_.Name) is a required PowerShell module"
                }
                else {
                    Write-Error "Unable to add required PowerShell module $($_.Name).  No version was specified in the module manifest RequiredModules property.  Please use module specification '@{ModuleName=;ModuleVersion=}'."
                }
            }
        }
    }

    $modulesToCopy += $powershellModulesToCopy

    $modulesToCopy.Values | ForEach-Object {
        $moduleToCopy = Get-Module -FullyQualifiedName @{ModuleName = $_.ModuleName; RequiredVersion = $_.ModuleVersion } -ListAvailable
        if ($null -ne $moduleToCopy) {
            $moduleToCopyPath = New-Item -ItemType Directory -Force -Path (Join-Path $modulePath $_.ModuleName)
            Copy-Item "$($moduleToCopy.ModuleBase)/*" $moduleToCopyPath -Recurse -Force
        }
        else {
            Write-Error "Module $($_.ModuleName) version $($_.ModuleVersion) could not be found in `$env:PSModulePath"
        }
    }

    # Copy binary resources.
    $nativeResourcePath = New-Item -ItemType Directory -Force -Path (Join-Path $modulePath 'DscNativeResources')
    $resources = Get-DscResource -Module GuestConfiguration
    $resources | ForEach-Object {
        if ($_.ImplementedAs -eq 'Binary') {
            $binaryResourcePath = Join-Path (Join-Path $latestModule.ModuleBase 'DscResources') $_.ResourceType
            Get-ChildItem $binaryResourcePath/* -Include *.sh | ForEach-Object { Convert-FileToUnixLineEndings -FilePath $_ }
            Copy-Item $binaryResourcePath $nativeResourcePath -Recurse -Force
        }
    }

    # Remove DSC binaries from package (just a safeguard).
    $binaryPath = Join-Path $guestConfigModulePath 'bin'
    Remove-Item -Path $binaryPath -Force -Recurse -ErrorAction 'SilentlyContinue' | Out-Null
}

function Copy-ChefInspecDependencies {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $PackagePath,

        [Parameter(Mandatory = $true)]
        [String]
        $Configuration,

        [Parameter(Mandatory = $false)]
        [string]
        $ChefInspecProfilePath
    )

    # Copy Chef resource and profiles.
    $modulePath = Join-Path $PackagePath 'Modules'
    $nativeResourcePath = New-Item -ItemType Directory -Force -Path (Join-Path $modulePath 'DscNativeResources')
    $missingDependencies = @()
    $chefInspecProfiles = @()
    $resourcesInMofDocument = [Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache]::ImportInstances($Configuration, 4)
    $usingChefResource = $false
    $resourcesInMofDocument | ForEach-Object {
        if ($_.CimClass.CimClassName -eq 'MSFT_ChefInSpecResource') {
            $usingChefResource = $true
            if ([string]::IsNullOrEmpty($ChefInspecProfilePath)) {
                Throw "Failed to find Chef Inspec profile(s) '$($_.CimInstanceProperties['Name'].Value)'. Please use ChefInspecProfilePath parameter to specify profile path."
            }

            $inspecProfilePath = Join-Path $ChefInspecProfilePath $_.CimInstanceProperties['Name'].Value
            if (-not (Test-Path $inspecProfilePath)) {
                $missingDependencies += $_.CimInstanceProperties['Name'].Value
            }
            else {
                $chefInspecProfiles += $inspecProfilePath
            }

            $chefResourcePath = Join-Path $nativeResourcePath 'MSFT_ChefInSpecResource'
            Convert-FileToUnixLineEndings -FilePath $chefResourcePath/install_inspec.sh
            Copy-Item $chefResourcePath/install_inspec.sh  $modulePath -Force -ErrorAction SilentlyContinue
        }
    }
    if ($usingChefResource) {
        if ($missingDependencies.Length) {
            Throw "Failed to find Chef Inspec profile for '$($missingDependencies -join ',')'. Please make sure profile is present on $ChefInspecProfilePath path."
        }
        else {
            $chefInspecProfiles | ForEach-Object { Copy-Item $_ $modulePath -Recurse -Force -ErrorAction SilentlyContinue }
        }
    }
    else {
        if (-not [string]::IsNullOrEmpty($ChefInspecProfilePath)) {
            Throw "ChefInspecProfilePath parameter is supported only for Linux packages."
        }
    }
}

function Convert-FileToUnixLineEndings {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $FilePath
    )

    $fileContent = Get-Content -Path $FilePath -Raw
    $fileContentWithLinuxLineEndings = $fileContent.Replace("`r`n", "`n")
    $null = Set-Content -Path $FilePath -Value $fileContentWithLinuxLineEndings -Force
    Write-Verbose -Message "Converted the file at the path '$FilePath' to Unix line endings."
}

function Update-MofDocumentParameters {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $Path,

        [parameter(Mandatory = $false)]
        [Hashtable[]] $Parameter
    )

    if ($Parameter.Count -eq 0) {
        return
    }

    $resourcesInMofDocument = [Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache]::ImportInstances($Path, 4)

    foreach ($parmInfo in $Parameter) {
        if (-not $parmInfo.Contains('ResourceType')) {
            Throw "Policy parameter is missing a mandatory property 'ResourceType'. Please make sure that configuration resource type is specified in configuration parameter."
        }
        if (-not $parmInfo.Contains('ResourceId')) {
            Throw "Policy parameter is missing a mandatory property 'ResourceId'. Please make sure that configuration resource Id is specified in configuration parameter."
        }
        if (-not $parmInfo.Contains('ResourcePropertyName')) {
            Throw "Policy parameter is missing a mandatory property 'ResourcePropertyName'. Please make sure that configuration resource property name is specified in configuration parameter."
        }
        if (-not $parmInfo.Contains('ResourcePropertyValue')) {
            Throw "Policy parameter is missing a mandatory property 'ResourcePropertyValue'. Please make sure that configuration resource property value is specified in configuration parameter."
        }

        $resourceId = "[$($parmInfo.ResourceType)]$($parmInfo.ResourceId)"
        if (($resourcesInMofDocument | Where-Object { `
                    ($_.CimInstanceProperties.Name -contains 'ResourceID') `
                        -and ($_.CimInstanceProperties['ResourceID'].Value -eq $resourceId) `
                        -and ($_.CimInstanceProperties.Name -contains $parmInfo.ResourcePropertyName) `
                }) -eq $null) {

            Throw "Failed to find parameter reference in the configuration '$Path'. Please make sure parameter with ResourceType:'$($parmInfo.ResourceType)', ResourceId:'$($parmInfo.ResourceId)' and ResourcePropertyName:'$($parmInfo.ResourcePropertyName)' exist in the configuration."
        }

        Write-Verbose "Updating configuration parameter for $resourceId ..."
        $resourcesInMofDocument | ForEach-Object {
            if (($_.CimInstanceProperties.Name -contains 'ResourceID') -and ($_.CimInstanceProperties['ResourceID'].Value -eq $resourceId)) {
                $item = $_.CimInstanceProperties.Item($parmInfo.ResourcePropertyName)
                $item.Value = $parmInfo.ResourcePropertyValue
            }
        }
    }

    Write-Verbose "Saving configuration file '$Path' with updated parameters ..."
    $content = ""
    for ($i = 0; $i -lt $resourcesInMofDocument.Count; $i++) {
        $resourceClassName = $resourcesInMofDocument[$i].CimSystemProperties.ClassName
        $content += "instance of $resourceClassName"

        if ($resourceClassName -ne 'OMI_ConfigurationDocument') {
            $content += ' as $' + "$resourceClassName$i"
        }
        $content += "`n{`n"
        $resourcesInMofDocument[$i].CimInstanceProperties | ForEach-Object {
            $content += " $($_.Name)"
            if ($_.CimType -eq 'StringArray') {
                $content += " = {""$($_.Value -replace '[""\\]','\$&')""}; `n"
            }
            else {
                $content += " = ""$($_.Value -replace '[""\\]','\$&')""; `n"
            }
        }
        $content += "};`n" ;
    }

    $content | Out-File $Path
}

function Get-GuestConfigurationMofContent {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $Name,

        [Parameter(Mandatory = $true)]
        [String]
        $Path
    )

    Write-Verbose "Parsing Configuration document '$Path'"
    $resourcesInMofDocument = [Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache]::ImportInstances($Path, 4)

    # Set the profile path for Chef resource
    $resourcesInMofDocument | ForEach-Object {
        if ($_.CimClass.CimClassName -eq 'MSFT_ChefInSpecResource') {
            $profilePath = "$Name/Modules/$($_.Name)"
            $item = $_.CimInstanceProperties.Item('GithubPath')
            if ($item -eq $null) {
                $item = [Microsoft.Management.Infrastructure.CimProperty]::Create('GithubPath', $profilePath, [Microsoft.Management.Infrastructure.CimFlags]::Property)                      
                $_.CimInstanceProperties.Add($item) 
            }
            else {
                $item.Value = $profilePath
            }
        }
    }

    return $resourcesInMofDocument
}

function Save-GuestConfigurationMofDocument {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $Name,

        [Parameter(Mandatory = $true)]
        [String]
        $SourcePath,

        [Parameter(Mandatory = $true)]
        [String]
        $DestinationPath
    )

    $resourcesInMofDocument = Get-GuestConfigurationMofContent -Name $Name -Path $SourcePath

    # if mof contains Chef resource
    if ($resourcesInMofDocument.CimSystemProperties.ClassName -contains 'MSFT_ChefInSpecResource') {
        Write-Verbose "Serialize DSC document to $DestinationPath path ..."
        $content = ""
        for ($i = 0; $i -lt $resourcesInMofDocument.Count; $i++) {
            $resourceClassName = $resourcesInMofDocument[$i].CimSystemProperties.ClassName
            $content += "instance of $resourceClassName"

            if ($resourceClassName -ne 'OMI_ConfigurationDocument') {
                $content += ' as $' + "$resourceClassName$i"
            }
            $content += "`n{`n"
            $resourcesInMofDocument[$i].CimInstanceProperties | ForEach-Object {
                $content += " $($_.Name)"
                if ($_.CimType -eq 'StringArray') {
                    $content += " = {""$($_.Value -replace '[""\\]','\$&')""}; `n"
                }
                else {
                    $content += " = ""$($_.Value -replace '[""\\]','\$&')""; `n"
                }
            }
            $content += "};`n" ;
        }

        $content | Out-File $DestinationPath
    }
    else {
        Write-Verbose "Copy DSC document to $DestinationPath path ..."
        Copy-Item $SourcePath $DestinationPath
    }
}

function Format-Json {
    [CmdletBinding()]
    [OutputType([String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $Json
    )

    $indent = 0
    $jsonLines = $Json -Split '\n'
    $formattedLines = @()
    $previousLine = ''

    foreach ($line in $jsonLines) {
        $skipAddingLine = $false
        if ($line -match '^\s*\}\s*' -or $line -match '^\s*\]\s*') {
            # This line contains  ] or }, decrement the indentation level
            $indent--
        }

        $formattedLine = (' ' * $indent * 4) + $line.TrimStart().Replace(':  ', ': ')

        if ($line -match '\s*".*"\s*:\s*\[' -or $line -match '\s*".*"\s*:\s*\{' -or $line -match '^\s*\{\s*' -or $line -match '^\s*\[\s*') {
            # This line contains [ or {, increment the indentation level
            $indent++
        }

        if ($previousLine.Trim().EndsWith("{")) {
            if ($formattedLine.Trim() -in @("}", "},")) {
                $newLine = "$($previousLine.TrimEnd())$($formattedLine.Trim())"
                #Write-Verbose -Message "FOUND SHORTENED LINE: $newLine"
                $formattedLines[($formattedLines.Count - 1)] = $newLine
                $previousLine = $newLine
                $skipAddingLine = $true
            }
        }

        if ($previousLine.Trim().EndsWith("[")) {
            if ($formattedLine.Trim() -in @("]", "],")) {
                $newLine = "$($previousLine.TrimEnd())$($formattedLine.Trim())"
                #Write-Verbose -Message "FOUND SHORTENED LINE: $newLine"
                $formattedLines[($formattedLines.Count - 1)] = $newLine
                $previousLine = $newLine
                $skipAddingLine = $true
            }
        }

        if (-not $skipAddingLine -and -not [String]::IsNullOrWhiteSpace($formattedLine)) {
            $previousLine = $formattedLine
            $formattedLines += $formattedLine
        }
    }

    $formattedJson = $formattedLines -join "`n"
    return $formattedJson
}

function New-GuestConfigurationDeployPolicyDefinition {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $FileName,

        [Parameter(Mandatory = $true)]
        [String]
        $FolderPath,

        [Parameter(Mandatory = $true)]
        [String]
        $DisplayName,

        [Parameter(Mandatory = $true)]
        [String]
        $Description,

        [Parameter(Mandatory = $true)]
        [String]
        $ConfigurationName,

        [Parameter(Mandatory = $true)]
        [version]
        $ConfigurationVersion,

        [Parameter(Mandatory = $true)]
        [String]
        $ContentUri,

        [Parameter(Mandatory = $true)]
        [String]
        $ContentHash,

        [Parameter(Mandatory = $true)]
        [String]
        $ReferenceId,

        [Parameter(Mandatory = $false)]
        [Hashtable[]]
        $ParameterInfo,

        [Parameter(Mandatory = $false)]
        [String]
        $Guid,

        [Parameter(Mandatory = $false)]
        [ValidateSet('Windows', 'Linux')]
        [String]
        $Platform = 'Windows',

        [Parameter(Mandatory = $false)]
        [bool]
        $UseCertificateValidation = $false,

        [Parameter(Mandatory = $false)]
        [String]
        $Category = 'Guest Configuration'
    )

    if (-not [String]::IsNullOrEmpty($Guid)) {
        $deployPolicyGuid = $Guid
    }
    else {
        $deployPolicyGuid = [Guid]::NewGuid()
    }

    $filePath = Join-Path -Path $FolderPath -ChildPath $FileName

    $deployPolicyContentHashtable = [Ordered]@{
        properties = [Ordered]@{
            displayName = $DisplayName
            policyType  = 'Custom'
            mode        = 'Indexed'
            description = $Description
            metadata    = [Ordered]@{
                category          = $Category
                requiredProviders = @(
                    'Microsoft.GuestConfiguration'
                )
            }
        }
    }

    $policyRuleHashtable = [Ordered]@{
        if   = [Ordered]@{
            anyOf = @(
                [Ordered]@{
                    allOf = @(
                        [Ordered]@{
                            field  = 'type'
                            equals = "Microsoft.Compute/virtualMachines"
                        }
                    )
                },
                [Ordered]@{
                    allOf = @(,
                        [Ordered]@{
                            field = "type"
                            equals = "Microsoft.HybridCompute/machines"
                        }
                    )
                }
            )
        }
        then = [Ordered]@{
            effect  = 'deployIfNotExists'
            details = [Ordered]@{
                type              = 'Microsoft.GuestConfiguration/guestConfigurationAssignments'
                name              = $ConfigurationName
                roleDefinitionIds = @('/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c')
            }
        }
    }

    $deploymentHashtable = [Ordered]@{
        properties = [Ordered]@{
            mode       = 'incremental'
            parameters = [Ordered]@{
                vmName            = [Ordered]@{
                    value = "[field('name')]"
                }
                location          = [Ordered]@{
                    value = "[field('location')]"
                }
                type              = [Ordered]@{
                    value = "[field('type')]"
                }
                configurationName = [Ordered]@{
                    value = $ConfigurationName
                }
                contentUri        = [Ordered]@{
                    value = $ContentUri
                }
                contentHash       = [Ordered]@{
                    value = $ContentHash
                }
            }
            template   = [Ordered]@{
                '$schema'      = 'https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#'
                contentVersion = '1.0.0.0'
                parameters     = [Ordered]@{
                    vmName            = [Ordered]@{
                        type = 'string'
                    }
                    location          = [Ordered]@{
                        type = 'string'
                    }
                    type              = [Ordered]@{
                        type = 'string'
                    }
                    configurationName = [Ordered]@{
                        type = 'string'
                    }
                    contentUri        = [Ordered]@{
                        type = 'string'
                    }
                    contentHash       = [Ordered]@{
                        type = 'string'
                    }
                }
                resources      = @()
            }
        }
    }

    $guestConfigurationAssignmentHashtable = @(
        [Ordered]@{
            apiVersion = '2018-11-20'
            type       = 'Microsoft.Compute/virtualMachines/providers/guestConfigurationAssignments'
            name       = "[concat(parameters('vmName'), '/Microsoft.GuestConfiguration/', parameters('configurationName'))]"
            location   = "[parameters('location')]"
            properties = [Ordered]@{
                guestConfiguration = [Ordered]@{
                    name        = "[parameters('configurationName')]"
                    contentUri  = "[parameters('contentUri')]"
                    contentHash = "[parameters('contentHash')]"
                    version     = $ConfigurationVersion.ToString()
                }
            }
            condition  = "[equals(toLower(parameters('type')), toLower('Microsoft.Compute/virtualMachines'))]"
        },
        [Ordered]@{
            apiVersion = '2018-11-20'
            type       = 'Microsoft.HybridCompute/machines/providers/guestConfigurationAssignments'
            name       = "[concat(parameters('vmName'), '/Microsoft.GuestConfiguration/', parameters('configurationName'))]"
            location   = "[parameters('location')]"
            properties = [Ordered]@{
                guestConfiguration = [Ordered]@{
                    name        = "[parameters('configurationName')]"
                    contentUri  = "[parameters('contentUri')]"
                    contentHash = "[parameters('contentHash')]"
                    version     = $ConfigurationVersion.ToString()
                }
            }
            condition  = "[equals(toLower(parameters('type')), toLower('microsoft.hybridcompute/machines'))]"
        }
    )

    if ($Platform -ieq 'Windows')
    {
        $policyRuleHashtable['if']['anyOf'][0]['allOf'] += @(
            [Ordered]@{
                anyOf = @(
                    [Ordered]@{
                        field = "Microsoft.Compute/imagePublisher"
                        in = @(
                            'esri',
                            'incredibuild',
                            'MicrosoftDynamicsAX',
                            'MicrosoftSharepoint',
                            'MicrosoftVisualStudio',
                            'MicrosoftWindowsDesktop',
                            'MicrosoftWindowsServerHPCPack'
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imagePublisher"
                                equals = 'MicrosoftWindowsServer'
                            },
                            [Ordered]@{
                                field = "Microsoft.Compute/imageSKU"
                                notLike = '2008*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imagePublisher"
                                equals = 'MicrosoftSQLServer'
                            },
                            [Ordered]@{
                                field = "Microsoft.Compute/imageOffer"
                                notLike = 'SQL2008*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imagePublisher"
                                equals = 'microsoft-dsvm'
                            },
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imageOffer"
                                equals = 'dsvm-windows'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imagePublisher"
                                equals = 'microsoft-ads'
                            },
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imageOffer"
                                in = @(
                                    'standard-data-science-vm',
                                    'windows-data-science-vm'
                                )
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imagePublisher"
                                equals = 'batch'
                            },
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imageOffer"
                                equals = 'rendering-windows2016'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imagePublisher"
                                equals = 'center-for-internet-security-inc'
                            },
                            [Ordered]@{
                                field = "Microsoft.Compute/imageOffer"
                                like = 'cis-windows-server-201*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imagePublisher"
                                equals = 'pivotal'
                            },
                            [Ordered]@{
                                field = "Microsoft.Compute/imageOffer"
                                like = 'bosh-windows-server*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imagePublisher"
                                equals = 'cloud-infrastructure-services'
                            },
                            [Ordered]@{
                                field = "Microsoft.Compute/imageOffer"
                                like = 'ad*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                anyOf = @(
                                    [Ordered]@{ 
                                        field = "Microsoft.Compute/virtualMachines/osProfile.windowsConfiguration"
                                        exists = 'true'
                                    },
                                    [Ordered]@{
                                        field = "Microsoft.Compute/virtualMachines/storageProfile.osDisk.osType"
                                        like = 'Windows*'
                                    }
                                )
                            },
                            [Ordered]@{ 
                                anyOf = @(
                                    [Ordered]@{ 
                                        field = "Microsoft.Compute/imageSKU"
                                        exists = 'false'
                                    },
                                    [Ordered]@{
                                        allOf = @(
                                            [Ordered]@{ 
                                                field = "Microsoft.Compute/imageSKU"
                                                notLike = '2008*'
                                            },
                                            [Ordered]@{
                                                field = "Microsoft.Compute/imageOffer"
                                                notLike = 'SQL2008*'
                                            }
                                        )
                                    }
                                )
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                anyOf = @(
                                    [Ordered]@{ 
                                        field = "Microsoft.Compute/virtualMachines/osProfile.windowsConfiguration"
                                        exists = 'true'
                                    },
                                    [Ordered]@{
                                        field = "Microsoft.Compute/virtualMachines/storageProfile.osDisk.osType"
                                        like = 'Windows*'
                                    }
                                )
                            },
                            [Ordered]@{ 
                                anyOf = @(
                                    [Ordered]@{ 
                                        field = "Microsoft.Compute/imageSKU"
                                        exists = 'false'
                                    },
                                    [Ordered]@{
                                        allOf = @(
                                            [Ordered]@{ 
                                                field = "Microsoft.Compute/imageSKU"
                                                notLike = '2008*'
                                            },
                                            [Ordered]@{
                                                field = "Microsoft.Compute/imageOffer"
                                                notLike = 'SQL2008*'
                                            }
                                        )
                                    }
                                )
                            }
                        )
                    }
                )
            }
        )

        $policyRuleHashtable['if']['anyOf'][1]['allOf'] += @(
            [Ordered]@{
                field = "Microsoft.HybridCompute/imageOffer"
                like = "windows*"
            }
        )

        $guestConfigurationExtensionHashtable = [Ordered]@{
            apiVersion = '2015-05-01-preview'
            name       = "[concat(parameters('vmName'), '/AzurePolicyforWindows')]"
            type       = 'Microsoft.Compute/virtualMachines/extensions'
            location   = "[parameters('location')]"
            properties = [Ordered]@{
                publisher               = 'Microsoft.GuestConfiguration'
                type                    = 'ConfigurationforWindows'
                typeHandlerVersion      = '1.1'
                autoUpgradeMinorVersion = $true
                settings                = @{ }
                protectedSettings       = @{ }
            }
        )
    }
    elseif ($Platform -ieq 'Linux')
    {
        $policyRuleHashtable['if']['anyOf'][0]['allOf'] += @(
            [Ordered]@{
                anyOf = @(
                    [Ordered]@{
                        field = "Microsoft.Compute/imagePublisher"
                        in = @(
                            'microsoft-aks',
                            'AzureDatabricks',
                            'qubole-inc',
                            'datastax',
                            'couchbase',
                            'scalegrid',
                            'checkpoint',
                            'paloaltonetworks'
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imagePublisher"
                                equals = 'OpenLogic'
                            },
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imageOffer"
                                like = 'CentOS*'
                            },
                            [Ordered]@{
                                field = "Microsoft.Compute/imageSKU"
                                notLike = '6*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imagePublisher"
                                equals = 'RedHat'
                            },
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imageOffer"
                                equals = 'RHEL'
                            },
                            [Ordered]@{
                                field = "Microsoft.Compute/imageSKU"
                                notLike = '6*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imagePublisher"
                                equals = 'RedHat'
                            },
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imageOffer"
                                equals = 'osa'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imagePublisher"
                                equals = 'credativ'
                            },
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imageOffer"
                                equals = 'Debian'
                            },
                            [Ordered]@{
                                field = "Microsoft.Compute/imageSKU"
                                notLike = '7*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imagePublisher"
                                equals = 'Suse'
                            },
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imageOffer"
                                like = 'SLES*'
                            },
                            [Ordered]@{
                                field = "Microsoft.Compute/imageSKU"
                                notLike = '11*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imagePublisher"
                                equals = 'Canonical'
                            },
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imageOffer"
                                equals = 'UbuntuServer'
                            },
                            [Ordered]@{
                                field = "Microsoft.Compute/imageSKU"
                                notLike = '12*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imagePublisher"
                                equals = 'microsoft-dsvm'
                            },
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imageOffer"
                                in = @(
                                    'linux-data-science-vm-ubuntu',
                                    'azureml'
                                )
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imagePublisher"
                                equals = 'cloudera'
                            },
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imageOffer"
                                equals = 'cloudera-centos-os'
                            },
                            [Ordered]@{
                                field = "Microsoft.Compute/imageSKU"
                                notLike = '6*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imagePublisher"
                                equals = 'cloudera'
                            },
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imageOffer"
                                equals = 'cloudera-altus-centos-os'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imagePublisher"
                                equals = 'microsoft-ads'
                            },
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imageOffer"
                                like = 'linux*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{
                                anyOf = @(
                                    [Ordered]@{
                                        field = "Microsoft.Compute/virtualMachines/osProfile.linuxConfiguration"
                                        exists = "true"
                                    },
                                    [Ordered]@{
                                        field = "Microsoft.Compute/virtualMachines/storageProfile.osDisk.osType"
                                        like = "Linux*"
                                    }
                                )
                            },
                            [Ordered]@{
                                anyOf = @(
                                    [Ordered]@{
                                        field = "Microsoft.Compute/imageSKU"
                                        exists = "false"
                                    }
                                )
                            }
                        )
                    }
                )
            }
        )

        $policyRuleHashtable['if']['anyOf'][1]['allOf'] += @(
            [Ordered]@{
                field = "Microsoft.HybridCompute/imageOffer"
                like = "linux*"
            }
        )

        $guestConfigurationExtensionHashtable = [Ordered]@{
            apiVersion = '2015-05-01-preview'
            name       = "[concat(parameters('vmName'), '/AzurePolicyforLinux')]"
            type       = 'Microsoft.Compute/virtualMachines/extensions'
            location   = "[parameters('location')]"
            properties = [Ordered]@{
                publisher               = 'Microsoft.GuestConfiguration'
                type                    = 'ConfigurationforLinux'
                typeHandlerVersion      = '1.0'
                autoUpgradeMinorVersion = $true
            }
            dependsOn  = @(
                "[concat('Microsoft.Compute/virtualMachines/',parameters('vmName'),'/providers/Microsoft.GuestConfiguration/guestConfigurationAssignments/',parameters('configurationName'))]"
            )
            condition  = "[equals(toLower(parameters('type')), toLower('Microsoft.Compute/virtualMachines'))]"
        }
    }
    else
    {
        throw "The specified platform '$Platform' is not currently supported by this script."
    }

    $existenceConditionList = @()
    # Handle adding parameters if needed
    if ($null -ne $ParameterInfo -and $ParameterInfo.Count -gt 0) {
        $parameterValueConceatenatedStringList = @()

        if (-not $deployPolicyContentHashtable['properties'].Contains('parameters')) {
            $deployPolicyContentHashtable['properties']['parameters'] = [Ordered]@{ }
        }

        if (-not $guestConfigurationAssignmentHashtable['properties']['guestConfiguration'].Contains('configurationParameter')) {
            $guestConfigurationAssignmentHashtable['properties']['guestConfiguration']['configurationParameter'] = @()
        }

        foreach ($currentParameterInfo in $ParameterInfo) {
            $deployPolicyContentHashtable['properties']['parameters'] += [Ordered]@{
                $currentParameterInfo.ReferenceName = [Ordered]@{
                    type     = $currentParameterInfo.Type
                    metadata = [Ordered]@{
                        displayName = $currentParameterInfo.DisplayName
                    }
                }
            }

            if ($currentParameterInfo.ContainsKey('Description')) {
                $deployPolicyContentHashtable['properties']['parameters'][$currentParameterInfo.ReferenceName]['metadata']['description'] = $currentParameterInfo['Description']
            }

            if ($currentParameterInfo.ContainsKey('DefaultValue')) {
                $deployPolicyContentHashtable['properties']['parameters'][$currentParameterInfo.ReferenceName] += [Ordered]@{
                    defaultValue = $currentParameterInfo.DefaultValue
                }
            }

            if ($currentParameterInfo.ContainsKey('AllowedValues')) {
                $deployPolicyContentHashtable['properties']['parameters'][$currentParameterInfo.ReferenceName] += [Ordered]@{
                    allowedValues = $currentParameterInfo.AllowedValues
                }
            }

            if ($currentParameterInfo.ContainsKey('DeploymentValue')) {
                $deploymentHashtable['properties']['parameters'] += [Ordered]@{
                    $currentParameterInfo.ReferenceName = [Ordered]@{
                        value = $currentParameterInfo.DeploymentValue
                    }
                }
            }
            else {
                $deploymentHashtable['properties']['parameters'] += [Ordered]@{
                    $currentParameterInfo.ReferenceName = [Ordered]@{
                        value = "[parameters('$($currentParameterInfo.ReferenceName)')]"
                    }
                }
            }

            $deploymentHashtable['properties']['template']['parameters'] += [Ordered]@{
                $currentParameterInfo.ReferenceName = [Ordered]@{
                    type = $currentParameterInfo.Type
                }
            }

            $configurationParameterName = "$($currentParameterInfo.MofResourceReference);$($currentParameterInfo.MofParameterName)"

            if ($currentParameterInfo.ContainsKey('ConfigurationValue')) {
                $configurationParameterValue = $currentParameterInfo.ConfigurationValue

                if ($currentParameterInfo.ConfigurationValue.StartsWith('[') -and $currentParameterInfo.ConfigurationValue.EndsWith(']')) {
                    $configurationParameterStringValue = $currentParameterInfo.ConfigurationValue.Substring(1, $currentParameterInfo.ConfigurationValue.Length - 2)
                }
                else {
                    $configurationParameterStringValue = "'$($currentParameterInfo.ConfigurationValue)'"
                }
            }
            else {
                $configurationParameterValue = "[parameters('$($currentParameterInfo.ReferenceName)')]"
                $configurationParameterStringValue = "parameters('$($currentParameterInfo.ReferenceName)')"
            }

            $guestConfigurationAssignmentHashtable['properties']['guestConfiguration']['configurationParameter'] += [Ordered]@{
                name  = $configurationParameterName
                value = $configurationParameterValue
            }

            $currentParameterValueConcatenatedString = "'$configurationParameterName', '=', $configurationParameterStringValue"
            $parameterValueConceatenatedStringList += $currentParameterValueConcatenatedString
        }

        $allParameterValueConcantenatedString = $parameterValueConceatenatedStringList -join ", ',', "
        $parameterExistenceConditionEqualsValue = "[base64(concat($allParameterValueConcantenatedString))]"

        $existenceConditionList += [Ordered]@{
            field  = 'Microsoft.GuestConfiguration/guestConfigurationAssignments/parameterHash'
            equals = $parameterExistenceConditionEqualsValue
        }
    }

    $existenceConditionList += [Ordered]@{
        field  = 'Microsoft.GuestConfiguration/guestConfigurationAssignments/contentHash'
        equals = "$ContentHash"
    }

    $policyRuleHashtable['then']['details']['existenceCondition'] = [Ordered]@{
        allOf = $existenceConditionList
    }
    $policyRuleHashtable['then']['details']['deployment'] = $deploymentHashtable

    $policyRuleHashtable['then']['details']['deployment']['properties']['template']['resources'] += $guestConfigurationAssignmentHashtable
    
    $systemAssignedHashtable = [Ordered]@{
        apiVersion = '2017-03-30'
        type       = 'Microsoft.Compute/virtualMachines'
        identity   = [Ordered]@{
            type = 'SystemAssigned'
        }
        name       = "[parameters('vmName')]"
        location   = "[parameters('location')]"
        condition  = "[equals(toLower(parameters('type')), toLower('Microsoft.Compute/virtualMachines'))]"
    }    
    
    $policyRuleHashtable['then']['details']['deployment']['properties']['template']['resources'] += $systemAssignedHashtable
    
    $policyRuleHashtable['then']['details']['deployment']['properties']['template']['resources'] += $guestConfigurationExtensionHashtable

    $deployPolicyContentHashtable['properties']['policyRule'] = $policyRuleHashtable

    $deployPolicyContentHashtable += [Ordered]@{
        id   = "/providers/Microsoft.Authorization/policyDefinitions/$deployPolicyGuid"
        name = $deployPolicyGuid
    }

    $deployPolicyContent = ConvertTo-Json -InputObject $deployPolicyContentHashtable -Depth 100 | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) }
    $formattedDeployPolicyContent = Format-Json -Json $deployPolicyContent

    if (Test-Path -Path $filePath) {
        Write-Error -Message "A file at the policy destination path '$filePath' already exists. Please remove this file or specify a different destination path."
    }
    else {
        $null = New-Item -Path $filePath -ItemType 'File' -Value $formattedDeployPolicyContent
    }

    return $deployPolicyGuid
}

<#
    .SYNOPSIS
        Creates a new audit policy definition for a guest configuration policy definition set.
#>
function New-GuestConfigurationAuditPolicyDefinition {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $FileName,

        [Parameter(Mandatory = $true)]
        [String]
        $FolderPath,

        [Parameter(Mandatory = $true)]
        [String]
        $DisplayName,

        [Parameter(Mandatory = $true)]
        [String]
        $Description,

        [Parameter(Mandatory = $true)]
        [String]
        $ConfigurationName,

        [Parameter(Mandatory = $true)]
        [String]
        $ReferenceId,

        [Parameter(Mandatory = $false)]
        [String]
        $Guid,

        [Parameter(Mandatory = $false)]
        [ValidateSet('Windows', 'Linux')]
        [String]
        $Platform = 'Windows',

        [Parameter(Mandatory = $false)]
        [String]
        $Category = 'Guest Configuration'
    )

    if (-not [String]::IsNullOrEmpty($Guid)) {
        $auditPolicyGuid = $Guid
    }
    else {
        $auditPolicyGuid = [Guid]::NewGuid()
    }

    $filePath = Join-Path -Path $FolderPath -ChildPath $FileName

    $auditPolicyContentHashtable = [Ordered]@{
        properties = [Ordered]@{
            displayName = $DisplayName
            policyType  = 'Custom'
            mode        = 'All'
            description = $Description
            metadata    = [Ordered]@{
                category = $Category
            }
            
        }
        id         = "/providers/Microsoft.Authorization/policyDefinitions/$auditPolicyGuid"
        name       = $auditPolicyGuid
    }

    $policyRuleHashtable = [Ordered]@{
        if   = [Ordered]@{
            anyOf = @(
                [Ordered]@{
                    allOf = @(
                        [Ordered]@{
                            field  = 'type'
                            equals = "Microsoft.Compute/virtualMachines"
                        }
                    )
                },
                [Ordered]@{
                    allOf = @(,
                        [Ordered]@{
                            field = "type"
                            equals = "Microsoft.HybridCompute/machines"
                        }
                    )
                }
            )
        }
        then = [Ordered]@{
            effect  = 'auditIfNotExists'
            details = [Ordered]@{
                type = 'Microsoft.GuestConfiguration/guestConfigurationAssignments'
                name = $ConfigurationName
            }
        }

    }

    if ($Platform -ieq 'Windows')
    {
        $policyRuleHashtable['if']['anyOf'][0]['allOf'] += @(
            [Ordered]@{
                anyOf = @(
                    [Ordered]@{
                        field = "Microsoft.Compute/imagePublisher"
                        in = @(
                            'esri',
                            'incredibuild',
                            'MicrosoftDynamicsAX',
                            'MicrosoftSharepoint',
                            'MicrosoftVisualStudio',
                            'MicrosoftWindowsDesktop',
                            'MicrosoftWindowsServerHPCPack'
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imagePublisher"
                                equals = 'MicrosoftWindowsServer'
                            },
                            [Ordered]@{
                                field = "Microsoft.Compute/imageSKU"
                                notLike = '2008*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imagePublisher"
                                equals = 'MicrosoftSQLServer'
                            },
                            [Ordered]@{
                                field = "Microsoft.Compute/imageOffer"
                                notLike = 'SQL2008*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imagePublisher"
                                equals = 'microsoft-dsvm'
                            },
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imageOffer"
                                equals = 'dsvm-windows'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imagePublisher"
                                equals = 'microsoft-ads'
                            },
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imageOffer"
                                in = @(
                                    'standard-data-science-vm',
                                    'windows-data-science-vm'
                                )
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imagePublisher"
                                equals = 'batch'
                            },
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imageOffer"
                                equals = 'rendering-windows2016'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imagePublisher"
                                equals = 'center-for-internet-security-inc'
                            },
                            [Ordered]@{
                                field = "Microsoft.Compute/imageOffer"
                                like = 'cis-windows-server-201*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imagePublisher"
                                equals = 'pivotal'
                            },
                            [Ordered]@{
                                field = "Microsoft.Compute/imageOffer"
                                like = 'bosh-windows-server*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imagePublisher"
                                equals = 'cloud-infrastructure-services'
                            },
                            [Ordered]@{
                                field = "Microsoft.Compute/imageOffer"
                                like = 'ad*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                anyOf = @(
                                    [Ordered]@{ 
                                        field = "Microsoft.Compute/virtualMachines/osProfile.windowsConfiguration"
                                        exists = 'true'
                                    },
                                    [Ordered]@{
                                        field = "Microsoft.Compute/virtualMachines/storageProfile.osDisk.osType"
                                        like = 'Windows*'
                                    }
                                )
                            },
                            [Ordered]@{ 
                                anyOf = @(
                                    [Ordered]@{ 
                                        field = "Microsoft.Compute/imageSKU"
                                        exists = 'false'
                                    },
                                    [Ordered]@{
                                        allOf = @(
                                            [Ordered]@{ 
                                                field = "Microsoft.Compute/imageSKU"
                                                notLike = '2008*'
                                            },
                                            [Ordered]@{
                                                field = "Microsoft.Compute/imageOffer"
                                                notLike = 'SQL2008*'
                                            }
                                        )
                                    }
                                )
                            }
                        )
                    }
                )
            }
        )

        $policyRuleHashtable['if']['anyOf'][1]['allOf'] += @(
            [Ordered]@{
                field = "Microsoft.HybridCompute/imageOffer"
                like = "windows*"
            }
        )

        $guestConfigurationExtensionHashtable = [Ordered]@{
            apiVersion = '2015-05-01-preview'
            name       = "[concat(parameters('vmName'), '/AzurePolicyforWindows')]"
            type       = 'Microsoft.Compute/virtualMachines/extensions'
            location   = "[parameters('location')]"
            properties = [Ordered]@{
                publisher               = 'Microsoft.GuestConfiguration'
                type                    = 'ConfigurationforWindows'
                typeHandlerVersion      = '1.1'
                autoUpgradeMinorVersion = $true
                settings                = @{ }
                protectedSettings       = @{ }
            }
            dependsOn  = @(
                "[concat('Microsoft.Compute/virtualMachines/',parameters('vmName'),'/providers/Microsoft.GuestConfiguration/guestConfigurationAssignments/',parameters('configurationName'))]"
            )
        }
    }
    elseif ($Platform -ieq 'Linux')
    {
        $policyRuleHashtable['if']['anyOf'][0]['allOf'] += @(
            [Ordered]@{
                anyOf = @(
                    [Ordered]@{
                        field = "Microsoft.Compute/imagePublisher"
                        in = @(
                            'microsoft-aks',
                            'AzureDatabricks',
                            'qubole-inc',
                            'datastax',
                            'couchbase',
                            'scalegrid',
                            'checkpoint',
                            'paloaltonetworks'
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imagePublisher"
                                equals = 'OpenLogic'
                            },
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imageOffer"
                                like = 'CentOS*'
                            },
                            [Ordered]@{
                                field = "Microsoft.Compute/imageSKU"
                                notLike = '6*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imagePublisher"
                                equals = 'RedHat'
                            },
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imageOffer"
                                equals = 'RHEL'
                            },
                            [Ordered]@{
                                field = "Microsoft.Compute/imageSKU"
                                notLike = '6*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imagePublisher"
                                equals = 'RedHat'
                            },
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imageOffer"
                                equals = 'osa'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imagePublisher"
                                equals = 'credativ'
                            },
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imageOffer"
                                equals = 'Debian'
                            },
                            [Ordered]@{
                                field = "Microsoft.Compute/imageSKU"
                                notLike = '7*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imagePublisher"
                                equals = 'Suse'
                            },
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imageOffer"
                                like = 'SLES*'
                            },
                            [Ordered]@{
                                field = "Microsoft.Compute/imageSKU"
                                notLike = '11*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imagePublisher"
                                equals = 'Canonical'
                            },
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imageOffer"
                                equals = 'UbuntuServer'
                            },
                            [Ordered]@{
                                field = "Microsoft.Compute/imageSKU"
                                notLike = '12*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imagePublisher"
                                equals = 'microsoft-dsvm'
                            },
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imageOffer"
                                in = @(
                                    'linux-data-science-vm-ubuntu',
                                    'azureml'
                                )
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imagePublisher"
                                equals = 'cloudera'
                            },
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imageOffer"
                                equals = 'cloudera-centos-os'
                            },
                            [Ordered]@{
                                field = "Microsoft.Compute/imageSKU"
                                notLike = '6*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imagePublisher"
                                equals = 'cloudera'
                            },
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imageOffer"
                                equals = 'cloudera-altus-centos-os'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imagePublisher"
                                equals = 'microsoft-ads'
                            },
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imageOffer"
                                like = 'linux*'
                            }
                        )
                    }
                )
            }
        )

        $policyRuleHashtable['if']['anyOf'][1]['allOf'] += @(
            [Ordered]@{
                field = "Microsoft.HybridCompute/imageOffer"
                like = "linux*"
            }
        )

        $guestConfigurationExtensionHashtable = [Ordered]@{
            apiVersion = '2015-05-01-preview'
            name       = "[concat(parameters('vmName'), '/AzurePolicyforLinux')]"
            type       = 'Microsoft.Compute/virtualMachines/extensions'
            location   = "[parameters('location')]"
            properties = [Ordered]@{
                publisher               = 'Microsoft.GuestConfiguration'
                type                    = 'ConfigurationforLinux'
                typeHandlerVersion      = '1.0'
                autoUpgradeMinorVersion = $true
            }
            dependsOn  = @(
                "[concat('Microsoft.Compute/virtualMachines/',parameters('vmName'),'/providers/Microsoft.GuestConfiguration/guestConfigurationAssignments/',parameters('configurationName'))]"
            )
        }
    }
    else
    {
        throw "The specified platform '$Platform' is not currently supported by this script."
    }

    $existenceConditionList = [Ordered]@{
        field  = 'Microsoft.GuestConfiguration/guestConfigurationAssignments/complianceStatus'
        equals = 'Compliant'
    }

    $policyRuleHashtable['then']['details']['existenceCondition'] = $existenceConditionList

    $auditPolicyContentHashtable['properties']['policyRule'] = $policyRuleHashtable

    $auditPolicyContent = ConvertTo-Json -InputObject $auditPolicyContentHashtable -Depth 100 | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) }
    $formattedAuditPolicyContent = Format-Json -Json $auditPolicyContent

    if (Test-Path -Path $filePath) {
        Write-Error -Message "A file at the policy destination path '$filePath' already exists. Please remove this file or specify a different destination path."
    }
    else {
        $null = New-Item -Path $filePath -ItemType 'File' -Value $formattedAuditPolicyContent
    }

    return $auditPolicyGuid
}

<#
    .SYNOPSIS
        Creates a new policy initiative definition for a guest configuration policy definition set.
#>
function New-GuestConfigurationPolicyInitiativeDefinition {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $FileName,

        [Parameter(Mandatory = $true)]
        [String]
        $FolderPath,

        [Parameter(Mandatory = $true)]
        [Hashtable[]]
        $DeployPolicyInfo,

        [Parameter(Mandatory = $true)]
        [Hashtable[]]
        $AuditPolicyInfo,

        [Parameter(Mandatory = $true)]
        [String]
        $DisplayName,

        [Parameter(Mandatory = $true)]
        [String]
        $Description,

        [Parameter(Mandatory = $false)]
        [String]
        $Guid,

        [Parameter(Mandatory = $false)]
        [string]
        $Category = 'Guest Configuration'
    )

    if (-not [String]::IsNullOrEmpty($Guid)) {
        $initiativeGuid = $Guid
    }
    else {
        $initiativeGuid = [Guid]::NewGuid()
    }

    $filePath = Join-Path -Path $FolderPath -ChildPath $FileName
    $policyDefinitions = @()

    $initiativeContentHashtable = [Ordered]@{
        properties = [Ordered]@{
            displayName = $DisplayName
            policyType  = 'Custom'
            description = $Description
            metadata    = [Ordered]@{
                category = $Category
            }
        }
    }

    foreach ($currentDeployPolicyInfo in $DeployPolicyInfo) {
        $deployPolicyContentHash = [Ordered]@{
            policyDefinitionId          = "/providers/Microsoft.Authorization/policyDefinitions/$($currentDeployPolicyInfo.Guid)"
            policyDefinitionReferenceId = $currentDeployPolicyInfo.ReferenceId
        }

        if ($currentDeployPolicyInfo.ContainsKey('ParameterInfo')) {
            if (-not $initiativeContentHashtable['properties'].Contains('parameters')) {
                $initiativeContentHashtable['properties']['parameters'] = [Ordered]@{ }
            }

            if (-not $deployPolicyContentHash.Contains('parameters')) {
                $deployPolicyContentHash['parameters'] = [Ordered]@{ }
            }

            foreach ($currentParameterInfo in $currentDeployPolicyInfo.ParameterInfo) {
                $initiativeContentHashtable['properties']['parameters'] += [Ordered]@{
                    $currentParameterInfo.ReferenceName = [Ordered]@{
                        type     = $currentParameterInfo.Type
                        metadata = [Ordered]@{
                            displayName = $currentParameterInfo.DisplayName
                        }
                    }
                }

                if ($currentParameterInfo.ContainsKey('Description')) {
                    $initiativeContentHashtable['properties']['parameters'][$currentParameterInfo.ReferenceName]['metadata']['description'] = $currentParameterInfo['Description']
                }

                if ($currentParameterInfo.ContainsKey('DefaultValue')) {
                    $initiativeContentHashtable['properties']['parameters'][$currentParameterInfo.ReferenceName] += [Ordered]@{
                        defaultValue = $currentParameterInfo.DefaultValue
                    }
                }

                if ($currentParameterInfo.ContainsKey('AllowedValues')) {
                    $initiativeContentHashtable['properties']['parameters'][$currentParameterInfo.ReferenceName] += [Ordered]@{
                        allowedValues = $currentParameterInfo.AllowedValues
                    }
                }

                $deployPolicyContentHash['parameters'] += [Ordered]@{
                    $currentParameterInfo.ReferenceName = [Ordered]@{
                        value = "[parameters('$($currentParameterInfo.ReferenceName)')]"
                    }
                }
            }
        }

        $policyDefinitions += $deployPolicyContentHash
    }

    foreach ($currentAuditPolicyInfo in $AuditPolicyInfo) {
        $auditPolicyContentHash = [Ordered]@{
            policyDefinitionId          = "/providers/Microsoft.Authorization/policyDefinitions/$($currentAuditPolicyInfo.Guid)"
            policyDefinitionReferenceId = $currentAuditPolicyInfo.ReferenceId
        }

        $policyDefinitions += $auditPolicyContentHash
    }

    $initiativeContentHashtable['properties']['policyDefinitions'] = $policyDefinitions
    $initiativeContentHashtable += [Ordered]@{
        id   = "/providers/Microsoft.Authorization/policySetDefinitions/$initiativeGuid"
        name = $initiativeGuid
    }

    $initiativeContent = ConvertTo-Json -InputObject $initiativeContentHashtable -Depth 100 | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) }
    $formattedInitiativeContent = Format-Json -Json $initiativeContent

    if (Test-Path -Path $filePath) {
        Write-Error -Message "A file at the initiative destination path '$filePath' already exists. Please remove this file or specify a different destination path."
    }
    else {
        $null = New-Item -Path $filePath -ItemType 'File' -Value $formattedInitiativeContent
    }

    return $initiativeGuid
}

<#
    .SYNOPSIS
        Creates a new policy set for guest configuration. This set should include at least one
        audit policy definition, at least one deploy policy definition, and only one policy
        initiative definition.
#>
function New-GuestConfigurationPolicyDefinitionSet {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $PolicyFolderPath,

        [Parameter(Mandatory = $true)]
        [Hashtable[]]
        $DeployPolicyInfo,

        [Parameter(Mandatory = $true)]
        [Hashtable[]]
        $AuditPolicyInfo,

        [Parameter(Mandatory = $true)]
        [Hashtable]
        $InitiativeInfo,

        [Parameter(Mandatory = $false)]
        [ValidateSet('Windows', 'Linux')]
        [String]
        $Platform = 'Windows'
    )

    if (Test-Path -Path $PolicyFolderPath) {
        $null = Remove-Item -Path $PolicyFolderPath -Force -Recurse -ErrorAction 'SilentlyContinue'
    }

    $null = New-Item -Path $PolicyFolderPath -ItemType 'Directory'

    foreach ($currentDeployPolicyInfo in $DeployPolicyInfo) {
        $currentDeployPolicyInfo['FolderPath'] = $PolicyFolderPath
        $deployPolicyGuid = New-GuestConfigurationDeployPolicyDefinition @currentDeployPolicyInfo -Platform $Platform
        $currentDeployPolicyInfo['Guid'] = $deployPolicyGuid
    }

    foreach ($currentAuditPolicyInfo in $AuditPolicyInfo) {
        $currentAuditPolicyInfo['FolderPath'] = $PolicyFolderPath
        $auditPolicyGuid = New-GuestConfigurationAuditPolicyDefinition @currentAuditPolicyInfo -Platform $Platform
        $currentAuditPolicyInfo['Guid'] = $auditPolicyGuid
    }

    $InitiativeInfo['FolderPath'] = $PolicyFolderPath
    $InitiativeInfo['DeployPolicyInfo'] = $DeployPolicyInfo
    $InitiativeInfo['AuditPolicyInfo'] = $AuditPolicyInfo

    $initiativeGuid = New-GuestConfigurationPolicyInitiativeDefinition @InitiativeInfo
    return $initiativeGuid
}

function New-CustomGuestConfigPolicy {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $PolicyFolderPath,

        [Parameter(Mandatory = $true)]
        [Hashtable]
        $DeployPolicyInfo,

        [Parameter(Mandatory = $true)]
        [Hashtable]
        $AuditPolicyInfo,

        [Parameter(Mandatory = $true)]
        [Hashtable]
        $InitiativeInfo,

        [Parameter(Mandatory = $false)]
        [ValidateSet('Windows', 'Linux')]
        [String]
        $Platform = 'Windows'
    )

    $existingPolicies = Get-AzPolicyDefinition
    $existingDeployPolicy = $existingPolicies | Where-Object { ($_.Properties.PSObject.Properties.Name -contains 'displayName') -and ($_.Properties.displayName -eq $DeployPolicyInfo.DisplayName) }
    if ($null -ne $existingDeployPolicy) {
        Write-Verbose -Message "Found policy with name '$($existingDeployPolicy.Properties.displayName)' and guid '$($existingDeployPolicy.Name)'..."
        $DeployPolicyInfo['Guid'] = $existingDeployPolicy.Name.ToString()
    }

    $existingAuditPolicy = $existingPolicies | Where-Object { ($_.Properties.PSObject.Properties.Name -contains 'displayName') -and ($_.Properties.displayName -eq $AuditPolicyInfo.DisplayName) }
    if ($null -ne $existingAuditPolicy) {
        Write-Verbose -Message "Found policy with name '$($existingAuditPolicy.Properties.displayName)' and guid '$($existingAuditPolicy.Name)'..."
        $AuditPolicyInfo['Guid'] = $existingAuditPolicy.Name.ToString()
    }

    $existingInitiative = Get-AzPolicySetDefinition | Where-Object { ($_.Properties.PSObject.Properties.Name -contains 'displayName') -and ($_.Properties.displayName -eq $InitiativeInfo.DisplayName) }
    if ($null -ne $existingInitiative) {
        Write-Verbose -Message "Found initiative with name '$($existingInitiative.Properties.displayName)' and guid '$($existingInitiative.Name)'..."
        $InitiativeInfo['Guid'] = $existingInitiative.Name.ToString()
    }

    New-GuestConfigurationPolicyDefinitionSet @PSBoundParameters
}