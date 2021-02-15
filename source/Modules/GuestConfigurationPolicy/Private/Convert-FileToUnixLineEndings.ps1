function Convert-FileToUnixLineEndings {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $FilePath
    )

    $fileContent = Get-Content -Path $FilePath -Raw
    $fileContentWithLinuxLineEndings = $fileContent.Replace("`r`n", "`n")
    $null = Set-Content -Path $FilePath -Value $fileContentWithLinuxLineEndings -Force -NoNewline
    Write-Verbose -Message "Converted the file at the path '$FilePath' to Unix line endings."
}
