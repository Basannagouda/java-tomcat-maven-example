  GNU nano 6.2                                                                   Dockerfile                                                                             
# Use the official Maven image to build the application
FROM maven:3.8.6-openjdk-11 as builder

# Set the working directory to /app
WORKDIR /app

# Copy the pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the rest of the application
COPY src /app/src

# Build the WAR file
RUN mvn clean package -DskipTests

# Use the official Tomcat image as a base image
FROM tomcat:9.0.62-jdk11-openjdk

# Copy the WAR file from the builder image to the webapps directory of Tomcat
COPY --from=builder /app/target/java-tomcat-maven-example.war /usr/local/tomcat/webapps/

# Expose port 8080 to allow traffic to the Tomcat server
EXPOSE 8000

# Start the Tomcat server
CMD ["catalina.sh", "run"]
