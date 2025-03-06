# Use Alpine Linux as the base image
FROM alpine:latest

RUN which crond && \
    rm -rf /etc/periodic

# Install necessary packages: Git, OpenSSH (for authentication), and cron
RUN apk add --no-cache \
    git \
    openssh \
    bash \
	tini \
    curl \
    tzdata \
	html2text 
	
ENV TZ=Asia/Dhaka

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
COPY crontab /crontab

ENTRYPOINT ["/sbin/tini", "-s", "/root/entrypoint.sh"]

# https://manpages.ubuntu.com/manpages/trusty/man8/cron.8.html
# -f | Stay in foreground mode, don't daemonize.
# -L loglevel | Tell  cron  what to log about jobs (errors are logged regardless of this value) as the sum of the following values:
CMD ["crond", "-f", "-l", "2"]
