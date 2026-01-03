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
LABEL org.opencontainers.image.title="rms" \
      org.opencontainers.image.description="Railway Management System" \
      org.opencontainers.image.source="https://example.invalid/railways/rms" \
      org.opencontainers.image.version="${APPLICATION_SERVICE_VERSION}" \
      org.opencontainers.image.vendor="abhinav"
ENV JAVA_OPTS=""
ENV SERVER_PORT=8080
WORKDIR /app

# Copy the built jar
COPY --from=build /app/target/*.jar /app/rms.jar

# Expose the port (informative; use -p mapping at runtime)
EXPOSE 8080

# Healthcheck (optional)
HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 \
  CMD wget -qO- http://localhost:${SERVER_PORT}/actuator/health || exit 1

# Run the app; env vars are passed through at runtime
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar /app/rms.jar"]
