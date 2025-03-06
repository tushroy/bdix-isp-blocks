#!/bin/sh

env >> /etc/environment

cat /crontab > /var/spool/cron/crontabs/root
CURRENT_DATETIME=$(date +"%Y-%m-%d %H:%M %Z")
echo "Startup date time: $CURRENT_DATETIME"
# execute CMD
echo "$@"
exec "$@"