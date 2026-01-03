#!/bin/sh
set -eu

# Required env vars (externalized parameters)
REQUIRED_VARS="\
DB_HOST \
DB_PORT \
DB_USER \
DB_PASSWORD \
FLYWAY_USER \
FLYWAY_PASSWORD\
"

missing=0
for var in $REQUIRED_VARS; do
  eval val="\${$var:-}"
  if [ -z "$val" ]; then
    echo "[ERROR] Required environment variable not set: $var" >&2
    missing=1
  fi
done

if [ "$missing" -ne 0 ]; then
  echo "\nAborting startup due to missing environment variables." >&2
  echo "Ensure all externalized parameters are set before launching the container." >&2
  exit 2
fi

# Defaults for optional parameters
: "${SERVER_PORT:=8080}"
: "${DB_NAME:=rms}"

# Compose JDBC URLs from env
DATASOURCE_URL="jdbc:mysql://${DB_HOST}:${DB_PORT}/${DB_NAME}"
FLYWAY_URL_COMPOSED="jdbc:mysql://${DB_HOST}:${DB_PORT}/${DB_NAME}"

# Append Spring Boot properties to JAVA_OPTS so the app receives them at runtime
JAVA_OPTS="${JAVA_OPTS:-} \
  -Dserver.port=${SERVER_PORT} \
  -Dspring.datasource.url=${DATASOURCE_URL} \
  -Dspring.datasource.username=${DB_USER} \
  -Dspring.datasource.password=${DB_PASSWORD} \
  -Dspring.flyway.url=${FLYWAY_URL_COMPOSED} \
  -Dspring.flyway.user=${FLYWAY_USER} \
  -Dspring.flyway.password=${FLYWAY_PASSWORD}"

# Optional info
echo "[INFO] All required environment variables are set. Starting application..."
echo "[INFO] SERVER_PORT=${SERVER_PORT}"
echo "[INFO] DB_URL=${DATASOURCE_URL}"

# Launch the application
exec java $JAVA_OPTS -jar /app/rms.jar
