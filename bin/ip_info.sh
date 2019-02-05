#!/bin/bash

tor_node_list="/tmp/tor_exit_nodes_"$(date "+%Y-%m-%d_%H:%M")".lst"
blacklist="/tmp/blacklist_"$(date "+%Y-%m-%d_%H:%M")".lst"

if [ ! -f $blacklist ]; then
	curl -s 'https://lists.blocklist.de/lists/all.txt' > $blacklist
fi

if [ ! -f $tor_node_list ]; then
	curl -s 'https://check.torproject.org/cgi-bin/TorBulkExitList.py?ip=1.1.1.1' | egrep -v "^#" > $tor_node_list
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
done
