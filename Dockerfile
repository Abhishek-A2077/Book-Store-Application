# Stage 1: Build the Application using Maven
FROM maven:3.9.9-eclipse-temurin-17 AS builder
WORKDIR /app

# Copy pom.xml and source code
COPY pom.xml .
COPY src/ src/

# Build the application (skip tests to speed up the build)
RUN mvn clean package -DskipTests

# Stage 2: Create the Runtime Image
FROM openjdk:17-jdk-alpine
WORKDIR /app

# Copy the packaged JAR from the builder stage
COPY --from=builder /app/target/bookStore-0.0.1-SNAPSHOT.jar app.jar

# Expose the port on which your Spring Boot app listens
EXPOSE 9090

# Start the Spring Boot application
ENTRYPOINT ["java", "-jar", "app.jar"]
