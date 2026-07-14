@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "HARBOR_REGISTRY=192.168.180.146:8082"
if not defined HARBOR_PROJECT set "HARBOR_PROJECT=smart-resume"
if not defined IMAGE_NAME set "IMAGE_NAME=smartresume"

if not "%~1"=="" (
    set "IMAGE_TAG=%~1"
) else (
    for /f %%i in ('git rev-parse --short HEAD 2^>nul') do set "IMAGE_TAG=%%i"
    if not defined IMAGE_TAG set "IMAGE_TAG=latest"
)

set "IMAGE=%HARBOR_REGISTRY%/%HARBOR_PROJECT%/%IMAGE_NAME%:%IMAGE_TAG%"

where docker >nul 2>nul
if errorlevel 1 (
    echo ERROR: Docker CLI was not found in PATH.
    exit /b 1
)

echo Logging in to %HARBOR_REGISTRY%...
docker login %HARBOR_REGISTRY%
if errorlevel 1 goto :failed

echo Building %IMAGE%...
docker build --file docker\Dockerfile --tag %IMAGE% .
if errorlevel 1 goto :failed

echo Pushing %IMAGE%...
docker push %IMAGE%
if errorlevel 1 goto :failed

echo.
echo Image published: %IMAGE%
echo On the server, set SMARTRESUME_IMAGE=%IMAGE% and run:
echo docker compose --env-file docker/.env.production -f docker/docker-compose.production.yml pull
echo docker compose --env-file docker/.env.production -f docker/docker-compose.production.yml up -d
goto :end

:failed
echo.
echo ERROR: The previous Docker command failed. Review the message above.

:end
pause
