function Get-GuestConfigurationPolicySectionFromTemplate
{
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $FileName
    )

    $templateFolderPath = Join-Path -Path $PSScriptRoot -ChildPath 'templates'
    $filePath = Join-Path -Path $templateFolderPath -ChildPath $FileName

    $fileContent = Get-Content -Path $filePath -Raw
    $fileContentObject = $fileContent | ConvertFrom-Json

    $fileContentHashtable = ConvertTo-OrderedHashtable -InputObject $fileContentObject

    return $fileContentHashtable
}
