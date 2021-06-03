# Package the files
# TODO: Look at what the other pipeline does! The old one -- azure pipelines public
Write-Verbose "About to run pack command" -Verbose
../build.ps1 -tasks pack
