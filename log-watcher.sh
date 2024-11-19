#!/bin/bash
LOGFILE="/logs/central.log"
LOGINFILE="/logs/login.txt"

# Initialize log files
echo "NFS Central Log Started at $(date)" > $LOGFILE
touch $LOGINFILE

# Monitor login.txt for new activity
# Monitor /mnt for changes and log them
inotifywait -m /mnt -e create -e modify -e delete --format '%T %w%f %e' --timefmt '%Y-%m-%d %H:%M:%S' |
while read change; do
  echo "$change" >> /mnt/logs/changes.log
done