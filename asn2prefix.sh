#!/bin/sh

# Creating and navigating to 'asn' directory
mkdir -p asn
cd asn || { echo "Failed to enter 'asn' directory"; exit 1; }

# Removing old ASN files
rm -f asn*.html

# Fetch BDIX ASNs from Hurricane Electric BDIX overview page.
curl -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36" -s "https://bgp.he.net/exchange/BDIX" | lynx -stdin -dump | grep -oE "\bAS[0-9]{1,6}\b" | sort -u > ../bdix-asn-list.txt

# Fetching ASN data
grep -oP 'AS\K([0-9]+)' ../bdix-asn-list.txt | xargs -P8 -I {} curl -s -o asn{}.html "https://www.dan.me.uk/bgplookup?asn={}&include_downstream=on"

# Extracting IPv4 and IPv6 prefixes
lynx -dump asn*.html | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,2}/[0-9]{1,2}\b" > ../bdix-prefix_ipv4.txt
lynx -dump asn*.html | grep -oE "\b([0-9a-fA-F:]+:+)+(:[0-9a-fA-F]+)?/[0-9]{1,3}\b" > ../bdix-prefix_ipv6.txt

echo "Script execution completed successfully."
