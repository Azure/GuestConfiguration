function Install-GuestConfigurationPackage
{
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [System.String[]]
        [ValidateScript({$_.Where{-not ((Test-Path -Path $_ -PathType 'Leaf') -or (([uri]$_).Scheme -match 'http'))}})]
        # Each package should either be a local or UNC path to a file (not a folder), or an uri of http/https scheme
        # When it's an URI, we can't assume it will end with .zip
        $Package
    )

    begin
    {
        # Determine if verbose is enabled to pass down to other functions
        $verbose = ($PSBoundParameters.ContainsKey("Verbose") -and ($PSBoundParameters["Verbose"] -eq $true))
        $guestConfigPolicyPath = Get-GuestConfigPolicyPath
    }

    process
    {
        foreach ($PackageItem in $Package)
        {
            if ($PackageItem -as [uri])
            {
                # Download the package from http/s
                $PackageItemPath = (Get-GuestConfigurationPackageFromUri -Path $PackageItem).FullName
            }
            else
            {
                $PackageItemPath = [System.Io.Path]::GetFullPath($PackageItem, $PWD.Path)
            }

            $packageName = Get-GuestConfigurationPackageNameFromZip -Path $PackageItemPath
            $destinationPackagePath = Join-Path -Path $guestConfigPolicyPath -ChildPath $packageName

            if (Test-Path -Path $destinationPackagePath)
            {
                Write-Debug -Message "The package '$packageName' already exists. Cleaning up..."
                Remove-Item -Path $destinationPackagePath -Force -Recurse -ErrorAction 'Stop'
            }

            $null = Expand-Archive -LiteralPath $PackageItemPath -DestinationPath $destinationPackagePath -Verbose:$verbose

            return $destinationPackagePath
        }
    }
}
