# Railway Management System (RMS)

A Spring Boot application for managing railway stations with a DTO-centric service layer, versioned controllers,
validation, and Swagger/OpenAPI documentation.

## Configuration

All sensitive configuration values are externalized via environment variables. Do not hardcode secrets.

Required environment variables (with safe defaults where applicable):

- `APPLICATION_SERVICE_VERSION` (default: `1.0.0`) – selects the service implementation version
- `SERVER_PORT` (default: `8080`) – server port
- `DB_HOST` (default: `localhost`) – database host
- `DB_PORT` (default: `3306`) – database port
- `DB_NAME` (default: `rms`) – database schema name
- `DB_USER` – database username (required)
- `DB_PASSWORD` – database password (required)
- `JPA_SHOW_SQL` (default: `false`) – toggle SQL logging

Configuration is wired in `src/main/resources/application.properties` using Spring property placeholders.

## Run (development)

Set environment variables and start the app.

```powershell
$env:APPLICATION_SERVICE_VERSION="1.0.0"
$env:SERVER_PORT="8080"
$env:DB_HOST="localhost"
$env:DB_PORT="3306"
$env:DB_NAME="rms"
$env:DB_USER="rms_user"
$env:DB_PASSWORD="change_me"
$env:JPA_SHOW_SQL="false"
.\mvnw.cmd spring-boot:run
```

Swagger UI: http://localhost:8080/swagger-ui.html

OpenAPI spec (generated): http://localhost:8080/v3/api-docs

External contract (example): `src/main/resources/openapi/stations-v1.yaml`

## API Versioning

- Versioned controllers expose endpoints under `/api/v{n}/...` (e.g., `/api/v1/stations`).
- Service implementations are versioned and selected via `application.service.version`.

## Validation and Error Handling

- Request DTOs use Bean Validation annotations.
- Controller methods use `@Valid` to enforce validation.
- Global error handler (`GlobalExceptionHandler`) returns structured 400 responses for validation errors and a 500
  fallback.

## Run tests

Tests use the `test` profile and an in-memory H2 database. No secrets required.

```powershell
.\mvnw.cmd -q clean test
```

## Production Secrets

Use a secrets manager for DB credentials and other sensitive values (Vault, AWS Secrets Manager, Azure Key Vault).
Inject them as environment variables or via Spring Cloud integrations. Restrict actuator endpoints and avoid logging
configurations containing secrets.

## Troubleshooting

- If context fails to load in tests, ensure `application-test.properties` exists and the `test` profile is active.
- If Swagger annotations aren’t recognized, run a full build to fetch dependencies:

```powershell
.\mvnw.cmd -q clean package
```

## Docker Quickstart

This project includes a multi-stage Dockerfile that builds the app with Maven and runs it on a slim Java 21 JRE image.

### Required environment variables (container will not start unless all are set)
The Docker entrypoint validates these variables at startup:
- APPLICATION_SERVICE_VERSION
- SERVER_PORT
- DB_HOST
- DB_PORT
- DB_NAME
- DB_USER
- DB_PASSWORD
- JPA_SHOW_SQL
- FLYWAY_URL
- FLYWAY_USER
- FLYWAY_PASSWORD
- Optional: JAVA_OPTS (JVM tuning flags)

If any required variable is missing, the container exits with an error indicating which ones are missing.

### Build the image (run from the project root where the Dockerfile is located)

```powershell
docker build -t rms:latest .
```

### Run the container (map port and pass all required environment variables)

```powershell
# Replace values accordingly
$env:APPLICATION_SERVICE_VERSION="1.0.0"
$env:SERVER_PORT="8080"
$env:DB_HOST="localhost"
$env:DB_PORT="3306"
$env:DB_NAME="rms"
$env:DB_USER="rms_user"
$env:DB_PASSWORD="change_me"
$env:JPA_SHOW_SQL="false"
$env:FLYWAY_URL="jdbc:mysql://localhost:3306/rms"
$env:FLYWAY_USER="rms_user"
$env:FLYWAY_PASSWORD="change_me"
$env:JAVA_OPTS="-Xms256m -Xmx512m"

docker run --rm -p 8080:8080 `
  -e APPLICATION_SERVICE_VERSION=$env:APPLICATION_SERVICE_VERSION `
  -e SERVER_PORT=$env:SERVER_PORT `
  -e DB_HOST=$env:DB_HOST `
  -e DB_PORT=$env:DB_PORT `
  -e DB_NAME=$env:DB_NAME `
  -e DB_USER=$env:DB_USER `
  -e DB_PASSWORD=$env:DB_PASSWORD `
  -e JPA_SHOW_SQL=$env:JPA_SHOW_SQL `
  -e FLYWAY_URL=$env:FLYWAY_URL `
  -e FLYWAY_USER=$env:FLYWAY_USER `
  -e FLYWAY_PASSWORD=$env:FLYWAY_PASSWORD `
  -e JAVA_OPTS=$env:JAVA_OPTS `
  rms:latest
```

### Optional JVM tuning

```powershell
docker run --rm -p 8080:8080 -e JAVA_OPTS="-Xms256m -Xmx512m" rms:latest
```

### Notes
- The Dockerfile uses Maven to build inside the container; no local Maven installation required.
- Secrets (DB_USER/DB_PASSWORD/FLYWAY_PASSWORD) must be provided as environment variables; do not hardcode credentials.
- If your database runs in another container, ensure networking is configured (e.g., same Docker network) and DB_HOST points to the DB service name.
- Healthcheck (if Spring Boot Actuator is enabled): http://localhost:8080/actuator/health

### Troubleshooting
- If the container exits immediately, it likely indicates missing required environment variables; set all listed above.
- View logs for details:

```powershell
docker logs <container-id>
```

- Verify the jar was copied correctly into the image:

```powershell
docker run --rm rms:latest sh -c "ls -lah /app"
```

- Confirm the application port mapping:
  - The container exposes 8080. Ensure you map -p 8080:8080 or change with SERVER_PORT.

- MySQL connectivity:
  - Ensure DB_HOST, DB_PORT, DB_NAME, DB_USER, DB_PASSWORD are correct and reachable.
  - If using Dockerized MySQL, consider a dedicated network and use the service name for DB_HOST.

## TODO

- If you want request-only required fields
  If latitude, longitude, and platformCount should be required in requests but not necessarily in responses, we can
  split the schema:
  StationCreateRequest and StationUpdateRequest (with required fields)
  StationResponse (readOnly fields like stationId, and optional others) Say the word and I’ll refactor the YAML and
  update controller DTO usage accordingly.
- Add authentication/authorization (e.g., JWT, OAuth2) for secure endpoints.
- Implement pagination and filtering for list endpoints.
- Add caching for frequently accessed data.
- I have not added validation for position number for the coaches in the train. We can add that if needed.
- Add integration tests for controllers and services.
- Need to show all berths in the train details as well
- Add more details in the OpenAPI spec like response examples, error responses, etc.
- Add CI/CD pipeline configuration for automated builds, tests, and deployments.
