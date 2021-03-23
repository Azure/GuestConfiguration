<#
    .SYNOPSIS
        Tests a Guest Configuration policy package.

    .Parameter Path
        Full path of the zipped Guest Configuration package.

    .Parameter Parameter
        Policy parameters.

    .Example
        Install-GuestConfigurationPackage -Path ./custom_policy/WindowsTLS.zip

        $Parameter = @(
            @{
                ResourceType = "Service"            # dsc configuration resource type (mandatory)
                ResourceId = 'windowsService'       # dsc configuration resource property id (mandatory)
                ResourcePropertyName = "Name"       # dsc configuration resource property name (mandatory)
                ResourcePropertyValue = 'winrm'     # dsc configuration resource property value (mandatory)
            })

        Install-GuestConfigurationPackage -Path ./custom_policy/AuditWindowsService.zip -Parameter $Parameter

    .OUTPUTS
        Returns compliance details.
#>

function Install-GuestConfigurationPackage {
    [CmdletBinding()]
    param (
        [parameter(Position = 0, Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $Path,

        [parameter(Mandatory = $false)]
        [Hashtable[]] $Parameter = @()
    )
    if ($env:OS -notmatch "Windows" -and $IsMacOS) {
        Throw 'The Test-GuestConfigurationPackage cmdlet is not supported on MacOS'
    }

    if (-not (Test-Path $Path -PathType Leaf)) {
        Throw 'Invalid Guest Configuration package path : $($Path)'
    }

    $verbose = ($PSBoundParameters.ContainsKey("Verbose") -and ($PSBoundParameters["Verbose"] -eq $true))
    $systemPSModulePath = [Environment]::GetEnvironmentVariable("PSModulePath", "Process")

    Try {
        # Create policy folder
        $Path = Resolve-Path $Path
        $policyPath = Join-Path $(Get-GuestConfigPolicyPath) ([System.IO.Path]::GetFileNameWithoutExtension($Path))
        Remove-Item $policyPath -Recurse -Force -ErrorAction SilentlyContinue
        New-Item -ItemType Directory -Force -Path $policyPath | Out-Null

        # Unzip policy package.
        Expand-Archive -LiteralPath $Path $policyPath

        # Get policy name
        $dscDocument = Get-ChildItem -Path $policyPath -Filter *.mof
        if (-not $dscDocument) {
            Throw "Invalid policy package, failed to find dsc document in policy package."
        }
        $policyName = [System.IO.Path]::GetFileNameWithoutExtension($dscDocument)

        # update configuration parameters
        if ($Parameter.Count -gt 0) {
            Update-MofDocumentParameters -Path $dscDocument.FullName -Parameter $Parameter
        }

        # Unzip Guest Configuration binaries
        $gcBinPath = Get-GuestConfigBinaryPath
        $gcBinRootPath = Get-GuestConfigBinaryRootPath
        if (-not (Test-Path $gcBinPath)) {
            # Clean the bin folder
            Remove-Item $gcBinRootPath'\*' -Recurse -Force -ErrorAction SilentlyContinue

            $zippedBinaryPath = Join-Path $(Get-GuestConfigurationModulePath) 'bin'
            if ($(Get-OSPlatform) -eq 'Windows') {
                $zippedBinaryPath = Join-Path $zippedBinaryPath 'DSC_Windows.zip'
            }
            else {
                # Linux zip package contains an additional DSC folder
                # Remove DSC folder from binary path to avoid two nested DSC folders.
                New-Item -ItemType Directory -Force -Path $gcBinPath | Out-Null
                $gcBinPath = (Get-Item $gcBinPath).Parent.FullName
                $zippedBinaryPath = Join-Path $zippedBinaryPath 'DSC_Linux.zip'
            }
            [System.IO.Compression.ZipFile]::ExtractToDirectory($zippedBinaryPath, $gcBinPath)
        }

        # Publish policy package
        Publish-DscConfiguration -ConfigurationName $policyName -Path $policyPath -Verbose:$verbose

        # Set LCM settings to force load powershell module.
        $metaConfigPath = Join-Path $policyPath "$policyName.metaconfig.json"
        "{""debugMode"":""ForceModuleImport""}" | Out-File $metaConfigPath -Encoding ascii
        Set-DscLocalConfigurationManager -ConfigurationName $policyName -Path $policyPath -Verbose:$verbose

        # Clear Inspec profiles
        Remove-Item $(Get-InspecProfilePath) -Recurse -Force -ErrorAction SilentlyContinue
    }
    Finally {
        $env:PSModulePath = $systemPSModulePath
    }

}
