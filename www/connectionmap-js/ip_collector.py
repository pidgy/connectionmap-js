import socket
import json
import urllib
import sys
import signal
import io
from netaddr import *

import io
try:
    to_unicode = unicode
except NameError:
    to_unicode = str

print "Launching geo lookup server"

localnet = list(IPNetwork('192.168.0.0/16'))
dns = IPAddress('8.8.8.8')
connections = {}
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.connect(('google.com', 0))
lip = s.getsockname()[0]
localip = IPAddress(lip)

try:
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.bind(('', 20001))
except:
    print "Server is already running!"
    sys.exit()

def dump_json(geoinfo):
    with io.open('/var/www/html/markers.json', 'w', encoding='utf8') as outfile:
        str_ = json.dumps(geoinfo,
        indent=4, sort_keys=True,
        separators=(',', ': '), ensure_ascii=False)
        outfile.write(to_unicode(str_))

def dump_local(geoinfo):
    with io.open('/var/www/html/local.json', 'w', encoding='utf8') as outfile:
        str_ = json.dumps(geoinfo,
        indent=4, sort_keys=True,
        separators=(',', ': '), ensure_ascii=False)
        outfile.write(to_unicode(str_))

dump_local({'ip': lip})

def geo_locate(connectionmap):
    geoconnections = []
    for dst, src in connectionmap.iteritems():
        try:
            urlFoLaction = "http://www.freegeoip.net/json/{0}".format(dst)
            locationInfo = json.loads(urllib.urlopen(urlFoLaction).read())
        except:
            continue
        if str(locationInfo['latitude']) == "0":
            continue
        geoconnections.append({
            'lat': str(locationInfo['latitude']),
            'lng':str(locationInfo['longitude']),
            'ip': str(locationInfo['ip']),
            'city': str(locationInfo['city']),
            'country_code': str(locationInfo['country_code']),
            'country_name': str(locationInfo['country_name']),
            'zip_code': str(locationInfo['zip_code']),
            'src': src
        })
    dump_json(geoconnections)

max = 0
while 1:
    data, addr = s.recvfrom(256)
    ipblock = json.loads(data)
    src = IPAddress(ipblock['src'])
    dst = IPAddress(ipblock['dst'])
    if src in localnet and dst not in localnet and src != localip:
        connections[ipblock['dst']] = ipblock['src']
    max = max + 1
    if max == 10:
        geo_locate(connections)
        max = 0
