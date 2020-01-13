#!/bin/bash

URL=$1

METHODS="GET POST OPTIONS TRACE PUT DELETE PROPFIND COPY MOVE PATCH"

if [ "" == "$URL" ]; then
    echo "USAGE: $0 URL"
    echo -n "Test running different HTTP methods on URL. The difference between this script and "
	echo -n "for example nmap --script http-methods is that the latter only scans the OPTIONS. "
	echo -n	"OPTIONS may say that a method works but the method is disabled in some other way. "
	echo -n "This script actually tests each method. Some servers (IIS) may answer 404 Not Found "
	echo "instead of 405 Method Not Allowed. Methods tested are:"
    echo $METHODS
    exit -1
fi
    
for m in $METHODS; do
    extra_args=""
    if [ $m == "POST" -o $m == "PUT" -o $m == "PATCH" ]; then
		extra_args="--data ''"
    fi
    r=$(curl $extra_args -v --insecure -X $m $URL 2>&1 | grep '< HTTP/1.')
    echo "==========================================="
    echo "$m : $r"
done
