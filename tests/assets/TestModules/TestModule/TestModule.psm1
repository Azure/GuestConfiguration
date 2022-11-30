[DscResource()]
class TestResource
{
    [DscProperty(Key)]
    [String]
    $TestKey

    [TestResource] Get()
    {
        return $this
    }

    [bool] Test()
    {
        Import-Module -Name 'SubModule' -Force
        New-SubModuleFunction
        return $true
    }

    Set()
    {
        Write-Verbose -Message "Called Set"
    }
}
