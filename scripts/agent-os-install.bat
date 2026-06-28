@echo off
:: agent-os-install wrapper for CMD (full name version of aoi)
:: Usage: agent-os-install [profile]
:: Profiles: react-nodejs (default), angular, angular-nestjs

if "%~1"=="" (
    bash "%USERPROFILE%/agent-os/scripts/project-install.sh"
) else (
    bash "%USERPROFILE%/agent-os/scripts/project-install.sh" --profile %1
)
