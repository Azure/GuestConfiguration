
<#
    .SYNOPSIS
        Creates a Guest Configuration policy package.

    .Parameter Name
        Guest Configuration package name.

    .Parameter Version
        Guest Configuration package Version (SemVer).

    .Parameter Configuration
        Compiled DSC configuration document full path.

    .Parameter Path
        Output folder path.
        This is an optional parameter. If not specified, the package will be created in the current directory.

    .Parameter ChefInspecProfilePath
        Chef profile path, supported only on Linux.

    .Parameter Type
        Specifies whether or not package will support AuditAndSet or only Audit. Set to Audit by default.

    .Parameter Force
        Overwrite the package files if already present.

    .Example
        New-GuestConfigurationPackage -Name WindowsTLS -Configuration ./custom_policy/WindowsTLS/localhost.mof -Path ./git/repository/release/policy/WindowsTLS

    .OUTPUTS
        Return name and path of the new Guest Configuration Policy package.
#>
function New-GuestConfigurationPackage
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
    param
    (
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Name,

        [Parameter(Position = 1, Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Configuration,

        [Parameter(Position = 2, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [SemVer]
        $Version = "0.0.0.0",

        [Parameter()]
        [System.String]
        $ChefInspecProfilePath,

        [Parameter()]
        [System.String]
        $FilesToInclude,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Path = '.',

        [Parameter()]
        [ValidateSet('Audit', 'AuditAndSet')]
        [ValidateNotNullOrEmpty()]
        [String]
        $Type = 'Audit',

        [Parameter()]
        [Switch]
        $Force
    )

    #-----VALIDATION-----

    # Validate mof
    if (-not (Test-Path -Path $Configuration -PathType 'Leaf'))
    {
        throw "No file found at the path '$Configuration'. Please specify the file path to a compiled DSC configuration (.mof) with the Configuration parameter."
    }

    $sourceMofFile = Get-Item -Path $Configuration

    if ($sourceMofFile.Extension -ine '.mof')
    {
        throw "The file found at the path '$Configuration' is not a .mof file. It has extension '$($sourceMofFile.Extension)'. Please specify the file path to a compiled DSC configuration (.mof) with the Configuration parameter."
    }

    # Validate dependencies
    $resourceDependencies = @( Get-ResouceDependenciesFromMof -MofFilePath $Configuration )

    if ($resourceDependencies.Count -le 0)
    {
        throw "Failed to determine resource dependencies from the mof at the path '$Configuration'. Please specify the file path to a compiled DSC configuration (.mof) with the Configuration parameter."
    }

    $usingInSpecResource = $false
    $moduleDependencies = @()
    $inSpecProfileNames = @()

    foreach ($resourceDependency in $resourceDependencies)
    {
        if ($resourceDependency['ResourceName'] -ieq 'MSFT_ChefInspecResource')
        {
            $usingInSpecResource = $true
            $inSpecProfileNames += $resourceDependency['ResourceInstanceName']
            continue
        }

        if ($resourceDependency['ModuleName'] -ieq 'PSDscResources' -and @('MSFT_WindowsFeature', 'MSFT_WindowsOptionalFeature') -icontains $resourceDependency['ResourceName'])
        {
            throw "Found a dependency on the resource '$($resourceDependency['ResourceName'])' from the PSDscResources module. This resource currently relies on DISM which will not work with Guest Configuration."
        }

        $getModuleDependenciesParameters = @{
            ModuleName = $resourceDependency['ModuleName']
            ModuleVersion = $resourceDependency['ModuleVersion']
        }

        $moduleDependencies += Get-ModuleDependencies @getModuleDependenciesParameters
    }

    Write-Verbose -Message "Found the module dependencies: $($moduleDependencies.Name)"

    $inSpecProfileSourcePaths = @()

    if ($usingInSpecResource)
    {
        Write-Verbose -Message "Expecting the InSpec profiles: $($inSpecProfileNames)"

        if ($Type -ieq 'AuditAndSet')
        {
            throw "The type of this package was specified as 'AuditAndSet', but native InSpec resource was detected in the provided .mof file. This resource does not currently support the set scenario and can only be used for 'Audit' packages."
        }

        if ([String]::IsNullOrEmpty($ChefInspecProfilePath))
        {
            throw "The native InSpec resource was detected in the provided .mof file, but no InSpec profiles folder path was provided. Please provide the path to an InSpec profiles folder via the ChefInspecProfilePath parameter."
        }
        else
        {
            $inSpecProfileFolder = Get-Item -Path $ChefInspecProfilePath -ErrorAction 'SilentlyContinue'

            if ($null -eq $inSpecProfileFolder)
            {
                throw "The native InSpec resource was detected in the provided .mof file, but the specified path to the InSpec profiles folder does not exist. Please provide the path to an InSpec profiles folder via the ChefInspecProfilePath parameter."
            }
            elseif ($inSpecProfileFolder -isnot [System.IO.DirectoryInfo])
            {
                throw "The native InSpec resource was detected in the provided .mof file, but the specified path to the InSpec profiles folder is not a directory. Please provide the path to an InSpec profiles folder via the ChefInspecProfilePath parameter."
            }
            else
            {
                foreach ($expectedInSpecProfileName in $inSpecProfileNames)
                {
                    $inSpecProfilePath = Join-Path -Path $ChefInspecProfilePath -ChildPath $expectedInSpecProfileName
                    $inSpecProfile = Get-Item -Path $inSpecProfilePath -ErrorAction 'SilentlyContinue'

                    if ($null -eq $inSpecProfile)
                    {
                        throw "Expected to find an InSpec profile at the path '$inSpecProfilePath', but there is no item at this path."
                    }
                    elseif ($inSpecProfile -isnot [System.IO.DirectoryInfo])
                    {
                        throw "Expected to find an InSpec profile at the path '$inSpecProfilePath', but the item at this path is not a directory."
                    }
                    else
                    {
                        $inSpecProfileYmlFileName = 'inspec.yml'
                        $inSpecProfileYmlFilePath = Join-Path -Path $inSpecProfilePath -ChildPath $inSpecProfileYmlFileName

                        if (Test-Path -Path $inSpecProfileYmlFilePath -PathType 'Leaf')
                        {
                            $inSpecProfileSourcePaths += $inSpecProfilePath
                        }
                        else
                        {
                            throw "Expected to find an InSpec profile at the path '$inSpecProfilePath', but there file named '$inSpecProfileYmlFileName' under this path."
                        }
                    }
                }
            }
        }
    }
    elseif (-not [String]::IsNullOrEmpty($ChefInspecProfilePath))
    {
        throw "A Chef InSpec profile path was provided, but the native InSpec resource was not detected in the provided .mof file. Please provide a compiled DSC configuration (.mof) that references the native InSpec resource or remove the reference to the ChefInspecProfilePath parameter."
    }

    # Check extra files if needed
    if (-not [string]::IsNullOrEmpty($FilesToInclude))
    {
        if (-not (Test-Path -Path $FilesToInclude))
        {
            throw "The item to include from the path '$FilesToInclude' does not exist. Please update or remove the FilesToInclude parameter."
        }
    }

    # Check set-up folder
    $packageRootPath = Join-Path -Path $Path -ChildPath $Name

    if (Test-Path -Path $packageRootPath)
    {
        if (-not $Force)
        {
            throw "An item already exists at the package path '$packageRootPath'. Please remove it or use the Force parameter."
        }
    }

    # Check destination
    $packageDestinationPath = '{0}.zip' -f $packageRootPath

    if (Test-Path -Path $packageDestinationPath)
    {
        if (-not $Force)
        {
            throw "An item already exists at the package destination path '$packageDestinationPath'. Please remove it or use the Force parameter."
        }
    }

    #-----PACKAGE CREATION-----

    # Clear the root package folder
    if (Test-Path -Path $packageRootPath)
    {
        Write-Verbose -Message "Removing existing package at the path '$packageRootPath'..."
        $null = Remove-Item -Path $packageRootPath -Recurse -Force
    }

    $null = New-Item -Path $packageRootPath -ItemType 'Directory'

    # Clear the package destination
    if (Test-Path -Path $packageDestinationPath)
    {
        Write-Verbose -Message "Removing existing package zip at the path '$packageDestinationPath'..."
        $null = Remove-Item -Path $packageDestinationPath -Recurse -Force
    }

    # Create the package structure
    $modulesFolderPath = Join-Path -Path $packageRootPath -ChildPath 'Modules'
    $null = New-Item -Path $modulesFolderPath -ItemType 'Directory'

    # Create the metaconfig file
    $metaconfigFileName = "$Name.metaconfig.json"
    $metaconfigFilePath = Join-Path -Path $packageRootPath -ChildPath $metaconfigFileName

    $metaconfig = @{
        Type = $Type
        Version = $Version
    }

    $metaconfigJson = $metaconfig | ConvertTo-Json
    $null = Set-Content -Path $metaConfigPath -Value $metaconfigJson -Encoding 'ascii'

    # Copy the mof into the package
    $mofFileName = "$Name.mof"
    $mofFilePath = Join-Path -Path $packageRootPath -ChildPath $mofFileName

    $null = Copy-Item -Path $Configuration -Destination $mofFilePath

    # Copy resource dependencies
    foreach ($moduleDependency in $moduleDependencies)
    {
        $null = Copy-Item -Path $moduleDependency['SourcePath'] -Destination $modulesFolderPath -Container -Recurse -Force
    }

    # Copy native Chef InSpec resource if needed
    if ($usingInSpecResource)
    {
        $nativeResourcesFolder = Join-Path -Path $modulesFolderPath -ChildPath 'DscNativeResources'
        $null = New-Item -Path $nativeResourcesFolder -ItemType 'Directory'

        $inSpecResourceFolder = Join-Path -Path $nativeResourcesFolder -ChildPath 'MSFT_ChefInSpecResource'
        $null = New-Item -Path $inSpecResourceFolder -ItemType 'Directory'

        $dscResourcesFolderPath = Join-Path -Path $PSScriptRoot -ChildPath 'DscResources'
        $inSpecResourceSourcePath = Join-Path -Path $dscResourcesFolderPath -ChildPath 'MSFT_ChefInSpecResource'

        $installInSpecScriptSourcePath = Join-Path -Path $inSpecResourceSourcePath -ChildPath 'install_inspec.sh'
        $null = Copy-Item -Path $installInSpecScriptSourcePath -Destination $modulesFolderPath

        $inSpecResourceLibrarySourcePath = Join-Path -Path $inSpecResourceSourcePath -ChildPath 'libMSFT_ChefInSpecResource.so'
        $null = Copy-Item -Path $inSpecResourceLibrarySourcePath -Destination $inSpecResourceFolder

        $inSpecResourceSchemaMofSourcePath = Join-Path -Path $inSpecResourceSourcePath -ChildPath 'MSFT_ChefInSpecResource.schema.mof'
        $null = Copy-Item -Path $inSpecResourceSchemaMofSourcePath -Destination $inSpecResourceFolder

        foreach ($inSpecProfileSourcePath in $inSpecProfileSourcePaths)
        {
            $null = Copy-Item -Path $inSpecProfileSourcePath -Destination $modulesFolderPath -Container -Recurse
        }
    }

    # Copy extra files
    if (-not [string]::IsNullOrEmpty($FilesToInclude))
    {
        if (Test-Path $FilesToInclude -PathType 'Leaf')
        {
            $null = Copy-Item -Path $FilesToInclude -Destination $modulesFolderPath
        }
        else
        {
            $null = Copy-Item -Path $FilesToIncludePath -Destination $modulesFolderPath -Container -Recurse
        }
    }

    # Zip the package
    $null = Compress-Archive -Path $packageRootPath -DestinationPath $packageDestinationPath -CompressionLevel 'Fastest'

    return [PSCustomObject]@{
        PSTypeName = 'GuestConfiguration.Package'
        Name = $Name
        Path = $packageDestinationPath
    }
}

function Get-ResouceDependenciesFromMof
{
    [CmdletBinding()]
    [OutputType([Hashtable[]])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $MofFilePath
    )

    $resourceDependencies = @()
    $reservedResourceNames = @('OMI_ConfigurationDocument')
    $mofInstances = [Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache]::ImportInstances($mofFilePath, 4)

    foreach ($mofInstance in $mofInstances)
    {
        if ($reservedResourceNames -inotcontains $mofInstance.CimClass.CimClassName -and $mofInstance.CimInstanceProperties.Name -icontains 'ModuleName')
        {
            Write-Verbose -Message "Found resource dependency in mof with name '$($mofInstance.CimClass.CimClassName)' from module '$($mofInstance.ModuleName)' with version '$($mofInstance.ModuleVersion)'."
            $resourceDependencies += @{
                ResourceInstanceName = $mofInstance.CimInstanceProperties['Name'].Value
                ResourceName = $mofInstance.CimClass.CimClassName
                ModuleName = $mofInstance.ModuleName
                ModuleVersion = $mofInstance.ModuleVersion
            }
        }
    }

    return $resourceDependencies
}

function Get-ModuleDependencies
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $ModuleName,

        [Parameter()]
        [String]
        $ModuleVersion
    )

    $moduleDependencies = @()

    if ($ModuleName -ieq 'PSDesiredStateConfiguration')
    {
        throw "Found a dependency on the PSDesiredStateConfiguration module, but we cannot copy these resources into the Guest Configuration package. Please switch these resources to using the PSDscResources module instead."
    }

    $getModuleParameters = @{
        ListAvailable = $true
    }

    if ([String]::IsNullOrWhiteSpace($ModuleVersion))
    {
        Write-Verbose -Message "Searching for a module with the name '$ModuleName'..."
        $getModuleParameters['Name'] = $ModuleName
    }
    else
    {
        Write-Verbose -Message "Searching for a module with the name '$ModuleName' and version '$ModuleVersion'..."
        $getModuleParameters['FullyQualifiedName'] = @{
            ModuleName = $ModuleName
            ModuleVersion = $ModuleVersion
        }
    }

    $sourceModule = Get-Module @getModuleParameters

    if ($null -eq $sourceModule)
    {
        throw "Failed to find a module with the name '$ModuleName' and the version '$ModuleVersion'. Please check that the module is installed and available in your PSModulePath."
    }
    elseif ('Count' -in $sourceModule.PSObject.Properties.Name -and $sourceModule.Count -gt 1)
    {
        $sourceModule = ($sourceModule | Sort-Object -Property 'Version' -Descending)[0]
        Write-Warning -Message "Found more than one module with the name '$ModuleName'. Using the version '$($sourceModule.Version)'."
    }

    $moduleDependency = @{
        Name = $resourceDependency['ModuleName']
        Version = $resourceDependency['ModuleVersion']
        SourcePath = $sourceModule.ModuleBase
    }

    $moduleDependencies += $moduleDependency

    # Add any modules required by this module to the package
    if ('RequiredModules' -in $sourceModule.PSObject.Properties.Name -and $null -ne $sourceModule.RequiredModules -and $sourceModule.RequiredModules.Count -gt 0)
    {
        foreach ($requiredModule in $sourceModule.RequiredModules)
        {
            Write-Verbose -Message "The module '$ModuleName' requires the module '$($requiredModule.Name)'. Attempting to copy the required module..."

            $getModuleDependenciesParameters = @{
                ModuleName = $requiredModule.Name
                ModuleVersion = $requiredModule.Version
            }

            $moduleDependencies += Get-ModuleDependencies @getModuleDependenciesParameters
        }
    }

    # Add any modules marked as external module dependencies by this module to the package
    if ('ExternalModuleDependencies' -in $sourceModule.PSObject.Properties.Name -and $null -ne $sourceModule.ExternalModuleDependencies -and $sourceModule.ExternalModuleDependencies.Count -gt 0)
    {
        foreach ($externalModuleDependency in $sourceModule.ExternalModuleDependencies)
        {
            Write-Verbose -Message "The module '$ModuleName' requires the module '$externalModuleDependency'. Attempting to copy the required module..."

            $getModuleDependenciesParameters = @{
                ModuleName = $requiredModule.Name
            }

            $moduleDependencies += Get-ModuleDependencies @getModuleDependenciesParameters
        }
    }

    return $moduleDependencies
}
