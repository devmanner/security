#!/bin/bash

node_list="/tmp/tor_exit_nodes_"$(date "+%Y-%m-%d_%H:%M")".lst"

if [ ! -f $node_list ]; then
	curl -s 'https://check.torproject.org/cgi-bin/TorBulkExitList.py?ip=1.1.1.1' | egrep -v "^#" > $node_list
fi

for ip in "$@"; do
	grep -q $ip $node_list
	r=$?
	if [ $r -eq 0  ]; then
		echo $ip" is a TOR exit node"
	elif [ $r -eq 1 ]; then
		echo $ip" is NOT a TOR exit node"
	else
		echo "ERROR grepping"
	fi
	
	
done
