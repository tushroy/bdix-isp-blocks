# Use Alpine Linux as the base image
FROM alpine:latest

# Install necessary packages: Git, OpenSSH (for authentication), and cron
RUN apk add --no-cache \
    git \
    openssh \
    bash \
    curl \
    tzdata \
    cronie

# Set timezone to UTC (or change as needed)
RUN cp /usr/share/zoneinfo/UTC /etc/localtime

# Set the working directory
WORKDIR /root

# Copy SSH keys (ensure they are added securely)
COPY id_rsa /root/.ssh/id_rsa
COPY id_rsa.pub /root/.ssh/id_rsa.pub
RUN chmod 600 /root/.ssh/id_rsa && chmod 644 /root/.ssh/id_rsa.pub

# Prevent SSH from asking for confirmation
RUN echo -e "Host github.com\n\tStrictHostKeyChecking no\n" > /root/.ssh/config

# Clone the repository
RUN git clone git@github.com:tushroy/bdix-isp-blocks.git

# Change working directory to the repository
WORKDIR /root/bdix-isp-blocks

# Copy update script and set permissions
COPY update.sh /root/update.sh
RUN chmod +x /root/update.sh

# Copy crontab file and install cron job
COPY crontab /etc/crontabs/root

# Start cron in the foreground
CMD ["crond", "-f", "-l", "2"]
