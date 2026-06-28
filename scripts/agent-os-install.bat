@echo off
:: agent-os-install wrapper for CMD (full name version of aoi)
:: Usage: agent-os-install [profile]
:: Profiles: react-nodejs (default), angular, angular-nestjs

set BASH="C:\Program Files\Git\bin\bash.exe"

if "%~1"=="" (
    %BASH% "%USERPROFILE%/agent-os/scripts/project-install.sh"
) else (
    %BASH% "%USERPROFILE%/agent-os/scripts/project-install.sh" --profile %1
)
