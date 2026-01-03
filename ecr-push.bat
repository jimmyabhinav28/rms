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

if "%IMAGE_TAG%"=="" set IMAGE_TAG=latest
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

REM Check tools
where aws >nul 2>&1
if errorlevel 1 (
  echo [ERROR] AWS CLI not found in PATH.
  exit /b 1
)
where docker >nul 2>&1
if errorlevel 1 (
  echo [ERROR] Docker not found in PATH.
  exit /b 1
)

REM Get AWS account ID
for /f "usebackq tokens=*" %%A in (`aws sts get-caller-identity --query Account --output text 2^>^&1`) do set ACCOUNT_ID=%%A
if "%ACCOUNT_ID%"=="" (
  echo [ERROR] Could not determine AWS account ID. Check credentials.
  exit /b 1
)

set ECR_HOST=%ACCOUNT_ID%.dkr.ecr.%AWS_DEFAULT_REGION%.amazonaws.com
set REPO_NAME=%IMAGE_NAME%
set IMAGE_URI=%ECR_HOST%/%REPO_NAME%:%IMAGE_TAG%

REM Ensure repository exists
for /f "usebackq tokens=*" %%R in (`aws ecr describe-repositories --repository-names %REPO_NAME% --query 'repositories[0].repositoryUri' --output text 2^>^&1`) do set REPO_URI=%%R
if "%REPO_URI%"=="None" (
  echo Repository %REPO_NAME% not found. Creating...
  aws ecr create-repository --repository-name "%REPO_NAME%" >nul 2>&1
  if errorlevel 1 (
    echo [ERROR] Failed to create ECR repository %REPO_NAME%.
    exit /b 1
  )
  set REPO_URI=%ECR_HOST%/%REPO_NAME%
)

echo Using ECR URI: %REPO_URI%

REM ECR login
for /f "usebackq tokens=*" %%L in (`aws ecr get-login-password 2^>^&1`) do set ECR_PWD=%%L
if "%ECR_PWD%"=="" (
  echo [ERROR] Failed to retrieve ECR login password.
  exit /b 1
)

echo Logging in to ECR: %ECR_HOST%
echo %ECR_PWD% | docker login --username AWS --password-stdin %ECR_HOST%
if errorlevel 1 (
  echo [ERROR] Docker login to ECR failed.
  exit /b 1
)

REM Build image from ../images/<image_name>
set BUILD_CONTEXT=..\images\%IMAGE_NAME%
if not exist "%BUILD_CONTEXT%" (
  echo [ERROR] Build context not found: %BUILD_CONTEXT%
  echo Ensure a Dockerfile exists in that folder.
  exit /b 1
)

echo Building image %IMAGE_NAME%:%IMAGE_TAG% from %BUILD_CONTEXT%
docker build -t %REPO_NAME%:%IMAGE_TAG% "%BUILD_CONTEXT%"
if errorlevel 1 (
  echo [ERROR] Docker build failed.
  exit /b 1
)

REM Tag and push

echo Tagging %REPO_NAME%:%IMAGE_TAG% as %IMAGE_URI%
docker tag %REPO_NAME%:%IMAGE_TAG% %IMAGE_URI%
if errorlevel 1 (
  echo [ERROR] Docker tag failed.
  exit /b 1
)

echo Pushing %IMAGE_URI%
docker push %IMAGE_URI%
if errorlevel 1 (
  echo [ERROR] Docker push failed.
  exit /b 1
)

echo [SUCCESS] Pushed %IMAGE_URI%
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

