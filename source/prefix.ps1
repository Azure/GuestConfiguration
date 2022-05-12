$currentCulture = [System.Globalization.CultureInfo]::CurrentCulture
if ($currentCulture.Name -eq 'en-US-POSIX')
{
    throw "'$($currentCulture.Name)' culture is not supported, please change to 'en-US'"
}
