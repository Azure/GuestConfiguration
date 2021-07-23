<#
    .SYNOPSIS
        Installs a Guest Configuration policy package.

    .Parameter Package
        Path or Uri of the Guest Configuration package zip.

    .Parameter Force
        Force installing over an existing package, even if it already exists.

    .Example
        Install-GuestConfigurationPackage -Path ./custom_policy/WindowsTLS.zip

        Install-GuestConfigurationPackage -Path ./custom_policy/AuditWindowsService.zip -Force

    .OUTPUTS
        The path to the installed Guest Configuration package.
#>

function Install-GuestConfigurationPackage
{
    [CmdletBinding()]
    [Experimental('GuestConfiguration.SetScenario', 'Show')]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
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


    $verbose = $VerbosePreference -ne 'SilentlyContinue' -or ($PSBoundParameters.ContainsKey('Verbose') -and ($PSBoundParameters['Verbose'] -eq $true))
    $systemPSModulePath = [Environment]::GetEnvironmentVariable('PSModulePath', 'Process')
    $guestConfigurationPolicyPath = Get-GuestConfigPolicyPath

    try
    {
        # Unzip Guest Configuration binaries if missing
        Install-GuestConfigurationAgent -verbose:$verbose

        # Resolve the zip (to temp folder if URI)
        if (($Path -as [uri]).Scheme -match '^http')
        {
            # Get the package from URI to a temp folder
            $PackageZipPath = (Get-GuestConfigurationPackageFromUri -Uri $Path -Verbose:$verbose).ToString()
        }
        elseif ((Test-Path -PathType 'Leaf' -Path $Path) -and $Path -match '\.zip$')
        {
            $PackageZipPath = (Resolve-Path -Path $Path).ToString()
        }
        else
        {
            Write-Debug -Message "'$Path' is the Package Name."
            # The $Path parameter is the PackageName, no need to version check.
            # if package name is not installed, throw an error
            try
            {
                $installedPackagePath = Join-Path -Path $guestConfigurationPolicyPath -ChildPath $Path -Resolve
            }
            catch
            {
                throw "The Package '$Package' is not installed. Please provide the Path to the Zip or the URL to download the package from."
                return
            }
        }


        Write-Debug -Message "Getting package name from '$PackageZipPath'."
        $packageName = Get-GuestConfigurationPackageNameFromZip -Path $PackageZipPath
        $packageZipMetadata = Get-GuestConfigurationPackageMetadataFromZip -Path $PackageZipPath -Verbose:$verbose
        $installedPackagePath = Join-Path -Path $guestConfigurationPolicyPath -ChildPath $packageName
        $isPackageAlreadyInstalled = $false

        if (Test-Path -Path $installedPackagePath)
        {
            Write-Debug -Message "The Package '$PackageName' exists at '$installedPackagePath'. Checking version..."
            $installedPackageMetadata = Get-GuestConfigurationPackageMetaConfig -Path $installedPackagePath -Verbose:$verbose

            # None of the packages are versioned or the versions match, we're good
            if (-not ($installedPackageMetadata.ContainsKey('Version') -or $packageZipMetadata.Contains('Version')) -or
                ($installedPackageMetadata.ContainsKey('Version') -ne $packageZipMetadata.Contains('Version')) -or # to avoid next statement
                $installedPackageMetadata.Version -eq $packageZipMetadata.Version)
            {
                $isPackageAlreadyInstalled = $true
                Write-Debug -Message ("Package '{0}{1}' is installed." -f $PackageName,($packageZipMetadata.Contains('Version') ? "_$($packageZipMetadata['Version'])" : ''))
            }
            else
            {
                Write-Verbose -Message "Package '$packageName' was found at version '$($installedPackageMetadata.Version)' but we're expecting '$($packageZipMetadata.Version)'."
            }
        }

        if ($PSBoundParameters.ContainsKey('Force') -and $PSBoundParameters['Force'])
        {
            $withForce = $true
        }
        else
        {
            $withForce = $false
        }

        if ((-not $isPackageAlreadyInstalled) -or $withForce)
        {
            Write-Debug -Message "Removing existing package at '$installedPackagePath'."
            Remove-Item -Path $installedPackagePath -Recurse -Force -ErrorAction SilentlyContinue
            $null = New-Item -ItemType Directory -Force -Path $installedPackagePath
            # Unzip policy package
            Write-Verbose -Message "Unzipping the Guest Configuration Package to '$installedPackagePath'."
            Expand-Archive -LiteralPath $PackageZipPath -DestinationPath $installedPackagePath -ErrorAction Stop -Force
        }
        else
        {
            Write-Verbose -Message "Package is already installed at '$installedPackagePath', skipping install."
        }

        # Clear Inspec profiles
        Remove-Item -Path (Get-InspecProfilePath) -Recurse -Force -ErrorAction SilentlyContinue
    }
    finally
    {
        $env:PSModulePath = $systemPSModulePath

        # If we downloaded the Zip file from URI to temp folder, do cleanup
        if (($Path -as [uri]).Scheme -match '^http')
        {
            Write-Debug -Message "Removing the Package zip at '$PackageZipPath' that was downloaded from URI."
            Remove-Item -Force -ErrorAction SilentlyContinue -Path $PackageZipPath
        }
    }

    return $installedPackagePath
}
