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
    && rm -rf /var/lib/apt/lists/* \
    && which cron \
    && rm -rf /etc/cron.*/*

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
COPY entrypoint.sh /root/entrypoint.sh
RUN chmod +x /root/update.sh
RUN chmod +x /root/entrypoint.sh

# Copy crontab file and install cron job
COPY crontab /etc/crontab

ENTRYPOINT ["/root/entrypoint.sh"]

# https://manpages.ubuntu.com/manpages/trusty/man8/cron.8.html
# -f | Stay in foreground mode, don't daemonize.
# -L loglevel | Tell  cron  what to log about jobs (errors are logged regardless of this value) as the sum of the following values:
CMD ["cron","-f", "-L", "2"]
