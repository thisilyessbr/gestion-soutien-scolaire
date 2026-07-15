# ========================================================
# Single-container deployment of the JEE application
# Includes Tomcat 10 + MySQL 8 for easy cloud deployment
# Multi-stage build: first stage compiles the WAR with Maven
# ========================================================

# ------------------- Stage 1: Build WAR -------------------
FROM maven:3.9-eclipse-temurin-11 AS builder

WORKDIR /app

# Copy Maven wrapper and pom first to cache dependencies
COPY pom.xml ./
COPY .mvn ./.mvn
COPY mvnw ./
RUN chmod +x mvnw

# Download dependencies (cached layer)
RUN ./mvnw dependency:go-offline -B

# Copy source code and build the WAR
COPY src ./src
RUN ./mvnw clean package -DskipTests -B

# ------------------- Stage 2: Runtime -------------------
FROM tomcat:10.1-jdk11-temurin

LABEL maintainer="Ilyes Saber"
LABEL description="Gestion du Soutien Scolaire - Jakarta EE Web Application"

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install MySQL server and other required packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        mysql-server \
        wget \
        curl \
        netcat-traditional \
        supervisor && \
    rm -rf /var/lib/apt/lists/*

# Configure MySQL to listen on localhost
RUN mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld && \
    echo "[mysqld]\nport=3306\nbind-address=127.0.0.1\ndefault-authentication-plugin=mysql_native_password" > /etc/mysql/mysql.conf.d/smarterschool.cnf

# Set MySQL root password and create application database/user
ENV MYSQL_ROOT_PASSWORD=rootpass
ENV DB_HOST=localhost
ENV DB_PORT=3306
ENV DB_NAME=gestion_du_soutien
ENV DB_USER=appuser
ENV DB_PASS=apppass
ENV DB_USE_SSL=false

# Remove default Tomcat webapps and copy our WAR as ROOT
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the built WAR from the builder stage
COPY --from=builder /app/target/projetJee22-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

# Copy database initialization scripts
COPY src/main/resources/schema.sql /docker-entrypoint-initdb.d/01-schema.sql
COPY src/main/resources/data.sql /docker-entrypoint-initdb.d/02-data.sql

# Copy supervisor and startup scripts
COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY docker/init-mysql.sh /usr/local/bin/init-mysql.sh
COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/init-mysql.sh /usr/local/bin/entrypoint.sh

# Expose Tomcat port
EXPOSE 8080

# Start everything via entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
# ========================================================
# Single-container deployment of the JEE application
# Includes Tomcat 10 + MySQL 8 for easy cloud deployment
# ========================================================

FROM tomcat:10.1-jdk11-temurin

LABEL maintainer="Ilyes Saber"
LABEL description="Gestion du Soutien Scolaire - Jakarta EE Web Application"

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install MySQL server and other required packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        mysql-server \
        wget \
        curl \
        netcat-traditional \
        supervisor && \
    rm -rf /var/lib/apt/lists/*

# Configure MySQL to listen on localhost
RUN mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld && \
    echo "[mysqld]\nport=3306\nbind-address=127.0.0.1\ndefault-authentication-plugin=mysql_native_password" > /etc/mysql/mysql.conf.d/smarterschool.cnf

# Set MySQL root password and create application database/user
ENV MYSQL_ROOT_PASSWORD=rootpass
ENV DB_HOST=localhost
ENV DB_PORT=3306
ENV DB_NAME=gestion_du_soutien
ENV DB_USER=appuser
ENV DB_PASS=apppass
ENV DB_USE_SSL=false

# Remove default Tomcat webapps and copy our WAR as ROOT
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the built WAR into Tomcat
COPY target/projetJee22-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

# Copy database initialization scripts
COPY src/main/resources/schema.sql /docker-entrypoint-initdb.d/01-schema.sql
COPY src/main/resources/data.sql /docker-entrypoint-initdb.d/02-data.sql

# Copy supervisor and startup scripts
COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY docker/init-mysql.sh /usr/local/bin/init-mysql.sh
COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/init-mysql.sh /usr/local/bin/entrypoint.sh

# Expose Tomcat port
EXPOSE 8080

# Start everything via entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
