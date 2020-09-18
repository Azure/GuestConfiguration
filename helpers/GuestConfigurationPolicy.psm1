Set-StrictMode -Version latest
$ErrorActionPreference = 'Stop'

Import-Module $PSScriptRoot/DscOperations.psm1 -Force

function Update-PolicyParameter {
    [CmdletBinding()]
    param
    (
        [parameter()]
        [Hashtable[]]
        $parameter
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
                Throw "'PsDesiredStateConfiguration' module is not supported by GuestConfiguration. Please use 'PSDSCResources' module instead of 'PsDesiredStateConfiguration' module in DSC configuration."
            }

            $configurationName = $resourcesInMofDocument[$i].ConfigurationName
            Write-Warning -Message "The configuration '$configurationName' is using one or more resources outside of the GuestConfiguration module. Please make sure these resources work with PowerShell Core"
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

    Write-Verbose 'Copy DSC resources ...'
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
            if (($requiredModule | Get-Member -MemberType 'Property' | ForEach-Object { $_.Name }) -contains 'RequiredModules') {
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
    }

    $modulesToCopy += $powershellModulesToCopy

    $modulesToCopy.Values | ForEach-Object {
        $moduleToCopy = Get-Module -FullyQualifiedName @{ModuleName = $_.ModuleName; RequiredVersion = $_.ModuleVersion } -ListAvailable
        if ($null -ne $moduleToCopy) {
            if ($_.ModuleName -eq 'PSDesiredStateConfiguration') {
                Write-Error 'The configuration includes DSC resources from the Windows PowerShell 5.1 module "PSDesiredStateConfiguration" that are not available in PowerShell Core. Switch to the "PSDSCResources" module available from the PowerShell Gallery. Note that the File and Package resources are not yet available in "PSDSCResources".'
            }
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

        [string]
        $ChefInspecProfilePath
    )

    # Copy Chef resource and profiles.
    $modulePath = Join-Path $PackagePath 'Modules'
    $nativeResourcePath = New-Item -ItemType Directory -Force -Path (Join-Path $modulePath 'DscNativeResources')
    $resourcesInMofDocument = Get-GuestConfigurationMofContent -Name $Name -Path $SourcePath
    $missingDependencies = @()
    $chefInspecProfiles = @()
    $usingChefResource = $false

    # if mof contains Chef resource
    if ($resourcesInMofDocument.CimSystemProperties.ClassName -contains 'MSFT_ChefInSpecResource') {
        Write-Host "MOF: $($resourcesInMofDocument.CimSystemProperties.ClassName)"
        $usingChefResource = $true
    }
    $resourcesInMofDocument | ForEach-Object {
        Write-Host "Resource: $($_.CimClass.CimClassName)"
        if ($_.CimClass.CimClassName -eq 'MSFT_ChefInSpecResource') {
            $usingChefResource = $true
            Write-Host "usingCR1: $usingChefResource"
            if ([string]::IsNullOrEmpty($ChefInspecProfilePath)) {
                Throw "'$($_.CimInstanceProperties['Name'].Value)'. Please use ChefInspecProfilePath parameter to specify profile path."
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
    Write-Host "usingCR2: $usingChefResource"
    if ($true -eq $usingChefResource) {
        if ($missingDependencies.Length) {
            Throw "Failed to find Chef Inspec profile for '$($missingDependencies -join ',')'. Please make sure profile is present on $ChefInspecProfilePath path."
        }
        else {
            $chefInspecProfiles | ForEach-Object { Copy-Item $_ $modulePath -Recurse -Force -ErrorAction SilentlyContinue }
        }
    }
    else {
        if (-not [string]::IsNullOrEmpty($ChefInspecProfilePath)) {
            Throw 'Using the ChefInspecProfilePath parameter requires including the ChefInSpecResource DSC resource in the configuration MOF.'
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

        [parameter()]
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
        if ($null -eq ($resourcesInMofDocument | Where-Object { `
                    ($_.CimInstanceProperties.Name -contains 'ResourceID') `
                        -and ($_.CimInstanceProperties['ResourceID'].Value -eq $resourceId) `
                        -and ($_.CimInstanceProperties.Name -contains $parmInfo.ResourcePropertyName) `
                })) {

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
            $item.Value = "$Name/Modules/$($_.Name)"
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
        $content = ''
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

        [Parameter()]
        [Hashtable[]]
        $ParameterInfo,

        [Parameter()]
        [String]
        $Guid,

        [Parameter()]
        [ValidateSet('Windows', 'Linux')]
        [String]
        $Platform = 'Windows',

        [Parameter()]
        [bool]
        $UseCertificateValidation = $false,

        [Parameter()]
        [String]
        $Category = 'Guest Configuration',

        [Parameter()]
        [Hashtable[]]
        $Tag
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
                            field  = "type"
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

    if ($Platform -ieq 'Windows') {
        $policyRuleHashtable['if']['anyOf'][0]['allOf'] += @(
            [Ordered]@{
                anyOf = @(
                    [Ordered]@{
                        field = "Microsoft.Compute/imagePublisher"
                        in    = @(
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
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'MicrosoftWindowsServer'
                            },
                            [Ordered]@{
                                field   = 'Microsoft.Compute/imageSKU'
                                notLike = '2008*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'MicrosoftSQLServer'
                            },
                            [Ordered]@{
                                field   = 'Microsoft.Compute/imageOffer'
                                notLike = 'SQL2008*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'microsoft-dsvm'
                            },
                            [Ordered]@{ 
                                field  = 'Microsoft.Compute/imageOffer'
                                equals = 'dsvm-windows'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'microsoft-ads'
                            },
                            [Ordered]@{ 
                                field = 'Microsoft.Compute/imageOffer'
                                in    = @(
                                    'standard-data-science-vm',
                                    'windows-data-science-vm'
                                )
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'batch'
                            },
                            [Ordered]@{ 
                                field  = 'Microsoft.Compute/imageOffer'
                                equals = 'rendering-windows2016'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'center-for-internet-security-inc'
                            },
                            [Ordered]@{
                                field = 'Microsoft.Compute/imageOffer'
                                like  = 'cis-windows-server-201*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'pivotal'
                            },
                            [Ordered]@{
                                field = 'Microsoft.Compute/imageOffer'
                                like  = 'bosh-windows-server*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'cloud-infrastructure-services'
                            },
                            [Ordered]@{
                                field = 'Microsoft.Compute/imageOffer'
                                like  = 'ad*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                anyOf = @(
                                    [Ordered]@{ 
                                        field  = 'Microsoft.Compute/virtualMachines/osProfile.windowsConfiguration'
                                        exists = 'true'
                                    },
                                    [Ordered]@{
                                        field = 'Microsoft.Compute/virtualMachines/storageProfile.osDisk.osType'
                                        like  = 'Windows*'
                                    }
                                )
                            },
                            [Ordered]@{ 
                                anyOf = @(
                                    [Ordered]@{ 
                                        field  = 'Microsoft.Compute/imageSKU'
                                        exists = 'false'
                                    },
                                    [Ordered]@{
                                        allOf = @(
                                            [Ordered]@{ 
                                                field   = 'Microsoft.Compute/imageSKU'
                                                notLike = '2008*'
                                            },
                                            [Ordered]@{
                                                field   = 'Microsoft.Compute/imageOffer'
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
                field = 'Microsoft.HybridCompute/imageOffer'
                like  = 'windows*'
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
            condition  = "[equals(toLower(parameters('type')), toLower('Microsoft.Compute/virtualMachines'))]"
        }
    }
    elseif ($Platform -ieq 'Linux') {
        $policyRuleHashtable['if']['anyOf'][0]['allOf'] += @(
            [Ordered]@{
                anyOf = @(
                    [Ordered]@{
                        field = 'Microsoft.Compute/imagePublisher'
                        in    = @(
                            'microsoft-aks',
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
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'OpenLogic'
                            },
                            [Ordered]@{ 
                                field = 'Microsoft.Compute/imageOffer'
                                like  = 'CentOS*'
                            },
                            [Ordered]@{
                                field   = 'Microsoft.Compute/imageSKU'
                                notLike = '6*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'Oracle'
                            },
                            [Ordered]@{ 
                                field  = 'Microsoft.Compute/imageOffer'
                                equals = 'Oracle-Linux'
                            },
                            [Ordered]@{
                                field   = 'Microsoft.Compute/imageSKU'
                                notLike = '6*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'RedHat'
                            },
                            [Ordered]@{ 
                                field = 'Microsoft.Compute/imageOffer'
                                in    = @(
                                    'RHEL',
                                    'RHEL-HA'
                                    'RHEL-SAP',
                                    'RHEL-SAP-APPS',
                                    'RHEL-SAP-HA',
                                    'RHEL-SAP-HANA'
                                )
                            },
                            [Ordered]@{
                                field   = 'Microsoft.Compute/imageSKU'
                                notLike = '6*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'RedHat'
                            },
                            [Ordered]@{ 
                                field = 'Microsoft.Compute/imageOffer'
                                in    = @(
                                    'osa',
                                    'rhel-byos'
                                )
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'center-for-internet-security-inc'
                            },
                            [Ordered]@{ 
                                field = 'Microsoft.Compute/imageOffer'
                                in    = @(
                                    'cis-centos-7-l1',
                                    'cis-centos-7-v2-1-1-l1'
                                    'cis-centos-8-l1',
                                    'cis-debian-linux-8-l1',
                                    'cis-debian-linux-9-l1',
                                    'cis-nginx-centos-7-v1-1-0-l1',
                                    'cis-oracle-linux-7-v2-0-0-l1',
                                    'cis-oracle-linux-8-l1',
                                    'cis-postgresql-11-centos-linux-7-level-1',
                                    'cis-rhel-7-l2',
                                    'cis-rhel-7-v2-2-0-l1',
                                    'cis-rhel-8-l1',
                                    'cis-suse-linux-12-v2-0-0-l1',
                                    'cis-ubuntu-linux-1604-v1-0-0-l1',
                                    'cis-ubuntu-linux-1804-l1'

                                )
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'credativ'
                            },
                            [Ordered]@{ 
                                field  = 'Microsoft.Compute/imageOffer'
                                equals = 'Debian'
                            },
                            [Ordered]@{
                                field   = 'Microsoft.Compute/imageSKU'
                                notLike = '7*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'Suse'
                            },
                            [Ordered]@{ 
                                field = 'Microsoft.Compute/imageOffer'
                                like  = 'SLES*'
                            },
                            [Ordered]@{
                                field   = 'Microsoft.Compute/imageSKU'
                                notLike = '11*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'Canonical'
                            },
                            [Ordered]@{ 
                                field  = 'Microsoft.Compute/imageOffer'
                                equals = 'UbuntuServer'
                            },
                            [Ordered]@{
                                field   = 'Microsoft.Compute/imageSKU'
                                notLike = '12*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'microsoft-dsvm'
                            },
                            [Ordered]@{ 
                                field = 'Microsoft.Compute/imageOffer'
                                in    = @(
                                    'linux-data-science-vm-ubuntu',
                                    'azureml'
                                )
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'cloudera'
                            },
                            [Ordered]@{ 
                                field  = 'Microsoft.Compute/imageOffer'
                                equals = 'cloudera-centos-os'
                            },
                            [Ordered]@{
                                field   = 'Microsoft.Compute/imageSKU'
                                notLike = '6*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'cloudera'
                            },
                            [Ordered]@{ 
                                field  = 'Microsoft.Compute/imageOffer'
                                equals = 'cloudera-altus-centos-os'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'microsoft-ads'
                            },
                            [Ordered]@{ 
                                field = 'Microsoft.Compute/imageOffer'
                                like  = 'linux*'
                            }
                        )
                    }
                )
            }
        )

        $policyRuleHashtable['if']['anyOf'][1]['allOf'] += @(
            [Ordered]@{
                field = "Microsoft.HybridCompute/imageOffer"
                like  = "linux*"
            }
        )

        $policyRuleHashtable['if']['anyOf'][1]['allOf'] += @(
            [Ordered]@{
                field = 'Microsoft.HybridCompute/imageOffer'
                like  = 'linux*'
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
    else {
        throw "The specified platform '$Platform' is not currently supported by this script."
    }

    # if there is atleast one tag
    if ($PSBoundParameters.ContainsKey('Tag') -AND $null -ne $Tag) {
        # capture existing 'anyOf' section
        $anyOf = $policyRuleHashtable['if']
        # replace with new 'allOf' at top order
        $policyRuleHashtable['if'] = [Ordered]@{
            allOf = @(
            )
        }
        # add tags section under new 'allOf'
        $policyRuleHashtable['if']['allOf'] += [Ordered]@{
            allOf = @(
            )
        }
        # re-insert 'anyOf' under new 'allOf' after tags 'allOf'
        $policyRuleHashtable['if']['allOf'] += $anyOf
        # add each tag individually to tags 'allOf'
        for ($i = 0; $i -lt $Tag.count; $i++) {
            # if there is atleast one tag
            if (-not [string]::IsNullOrEmpty($Tag[$i].Keys)) {
                $policyRuleHashtable['if']['allOf'][0]['allOf'] += [Ordered]@{
                    field  = "tags.$($Tag[$i].Keys)"
                    equals = "$($Tag[$i].Values)"
                }
            }
        }
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
        apiVersion = '2019-07-01'
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
        Creates a new audit policy definition for a guest configuration policy.
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
        $ConfigurationVersion,

        [Parameter(Mandatory = $true)]
        [String]
        $ReferenceId,

        [Parameter()]
        [Hashtable[]]
        $ParameterInfo,

        [Parameter()]
        [String]
        $ContentUri,

        [Parameter()]
        [String]
        $ContentHash,

        [Parameter()]
        [bool]
        $UseCertificateValidation = $false,

        [Parameter(Mandatory = $false)]
        [String]
        $Category = 'Guest Configuration',

        [Parameter()]
        [String]
        $Guid,

        [Parameter(Mandatory = $false)]
        [ValidateSet('Windows', 'Linux')]
        [String]
        $Platform = 'Windows',

        [Parameter()]
        [Hashtable[]]
        $Tag
    )

    if (-not [String]::IsNullOrEmpty($Guid)) {
        $auditPolicyGuid = $Guid
    }
    else {
        $auditPolicyGuid = [Guid]::NewGuid()
    }

    $filePath = Join-Path -Path $FolderPath -ChildPath $FileName
    $ParameterMapping = @{ }
    $ParameterDefinitions = @{ }
    $auditPolicyContentHashtable = [Ordered]@{ }
    
    if ($null -ne $ParameterInfo) {
        $ParameterMapping = Get-ParameterMappingForAINE $ParameterInfo
        $ParameterDefinitions = Get-ParameterDefinitionsAINE $ParameterInfo
    }
    
    $ParameterDefinitions['IncludeArcMachines'] += [Ordered]@{
        Type          = "String"
        Metadata      = [Ordered]@{
            DisplayName = 'Include Arc connected servers'
            Description = 'By selecting this option, you agree to be charged monthly per Arc connected machine.'
        }
        AllowedValues = @('True', 'False')
        DefaultValue  = 'False'
    }
    
    $auditPolicyContentHashtable = [Ordered]@{
        properties = [Ordered]@{
            displayName = $DisplayName
            policyType  = 'Custom'
            mode        = 'All'
            description = $Description
            metadata    = [Ordered]@{
                category           = $Category
                guestConfiguration = [Ordered]@{
                    configurationParameter = $ParameterMapping
                    name                   = $ConfigurationName
                    version                = $ConfigurationVersion
                    contentType            = "Custom"
                    contentUri             = $ContentUri
                    contentHash            = $ContentHash
                }
            }
            parameters  = $ParameterDefinitions
            
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
                    allOf = @(
                        [Ordered]@{
                            value  = "[parameters('IncludeArcMachines')]"
                            equals = "true"
                        },
                        [Ordered]@{
                            field  = "type"
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

    if ($Platform -ieq 'Windows') {
        $policyRuleHashtable['if']['anyOf'][0]['allOf'] += @(
            [Ordered]@{
                anyOf = @(
                    [Ordered]@{
                        field = "Microsoft.Compute/imagePublisher"
                        in    = @(
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
                                field  = "Microsoft.Compute/imagePublisher"
                                equals = 'MicrosoftWindowsServer'
                            },
                            [Ordered]@{
                                field   = "Microsoft.Compute/imageSKU"
                                notLike = '2008*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field  = "Microsoft.Compute/imagePublisher"
                                equals = 'MicrosoftSQLServer'
                            },
                            [Ordered]@{
                                field   = "Microsoft.Compute/imageOffer"
                                notLike = 'SQL2008*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field  = "Microsoft.Compute/imagePublisher"
                                equals = 'microsoft-dsvm'
                            },
                            [Ordered]@{ 
                                field  = "Microsoft.Compute/imageOffer"
                                equals = 'dsvm-windows'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field  = "Microsoft.Compute/imagePublisher"
                                equals = 'microsoft-ads'
                            },
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imageOffer"
                                in    = @(
                                    'standard-data-science-vm',
                                    'windows-data-science-vm'
                                )
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field  = "Microsoft.Compute/imagePublisher"
                                equals = 'batch'
                            },
                            [Ordered]@{ 
                                field  = "Microsoft.Compute/imageOffer"
                                equals = 'rendering-windows2016'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field  = "Microsoft.Compute/imagePublisher"
                                equals = 'center-for-internet-security-inc'
                            },
                            [Ordered]@{
                                field = "Microsoft.Compute/imageOffer"
                                like  = 'cis-windows-server-201*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field  = "Microsoft.Compute/imagePublisher"
                                equals = 'pivotal'
                            },
                            [Ordered]@{
                                field = "Microsoft.Compute/imageOffer"
                                like  = 'bosh-windows-server*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field  = "Microsoft.Compute/imagePublisher"
                                equals = 'cloud-infrastructure-services'
                            },
                            [Ordered]@{
                                field = "Microsoft.Compute/imageOffer"
                                like  = 'ad*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                anyOf = @(
                                    [Ordered]@{ 
                                        field  = "Microsoft.Compute/virtualMachines/osProfile.windowsConfiguration"
                                        exists = 'true'
                                    },
                                    [Ordered]@{
                                        field = "Microsoft.Compute/virtualMachines/storageProfile.osDisk.osType"
                                        like  = 'Windows*'
                                    }
                                )
                            },
                            [Ordered]@{ 
                                anyOf = @(
                                    [Ordered]@{ 
                                        field  = "Microsoft.Compute/imageSKU"
                                        exists = 'false'
                                    },
                                    [Ordered]@{
                                        allOf = @(
                                            [Ordered]@{ 
                                                field   = "Microsoft.Compute/imageSKU"
                                                notLike = '2008*'
                                            },
                                            [Ordered]@{
                                                field   = "Microsoft.Compute/imageOffer"
                                                notLike = 'SQL2008*'
                                            }
                                        )
                                    },
                                    [Ordered]@{
                                        allOf = @(
                                            [Ordered]@{ 
                                                anyOf = @(
                                                    [Ordered]@{ 
                                                        field  = "Microsoft.Compute/virtualMachines/osProfile.windowsConfiguration"
                                                        exists = 'true'
                                                    },
                                                    [Ordered]@{
                                                        field = "Microsoft.Compute/virtualMachines/storageProfile.osDisk.osType"
                                                        like  = 'Windows*'
                                                    }
                                                )
                                            },
                                            [Ordered]@{ 
                                                anyOf = @(
                                                    [Ordered]@{ 
                                                        field  = "Microsoft.Compute/imageSKU"
                                                        exists = 'false'
                                                    },
                                                    [Ordered]@{
                                                        allOf = @(
                                                            [Ordered]@{ 
                                                                field   = "Microsoft.Compute/imageSKU"
                                                                notLike = '2008*'
                                                            },
                                                            [Ordered]@{
                                                                field   = "Microsoft.Compute/imageOffer"
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
                                                        field  = "Microsoft.Compute/virtualMachines/osProfile.windowsConfiguration"
                                                        exists = 'true'
                                                    },
                                                    [Ordered]@{
                                                        field = "Microsoft.Compute/virtualMachines/storageProfile.osDisk.osType"
                                                        like  = 'Windows*'
                                                    }
                                                )
                                            },
                                            [Ordered]@{ 
                                                anyOf = @(
                                                    [Ordered]@{ 
                                                        field  = "Microsoft.Compute/imageSKU"
                                                        exists = 'false'
                                                    },
                                                    [Ordered]@{
                                                        allOf = @(
                                                            [Ordered]@{ 
                                                                field   = "Microsoft.Compute/imageSKU"
                                                                notLike = '2008*'
                                                            },
                                                            [Ordered]@{
                                                                field   = "Microsoft.Compute/imageOffer"
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
                    }
                )
            }
        )

        $policyRuleHashtable['if']['anyOf'][1]['allOf'] += @(
            [Ordered]@{
                field = "Microsoft.HybridCompute/imageOffer"
                like  = "windows*"
            }
        )
    }
    elseif ($Platform -ieq 'Linux') {
        $policyRuleHashtable['if']['anyOf'][0]['allOf'] += @(
            [Ordered]@{
                anyOf = @(
                    [Ordered]@{
                        field = "Microsoft.Compute/imagePublisher"
                        in    = @(
                            'microsoft-aks',
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
                                field  = "Microsoft.Compute/imagePublisher"
                                equals = 'OpenLogic'
                            },
                            [Ordered]@{ 
                                field = "Microsoft.Compute/imageOffer"
                                like  = 'CentOS*'
                            },
                            [Ordered]@{
                                field   = "Microsoft.Compute/imageSKU"
                                notLike = '6*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field  = "Microsoft.Compute/imagePublisher"
                                equals = 'Oracle'
                            },
                            [Ordered]@{ 
                                field  = "Microsoft.Compute/imageOffer"
                                equals = 'Oracle-Linux'
                            },
                            [Ordered]@{
                                field   = "Microsoft.Compute/imageSKU"
                                notLike = '6*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'RedHat'
                            },
                            [Ordered]@{ 
                                field = 'Microsoft.Compute/imageOffer'
                                in    = @(
                                    'RHEL',
                                    'RHEL-HA'
                                    'RHEL-SAP',
                                    'RHEL-SAP-APPS',
                                    'RHEL-SAP-HA',
                                    'RHEL-SAP-HANA'
                                )
                            },
                            [Ordered]@{
                                field   = 'Microsoft.Compute/imageSKU'
                                notLike = '6*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'RedHat'
                            },
                            [Ordered]@{ 
                                field = 'Microsoft.Compute/imageOffer'
                                in    = @(
                                    'osa',
                                    'rhel-byos'
                                )
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'center-for-internet-security-inc'
                            },
                            [Ordered]@{ 
                                field = 'Microsoft.Compute/imageOffer'
                                in    = @(
                                    'cis-centos-7-l1',
                                    'cis-centos-7-v2-1-1-l1'
                                    'cis-centos-8-l1',
                                    'cis-debian-linux-8-l1',
                                    'cis-debian-linux-9-l1',
                                    'cis-nginx-centos-7-v1-1-0-l1',
                                    'cis-oracle-linux-7-v2-0-0-l1',
                                    'cis-oracle-linux-8-l1',
                                    'cis-postgresql-11-centos-linux-7-level-1',
                                    'cis-rhel-7-l2',
                                    'cis-rhel-7-v2-2-0-l1',
                                    'cis-rhel-8-l1',
                                    'cis-suse-linux-12-v2-0-0-l1',
                                    'cis-ubuntu-linux-1604-v1-0-0-l1',
                                    'cis-ubuntu-linux-1804-l1'

                                )
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'credativ'
                            },
                            [Ordered]@{ 
                                field  = 'Microsoft.Compute/imageOffer'
                                equals = 'Debian'
                            },
                            [Ordered]@{
                                field   = 'Microsoft.Compute/imageSKU'
                                notLike = '7*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'Suse'
                            },
                            [Ordered]@{ 
                                field = 'Microsoft.Compute/imageOffer'
                                like  = 'SLES*'
                            },
                            [Ordered]@{
                                field   = 'Microsoft.Compute/imageSKU'
                                notLike = '11*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'Canonical'
                            },
                            [Ordered]@{ 
                                field  = 'Microsoft.Compute/imageOffer'
                                equals = 'UbuntuServer'
                            },
                            [Ordered]@{
                                field   = 'Microsoft.Compute/imageSKU'
                                notLike = '12*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'microsoft-dsvm'
                            },
                            [Ordered]@{ 
                                field = 'Microsoft.Compute/imageOffer'
                                in    = @(
                                    'linux-data-science-vm-ubuntu',
                                    'azureml'
                                )
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'cloudera'
                            },
                            [Ordered]@{ 
                                field  = 'Microsoft.Compute/imageOffer'
                                equals = 'cloudera-centos-os'
                            },
                            [Ordered]@{
                                field   = 'Microsoft.Compute/imageSKU'
                                notLike = '6*'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'cloudera'
                            },
                            [Ordered]@{ 
                                field  = 'Microsoft.Compute/imageOffer'
                                equals = 'cloudera-altus-centos-os'
                            }
                        )
                    },
                    [Ordered]@{
                        allOf = @(
                            [Ordered]@{ 
                                field  = 'Microsoft.Compute/imagePublisher'
                                equals = 'microsoft-ads'
                            },
                            [Ordered]@{ 
                                field = 'Microsoft.Compute/imageOffer'
                                like  = 'linux*'
                            }
                        )
                    }
                )
            }
        )

        $policyRuleHashtable['if']['anyOf'][1]['allOf'] += @(
            [Ordered]@{
                field = "Microsoft.HybridCompute/imageOffer"
                like  = "linux*"
            }
        )

        $policyRuleHashtable['if']['anyOf'][1]['allOf'] += @(
            [Ordered]@{
                field = 'Microsoft.HybridCompute/imageOffer'
                like  = 'linux*'
            }
        )

        $hybridSection['allOf'] += @(
            [Ordered]@{
                field = "Microsoft.HybridCompute/imageOffer"
                like  = "linux*"
            }
        )
    }
    else {
        throw "The specified platform '$Platform' is not currently supported by this script."
    }

    # if there is atleast one tag
    if ($PSBoundParameters.ContainsKey('Tag') -AND $null -ne $Tag) {
        # capture existing 'anyOf' section
        $anyOf = $policyRuleHashtable['if']
        # replace with new 'allOf' at top order
        $policyRuleHashtable['if'] = [Ordered]@{
            allOf = @(
            )
        }
        # add tags section under new 'allOf'
        $policyRuleHashtable['if']['allOf'] += [Ordered]@{
            allOf = @(
            )
        }
        # re-insert 'anyOf' under new 'allOf' after tags 'allOf'
        $policyRuleHashtable['if']['allOf'] += $anyOf
        # add each tag individually to tags 'allOf'
        for ($i = 0; $i -lt $Tag.count; $i++) {
            # if there is atleast one tag
            if (-not [string]::IsNullOrEmpty($Tag[$i].Keys)) {
                $policyRuleHashtable['if']['allOf'][0]['allOf'] += [Ordered]@{
                    field  = "tags.$($Tag[$i].Keys)"
                    equals = "$($Tag[$i].Values)"
                }
            }
        }
    }

    $existenceConditionList = [Ordered]@{
        allOf = [System.Collections.ArrayList]@()
    }
    $existenceConditionList['allOf'].Add([Ordered]@{
            field  = 'Microsoft.GuestConfiguration/guestConfigurationAssignments/complianceStatus'
            equals = 'Compliant'
        })
    
    if ($null -ne $ParameterInfo) {
        $parametersExistenceCondition = Get-GuestConfigurationAssignmentParametersExistenceConditionSection -ParameterInfo $ParameterInfo
        $existenceConditionList['allOf'].Add($parametersExistenceCondition)
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
        Creates a new policy for guest configuration.
#>
function New-GuestConfigurationPolicyDefinition {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $PolicyFolderPath,

        [Parameter(Mandatory = $true)]
        [Hashtable]
        $AuditIfNotExistsInfo,

        [Parameter()]
        [ValidateSet('Windows', 'Linux')]
        [String]
        $Platform = 'Windows'
    )

    if (Test-Path -Path $PolicyFolderPath) {
        $null = Remove-Item -Path $PolicyFolderPath -Force -Recurse -ErrorAction 'SilentlyContinue'
    }

    $null = New-Item -Path $PolicyFolderPath -ItemType 'Directory'
    
    foreach ($currentAuditPolicyInfo in $AuditIfNotExistsInfo) {
        $currentAuditPolicyInfo['FolderPath'] = $PolicyFolderPath
        New-GuestConfigurationAuditPolicyDefinition @currentAuditPolicyInfo
    }
}

function New-CustomGuestConfigPolicy {
    [CmdletBinding()]
    [OutputType([String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $PolicyFolderPath,
        
        [Parameter(Mandatory = $true)]
        [Hashtable]
        $AuditIfNotExistsInfo,

        [Parameter()]
        [ValidateSet('Windows', 'Linux')]
        [String]
        $Platform = 'Windows'
    )

    $existingPolicies = Get-AzPolicyDefinition
    
    $existingAuditPolicy = $existingPolicies | Where-Object { ($_.Properties.PSObject.Properties.Name -contains 'displayName') -and ($_.Properties.displayName -eq $AuditIfNotExistsInfo.DisplayName) }
    if ($null -ne $existingAuditPolicy) {
        Write-Verbose -Message "Found policy with name '$($existingAuditPolicy.Properties.displayName)' and guid '$($existingAuditPolicy.Name)'..."
        $AuditIfNotExistsInfo['Guid'] = $existingAuditPolicy.Name
    }

    New-GuestConfigurationPolicyDefinition @PSBoundParameters
}

<#
    .SYNOPSIS
        Retrieves a policy section check for the existence of a Guest Configuration Assignment with the specified parameters.
    .PARAMETER ParameterInfo
        A list of hashtables indicating the necessary info for parameters that need to be passed into this Guest Configuration Assignment.
    .EXAMPLE
        Get-GuestConfigurationAssignmentParametersExistenceConditionSection -ParameterInfo $parameterInfo
#>
function Get-GuestConfigurationAssignmentParametersExistenceConditionSection {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Hashtable[]]
        $ParameterInfo
    )
    $parameterValueConceatenatedStringList = @()
    foreach ($currentParameterInfo in $ParameterInfo) {
        $assignmentParameterName = Get-GuestConfigurationAssignmentParameterName -ParameterInfo $currentParameterInfo
        $assignmentParameterStringValue = Get-GuestConfigurationAssignmentParameterStringValue -ParameterInfo $currentParameterInfo
        $currentParameterValueConcatenatedString = "'$assignmentParameterName', '=', $assignmentParameterStringValue"
        $parameterValueConceatenatedStringList += $currentParameterValueConcatenatedString
    }
    $allParameterValueConcantenatedString = $parameterValueConceatenatedStringList -join ", ',', "
    $parameterExistenceConditionEqualsValue = "[base64(concat($allParameterValueConcantenatedString))]"
    $existenceConditionHashtable = [Ordered]@{
        field  = 'Microsoft.GuestConfiguration/guestConfigurationAssignments/parameterHash'
        equals = $parameterExistenceConditionEqualsValue
    }
    return $existenceConditionHashtable
}

<#
    .SYNOPSIS
        Retrieves the name of a Guest Configuration Assignment parameter correctly formatted to be passed to the Guest Configuration Assignment.
    .PARAMETER ParameterInfo
        A single hashtable indicating the necessary parameter info from which to retrieve the parameter name.
    .EXAMPLE
        Get-GuestConfigurationAssignmentParameterName -ParameterInfo $currentParameterInfo
#>
function Get-GuestConfigurationAssignmentParameterName {
    [CmdletBinding()]
    [OutputType([String])]
    param
    (
        [Parameter()]
        [Hashtable]
        $ParameterInfo
    )
    $assignmentParameterName = "$($ParameterInfo.MofResourceReference);$($ParameterInfo.MofParameterName)"
    return $assignmentParameterName
}

<#
    .SYNOPSIS
        Retrieves the string value of a Guest Configuration Assignment parameter correctly formatted to be passed to the Guest Configuration Assignment as part of the parameter hash.
    .PARAMETER ParameterInfo
        A single hashtable indicating the necessary parameter info from which to retrieve the parameter string value.
    .EXAMPLE
        Get-GuestConfigurationAssignmentParameterStringValue -ParameterInfo $currentParameterInfo
#>
function Get-GuestConfigurationAssignmentParameterStringValue {
    [CmdletBinding()]
    [OutputType([String])]
    param
    (
        [Parameter()]
        [Hashtable]
        $ParameterInfo
    )
    if ($ParameterInfo.ContainsKey('ConfigurationValue')) {
        if ($ParameterInfo.ConfigurationValue.StartsWith('[') -and $ParameterInfo.ConfigurationValue.EndsWith(']')) {
            $assignmentParameterStringValue = $ParameterInfo.ConfigurationValue.Substring(1, $ParameterInfo.ConfigurationValue.Length - 2)
        }
        else {
            $assignmentParameterStringValue = "'$($ParameterInfo.ConfigurationValue)'"
        }
    }
    else {
        $assignmentParameterStringValue = "parameters('$($ParameterInfo.ReferenceName)')"
    }
    return $assignmentParameterStringValue
}

<#
    .SYNOPSIS
        Define the policy parameter mapping to the parameters of the MOF file. 
    .PARAMETER ParameterInfo
        A list of hashtables indicating the necessary info for parameters that need to be passed into this Guest Configuration Assignment.
#>
function  Get-ParameterMappingForAINE {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param
    (
        [Parameter(Mandatory = $true)]   
        [array]     
        $ParameterInfo
    )
    $paramMapping = @{}
    foreach ($item in $ParameterInfo) {
        $paramMapping[$item.ReferenceName] = ("{0};{1}" -f $item.MofResourceReference, $item.MofParameterName)
    }
    return $paramMapping
}

<#
    .SYNOPSIS
        Define the parmameters of AINE policy for AuditWithout DINE scenario.
    .PARAMETER ParameterInfo
        A list of hashtables indicating the necessary info for parameters that need to be passed into this Guest Configuration Assignment.
#>
function Get-ParameterDefinitionsAINE {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]   
        [Hashtable[]]$ParameterInfo
    )
    
    $paramDefinition = [Ordered]@{}
    foreach ($item in $ParameterInfo) {
        $paramDefinition[$($item.ReferenceName)] = @{
            type     = $item.Type 
            metadata = [Ordered]@{
                displayName = $item.DisplayName
                description = $item.Description
            }
        }
        if ($item.ContainsKey('AllowedValues')) {
            $paramDefinition[$($item.ReferenceName)]['allowedValues'] = $item.AllowedValues
        }
        if ($item.ContainsKey('DefaultValue')) {
            $paramDefinition[$($item.ReferenceName)]['defaultValue'] = $item.DefaultValue  
        }
    }
    return $paramDefinition
}
