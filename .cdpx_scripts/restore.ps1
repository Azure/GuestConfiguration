# Run Build Command
../build.ps1 -Tasks build -ResolveDependency
Import-Module GuestConfiguration -Force
../build.ps1 -Tasks test
