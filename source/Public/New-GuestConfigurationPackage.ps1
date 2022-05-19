
<#
    .SYNOPSIS
        Creates a package to run code on machines through Azure Guest Configuration.

    .PARAMETER Name
        The name of the Guest Configuration package.

    .PARAMETER Configuration
        The path to the compiled DSC configuration file (.mof) to base the package on.

    .PARAMETER Version
        The semantic version of the Guest Configuration package.
        The default value is '1.0.0'.

    .PARAMETER Type
        Sets a tag in the metaconfig data of the package specifying whether or not this package is
        Audit-only or can support Set/Apply functionality.

        Audit indicates that the package will only monitor settings and cannot set the state of
        the machine.
        AuditAndSet indicates that the package can be used for both monitoring and setting the
        state of the machine.

        The default value is Audit.

    .PARAMETER FrequencyMinutes
        The frequency at which Guest Configuration should run this package in minutes.
        The default value is 15.
        15 is also the mimimum value.
        Guest Configuration cannot run a package less-frequently than every 15 minutes.

    .PARAMETER Path
        The path to a folder to output the package under.
        By default the package will be created under the current working directory.

    .PARAMETER ChefInspecProfilePath
        The path to a folder containing Chef InSpec profiles to include with the package.

        The compiled DSC configuration (.mof) provided must include a reference to the native Chef
        InSpec resource with the reference name of the resources matching the name of the profile
        folder to use.

        If the compiled DSC configuration (.mof) provided includes a reference to the native Chef
        InSpec resource, then specifying a Chef InSpec profile to include with this parameter is
        required.

    .PARAMETER FilesToInclude
        The path to files or folders to include under the Modules path within the package.

    .PARAMETER Force
        If present, this function will overwrite any existing package files at the output path.

    .EXAMPLE
        New-GuestConfigurationPackage `
            -Name 'WindowsTLS' `
            -Configuration ./custom_policy/WindowsTLS/localhost.mof `
            -Path ./git/repository/release/policy/WindowsTLS

    .OUTPUTS
        Returns a PSCustomObject with the name and path of the new Guest Configuration package.
        [PSCustomObject]@{
            PSTypeName = 'GuestConfiguration.Package'
            Name = (Same as the Name parameter)
            Path = (Path to the newly created package zip file)
        }
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
        [System.IO.FileInfo]
        $Configuration,

        [Parameter(Position = 2, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Version = '1.0.0',

        [Parameter()]
        [ValidateSet('Audit', 'AuditAndSet')]
        [ValidateNotNullOrEmpty()]
        [String]
        $Type = 'Audit',

        [Parameter()]
        [int]
        $FrequencyMinutes = 15,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [System.IO.DirectoryInfo]
        $Path = $(Get-Item -Path $(Get-Location)),

        [Parameter()]
        [System.IO.DirectoryInfo]
        $ChefInspecProfilePath,

        [Parameter()]
        [String[]]
        $FilesToInclude,

        [Parameter()]
        [Switch]
        $Force
    )

    Write-Verbose -Message 'Starting New-GuestConfigurationPackage'

    $Configuration = Resolve-RelativePath -Path $Configuration
    $Path = Resolve-RelativePath -Path $Path

    if (-not [String]::IsNullOrEmpty($ChefInspecProfilePath))
    {
        $ChefInspecProfilePath = Resolve-RelativePath -Path $ChefInspecProfilePath
    }

    if ($null -ne $FilesToInclude -and $FilesToInclude.Count -gt 0)
    {
        foreach ($file in $FilesToInclude)
        {
            $FilesToInclude = Resolve-RelativePath -Path $FilesToInclude
        }
    }

    #-----VALIDATION-----

    if ($FrequencyMinutes -lt 15)
    {
        throw "FrequencyMinutes must be 15 or greater. Guest Configuration cannot run packages more frequently than every 15 minutes."
    }

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
    $resourceDependencies = @( Get-MofResouceDependencies -MofFilePath $Configuration )

    if ($resourceDependencies.Count -le 0)
    {
        throw "Failed to determine resource dependencies from the mof at the path '$Configuration'. Please specify the file path to a compiled DSC configuration (.mof) with the Configuration parameter."
    }

    $usingInSpecResource = $false
    $moduleDependencies = @()
    $inSpecProfileNames = @()

    foreach ($resourceDependency in $resourceDependencies)
    {
        if ($resourceDependency['ResourceName'] -ieq 'MSFT_ChefInSpecResource')
        {
            $usingInSpecResource = $true
            $inSpecProfileNames += $resourceDependency['ResourceInstanceName']
            continue
        }

        $getModuleDependenciesParameters = @{
            ModuleName = $resourceDependency['ModuleName']
            ModuleVersion = $resourceDependency['ModuleVersion']
        }

        $moduleDependencies += Get-ModuleDependencies @getModuleDependenciesParameters
    }

    if ($moduleDependencies.Count -gt 0)
    {
        Write-Verbose -Message "Found the module dependencies: $($moduleDependencies.Name)"
    }

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
            throw "A folder already exists at the package folder path '$packageRootPath'. Please remove it or use the Force parameter. With -Force the cmdlet will remove this folder for you."
        }
    }

    # Check destination
    $packageDestinationPath = "$packageRootPath.zip"

    if (Test-Path -Path $packageDestinationPath)
    {
        if (-not $Force)
        {
            throw "A file already exists at the package destination path '$packageDestinationPath'. Please remove it or use the Force parameter. With -Force the cmdlet will remove this file for you."
        }
    }

    #-----PACKAGE CREATION-----

    # Clear the root package folder
    if (Test-Path -Path $packageRootPath)
    {
        if ($Configuration.FullName.Contains($packageRootPath))
        {
            Write-Warning -Message "You have elected to forcibly remove the existing package folder path '$packageRootPath', but the specificed source path for the configuration document is under this path at '$Configuration'. The configuration document at this source path will be changed to match package requirements."
            $gcWorkerTempPath = Reset-GCWorkerTempDirectory
            $copiedMof = Copy-Item -Path $Configuration -Destination $gcWorkerTempPath -Force
            $Configuration = $copiedMof.FullName
        }

        Write-Verbose -Message "Removing an existing item at the path '$packageRootPath'..."
        $null = Remove-Item -Path $packageRootPath -Recurse -Force
    }

    Write-Verbose -Message "Creating the package root folder at the path '$packageRootPath'..."
    $null = New-Item -Path $packageRootPath -ItemType 'Directory' -Force

    # Clear the package destination
    if (Test-Path -Path $packageDestinationPath)
    {
        Write-Verbose -Message "Removing an existing item at the path '$packageDestinationPath'..."
        $null = Remove-Item -Path $packageDestinationPath -Recurse -Force
    }

    # Create the package structure
    $modulesFolderPath = Join-Path -Path $packageRootPath -ChildPath 'Modules'
    Write-Verbose -Message "Creating the package Modules folder at the path '$modulesFolderPath'..."
    $null = New-Item -Path $modulesFolderPath -ItemType 'Directory'

    # Create the metaconfig file
    $metaconfigFileName = "$Name.metaconfig.json"
    $metaconfigFilePath = Join-Path -Path $packageRootPath -ChildPath $metaconfigFileName

    $metaconfig = @{
        Type = $Type
        Version = $Version
    }

    if ($FrequencyMinutes -gt 15)
    {
        $metaconfig['configurationModeFrequencyMins'] = $FrequencyMinutes
    }

    $metaconfigJson = $metaconfig | ConvertTo-Json
    Write-Verbose -Message "Setting the content of the package metaconfig at the path '$metaconfigFilePath'..."
    $null = Set-Content -Path $metaconfigFilePath -Value $metaconfigJson -Encoding 'ascii'

    # Copy the mof into the package
    $mofFileName = "$Name.mof"
    $mofFilePath = Join-Path -Path $packageRootPath -ChildPath $mofFileName

    Write-Verbose -Message "Copying the compiled DSC configuration (.mof) from the path '$Configuration' to the package path '$mofFilePath'..."
    $null = Copy-Item -Path $Configuration -Destination $mofFilePath

    # Edit the native Chef InSpec resource parameters in the mof if needed
    if ($usingInSpecResource)
    {
        Edit-GuestConfigurationPackageMofChefInSpecContent -PackageName $Name -MofPath $mofFilePath
    }

    # Copy resource dependencies
    foreach ($moduleDependency in $moduleDependencies)
    {
        $moduleDestinationPath = Join-Path -Path $modulesFolderPath -ChildPath $moduleDependency['Name']

        Write-Verbose -Message "Copying module from '$($moduleDependency['SourcePath'])' to '$moduleDestinationPath'"
        $null = Copy-Item -Path $moduleDependency['SourcePath'] -Destination $moduleDestinationPath -Container -Recurse -Force
    }

    # Copy native Chef InSpec resource if needed
    if ($usingInSpecResource)
    {
        $nativeResourcesFolder = Join-Path -Path $modulesFolderPath -ChildPath 'DscNativeResources'
        Write-Verbose -Message "Creating the package native resources folder at the path '$nativeResourcesFolder'..."
        $null = New-Item -Path $nativeResourcesFolder -ItemType 'Directory'

        $inSpecResourceFolder = Join-Path -Path $nativeResourcesFolder -ChildPath 'MSFT_ChefInSpecResource'
        Write-Verbose -Message "Creating the native Chef InSpec resource folder at the path '$inSpecResourceFolder'..."
        $null = New-Item -Path $inSpecResourceFolder -ItemType 'Directory'

        $dscResourcesFolderPath = Join-Path -Path $PSScriptRoot -ChildPath 'DscResources'
        $inSpecResourceSourcePath = Join-Path -Path $dscResourcesFolderPath -ChildPath 'MSFT_ChefInSpecResource'

        $installInSpecScriptSourcePath = Join-Path -Path $inSpecResourceSourcePath -ChildPath 'install_inspec.sh'
        Write-Verbose -Message "Copying the Chef Inspec install script from the path '$installInSpecScriptSourcePath' to the package path '$modulesFolderPath'..."
        $null = Copy-Item -Path $installInSpecScriptSourcePath -Destination $modulesFolderPath

        $inSpecResourceLibrarySourcePath = Join-Path -Path $inSpecResourceSourcePath -ChildPath 'libMSFT_ChefInSpecResource.so'
        Write-Verbose -Message "Copying the native Chef Inspec resource library from the path '$inSpecResourceLibrarySourcePath' to the package path '$inSpecResourceFolder'..."
        $null = Copy-Item -Path $inSpecResourceLibrarySourcePath -Destination $inSpecResourceFolder

        $inSpecResourceSchemaMofSourcePath = Join-Path -Path $inSpecResourceSourcePath -ChildPath 'MSFT_ChefInSpecResource.schema.mof'
        Write-Verbose -Message "Copying the native Chef Inspec resource schema from the path '$inSpecResourceSchemaMofSourcePath' to the package path '$inSpecResourceFolder'..."
        $null = Copy-Item -Path $inSpecResourceSchemaMofSourcePath -Destination $inSpecResourceFolder

        foreach ($inSpecProfileSourcePath in $inSpecProfileSourcePaths)
        {
            Write-Verbose -Message "Copying the Chef Inspec profile from the path '$inSpecProfileSourcePath' to the package path '$modulesFolderPath'..."
            $null = Copy-Item -Path $inSpecProfileSourcePath -Destination $modulesFolderPath -Container -Recurse
        }
    }

    # Copy extra files
    if (-not [string]::IsNullOrEmpty($FilesToInclude))
    {
        if (Test-Path $FilesToInclude -PathType 'Leaf')
        {
            Write-Verbose -Message "Copying the custom file to include from the path '$FilesToInclude' to the package path '$modulesFolderPath'..."
            $null = Copy-Item -Path $FilesToInclude -Destination $modulesFolderPath
        }
        else
        {
            Write-Verbose -Message "Copying the custom folder to include from the path '$FilesToInclude' to the package path '$modulesFolderPath'..."
            $null = Copy-Item -Path $FilesToInclude -Destination $modulesFolderPath -Container -Recurse
        }
    }

    # Zip the package
    $compressArchiveSourcePath = Join-Path -Path $packageRootPath -ChildPath '*'
    Write-Verbose -Message "Compressing the generated package from the path '$compressArchiveSourcePath' to the package path '$packageDestinationPath'..."
    $null = Compress-Archive -Path $compressArchiveSourcePath -DestinationPath $packageDestinationPath -CompressionLevel 'Fastest'

    return [PSCustomObject]@{
        PSTypeName = 'GuestConfiguration.Package'
        Name = $Name
        Path = $packageDestinationPath
    }
}
