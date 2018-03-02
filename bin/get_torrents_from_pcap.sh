#!/bin/bash

PCAP=$1
GOOGLER=~/bin/googler.py

if [ "$PCAP" == "" ]; then
	echo "Usage: $0 file.pcap[ng]"
	echo "Search PCAP or PRCAPNG file for torrent hashes. Google those and print out 1:st result."
	echo "Good for finding out what torrents have been downloaded during a PCAP capture session."
	echo "Using googler from: https://github.com/jarun/googler/blob/master/googler"
	echo "and tshark"
	exit -1
fi

for h in $(tshark -V -r "$PCAP" bittorrent | grep "SHA1 Hash of info dictionary"| cut -f 2 -d ":"| sort | uniq); do
	echo "######################################################################################"
	echo $h
	echo
	$GOOGLER -n 1 --nocolor --noprompt $h	

	sleep 2
done

