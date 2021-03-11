<#
    .SYNOPSIS
        Tests a Guest Configuration policy package.

    .Parameter Path
        Full path of the zipped Guest Configuration package.

    .Parameter Parameter
        Policy parameters.

    .Example
        Test-GuestConfigurationPackage -Path ./custom_policy/WindowsTLS.zip

        $Parameter = @(
            @{
                ResourceType = "Service"            # dsc configuration resource type (mandatory)
                ResourceId = 'windowsService'       # dsc configuration resource property id (mandatory)
                ResourcePropertyName = "Name"       # dsc configuration resource property name (mandatory)
                ResourcePropertyValue = 'winrm'     # dsc configuration resource property value (mandatory)
            })

        Test-GuestConfigurationPackage -Path ./custom_policy/AuditWindowsService.zip -Parameter $Parameter

    .OUTPUTS
        Returns compliance details.
#>

function Test-GuestConfigurationPackage
{
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path,

        [Parameter()]
        [Hashtable[]]
        $Parameter = @()
    )

    if ($env:OS -notmatch "Windows" -and $IsMacOS)
    {
        throw 'The Test-GuestConfigurationPackage cmdlet is not supported on MacOS'
    }

    if (-not (Test-Path $Path -PathType Leaf))
    {
        throw 'Invalid Guest Configuration package path : $($Path)'
    }

    $verbose = ($PSBoundParameters.ContainsKey("Verbose") -and ($PSBoundParameters["Verbose"] -eq $true))
    $systemPSModulePath = [Environment]::GetEnvironmentVariable("PSModulePath", "Process")

    try
    {
        # Create policy folder
        $Path = Resolve-Path -Path $Path
        $policyPath = Join-Path $(Get-GuestConfigPolicyPath) ([System.IO.Path]::GetFileNameWithoutExtension($Path))
        Remove-Item $policyPath -Recurse -Force -ErrorAction SilentlyContinue
        $null = New-Item -ItemType Directory -Force -Path $policyPath

        # Unzip policy package.
        Expand-Archive -LiteralPath $Path $policyPath

        # Get policy name
        $dscDocument = Get-ChildItem -Path $policyPath -Filter *.mof
        if (-not $dscDocument)
        {
            throw "Invalid policy package, failed to find dsc document in policy package."
        }

        $policyName = [System.IO.Path]::GetFileNameWithoutExtension($dscDocument)

        # update configuration parameters
        if ($Parameter.Count -gt 0)
        {
            Update-MofDocumentParameters -Path $dscDocument.FullName -Parameter $Parameter
        }

        # Unzip Guest Configuration binaries
        $gcBinPath = Get-GuestConfigBinaryPath
        $gcBinRootPath = Get-GuestConfigBinaryRootPath
        if (-not (Test-Path -Path $gcBinPath))
        {
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

        # Publish policy package
        Publish-DscConfiguration -ConfigurationName $policyName -Path $policyPath -Verbose:$verbose

        # Set LCM settings to force load powershell module.
        $metaConfigPath = Join-Path -Path $policyPath -ChildPath "$policyName.metaconfig.json"
        "{""debugMode"":""ForceModuleImport""}" | Out-File $metaConfigPath -Encoding ascii
        Set-DscLocalConfigurationManager -ConfigurationName $policyName -Path $policyPath -Verbose:$verbose

        # Clear Inspec profiles
        Remove-Item -Path $(Get-InspecProfilePath) -Recurse -Force -ErrorAction SilentlyContinue

        $testResult = Test-DscConfiguration -ConfigurationName $policyName -Verbose:$verbose
        $getResult = @()
        $getResult = $getResult + (Get-DscConfiguration -ConfigurationName $policyName -Verbose:$verbose)

        $testResult.resources_not_in_desired_state | ForEach-Object {
            $resourceId = $_;
            if ($getResult.count -gt 1)
            {
                for ($i = 0; $i -lt $getResult.Count; $i++)
                {
                    if ($getResult[$i].ResourceId -ieq $resourceId)
                    {
                        $getResult[$i] = $getResult[$i] | Select-Object *, @{
                            n = 'complianceStatus'
                            e = { $false }
                        }
                    }
                }
            }
            elseif ($getResult.ResourceId -ieq $resourceId)
            {
                $getResult = $getResult | Select-Object *, @{
                    n = 'complianceStatus'
                    e = { $false }
                }
            }
        }

        $testResult.resources_in_desired_state | ForEach-Object {
            $resourceId = $_
            if ($getResult.count -gt 1)
            {
                for ($i = 0; $i -lt $getResult.Count; $i++)
                {
                    if ($getResult[$i].ResourceId -ieq $resourceId)
                    {
                        $getResult[$i] = $getResult[$i] | Select-Object *, @{
                            n = 'complianceStatus'
                            e = { $true }
                        }
                    }
                }
            }
            elseif ($getResult.ResourceId -ieq $resourceId)
            {
                $getResult = $getResult | Select-Object *, @{
                    n = 'complianceStatus'
                    e = { $true }
                }
            }
        }

        [PSCustomObject]@{
            complianceStatus = $testResult.compliance_state
            resources        = $getResult
        }
    }
    finally
    {
        $env:PSModulePath = $systemPSModulePath
    }
}
