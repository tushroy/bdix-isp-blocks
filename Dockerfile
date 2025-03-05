# Use Ubuntu as the base image
FROM ubuntu:latest

# Update package list and install necessary packages: Git, OpenSSH (for authentication), curl, bash, cron, and tzdata
RUN apt-get update && apt-get install -y \
    git \
    openssh-client \
    bash \
    curl \
    tzdata \
    cron \
    grep \
    html2text \
    && rm -rf /var/lib/apt/lists/*

# Set timezone to UTC (or change as needed)
RUN ln -fs /usr/share/zoneinfo/UTC /etc/localtime && dpkg-reconfigure -f noninteractive tzdata

# Set the working directory
WORKDIR /root

# Ensure the .ssh directory exists
RUN mkdir -p /root/.ssh

# Copy SSH keys (WARNING: Avoid adding private keys directly in Dockerfile)
COPY id_rsa.pub /root/.ssh/id_rsa.pub
RUN chmod 644 /root/.ssh/id_rsa.pub

# Prevent SSH from asking for confirmation by properly writing the config
RUN echo "Host github.com\n\tStrictHostKeyChecking no\n" > /root/.ssh/config

# Copy update script and set permissions
COPY update.sh /root/update.sh
RUN chmod +x /root/update.sh

# Copy crontab file and install cron job
COPY crontab /etc/cron.d/root-crontab
RUN chmod 0644 /etc/cron.d/root-crontab && crontab /etc/cron.d/root-crontab

# Set shell to bash
SHELL ["/bin/bash", "-c"]

# Start cron in the foreground
CMD ["cron", "-f"]
