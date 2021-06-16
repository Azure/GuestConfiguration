function Show-GuestConfigurationLatestAvailableModule
{
    [CmdletBinding()]
    [OutputType([void])]
    param
    (
        [Parameter(DontShow)]
        [Uri]
        $GalleryUrl = 'https://www.powershellgallery.com/api/v2/',

        [Parameter(DontShow)]
        [Int]
        $TimeoutSec = 1,

        [Parameter(DontShow)]
        [hashtable]
        $ManifestData = $GuestConfigurationManifest # Done in Prefix: Import-LocalizedData -BaseDirectory $PSScriptRoot -FileName GuestConfiguration.psd1 -BindingVariable GuestConfigurationManifest
    )

    try
    {
        # Test that the Find-Module command is available
        $findModuleCmdlet = Get-Command -Name 'Find-Module' -Module 'PowerShellGet'

        # Test that the Gallery is reachable
        $isGalleryReachable = (Invoke-WebRequest -Uri $GalleryUrl -TimeoutSec $TimeoutSec).StatusCode -eq 200

        # get whether the current module is a prerelease or a full release
        $isPrerelease = $false -eq [string]::IsNullOrEmpty($MyInvocation.MyCommand.Module.PrivateData.PSData.Prerelease)
        $RegisteredRepository = Get-PSRepository | Where-Object -FilterScript { $_.SourceLocation.TrimEnd('/') -match $GalleryUrl.ToString().TrimEnd('/')}
        $moduleSemVersion = $isPrerelease ? "$($ManifestData.ModuleVersion)-$($MyInvocation.MyCommand.Module.PrivateData.PSData.Prerelease)" : $ManifestData.ModuleVersion
        Write-Debug -Message "Current module version is '$moduleSemVersion'."

        if ($isGalleryReachable -and $RegisteredRepository -and $findModuleCmdlet)
        {
            # if the module is a prerelease, show newer releases.
            # if the module is a release, only show newer release (no pre)
            $latestModuleAvailable = Find-Module -Name GuestConfiguration -AllowPrerelease:$isPrerelease -MinimumVersion $moduleSemVersion

            if ($latestModuleAvailable.Version -ne $moduleSemVersion)
            {
                Write-Warning -Message "A newer version of this module is available: $($latestModuleAvailable.Version). Please consider updating with 'Update-Module -Name GuestConfiguration'."
            }
            else
            {
                Write-Debug -Message "This module version $($moduleSemVersion) seems to be the latest available. $($latestModuleAvailable.Version)"
            }
        }
    }
    catch
    {
        Write-Debug -Message "Cannot retrieve the latest available module. $_"
    }
}
