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

echo "Using powershell 7 to run package commands"
runas /user:administrator """%SYSTEMDRIVE%\Program Files\PowerShell\7\pwsh.exe"" -ExecutionPolicy Unrestricted -File %guestConfigRoot%\package.ps1"
@REM runas /user:administrator pwsh.exe -ExecutionPolicy Unrestricted -Verb runAS -File %guestConfigRoot%\package.ps1
@REM Start-Process powershell -verb runas -ArgumentList "-ExecutionPolicy Unrestricted -File %guestConfigRoot%\package.ps1"
echo "Using powershell 7 to run package commands take 2"

"%SYSTEMDRIVE%\Program Files\PowerShell\7\pwsh.exe" -Command "& {Start-Process Powershell.exe -ArgumentList ""-ExecutionPolicy Unrestricted -NoProfile -File %guestConfigRoot%\package.ps1 -Verb runas""}"


call "%SYSTEMDRIVE%\Program Files\PowerShell\7\pwsh.exe" -ExecutionPolicy Unrestricted -File %guestConfigRoot%\package.ps1


echo "Finished running package command  ..."

exit 0
