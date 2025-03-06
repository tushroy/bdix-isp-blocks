#!/bin/sh

# Creating and navigating to 'asn' directory
mkdir -p asn
cd asn || { echo "Failed to enter 'asn' directory"; exit 1; }

# Removing old ASN files
rm -f asn*.html

# Fetching ASN data
grep -oP 'AS\K([0-9]+)' ../bdix-asn-list.txt | xargs -P8 -I {} curl -s -o asn{}.html "https://www.dan.me.uk/bgplookup?asn={}&include_downstream=on"

# Extracting IPv4 and IPv6 prefixes
lynx -dump asn*.html | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,2}/[0-9]{1,2}\b" > ../bdix-prefix_ipv4.txt
lynx -dump asn*.html | grep -oE "\b([0-9a-fA-F:]+:+)+(:[0-9a-fA-F]+)?/[0-9]{1,3}\b" > ../bdix-prefix_ipv6.txt

echo "Script execution completed successfully."
