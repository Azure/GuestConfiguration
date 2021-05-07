function Install-GuestConfigurationAgent
{
    [CmdletBinding()]
    [OutputType([void])]
    param
    (
        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force
    )

    # Unzip Guest Configuration binaries
    $gcBinPath = Get-GuestConfigBinaryPath
    $gcBinRootPath = Get-GuestConfigBinaryRootPath
    $OsPlatform = Get-OSPlatform

    if ((-not (Test-Path -Path $gcBinPath)) -or $Force.IsPresent)
    {
        # Clean the bin folder
        Write-Verbose -Message "Removing existing installation from '$gcBinRootPath'."
        Remove-Item -Path $gcBinRootPath'\*' -Recurse -Force -ErrorAction SilentlyContinue
        $zippedBinaryPath = Join-Path -Path $(Get-GuestConfigurationModulePath) -ChildPath 'bin'

        if ($OsPlatform -eq 'Windows')
        {
            $zippedBinaryPath = Join-Path -Path $zippedBinaryPath -ChildPath 'DSC_Windows.zip'
        }
        else
        {
            # Linux zip package contains an additional DSC folder
            # Remove DSC folder from binary path to avoid two nested DSC folders.
            $null = New-Item -ItemType Directory -Force -Path $gcBinPath
            $gcBinPath = (Get-Item -Path $gcBinPath).Parent.FullName
            $zippedBinaryPath = Join-Path $zippedBinaryPath 'DSC_Linux.zip'
        }

        [System.IO.Compression.ZipFile]::ExtractToDirectory($zippedBinaryPath, $gcBinPath)

        if ($OsPlatform -ne 'Windows')
        {
            # Fix for “LTTng-UST: Error (-17) while registering tracepoint probe. Duplicate registration of tracepoint probes having the same name is not allowed.”
            Get-ChildItem -Path $gcBinPath -Filter libcoreclrtraceptprovider.so -Recurse | ForEach-Object {
                Remove-Item $_.FullName -Force -ErrorAction SilentlyContinue
            }

            chmod -R +x $gcBinPath
        }

    }
    else
    {
        Write-Verbose -Message "Guest Configuration Agent binaries already installed at '$gcBinPath', skipping."
    }
}
