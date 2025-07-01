# === Stage 1: Build with Maven ===
FROM maven:3.9.6-eclipse-temurin-17 AS build

# Set working directory
WORKDIR /app

# Copy pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the rest of the source code
COPY src ./src

# Build the application, skip tests
RUN mvn clean install -DskipTests

# === Stage 2: Runtime ===
FROM eclipse-temurin:17-jdk

WORKDIR /app

# Copy built jar from the previous stage
COPY --from=build /app/target/sonarqube-maven-example-1.0.0.jar app.jar

# Command to run the jar
ENTRYPOINT ["java", "-jar", "app.jar"]
