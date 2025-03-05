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
    findutils \
    xargs \
    html2text \
    && rm -rf /var/lib/apt/lists/*

# Set timezone to UTC (or change as needed)
RUN ln -fs /usr/share/zoneinfo/UTC /etc/localtime

# Set the working directory
WORKDIR /root

# Copy SSH keys (ensure they are added securely)
COPY id_rsa /root/.ssh/id_rsa
COPY id_rsa.pub /root/.ssh/id_rsa.pub
RUN chmod 600 /root/.ssh/id_rsa && chmod 644 /root/.ssh/id_rsa.pub

# Prevent SSH from asking for confirmation
RUN echo -e "Host github.com\n\tStrictHostKeyChecking no\n" > /root/.ssh/config

# Copy update script and set permissions
COPY update.sh /root/update.sh
RUN chmod +x /root/update.sh

# Copy crontab file and install cron job
COPY crontab /etc/cron.d/root-crontab

# Set proper permissions for crontab file
RUN chmod 0644 /etc/cron.d/root-crontab

# Start cron in the foreground
CMD ["cron", "-f"]
