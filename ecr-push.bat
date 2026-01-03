@echo off
setlocal ENABLEDELAYEDEXPANSION

REM Push a Docker image from ../images/<name> to AWS ECR
REM Usage:
REM   ecr-push.bat <image_name> [tag] [aws_region]
REM Requirements: AWS CLI, Docker. AWS credentials via env vars (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, optional AWS_SESSION_TOKEN).
REM Assumptions: Build context at ..\images\<image_name> with a Dockerfile.

if "%~1"=="" goto :help
if "%~1"=="/h" goto :help
if "%~1"=="-h" goto :help
if "%~1"=="--help" goto :help

set IMAGE_NAME=%~1
set IMAGE_TAG=%~2
set INPUT_REGION=%~3

REM -- if "%IMAGE_TAG%"=="" set IMAGE_TAG=latest
if not "%INPUT_REGION%"=="" set "AWS_DEFAULT_REGION=%INPUT_REGION%"

REM Validate AWS creds
if "%AWS_ACCESS_KEY_ID%"=="" (
  echo [ERROR] AWS_ACCESS_KEY_ID is not set.
  goto :help
)
if "%AWS_SECRET_ACCESS_KEY%"=="" (
  echo [ERROR] AWS_SECRET_ACCESS_KEY is not set.
  goto :help
)
if "%AWS_DEFAULT_REGION%"=="" (
  echo [WARN] AWS_DEFAULT_REGION not set. Defaulting to us-east-1.
  set "AWS_DEFAULT_REGION=us-east-1"
)




REM --- CONFIGURATION ---
SET AWS_REGION=us-east-1
SET AWS_ACCOUNT_ID=450681485069
SET REPO_NAME=rms

REM --- CHECK & CREATE REPO ---
echo Checking if ECR repository "%REPO_NAME%" exists...
aws ecr describe-repositories --repository-names %REPO_NAME% --region %AWS_REGION% >nul 2>&1

IF %ERRORLEVEL% NEQ 0 (
    echo Repository "%REPO_NAME%" not found. Creating it now...
    aws ecr create-repository --repository-name %REPO_NAME% --region %AWS_REGION%
    IF ERRORLEVEL 1 (
        echo [ERROR] Failed to create repository.
        exit /b 1
    )
) ELSE (
    echo Repository "%REPO_NAME%" already exists.
)


REM --- ECR LOGIN ---
echo Logging in to ECR...
aws ecr get-login-password --region %AWS_REGION% | docker login --username AWS --password-stdin %AWS_ACCOUNT_ID%.dkr.ecr.%AWS_REGION%.amazonaws.com

IF ERRORLEVEL 1 (
    echo [ERROR] Docker login failed. Check your AWS credentials.
    exit /b 1
)
REM -- look in the images folder for the image
SET SCRIPT_DIR=%~dp0
SET IMAGES_DIR=%SCRIPT_DIR%images
echo [INFO] Using images directory: %IMAGES_DIR%

REM List available tarballs for the specified image name and parse tags
if exist "%IMAGES_DIR%" (
    echo [INFO] Scanning for saved images matching "%IMAGE_NAME%-*.tar" in "%IMAGES_DIR%"...
    set FOUND_ANY=0
    for %%F in ("%IMAGES_DIR%\%IMAGE_NAME%-*.tar") do (
        set FOUND_ANY=1
        set "FILENAME=%%~nF"
        REM FILENAME is like image_name-<tag>
        REM Remove the prefix "image_name-" to get the tag
        set "TAG=!FILENAME:%IMAGE_NAME%-=!"
        echo   Found: %%~nxF  -> tag: !TAG!
        if "!IMAGE_TAG!"=="" set "IMAGE_TAG=!TAG!"
        echo   Using tag: !IMAGE_TAG!

    )
    if !FOUND_ANY! == 0 (
        echo   [WARN] No saved tarballs found for image name "%IMAGE_NAME%".
    )
) else (
    echo [WARN] Images directory not found at "%IMAGES_DIR%".
)
if "%IMAGE_TAG%"=="" (
    echo [ERROR] No image tag specified and no saved images found for "%IMAGE_NAME%".
    goto :help
)

REM --- TAG & PUSH ---
SET ECR_URI=%AWS_ACCOUNT_ID%.dkr.ecr.%AWS_REGION%.amazonaws.com/%REPO_NAME%


echo Tagging %IMAGE_NAME%:%IMAGE_TAG% as %ECR_URI%:%IMAGE_TAG%...
docker tag %IMAGE_NAME%:%IMAGE_TAG% %ECR_URI%:%IMAGE_TAG%

echo Pushing to ECR...
docker push %ECR_URI%:%IMAGE_TAG%

IF ERRORLEVEL 1 (
    echo [ERROR] Push failed.
    exit /b 1
)

echo [SUCCESS] Pushed %ECR_URI%:%IMAGE_TAG%

exit /b 0


:help
echo.
echo Usage: ecr-push.bat ^<image_name^> [tag] [aws_region]
echo   image_name: Name of subfolder in ..\images containing Dockerfile ^(also used as ECR repo name^)
echo   tag       : Image tag to push ^(default: latest^)
echo   aws_region: Override AWS_DEFAULT_REGION ^(default from env or us-east-1^)
echo Examples:
echo   ecr-push.bat my-app

echo   ecr-push.bat my-app v1 us-west-2

echo Requirements: AWS CLI, Docker, and AWS credentials set in env vars.
exit /b 1

