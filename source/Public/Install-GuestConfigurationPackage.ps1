
<#
    .SYNOPSIS
        Installs a Guest Configuration policy package.

    .Parameter Path
        Full path of the zipped Guest Configuration package.

    .Example
        Install-GuestConfigurationPackage -Path ./custom_policy/WindowsTLS.zip

        Install-GuestConfigurationPackage -Path ./custom_policy/AuditWindowsService.zip

    .OUTPUTS
        None
#>

function Install-GuestConfigurationPackage
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Path
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

    $verbose = $PSBoundParameters.ContainsKey('Verbose') -and ($PSBoundParameters['Verbose'] -eq $true)
    $systemPSModulePath = [Environment]::GetEnvironmentVariable('PSModulePath', 'Process')

    try
    {
        # Create policy folder
        $Path = Resolve-Path -Path $Path
        $policyPath = Join-Path -Path $(Get-GuestConfigPolicyPath) -ChildPath ([System.IO.Path]::GetFileNameWithoutExtension($Path))
        Remove-Item -Path $policyPath -Recurse -Force -ErrorAction SilentlyContinue
        $null = New-Item -ItemType Directory -Force -Path $policyPath

        # Unzip policy package
        Expand-Archive -LiteralPath $Path -DestinationPath $policyPath

        # Get policy name
        $dscDocument = Get-ChildItem -Path $policyPath -Filter *.mof
        if (-not $dscDocument)
        {
            throw 'Invalid policy package, failed to find dsc document in policy package.'
        }

        $policyName = [System.IO.Path]::GetFileNameWithoutExtension($dscDocument)

        # Unzip Guest Configuration binaries
        $gcBinPath = Get-GuestConfigBinaryPath
        $gcBinRootPath = Get-GuestConfigBinaryRootPath

        # Unzip Guest Configuration binaries if missing
        if (-not (Test-Path -Path $gcBinPath))
        {
            Install-GuestConfigurationAgent -verbose:$verbose
        }

        # Publish policy package
        Publish-DscConfiguration -ConfigurationName $policyName -Path $policyPath -Verbose:$verbose

        # Clear Inspec profiles
        Remove-Item -Path (Get-InspecProfilePath) -Recurse -Force -ErrorAction SilentlyContinue
    }
    finally
    {
        $env:PSModulePath = $systemPSModulePath
    }

    return $policyPath
}
