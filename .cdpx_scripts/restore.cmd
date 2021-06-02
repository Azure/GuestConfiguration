REM -----------------------------------------------------------------------------------------------------------------------------
REM
REM SYNOPSIS
REM This script is triggered by CDPx YML files to restore Nuget packages required by projects inside our main Visual Studio solution.
REM
REM ARGS1 RelativeLogFileName (Optional)
REM     The repo relative log file path where logs will be written to.
REM     Defaults to 'buildLogs\RestoreStorSimple.log' if not specified.
REM
REM NOTE
REM DO NOT ADD VSTS Build environment variables here as this script is designed to run on a CDPx local developer environment.
REM
REM -----------------------------------------------------------------------------------------------------------------------------

echo "Running restore command for Windows ..."

rem Save working directory so that we can restore it back after building everything. This will make developers happy and then
rem switch to the folder this script resides in. Don't assume absolute paths because on the build host and on the dev host the locations may be different.
pushd .
cd "%~dp0"

set guestConfigRoot=%CD%
echo extension root path ..%guestConfigRoot%...

echo "Installing chocolaty"
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
@REM call %SYSTEMDRIVE%\Windows\system32\WindowsPowershell\v1.0\Powershell.exe -ExecutionPolicy Unrestricted "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"

echo "Installing powershell 7"
call %SYSTEMDRIVE%\Windows\system32\WindowsPowershell\v1.0\Powershell.exe -ExecutionPolicy Unrestricted "choco install powershell-core --pre"

echo "Using powershell 7 to run build commands"
where.exe pwsh
call %SYSTEMDRIVE%\Program Files\PowerShell\7\pwsh.exe -ExecutionPolicy Unrestricted -File %guestConfigRoot%\restore.ps1

@REM call %SYSTEMDRIVE%\Windows\system32\WindowsPowershell\v1.0\Powershell.exe -ExecutionPolicy Unrestricted -File %guestConfigRoot%\restore.ps1


echo "Finished running build command  ..."

exit 0
