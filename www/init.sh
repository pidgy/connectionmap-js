#!/bin/sh
 
## Connection Map
 
##----------------------------------------------------------------------------------
##----------------------------------------------------------------------------------
## Do not run me unless you are debugging, only service files should run this script
##----------------------------------------------------------------------------------
##----------------------------------------------------------------------------------
 
PYTHON=/usr/bin/python
PARSER=/var/www/connectionmap-js/ip_parser.py
COLLECTOR=/var/www/connectionmap-js/ip_collector.py

# launch the geo-lookup server
$PYTHON $COLLECTOR &
GEO_PID=$!
 
sleep 1
 
# run tcp dump and pipe output to stdin parse_ips
tcpdump -i eth0 -n tcp or udp and not port 22 2>/dev/null 2>/dev/null | grep -P -o '([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+).*? > ([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)' | grep -P -o '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | xargs -n 2 | $PYTHON $PARSER $GEO_PID
