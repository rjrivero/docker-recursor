FROM phusion/baseimage:latest

# Install pdns-recursor
RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    pdns-recursor dnsutils && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add service files
ADD service /etc/service

# Expose DNS ports
EXPOSE 53 53/udp
