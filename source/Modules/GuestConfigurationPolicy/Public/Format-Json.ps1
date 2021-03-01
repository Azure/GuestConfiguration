
function Format-Json {
    [CmdletBinding()]
    [OutputType([String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $Json
    )

    $indent = 0
    $jsonLines = $Json -Split '\n'
    $formattedLines = @()
    $previousLine = ''

    foreach ($line in $jsonLines) {
        $skipAddingLine = $false
        if ($line -match '^\s*\}\s*' -or $line -match '^\s*\]\s*') {
            # This line contains  ] or }, decrement the indentation level
            $indent--
        }

        $formattedLine = (' ' * $indent * 4) + $line.TrimStart().Replace(':  ', ': ')

        if ($line -match '\s*".*"\s*:\s*\[' -or $line -match '\s*".*"\s*:\s*\{' -or $line -match '^\s*\{\s*' -or $line -match '^\s*\[\s*') {
            # This line contains [ or {, increment the indentation level
            $indent++
        }

        if ($previousLine.Trim().EndsWith("{")) {
            if ($formattedLine.Trim() -in @("}", "},")) {
                $newLine = "$($previousLine.TrimEnd())$($formattedLine.Trim())"
                #Write-Verbose -Message "FOUND SHORTENED LINE: $newLine"
                $formattedLines[($formattedLines.Count - 1)] = $newLine
                $previousLine = $newLine
                $skipAddingLine = $true
            }
        }

        if ($previousLine.Trim().EndsWith("[")) {
            if ($formattedLine.Trim() -in @("]", "],")) {
                $newLine = "$($previousLine.TrimEnd())$($formattedLine.Trim())"
                #Write-Verbose -Message "FOUND SHORTENED LINE: $newLine"
                $formattedLines[($formattedLines.Count - 1)] = $newLine
                $previousLine = $newLine
                $skipAddingLine = $true
            }
        }

        if (-not $skipAddingLine -and -not [String]::IsNullOrWhiteSpace($formattedLine)) {
            $previousLine = $formattedLine
            $formattedLines += $formattedLine
        }
    }

    $formattedJson = $formattedLines -join "`n"
    return $formattedJson
}
