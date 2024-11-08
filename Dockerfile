# Stage 1: Build the application using Maven
FROM maven:3.8-openjdk-11-slim AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the pom.xml file into the container
COPY pom.xml .


# Download the Maven dependencies (this layer will be cached if nothing changes in pom.xml)
RUN mvn dependency:go-offline

# Copy the Java source code into the container


# Package the application (skip tests for faster build)
RUN mvn clean package -DskipTests

# Stage 2: Run the application using OpenJDK image
FROM openjdk:11-jre-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the packaged JAR file from the build stage
COPY --from=build /app/target/my-java-app-1.0-SNAPSHOT.jar /app/app.jar

# Expose port 8080 (optional, can be customized if your app uses different port)
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "/app/app.jar"]

