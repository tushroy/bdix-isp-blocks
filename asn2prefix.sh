#!/bin/bash

# Function to check and install dependencies
check_dependency() { 
    if ! command -v "$1" &>/dev/null; then
        echo "Error: '$1' is not installed."
        if [[ "$OSTYPE" == "linux"* ]]; then
            if command -v apt &>/dev/null; then
                echo "Attempting to install '$1' using apt..."
                sudo apt update && sudo apt install -y "$2"
            elif command -v yum &>/dev/null; then
                echo "Attempting to install '$1' using yum..."
                sudo yum install -y "$2"
            elif command -v dnf &>/dev/null; then
                echo "Attempting to install '$1' using dnf..."
                sudo dnf install -y "$2"
            elif command -v pacman &>/dev/null; then
                echo "Attempting to install '$1' using pacman..."
                sudo pacman -Sy --noconfirm "$2"
            elif command -v apk &>/dev/null; then
                echo "Attempting to install '$1' using apk..."
                sudo apk add "$2"
            else
                echo "Error: Package manager not found. Install '$1' manually."
                exit 1
            fi
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            if command -v brew &>/dev/null; then
                echo "Attempting to install '$1' using Homebrew..."
                brew install "$2"
            else
                echo "Error: Homebrew not found. Install '$1' manually."
                exit 1
            fi
        else
            echo "Error: Unsupported OS. Install '$1' manually."
            exit 1
        fi
    fi
}

# Checking dependencies
check_dependency grep grep
check_dependency xargs findutils
check_dependency curl curl
check_dependency html2text html2text

# Creating and navigating to 'asn' directory
mkdir -p asn
cd asn || { echo "Failed to enter 'asn' directory"; exit 1; }

# Removing old ASN files
rm -f asn*.html

# Fetching ASN data
grep -oP 'AS\K([0-9]+)' ../bdix-asn-list.txt | xargs -P8 -I {} curl -s -o asn{}.html "https://www.dan.me.uk/bgplookup?asn={}&include_downstream=on"

# Extracting IPv4 and IPv6 prefixes
html2text -ascii asn*.html | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,2}/[0-9]{1,2}\b" > ../bdix-prefix_ipv4.txt
html2text -ascii asn*.html | grep -oE "\b([0-9a-fA-F:]+:+)+(:[0-9a-fA-F]+)?/[0-9]{1,3}\b" > ../bdix-prefix_ipv6.txt

echo "Script execution completed successfully."
