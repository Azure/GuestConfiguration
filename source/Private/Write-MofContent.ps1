function Write-MofContent
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        $MofInstances,

        [Parameter(Mandatory = $true)]
        [String]
        $OutputPath
    )

    $content = ''
    $resourceCount = 0

    foreach ($mofInstance in $MofInstances)
    {
        $resourceClassName = $mofInstance.CimClass.CimClassName
        $content += "instance of $resourceClassName"

        if ($resourceClassName -ne 'OMI_ConfigurationDocument')
        {
            $content += ' as $' + "$resourceClassName$resourceCount"
        }

        $content += "`n{`n"
        foreach ($cimProperty in $mofInstance.CimInstanceProperties)
        {
            $content += " $($cimProperty.Name)"
            if ($cimProperty.CimType -eq 'StringArray')
            {
                $content += " = {""$($cimProperty.Value -replace '[""\\]','\$&')""}; `n"
            }
            else
            {
                $content += " = ""$($cimProperty.Value -replace '[""\\]','\$&')""; `n"
            }
        }

        $content += "};`n"

        $resourceCount++
    }

    $null = Set-Content -Path $OutputPath -Value $content -Force
}
