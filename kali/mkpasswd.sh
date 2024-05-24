#!/bin/bash

# Variables
username="$1"
output="$2"

echo -n Password: 
read -s password
echo

# Generate password hash
hash=$(/opt/homebrew/bin/openssl passwd -6 "$password")

# Entry fields
lastchange=$(date +%s)  # Number of days since 1970-01-01
minimum=0
maximum=99999
warn=7
inactive=""
expire=""
reserved=""

# Combine fields into the shadow file format
new_entry="$username:$hash:$lastchange:$minimum:$maximum:$warn:$inactive:$expire:$reserved"

echo "$new_entry" > $output
