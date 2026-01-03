# Windows Batch Scripts: Docker Build & Publish

This project includes two Windows batch scripts to help you build Docker images locally and push them to AWS ECR. They are designed to work with Windows PowerShell or Command Prompt.

Scripts:
- build-and-publish-image.bat — Build a Docker image from this project and publish it locally as a .tar in the `images` folder.
- ecr-push.bat — Build an image from a subfolder under `images/` and push it to AWS Elastic Container Registry (ECR).
- build_and_save_image.bat — Build the `rms` Docker image and save it as a `.tar` into a sibling `images` folder from a workspace root.

---

## build-and-publish-image.bat

Builds a Docker image from the specified build context (defaults to the repo root), tags it with a timestamp, and saves the image as a portable `.tar` file to `rms/images/`.

- Location: `rms\build-and-publish-image.bat`
- Output:
  - Docker tag: `<image_name>:<yyyyMMdd-HHmmss>`
  - Tarball: `images\<image_name>-<yyyyMMdd-HHmmss>.tar`

### Prerequisites
- Docker Desktop installed and `docker` available in PATH.
- A `Dockerfile` present in the chosen build context (repo root has `Dockerfile`).

### Usage
```powershell
# From repo root
# Default image name (rms-app) and default build context (.)
./build-and-publish-image.bat

# Explicit image name
./build-and-publish-image.bat rms-app

# Explicit image name and build context
./build-and-publish-image.bat rms-app .
```

### Parameters
- `<image_name>`: Name of the image to build and tag. Default: `rms-app`
- `[build_context]`: Path to directory containing `Dockerfile`. Default: `.`

### Examples
```powershell
# Build from current directory and save to images/ with timestamp tag
./build-and-publish-image.bat

# Build a different name
./build-and-publish-image.bat my-service

# Build from a custom context folder
./build-and-publish-image.bat my-service .
```

### Result
- The script creates (if needed) `rms\images\`.
- Tags the image with the current timestamp (yyyyMMdd-HHmmss).
- Saves a tarball: `images\my-service-20260103-153045.tar`

### Troubleshooting
- `[ERROR] Docker not found in PATH.` — Install Docker Desktop and ensure `docker` is on PATH.
- `[ERROR] No Dockerfile found in build context` — Provide a directory with a `Dockerfile`.
- Run with elevated privileges if Docker commands fail due to permissions.

---

## ecr-push.bat

Builds a Docker image from a subfolder under `images/` (which must contain a `Dockerfile`) and pushes it to AWS ECR.

- Location: `rms\ecr-push.bat`
- Output:
  - Pushes to: `<account>.dkr.ecr.<region>.amazonaws.com/<repo>:<tag>`

### Prerequisites
- AWS CLI installed and configured (PATH + credentials via env vars or default profile).
- Docker installed.
- Environment variables (if not using profiles):
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`
  - Optional: `AWS_SESSION_TOKEN`
  - Optional: `AWS_DEFAULT_REGION` (script defaults to `us-east-1` if not set)
- A build context folder under `images/<image_name>` containing a `Dockerfile`.

### Usage
```powershell
# From repo root
./ecr-push.bat <image_name> [tag] [aws_region]
```

### Parameters
- `<image_name>`: Name of subfolder under `images/` and ECR repository name.
- `[tag]`: Image tag to push. Default: `latest`
- `[aws_region]`: Overrides `AWS_DEFAULT_REGION`. Defaults to env or `us-east-1`.

### Examples
```powershell
# Push images\my-app to ECR, tag latest, default region
./ecr-push.bat my-app

# Push with tag and region override
./ecr-push.bat my-app v1 us-west-2
```

### What the script does
1. Validates AWS credentials and tools (`aws`, `docker`).
2. Determines the AWS account ID and constructs the ECR registry URL.
3. Ensures the ECR repository `<image_name>` exists (creates if needed).
4. Logs in to ECR via `aws ecr get-login-password`.
5. Builds the Docker image from `images\<image_name>`.
6. Tags the image and pushes it to ECR.

### Troubleshooting
- `[ERROR] AWS_ACCESS_KEY_ID is not set.` — Set required AWS environment variables or configure AWS CLI profiles.
- `[ERROR] AWS CLI not found in PATH.` — Install AWS CLI v2 and ensure it’s on PATH.
- `[ERROR] Build context not found: ..\images\<image_name>` — Ensure `images\<image_name>` exists and has a `Dockerfile`.
- If login fails, verify region, credentials, and ECR permissions (e.g., `ecr:BatchCheckLayerAvailability`, `ecr:PutImage`).

---

## build_and_save_image.bat

Builds the `rms` Docker image from the project directory and saves it to a sibling `images` folder as a `.tar` file. Intended to be placed at the workspace root alongside `rms/` and `images/`.

- Location: `rms\build_and_save_image.bat` (ensure the script runs from the workspace root where `rms` exists)
- Output:
  - Tarball: `images\<image_name>-<tag>.tar` (e.g., `images\rms-20260104-101530.tar`)

### Prerequisites
- Docker Desktop installed and `docker` available in PATH.
- The `rms` folder must exist next to the script, and contain a valid `Dockerfile`.

### Usage
```powershell
# From the workspace root containing the 'rms' folder
# Defaults: image_name=rms, tag=current timestamp (yyyyMMdd-HHmmss)
./build_and_save_image.bat [image_name] [tag]
```

### Parameters
- `image_name` (optional): Name for the Docker image. Default: `rms`
- `tag` (optional): Image tag. Default: current timestamp `yyyyMMdd-HHmmss`

### Examples
```powershell
# Default name and timestamped tag
./build_and_save_image.bat

# Custom tag
./build_and_save_image.bat rms 20260104-101530

# Custom image name with timestamped tag
./build_and_save_image.bat my-app

# Custom image name and custom tag
./build_and_save_image.bat my-app v1
```

### Behavior
- Verifies `rms` directory exists at a known relative path.
- Creates `images/` if it does not exist.
- Builds image `<image_name>:<tag>` from `rms/Dockerfile`.
- Saves the image to `images/<image_name>-<tag>.tar`.

### Troubleshooting
- `ERROR: Expected directory not found: "<path>\rms"` — Run the script from the workspace root where `rms` exists.
- `ERROR: Docker not found in PATH.` — Install Docker Desktop and ensure `docker` is on PATH.
- `ERROR: Docker build failed.` — Check Docker is running and the `Dockerfile` in `rms` is valid.
- `ERROR: docker save failed.` — Ensure you have write permissions to the `images` directory and sufficient disk space.

---

## Tips and workflow
- Typical local build-and-publish:
```powershell
# Build from current repo and save to images/
./build-and-publish-image.bat rms-app .
```
- Typical ECR push:
```powershell
# Prepare a folder under images/ with a Dockerfile for your app
# then push it to ECR
./ecr-push.bat rms-app latest us-east-1
```
- Save from workspace root (fixed name/tag):
```powershell
./build_and_save_image.bat
```

## Notes
- The local tarballs produced by these scripts can be loaded on any Docker host:
```powershell
docker load -i images\<name>-<tag>.tar
```
- To re-tag a loaded image for ECR:
```powershell
$account = "123456789012"
$region = "us-east-1"
$repo   = "rms-app"
$tag    = "20260103-153045"
docker tag $repo:$tag $account.dkr.ecr.$region.amazonaws.com/$repo:$tag
```
