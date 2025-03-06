#!/bin/sh

env >> /etc/environment

cat /crontab > /var/spool/cron/crontabs/root

# execute CMD
echo "$@"
exec "$@"