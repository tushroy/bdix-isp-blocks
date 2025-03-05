#!/bin/bash
echo "Cloning git@github.com:tushroy/bdix-isp-blocks.git"
git clone git@github.com:tushroy/bdix-isp-blocks.git
cd /root/bdix-isp-blocks

echo "Pull the latest changes"
# Pull the latest changes
git pull origin master

# Make the asn2prefix.sh script executable
# chmod +x asn2prefix.sh

echo "Running asn2prefix.sh"
# Run the update script
sh asn2prefix.sh

# Get current date and time (YYYY-MM-DD HH:MM)
CURRENT_DATETIME=$(date +"%Y-%m-%d %H:%M")

git config user.email "skydel.net@gmail.com"
git config user.name "Tushar Roy"
# Add, commit, and push changes
git add .
git commit -m "Automated update: $CURRENT_DATETIME"
git push origin master

echo "Remoting /root/bdix-isp-blocks"
cd /root
rm -r -f /root/bdix-isp-blocks
echo "Finished"