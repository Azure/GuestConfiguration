Write-Output("About to run build")

../build.ps1 -Tasks noop -ResolveDependency
../build.ps1 -Tasks build
