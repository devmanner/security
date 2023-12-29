#!/bin/bash

tor_node_list="/tmp/tor_exit_nodes_"$(date "+%Y-%m-%d_%H")".lst"
blacklist="/tmp/blacklist_"$(date "+%Y-%m-%d_%H")".lst"

if [ ! -f $blacklist ]; then
	ret=$(curl -s 'https://lists.blocklist.de/lists/all.txt' -o $blacklist --write-out '%{http_code}')
	if [ $ret != "200" ]; then
		echo "Failed to fetch blacklist! HTTP error "$ret
		exit
	fi
fi

if [ ! -f $tor_node_list ]; then
	ret=$(curl -s 'https://check.torproject.org/torbulkexitlist?ip=1.1.1.1' -o $tor_node_list --write-out '%{http_code}')
	if [ $ret != "200" ]; then
		echo "Failed to fetch Tor exit node list! HTTP error "$ret
		exit
	fi
fi

for ip in "$@"; do
	geoiplookup $ip

	grep -q $ip $tor_node_list
	tor_r=$?
	if [ $tor_r -eq 0  ]; then
		echo $ip" is a TOR exit node"
	elif [ $tor_r -eq 1 ]; then
		echo $ip" is NOT a TOR exit node"
	else
		echo "ERROR grepping for TOR"
	fi

	grep -q $ip $blacklist
	blk_r=$?
	if [ $blk_r -eq 0 ]; then
		echo $ip" is blacklisted"
	elif [ $blk_r -eq 1 ]; then
		echo $ip" is NOT blacklisted"
	else
		echo "ERROR grepping for BLACKLIST"
	fi

	asn=$(curl -s https://api.hackertarget.com/aslookup/?q=$ip)
	echo $asn | while IFS="," read -r i as as_range as_name; do		
	    echo AS: ${as//\"/}
    	echo AS Name: ${as_name//\"/}
        echo AS Range: ${as_range//\"/}
	done
done
