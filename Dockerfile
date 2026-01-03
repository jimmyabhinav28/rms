# syntax=docker/dockerfile:1

# ---- Build stage ----
FROM maven:3.9.9-eclipse-temurin-21 AS build
WORKDIR /app

# Copy only pom first to leverage Docker layer caching
COPY pom.xml ./
RUN mvn -q -e -DskipTests dependency:go-offline

# Copy sources and build
COPY src ./src
RUN mvn -q -e -DskipTests clean package

# ---- Runtime stage ----
FROM eclipse-temurin:21-jre-alpine

# Define build-time application version for label to avoid UndefinedVar warning
ARG APPLICATION_SERVICE_VERSION="1.0.0"
RUN echo "[DEBUG] Building RMS image with APPLICATION_SERVICE_VERSION=${APPLICATION_SERVICE_VERSION}"
LABEL org.opencontainers.image.title="rms" \
      org.opencontainers.image.description="Railway Management System" \
      org.opencontainers.image.source="https://example.invalid/railways/rms" \
      org.opencontainers.image.version="${APPLICATION_SERVICE_VERSION}" \
      org.opencontainers.image.vendor="abhinav"

# Document environment variables ,values must be provided at runtime
ENV JAVA_OPTS="" \
    APPLICATION_SERVICE_VERSION="" \
    SERVER_PORT="" \
    DB_HOST="" \
    DB_PORT="" \
    DB_NAME="" \
    DB_USER="" \
    DB_PASSWORD="" \
    JPA_SHOW_SQL="" \
    FLYWAY_URL="" \
    FLYWAY_USER="" \
    FLYWAY_PASSWORD=""

WORKDIR /app

# Copy the built jar
COPY --from=build /app/target/*.jar /app/rms.jar

# Copy entrypoint validator
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Install curl for healthcheck busybox wget may be missing
RUN apk add --no-cache curl

# Runtime debug: list app contents and show Java version
RUN echo "[DEBUG] Contents of /app:" && ls -lah /app && echo "[DEBUG] Java version:" && java -version

# Expose the port
EXPOSE 8080

# Healthcheck using curl
HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 \
  CMD curl -sf "http://localhost:${SERVER_PORT:-8080}/actuator/health" || exit 1
#
## Run the validator which then launches the app
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
