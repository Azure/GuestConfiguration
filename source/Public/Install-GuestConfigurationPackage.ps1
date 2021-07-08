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
        [Alias('Path')]
        $Package,

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
        $PackageZipPath = $null
        if (($Package -as [uri]).Scheme -match '^http')
        {
            # Get the package from URI to a temp folder
            $PackageZipPath = (Get-GuestConfigurationPackageFromUri -Uri $Package -Verbose:$verbose).ToString()
        }
        elseif ((Test-Path -PathType 'Leaf' -Path $Package) -and $Package -match '\.zip$')
        {
            $PackageZipPath = (Resolve-Path -Path $Package).ToString()
        }
        else
        {
            Write-Debug -Message "'$Package' is the Package Name."
            # The $Package parameter is the PackageName, no need to version check.
            # If package name is not installed, throw an error
            try
            {
                $packageName = $Package
                $installedPackagePath = Join-Path -Path $guestConfigurationPolicyPath -ChildPath $Package -Resolve
                $isPackageAlreadyInstalled = $true
            }
            catch
            {
                throw "The Package '$Package' is not installed. Please provide the Path to the Zip or the URL to download the package from."
                return
            }
        }

        if ($PackageZipPath)
        {
            Write-Debug -Message "Getting package name from '$PackageZipPath'."
            $isPackageAlreadyInstalled = $false
            $packageName = Get-GuestConfigurationPackageNameFromZip -Path $PackageZipPath
            $packageZipMetadata = Get-GuestConfigurationPackageMetadataFromZip -Path $PackageZipPath -Verbose:$verbose
            $installedPackagePath = Join-Path -Path $guestConfigurationPolicyPath -ChildPath $packageName
        }
        else
        {
            $packageZipMetadata = Get-GuestConfigurationPackageMetaConfig -Path $installedPackagePath
        }

        if (Test-Path -Path $installedPackagePath)
        {
            Write-Debug -Message "The Package '$PackageName' exists at '$installedPackagePath'. Checking version..."
            $installedPackageMetadata = Get-GuestConfigurationPackageMetaConfig -Path $installedPackagePath -Verbose:$verbose

            if
            (   # None of the packages are versioned or the versions match, we're good
                -not ($installedPackageMetadata.ContainsKey('Version') -or $packageZipMetadata.Contains('Version')) -or
                ($installedPackageMetadata.ContainsKey('Version') -ne $packageZipMetadata.Contains('Version')) -or # to avoid next statement
                $installedPackageMetadata.Version -eq $packageZipMetadata.Version
            )
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

        # Do not re-install if package name was passed with force, since we do not have access to the zip file
        if ((-not $isPackageAlreadyInstalled) -or ($withForce -and (-not $packageName -eq $Package)))
        {
            Write-Debug -Message "Removing existing package at '$installedPackagePath'."
            Remove-Item -Path $installedPackagePath -Recurse -Force -ErrorAction SilentlyContinue
            $null = New-Item -ItemType Directory -Force -Path $installedPackagePath
            # Unzip policy package
            Write-Verbose -Message "Unzipping the Guest Configuration Package to '$installedPackagePath'."
            Expand-Archive -LiteralPath $PackageZipPath -DestinationPath $installedPackagePath -ErrorAction Stop -Force
        }
        elseif ($withForce -and ($packageName -eq $Package))
        {
            Write-Verbose -Message "Cannot force package reinstallation with package name."
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
        if (($Package -as [uri]).Scheme -match '^http')
        {
            Write-Debug -Message "Removing the Package zip at '$PackageZipPath' that was downloaded from URI."
            Remove-Item -Force -ErrorAction SilentlyContinue -Path $PackageZipPath
        }
    }

    return $installedPackagePath
}
