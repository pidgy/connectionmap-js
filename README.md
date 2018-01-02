# connectionmap-js
## Where's your traffic going?

![alt text](https://i.imgur.com/E4649LF.png "Connection Map")

Display all of the connections leaving your gateway in real time on a map in your browser!

# Setup 

You need a google maps API key to use the map.
Follow instructions <a href=https://developers.google.com/maps/documentation/javascript/get-api-key>here</a>: (its free)

This web server will work for a single machine's traffic, although the best scenario would be a device on your home network receiving all in/out traffic, be it through port mirroring or a network hub.

Simply run the install.sh script as root from the cloned repo repository and follow on-screen instructions!

## Port Mirroring

If you are using a router with openWRT firmware, or your router has ssh capabilities and iptables, you can set it up like I did with 2 iptables commands. (Thanks to Matīss Eriņš @ www.testdevlab.com)

` iptables -A PREROUTING -t mangle -i br-lan ! -d <TEST_DEVICE_IP_ADDRESS> -j TEE --gateway <MONITORING_WORKSTATION_IP_ADDRESS> `

` iptables -A POSTROUTING -t mangle -o br-lan ! -s <TEST_DEVICE_IP_ADDRESS> -j TEE --gateway <MONITORING_WORKSTATION_IP_ADDRESS> `

# How it works:

## The grunt work
- The init.sh script will run tcpdump and filter out src and dst ip addresses from all the seen traffic
- The filtered data is piped to the ip_parser script which load balances the work and sends it to the ip_collector.py server
- The ip_collector.py server will add another layer of filtering to ignore the traffic of the host device, and only add connections where the src address exists in the subnet "192.168.0.0/16".
- Every filtered dst ip address has a geo lookup done through freegeoip.net, after every 100 iterations a markers.json file is updated for use by the web server.

## The web server
- Using a basic apache web service, and some javascript a map is displayed on the web address of the host machine.
- script.js will parse markers.json and add markers to every json objects lat and lng field.
- The page will update every 10 seconds.

## Services and Cron Jobs
- The connectionmap.service file will ensure the grunt work is continually done and handled on startup
- the connectionmapcron cronjob will purge all of the markers once every day.

More on the article <a href="https://www.testdevlab.com/blog/2017/08/setting-up-router-traffic-mirroring-to-wireshark/">here</a> 

![alt text](https://i.imgur.com/eXG98TO.png "Marker description for connected servers")

![alt text](https://i.imgur.com/2Ya53rs.png "Side Panel navigation for overview of all local IP's")

![alt text](https://i.imgur.com/vncXZuw.jpg "Connection Map")
