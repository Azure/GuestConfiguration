<#
    .SYNOPSIS
        Creates a Guest Configuration policy package.

    .Parameter Name
        Guest Configuration package name.

    .Parameter Configuration
        Compiled DSC configuration document full path.

    .Parameter Path
        Output folder path.
        This is an optional parameter. If not specified, the package will be created in the current directory.

    .Parameter ChefInspecProfilePath
        Chef profile path, supported only on Linux.

    .Example
        New-GuestConfigurationPackage -Name WindowsTLS -Configuration ./custom_policy/WindowsTLS/localhost.mof -Path ./git/repository/release/policy/WindowsTLS

    .OUTPUTS
        Return name and path of the new Guest Configuration Policy package.
#>

function New-GuestConfigurationPackage {
    [CmdletBinding()]
    param (
        [parameter(Position = 0, Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [parameter(Position = 1, Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $Configuration,

        [ValidateNotNullOrEmpty()]
        [string] $ChefInspecProfilePath,

        [ValidateNotNullOrEmpty()]
        [string] $FilesToInclude,

        [string] $Path = '.',

        [switch] $Force
    )

    Try {
        $verbose = ($PSBoundParameters.ContainsKey("Verbose") -and ($PSBoundParameters["Verbose"] -eq $true))
        $unzippedPackagePath = New-Item -ItemType Directory -Force -Path (Join-Path (Join-Path $Path $Name) 'unzippedPackage')
        $Configuration = Resolve-Path $Configuration

        if (-not (Test-Path -Path $Configuration -PathType Leaf)) {
            Throw "Invalid mof file path, please specify full file path for dsc configuration in -Configuration parameter."
        }

        Write-Verbose "Creating Guest Configuration package in temporary directory '$unzippedPackagePath'"

        # Verify that only supported resources are used in DSC configuration.
        Test-GuestConfigurationMofResourceDependencies -Path $Configuration -Verbose:$verbose

        # Save DSC configuration to the temporary package path.
        Save-GuestConfigurationMofDocument -Name $Name -SourcePath $Configuration -DestinationPath (Join-Path $unzippedPackagePath "$Name.mof") -Verbose:$verbose

        # Copy DSC resources
        Copy-DscResources -MofDocumentPath $Configuration -Destination $unzippedPackagePath -Verbose:$verbose -Force:$Force

        if (-not [string]::IsNullOrEmpty($ChefInspecProfilePath)) {
            # Copy Chef resource and profiles.
            Copy-ChefInspecDependencies -PackagePath $unzippedPackagePath -Configuration $Configuration -ChefInspecProfilePath $ChefInspecProfilePath
        }

        # Copy FilesToInclude
        if (-not [string]::IsNullOrEmpty($FilesToInclude)) {
            $modulePath = Join-Path $unzippedPackagePath 'Modules'
            if (Test-Path $FilesToInclude -PathType Leaf) {
                Copy-Item -Path $FilesToInclude -Destination $modulePath  -Force:$Force
            }
            else {
                $filesToIncludeFolderName = Get-Item $FilesToInclude
                $FilesToIncludePath = Join-Path $modulePath $filesToIncludeFolderName.Name
                Copy-Item -Path $FilesToInclude -Destination $modulePath -Recurse  -Force:$Force
            }
        }

        # Create Guest Configuration Package.
        $packagePath = Join-Path $Path $Name
        New-Item -ItemType Directory -Force -Path $packagePath | Out-Null
        $packagePath = Resolve-Path $packagePath
        $packageFilePath = join-path $packagePath "$Name.zip"
        Remove-Item $packageFilePath -Force -ErrorAction SilentlyContinue

        Write-Verbose "Creating Guest Configuration package : $packageFilePath."
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::CreateFromDirectory($unzippedPackagePath, $packageFilePath)

        $result = [pscustomobject]@{
            Name = $Name
            Path = $packageFilePath
        }
        return $result
    }
    Finally {
    }
}
