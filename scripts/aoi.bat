@echo off
:: agent-os-install wrapper for CMD
:: Usage: aoi [profile]
:: Profiles: react-nodejs (default), react, angular, angular-nestjs,
::           nodejs, nestjs, vanilla-js, html-css

:: Find bash.exe — try PATH first, fall back to default Git for Windows location
set BASH=
for %%i in (bash.exe) do set BASH=%%~$PATH:i
if "%BASH%"=="" set BASH=C:\Program Files\Git\bin\bash.exe
if not exist "%BASH%" (
    echo Error: bash.exe not found.
    echo Install Git for Windows from https://git-scm.com/download/win
    exit /b 1
)

if "%~1"=="" (
    "%BASH%" "%USERPROFILE%/agent-os/scripts/project-install.sh"
) else (
    "%BASH%" "%USERPROFILE%/agent-os/scripts/project-install.sh" --profile %1
)
