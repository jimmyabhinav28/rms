#!/bin/sh
set -eu

# Required env vars (externalized parameters)
REQUIRED_VARS="\
APPLICATION_SERVICE_VERSION \
SERVER_PORT \
DB_HOST \
DB_PORT \
DB_NAME \
DB_USER \
DB_PASSWORD \
JPA_SHOW_SQL \
FLYWAY_URL \
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

# Optional info
echo "[INFO] All required environment variables are set. Starting application..."

# Launch the application
exec java $JAVA_OPTS -jar /app/rms.jar

