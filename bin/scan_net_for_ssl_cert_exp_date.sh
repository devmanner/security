#!/bin/bash

net=$1
port=$2

iplist=$(nmap -sT -p $port -oG – 192.168.165.0/24 | grep -B 3 open | grep "Nmap scan report for" | awk '{print $5}')

for ip in $iplist; do
	echo "==============================================="
	echo "Found SSL port: "$ip
	echo | timeout 10 openssl s_client -showcerts -connect $ip:$port 2>/dev/null | openssl x509 -inform pem -noout -enddate 2> /dev/null | cut -d "=" -f 2
done

