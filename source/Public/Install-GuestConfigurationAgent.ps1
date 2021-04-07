function Install-GuestConfigurationAgent
{
    [CmdletBinding()]
    [OutputType([void])]
    param
    (
    )

    # Unzip Guest Configuration binaries
    $gcBinPath = Get-GuestConfigBinaryPath
    $gcBinRootPath = Get-GuestConfigBinaryRootPath

    # Clean the bin folder
    Remove-Item -Path $gcBinRootPath'\*' -Recurse -Force -ErrorAction SilentlyContinue

    $zippedBinaryPath = Join-Path -Path $(Get-GuestConfigurationModulePath) -ChildPath 'bin'
    if ($(Get-OSPlatform) -eq 'Windows')
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
}
