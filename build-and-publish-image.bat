@echo off
setlocal ENABLEEXTENSIONS

REM Build a Docker image from the current project and publish (save) it under images/ with a date-time tag.
REM Usage:
REM   build-and-publish-image.bat <image_name> [build_context] [app_version]
REM Defaults:
REM   image_name   : rms
REM   build_context: . (current directory)
REM   app_version  : (omitted) — falls back to Dockerfile ARG default
REM Output:
REM   Saves image tarball to images/<image_name>-<timestamp>.tar and tags image as <image_name>:<timestamp>

REM Parse args
set IMAGE_NAME=%~1
set BUILD_CONTEXT=%~2
set APP_VERSION=%~3
if "%IMAGE_NAME%"=="" set IMAGE_NAME=rms
if "%BUILD_CONTEXT%"=="" set BUILD_CONTEXT=.
if "%APP_VERSION%"=="" set APP_VERSION=1.0.0

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

echo [INFO] Using image name: %IMAGE_NAME%
echo [INFO] Using image tag : %IMAGE_TAG%
if not "%APP_VERSION%"=="" echo [INFO] Using app version (build-arg): %APP_VERSION%

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

REM Build image (optionally pass APPLICATION_SERVICE_VERSION)
echo Building image %IMAGE_REF% from %BUILD_CONTEXT%
if "%APP_VERSION%"=="" (
  echo docker build -t "%IMAGE_NAME%:%IMAGE_TAG%" "%BUILD_CONTEXT%"
  docker build -t "%IMAGE_NAME%:%IMAGE_TAG%" "%BUILD_CONTEXT%"
) else (
  echo docker build --build-arg APPLICATION_SERVICE_VERSION="%APP_VERSION%" -t "%IMAGE_NAME%:%IMAGE_TAG%" "%BUILD_CONTEXT%"
  docker build --build-arg APPLICATION_SERVICE_VERSION="%APP_VERSION%" -t "%IMAGE_NAME%:%IMAGE_TAG%" "%BUILD_CONTEXT%"
)
if errorlevel 1 (
  echo [ERROR] Docker build failed.
  exit /b 1
)

REM Sanity check computed variables
if "%IMAGE_NAME%"=="" (
  echo [ERROR] Computed IMAGE_NAME is empty.
  exit /b 1
)
if "%IMAGE_TAG%"=="" (
  echo [ERROR] Computed IMAGE_TAG is empty.
  exit /b 1
)

REM Verify image exists before saving
docker image inspect "%IMAGE_NAME%:%IMAGE_TAG%" >nul 2>&1
if errorlevel 1 (
  echo [ERROR] Built image not found: %IMAGE_NAME%:%IMAGE_TAG%
  echo         Ensure the build completed successfully.
  exit /b 1
)

REM Cleanup: remove previously saved tarballs for this image name
set CLEAN_PATTERN=%IMAGES_DIR%\%IMAGE_NAME%-*.tar
if exist "%IMAGES_DIR%" (
  echo Cleaning old tarballs matching "%CLEAN_PATTERN%" ,if any...
  del /q "%CLEAN_PATTERN%" 2>nul
)

REM Save image tarball under images/
set IMAGE_TAR=%IMAGES_DIR%\%IMAGE_NAME%-%IMAGE_TAG%.tar

echo Saving image to "%IMAGE_TAR%"
REM Echo the exact docker save command for transparency
echo docker save -o "%IMAGE_TAR%" "%IMAGE_NAME%:%IMAGE_TAG%"
docker save -o "%IMAGE_TAR%" "%IMAGE_NAME%:%IMAGE_TAG%"
if errorlevel 1 (
  echo [ERROR] Docker save failed for %IMAGE_NAME%:%IMAGE_TAG%.
  echo         Check Docker daemon status and disk space.
  exit /b 1
)

echo [SUCCESS] Built and published image:
echo   Tag: %IMAGE_NAME%:%IMAGE_TAG%
echo   File: %IMAGE_TAR%
exit /b 0

