<#
    .SYNOPSIS
        Installs a Guest Configuration policy package.

    .Parameter Path
        Full path of the zipped Guest Configuration package.

    .Parameter Force
        Force installing over an existing package, even if it already exists.

    .Example
        Install-GuestConfigurationPackage -Path ./custom_policy/WindowsTLS.zip

        Install-GuestConfigurationPackage -Path ./custom_policy/AuditWindowsService.zip

    .OUTPUTS
        The path to the installed Guest Configuration package.
#>

function Install-GuestConfigurationPackage
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        [Alias('Package')]
        $Path,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [System.Management.Automation.SwitchParameter]
        $Force
    )

    $osPlatform = Get-OSPlatform

    if ($osPlatform -eq 'MacOS')
    {
        throw 'The Install-GuestConfigurationPackage cmdlet is not supported on MacOS'
    }

    if (-not (Test-Path -Path $Path -PathType Leaf))
    {
        throw 'Invalid Guest Configuration package path : $($Path)'
    }

    $verbose = $VerbosePreference -ne 'SilentlyContinue' -or ($PSBoundParameters.ContainsKey('Verbose') -and ($PSBoundParameters['Verbose'] -eq $true))
    $systemPSModulePath = [Environment]::GetEnvironmentVariable('PSModulePath', 'Process')

    # Unzip Guest Configuration binaries if missing
    Install-GuestConfigurationAgent -verbose:$verbose

    try
    {
        # Create policy folder
        $Path = Resolve-Path -Path $Path
        $packageName = Get-GuestConfigurationPackageNameFromZip -Path $Path
        $packagePath = Join-Path -Path $(Get-GuestConfigPolicyPath) -ChildPath $packageName
        $isPackageAlreadyInstalled = (Test-Path -Path $packagePath) -and (Test-Path -Path (Join-Path -Path $packagePath -ChildPath "$PackageName.mof"))

        if ((-not $isPackageAlreadyInstalled) -or $Force.IsPresent)
        {
            Remove-Item -Path $packagePath -Recurse -Force -ErrorAction SilentlyContinue
            $null = New-Item -ItemType Directory -Force -Path $packagePath
            # Unzip policy package
            Write-Verbose -Message "Unzipping the Guest Configuration Package to '$packagePath'."
            Expand-Archive -LiteralPath $Path -DestinationPath $packagePath -ErrorAction Stop
        }
        else
        {
            Write-Verbose -Message "Package is already installed at '$packagePath', skipping install."
        }

        # Clear Inspec profiles
        Remove-Item -Path (Get-InspecProfilePath) -Recurse -Force -ErrorAction SilentlyContinue
    }
    finally
    {
        $env:PSModulePath = $systemPSModulePath
    }

    return $packagePath
}
