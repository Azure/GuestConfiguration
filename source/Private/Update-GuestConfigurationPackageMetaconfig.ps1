function Update-GuestConfigurationPackageMetaconfig
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $MetaConfigPath,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Key,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Value
    )

    $metadataFile = $MetaConfigPath

    #region Write extra metadata on different file until the GC Agents supports it
    if ($Key -notin @('debugMode','ConfigurationModeFrequencyMins','configurationMode'))
    {
        $fileName = Split-Path -Path $MetadataFile -Leaf
        $filePath = Split-Path -Path $MetadataFile -Parent
        $metadataFileName = 'extra.{0}' -f $fileName

        $metadataFile = Join-Path -Path $filePath -ChildPath $metadataFileName
    }
    #endregion

    Write-Debug -Message "Updating the file '$metadataFile' with key $Key = '$Value'."

    if (Test-Path -Path $metadataFile)
    {
        $metaConfigObject = Get-Content -Raw -Path $metadataFile | ConvertFrom-Json -AsHashtable
        $metaConfigObject[$Key] = $Value
        $metaConfigObject | ConvertTo-Json | Out-File -Path $metadataFile -Encoding ascii -Force
    }
    else
    {
        @{
            $Key = $Value
        } | ConvertTo-Json | Out-File -Path $metadataFile -Encoding ascii -Force
    }
}
