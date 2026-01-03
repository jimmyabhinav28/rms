@echo off
setlocal ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

REM Build a Docker image from the current project and publish (save) it under images/ with a date-time tag.
REM Usage:
REM   build-and-publish-image.bat <image_name> [build_context]
REM Defaults:
REM   image_name   : rms-app
REM   build_context: . (current directory)
REM Output:
REM   Saves image tarball to images/<image_name>-<timestamp>.tar and tags image as <image_name>:<timestamp>

REM Parse args
set IMAGE_NAME=%~1
set BUILD_CONTEXT=%~2
if "%IMAGE_NAME%"=="" set IMAGE_NAME=rms-app
if "%BUILD_CONTEXT%"=="" set BUILD_CONTEXT=.

REM Check Docker
where docker >nul 2>&1
if errorlevel 1 (
  echo [ERROR] Docker not found in PATH.
  exit /b 1
)

REM Generate timestamp safe for tags and filenames (yyyyMMdd-HHmmss)
for /f "usebackq tokens=*" %%I in (`powershell -NoProfile -Command "(Get-Date).ToString('yyyyMMdd-HHmmss')"`) do set TS=%%I
if "%TS%"=="" (
  echo [ERROR] Failed to generate timestamp.
  exit /b 1
)

set IMAGE_TAG=%TS%
set IMAGE_REF=%IMAGE_NAME%:%IMAGE_TAG%

REM Ensure images directory exists (relative to this script location)
set SCRIPT_DIR=%~dp0
set IMAGES_DIR=%SCRIPT_DIR%images
if not exist "%IMAGES_DIR%" (
  mkdir "%IMAGES_DIR%" 2>nul
  if errorlevel 1 (
    echo [ERROR] Failed to create images directory: %IMAGES_DIR%
    exit /b 1
  )
)

REM Verify build context
if not exist "%BUILD_CONTEXT%" (
  echo [ERROR] Build context not found: %BUILD_CONTEXT%
  exit /b 1
)
if not exist "%BUILD_CONTEXT%\Dockerfile" (
  echo [ERROR] No Dockerfile found in build context: %BUILD_CONTEXT%
  exit /b 1
)

REM Build image
echo Building image %IMAGE_REF% from %BUILD_CONTEXT%
docker build -t %IMAGE_REF% "%BUILD_CONTEXT%"
if errorlevel 1 (
  echo [ERROR] Docker build failed.
  exit /b 1
)

REM Save image tarball under images/
set IMAGE_TAR=%IMAGES_DIR%\%IMAGE_NAME%-%IMAGE_TAG%.tar

echo Saving image to %IMAGE_TAR%
docker save -o "%IMAGE_TAR" %IMAGE_REF%
if errorlevel 1 (
  echo [ERROR] Docker save failed.
  exit /b 1
)

echo [SUCCESS] Built and published image:
echo   Tag: %IMAGE_REF%
echo   File: %IMAGE_TAR%
exit /b 0

