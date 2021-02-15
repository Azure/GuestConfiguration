
function Copy-DscResources {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $MofDocumentPath,

        [Parameter(Mandatory = $true)]
        [String]
        $Destination,

        [switch] $Force
    )
    $resourcesInMofDocument = [Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache]::ImportInstances($MofDocumentPath, 4)

    Write-Verbose 'Copy DSC resources ...'
    $modulePath = New-Item -ItemType Directory -Force -Path (Join-Path $Destination 'Modules')
    $guestConfigModulePath = New-Item -ItemType Directory -Force -Path (Join-Path $modulePath 'GuestConfiguration')
    try {
        $latestModule = @()
        $latestModule += Get-Module GuestConfiguration
        $latestModule += Get-Module GuestConfiguration -ListAvailable
        $latestModule = ($latestModule | Sort-Object Version -Descending)[0]
    }
    catch {
        write-error 'unable to find the GuestConfiguration module either as an imported module or in $env:PSModulePath'
    }
    Copy-Item "$($latestModule.ModuleBase)/DscResources/" "$guestConfigModulePath/DscResources/" -Recurse -Force
    Copy-Item "$($latestModule.ModuleBase)/helpers/" "$guestConfigModulePath/helpers/" -Recurse -Force
    Copy-Item "$($latestModule.ModuleBase)/GuestConfiguration.psd1" "$guestConfigModulePath/GuestConfiguration.psd1" -Force
    Copy-Item "$($latestModule.ModuleBase)/GuestConfiguration.psm1" "$guestConfigModulePath/GuestConfiguration.psm1" -Force

    # Copies DSC resource modules
    $modulesToCopy = @{ }
    $resourcesInMofDocument | ForEach-Object {
        if ($_.CimInstanceProperties.Name -contains 'ModuleName' -and $_.CimInstanceProperties.Name -contains 'ModuleVersion') {
            if ($_.ModuleName -ne 'GuestConfiguration') {
                $modulesToCopy[$_.CimClass.CimClassName] = @{ModuleName = $_.ModuleName; ModuleVersion = $_.ModuleVersion }
            }
        }
    }

    # PowerShell modules required by DSC resource module
    $powershellModulesToCopy = @{ }
    $modulesToCopy.Values | ForEach-Object {
        if ($_.ModuleName -ne 'GuestConfiguration') {
            $requiredModule = Get-Module -FullyQualifiedName @{ModuleName = $_.ModuleName; RequiredVersion = $_.ModuleVersion } -ListAvailable
            if (($requiredModule | Get-Member -MemberType 'Property' | ForEach-Object { $_.Name }) -contains 'RequiredModules') {
                $requiredModule.RequiredModules | ForEach-Object {
                    if ($null -ne $_.Version) {
                        $powershellModulesToCopy[$_.Name] = @{ModuleName = $_.Name; ModuleVersion = $_.Version }
                        Write-Verbose "$($_.Name) is a required PowerShell module"
                    }
                    else {
                        Write-Error "Unable to add required PowerShell module $($_.Name).  No version was specified in the module manifest RequiredModules property.  Please use module specification '@{ModuleName=;ModuleVersion=}'."
                    }
                }
            }
        }
    }

    $modulesToCopy += $powershellModulesToCopy

    $modulesToCopy.Values | ForEach-Object {
        $moduleToCopy = Get-Module -FullyQualifiedName @{ModuleName = $_.ModuleName; RequiredVersion = $_.ModuleVersion } -ListAvailable
        if ($null -ne $moduleToCopy) {
            if ($_.ModuleName -eq 'PSDesiredStateConfiguration') {
                Write-Error 'The configuration includes DSC resources from the Windows PowerShell 5.1 module "PSDesiredStateConfiguration" that are not available in PowerShell Core. Switch to the "PSDSCResources" module available from the PowerShell Gallery. Note that the File and Package resources are not yet available in "PSDSCResources".'
            }
            $moduleToCopyPath = New-Item -ItemType Directory -Force -Path (Join-Path $modulePath $_.ModuleName)
            Copy-Item "$($moduleToCopy.ModuleBase)/*" $moduleToCopyPath -Recurse -Force:$Force
        }
        else {
            Write-Error "Module $($_.ModuleName) version $($_.ModuleVersion) could not be found in `$env:PSModulePath"
        }
    }

    # Copy binary resources.
    $nativeResourcePath = New-Item -ItemType Directory -Force -Path (Join-Path $modulePath 'DscNativeResources')
    $resources = Get-DscResource -Module @{ModuleName='GuestConfiguration'; ModuleVersion=$latestModule.Version.ToString()}
    $resources | ForEach-Object {
        if ($_.ImplementedAs -eq 'Binary') {
            $binaryResourcePath = Join-Path (Join-Path $latestModule.ModuleBase 'DscResources') $_.ResourceType
            Get-ChildItem $binaryResourcePath/* -Include *.sh -Recurse | ForEach-Object { Convert-FileToUnixLineEndings -FilePath $_ }
            Copy-Item $binaryResourcePath/* -Include *.sh $modulePath -Recurse -Force
            Copy-Item $binaryResourcePath $nativeResourcePath -Recurse -Force
        }
    }

    # Remove DSC binaries from package (just a safeguard).
    $binaryPath = Join-Path $guestConfigModulePath 'bin'
    Remove-Item -Path $binaryPath -Force -Recurse -ErrorAction 'SilentlyContinue' | Out-Null
}
