@echo off
setlocal ENABLEDELAYEDEXPANSION

REM Build the Docker image for the rms project and save it to the sibling images folder.
REM This script assumes it is placed at the same level as the 'rms' directory.

REM Usage:
REM   build_and_save_image.bat [image_name] [tag]
REM Defaults:
REM   image_name: rms
REM   tag       : yyyyMMdd-HHmmss (timestamp)
REM Example:
REM   build_and_save_image.bat my-app 20260104-101530
REM   build_and_save_image.bat my-app
REM   build_and_save_image.bat

if /I "%~1"=="/h" goto :help
if /I "%~1"=="-h" goto :help
if /I "%~1"=="--help" goto :help

REM Script directory (should be the workspace root containing 'rms' and 'images')
set SCRIPT_DIR=%~dp0

REM Paths
set RMS_DIR=%SCRIPT_DIR%rms
set IMAGES_DIR=%SCRIPT_DIR%images

REM Parameters
set IMAGE_NAME=%~1
if "%IMAGE_NAME%"=="" set IMAGE_NAME=rms
set IMAGE_TAG=%~2

REM Generate timestamp if tag not provided
if "%IMAGE_TAG%"=="" (
  for /f "usebackq tokens=*" %%I in (`powershell -NoProfile -Command "(Get-Date).ToString('yyyyMMdd-HHmmss')"`) do set IMAGE_TAG=%%I
)

REM Ensure paths exist
if not exist "%RMS_DIR%" (
  echo ERROR: Expected directory not found: "%RMS_DIR%"
  echo Place this script alongside the 'rms' folder and run again.
  exit /b 1
)

if not exist "%IMAGES_DIR%" (
  echo Creating images directory at "%IMAGES_DIR%"...
  mkdir "%IMAGES_DIR%"
  if errorlevel 1 (
    echo ERROR: Failed to create images directory.
    exit /b 1
  )
)

REM Check Docker availability
where docker >nul 2>&1
if errorlevel 1 (
  echo ERROR: Docker not found in PATH.
  exit /b 1
)

REM Build the Docker image from the Dockerfile in the rms directory
echo Building Docker image %IMAGE_NAME%:%IMAGE_TAG% from "%RMS_DIR%"...
pushd "%RMS_DIR%" >nul

docker build -t %IMAGE_NAME%:%IMAGE_TAG% .
if errorlevel 1 (
  echo ERROR: Docker build failed.
  popd >nul
  exit /b 1
)

popd >nul

REM Save the image tarball to the images directory
set IMAGE_TAR=%IMAGES_DIR%\%IMAGE_NAME%-%IMAGE_TAG%.tar

echo Saving image to "%IMAGE_TAR%"...
docker save -o "%IMAGE_TAR%" %IMAGE_NAME%:%IMAGE_TAG%
if errorlevel 1 (
  echo ERROR: docker save failed.
  exit /b 1
)

echo SUCCESS: Image saved to "%IMAGE_TAR%".
exit /b 0

:help
echo.
echo Usage: build_and_save_image.bat [image_name] [tag]
echo   image_name: Name for the Docker image ^(default: rms^)
echo   tag       : Tag for the image; defaults to current timestamp ^(yyyyMMdd-HHmmss^)
echo Examples:
echo   build_and_save_image.bat

echo   build_and_save_image.bat rms 20260104-101530

echo   build_and_save_image.bat my-app
exit /b 0
