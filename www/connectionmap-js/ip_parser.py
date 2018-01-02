import sys
import socket
import signal
from os import kill
import psutil

geo_pid = psutil.Process(int(sys.argv[1]))

def handle_sigint(signal, frame):
    print "shutting down geo lookup server"
    try:
        geo_pid.terminate()
    except:
        print "already terminated"
        return

signal.signal(signal.SIGINT, handle_sigint)

print "Launching connectionmap-js"

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.bind(('', 20000))

try:
    for line in sys.stdin:
        line = line.strip("\n")
        line = line.split(" ")
        if len(line) < 2:
            continue
        s.sendto('{"src":"%s", "dst":"%s"}' % (line[0], line[1]), ('', 20001))
except:
    sys.exit()
