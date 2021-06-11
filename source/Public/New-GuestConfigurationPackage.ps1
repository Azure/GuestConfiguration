
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
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
    param
    (
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Name,

        [Parameter(Position = 1, Mandatory = $true, ParameterSetName = 'Configuration', ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Configuration,

        [Parameter(ParameterSetName = 'Configuration')]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $ChefInspecProfilePath,

        [Parameter(ParameterSetName = 'Configuration')]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $FilesToInclude,

        [Parameter()]
        [System.String]
        $Path = '.',

        [Parameter()]
        [Experimental('GuestConfiguration.SetScenario', 'Show')]
        [PackageType]
        $Type = 'Audit',

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force
    )

    if (-not (Get-Variable -Name Type -ErrorAction SilentlyContinue))
    {
        $Type = 'Audit'
    }

    $verbose = ($PSBoundParameters.ContainsKey("Verbose") -and ($PSBoundParameters["Verbose"] -eq $true))
    $stagingPackagePath = Join-Path -Path (Join-Path -Path $Path -ChildPath $Name) -ChildPath 'unzippedPackage'
    $unzippedPackageDirectory = New-Item -ItemType Directory -Force -Path $stagingPackagePath
    $Configuration = Resolve-Path -Path $Configuration

    if (-not (Test-Path -Path $Configuration -PathType Leaf))
    {
        throw "Invalid mof file path, please specify full file path for dsc configuration in -Configuration parameter."
    }

    Write-Verbose -Message "Creating Guest Configuration package in temporary directory '$unzippedPackageDirectory'"

    # Verify that only supported resources are used in DSC configuration.
    Test-GuestConfigurationMofResourceDependencies -Path $Configuration -Verbose:$verbose

    # Save DSC configuration to the temporary package path.
    $configMOFPath = Join-Path -Path $unzippedPackageDirectory -ChildPath "$Name.mof"
    Save-GuestConfigurationMofDocument -Name $Name -SourcePath $Configuration -DestinationPath $configMOFPath -Verbose:$verbose

    # Copy DSC resources
    Copy-DscResources -MofDocumentPath $Configuration -Destination $unzippedPackageDirectory -Verbose:$verbose -Force:$Force

    # Modify metaconfig file
    <#
        ##Bug##

        This is not a valid metaconfig data
        {
          "Type": "AuditAndSet"
        }

        Guest Configuration doesnt understand 'Type' name and 'AuditAndSet' value.
        Correct property name is 'configurationMode'
        and allowed values for this property are 'MonitorOnly', 'ApplyAndAutoCorrect' & 'ApplyAndMonitor'.

        Disabling the metaconfig file generation for now.
    #>
    # $metaConfigPath = Join-Path -Path $unzippedPackageDirectory -ChildPath "$Name.metaconfig.json"
    # Update-GuestConfigurationPackageMetaconfig -metaConfigPath $metaConfigPath -Key 'Type' -Value $Type.toString()

    if (-not [string]::IsNullOrEmpty($ChefInspecProfilePath))
    {
        # Copy Chef resource and profiles.
        Copy-ChefInspecDependencies -PackagePath $unzippedPackageDirectory -Configuration $Configuration -ChefInspecProfilePath $ChefInspecProfilePath
    }

    # Copy FilesToInclude
    if (-not [string]::IsNullOrEmpty($FilesToInclude))
    {
        $modulePath = Join-Path $unzippedPackageDirectory 'Modules'
        if (Test-Path $FilesToInclude -PathType Leaf)
        {
            Copy-Item -Path $FilesToInclude -Destination $modulePath  -Force:$Force
        }
        else
        {
            $filesToIncludeFolderName = Get-Item -Path $FilesToInclude
            $FilesToIncludePath = Join-Path -Path $modulePath -ChildPath $filesToIncludeFolderName.Name
            Copy-Item -Path $FilesToInclude -Destination $FilesToIncludePath -Recurse -Force:$Force
        }
    }

    # Create Guest Configuration Package.
    $packagePath = Join-Path -Path $Path -ChildPath $Name
    $null = New-Item -ItemType Directory -Force -Path $packagePath
    $packagePath = Resolve-Path -Path $packagePath
    $packageFilePath = join-path -Path $packagePath -ChildPath "$Name.zip"
    if (Test-Path -Path $packageFilePath)
    {
        Remove-Item -Path $packageFilePath -Force -ErrorAction SilentlyContinue
    }

    Write-Verbose -Message "Creating Guest Configuration package : $packageFilePath."
    Compress-ArchiveByDirectory -Path $unzippedPackageDirectory -DestinationPath $packageFilePath -Force:$Force

    [pscustomobject]@{
        PSTypeName = 'GuestConfiguration.Package'
        Name = $Name
        Path = $packageFilePath
    }
}
