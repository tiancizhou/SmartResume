@echo off
chcp 65001 >nul
setlocal EnableExtensions EnableDelayedExpansion

set "REGISTRY=192.168.180.146:8082"
set "REMOTE_IMAGE=192.168.180.146:8082/smart-resume/smartresume:latest"
set "PLATFORM=linux/amd64"

echo ========================================
echo   Image:    %REMOTE_IMAGE%
echo   Platform: %PLATFORM%
echo ========================================

echo [1] Logging in to Harbor ...
docker login "%REGISTRY%"
if errorlevel 1 goto :error

echo [2] Building image ...
docker buildx build --platform "%PLATFORM%" -f "docker/Dockerfile" -t "%REMOTE_IMAGE%" --load .
if errorlevel 1 goto :error

echo [3] Pushing image ...
docker push "%REMOTE_IMAGE%"
if errorlevel 1 goto :error

echo.
echo [DONE] %REMOTE_IMAGE%
goto :end

:error
echo.
echo [ERROR] Build or push failed. Review the message above.

:end
pause
