# Amazon Echo Bridge
# Emulates philips hue api to other home automation gateways
# Created based on the work of https://github.com/armzilla/amazon-echo-ha-bridge

# Usage: java:openjdk base image
FROM java:openjdk-8-jre

# Usage: MAINTAINER 
MAINTAINER Joe Dunn me@joedunn.com

# User can chose to mount these volumes to their local disk
VOLUME ["/config"]
# ha.log writes in this volume
VOLUME ["/log"]

# App Version
# Binary releases obtained here https://github.com/armzilla/amazon-echo-ha-bridge/releases
ENV VERSION="0.2.1"

# Add the remote file to /root/
# COPY does not allow for remote URL's for ADD had to be used
ADD https://github.com/armzilla/amazon-echo-ha-bridge/releases/download/v${VERSION}/amazon-echo-bridge-${VERSION}.jar /root/

# Upgrade Debian install
# RUN config based on Docker best practices https://docs.docker.com/engine/articles/dockerfile_best-practices/
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    wget \
    less \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Default port for application
EXPOSE 8080

# JAVA_HOME for Application 
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/

# Work in /root since its where the jar file is downloaded
WORKDIR /root/
CMD /usr/bin/java -jar amazon-echo-bridge-${VERSION}.jar --logging.level.com.armzilla.ha.upnp=DEBUG --logging.file=/log/ha.log
