function Get-GuestConfigurationPackageMetaConfig
{
    [CmdletBinding()]
    [OutputType([Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Path
    )

    $packageName = Get-GuestConfigurationPackageName -Path $Path
    $metadataFileName = '{0}.metaconfig.json' -f $packageName
    $metadataFile = Join-Path -Path $Path -ChildPath $metadataFileName

    if (Test-Path -Path $metadataFile)
    {
        Write-Debug -Message "Loading metadata from meta config file '$metadataFile'."
        $metadata = Get-Content -raw -Path $metadataFile | ConvertFrom-Json -AsHashtable -ErrorAction Stop
    }
    else
    {
        $metadata = @{}
    }

    #region Extra meta file until Agent supports one unique metadata file
    $extraMetadataFileName = 'extra.{0}' -f $metadataFileName
    $extraMetadataFile = Join-Path -Path $Path -ChildPath $extraMetadataFileName

    if (Test-Path -Path $extraMetadataFile)
    {
        Write-Debug -Message "Loading extra metadata from extra meta file '$extraMetadataFile'."
        $extraMetadata = Get-Content -raw -Path $extraMetadataFile | ConvertFrom-Json -AsHashtable -ErrorAction Stop

        foreach ($extraKey in $extraMetadata.keys)
        {
            if (-not $metadata.ContainsKey($extraKey))
            {
                $metadata[$extraKey] = $extraMetadata[$extraKey]
            }
            else
            {
                Write-Verbose -Message "The metadata '$extraKey' is already defined in '$metadataFile'."
            }
        }
    }
    #endregion

    return $metadata
}
