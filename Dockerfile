# OpenBoxes Docker for Dokploy
# Multi-stage build: downloads pre-built WAR and deploys to Tomcat 7

FROM alpine:3.18 AS downloader

# Download the latest OpenBoxes WAR file
ARG OPENBOXES_VERSION=v0.9.6-hotfix1
RUN apk add --no-cache curl \
    && curl -L -o /openboxes.war \
    "https://github.com/openboxes/openboxes/releases/download/${OPENBOXES_VERSION}/openboxes.war"


FROM tomcat:7.0.109-jdk8-openjdk

LABEL maintainer="Kevin Hill"
LABEL description="OpenBoxes Supply Chain Management System"

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the WAR file
COPY --from=downloader /openboxes.war /usr/local/tomcat/webapps/ROOT.war

# Create config directory for OpenBoxes
RUN mkdir -p /root/.grails

# Copy configuration file
COPY openboxes-config.properties /root/.grails/openboxes-config.properties

# Set JVM options for OpenBoxes
ENV CATALINA_OPTS="-server -Xms512m -Xmx2048m -XX:+UseG1GC -Djava.security.egd=file:/dev/./urandom"

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=120s --retries=3 \
    CMD curl -f http://localhost:8080/health || exit 1

EXPOSE 8080

CMD ["catalina.sh", "run"]
