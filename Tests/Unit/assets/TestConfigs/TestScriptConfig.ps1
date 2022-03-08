Configuration TestScriptConfig {
    Import-DscResource -ModuleName 'PSDscResources'

    Node localhost {
        Script MyTestScript {
            SetScript  = { $null = New-Item -Path 'C:\Test-GC-Folder' -ItemType 'Directory'}
            TestScript = { return (Test-Path -Path 'C:\Test-GC-Folder') }
            GetScript  = {
                $fileExists = Test-Path -Path 'C:\Test-GC-Folder'
                return @{
                    Result = @{
                        Reasons = @(
                            @{
                                Code = 'ScriptReason'
                                Phrase = "Test-Path for file at 'C:\Test-GC-Folder' returns $fileExists"
                            }
                        )
                    }
                }
            }
        }
    }
}

TestScriptConfig
