
<#
    .SYNOPSIS
        Creates a package to run code on machines for use through Azure Guest Configuration.

    .PARAMETER Name
        The name of the Guest Configuration package.

    .PARAMETER Version
        The semantic version of the Guest Configuration package.
        This is a tag for you to keep track of your pacakges; it is not currently used by Guest Configuration or Azure Policy.

    .PARAMETER Configuration
        The path to the compiled DSC configuration file (.mof) to base the package on.

    .PARAMETER Path
        The path to a folder to output the package under.
        By default the package will be created under the current directory.

    .PARAMETER ChefInspecProfilePath
        The path to a folder containing Chef InSpec profiles to include with the package.
        The compiled DSC configuration (.mof) provided should include a reference to the native Chef InSpec resource
        with the reference name of the resources matching the name of the profile folder to use.

    .PARAMETER Type
        Sets a tag in the metaconfig data of the package specifying whether or not this package can support Set functionality or not.
        This tag is currently used only for verfication by this module and does not affect the functionality of the package.
        AuditAndSet indicates that the package may be used for setting the state of the machine.
        Audit indicates that the package will not set the state of the machine and may only monitor settings.
        By default this tag is set to Audit.

    .PARAMETER Force
        If present, this function will overwrite any existing package files.

    .EXAMPLE
        New-GuestConfigurationPackage -Name WindowsTLS -Configuration ./custom_policy/WindowsTLS/localhost.mof -Path ./git/repository/release/policy/WindowsTLS

    .OUTPUTS
        Returns a PSCustomObject with the name and path of the new Guest Configuration package.
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

    $duplicateModules = @( $moduleDependencies | Group-Object -Property 'Name' | Where-Object { $_.Count -gt 1 } )

    foreach ($duplicateModule in $duplicateModules)
    {
        $uniqueVersions = @( $duplicateModule.Group.Version | Get-Unique )

        if ($uniqueVersions.Count -gt 1)
        {
            $moduleName = $duplicateModule.Group[0].Name
            throw "Cannot include more than one version of a module in one package. Detected versions $uniqueVersions of the module '$moduleName' are needed for this package."
        }
    }

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
        Write-Verbose -Message "Removing existing package at the path '$packageRootPath'..." -Verbose
        $null = Remove-Item -Path $packageRootPath -Recurse -Force
    }

    $null = New-Item -Path $packageRootPath -ItemType 'Directory'

    # Clear the package destination
    if (Test-Path -Path $packageDestinationPath)
    {
        Write-Verbose -Message "Removing existing package zip at the path '$packageDestinationPath'..." -Verbose
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
    $null = Set-Content -Path $metaconfigFilePath -Value $metaconfigJson -Encoding 'ascii'

    # Copy the mof into the package
    $mofFileName = "$Name.mof"
    $mofFilePath = Join-Path -Path $packageRootPath -ChildPath $mofFileName

    $null = Copy-Item -Path $Configuration -Destination $mofFilePath

    # Copy resource dependencies
    foreach ($moduleDependency in $moduleDependencies)
    {
        $moduleDestinationPath = Join-Path -Path $modulesFolderPath -ChildPath $moduleDependency['Name']

        Write-Verbose -Message "Copying module from '$moduleDependency['SourcePath']' to '$moduleDestinationPath'" -Verbose
        $null = Copy-Item -Path $moduleDependency['SourcePath'] -Destination $moduleDestinationPath -Container -Recurse -Force
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
