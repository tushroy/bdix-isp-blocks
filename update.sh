#!/bin/bash

git clone git@github.com:tushroy/bdix-isp-blocks.git
cd /root/bdix-isp-blocks

# Pull the latest changes
git pull origin master

# Make the asn2prefix.sh script executable
chmod +x asn2prefix.sh
# Run the update script
./asn2prefix.sh

# Get current date and time (YYYY-MM-DD HH:MM)
CURRENT_DATETIME=$(date +"%Y-%m-%d %H:%M")

# Add, commit, and push changes
git add .
git commit -m "Automated update: $CURRENT_DATETIME"
git push origin master

cd /root
rm -r -f /root/bdix-isp-blocks
