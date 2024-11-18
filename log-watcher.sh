#!/bin/bash
LOGFILE="/logs/central.log"
LOGINFILE="/logs/login.txt"

# Ensure log directory exists and set permissions
mkdir -p /logs
chmod 700 /logs
chown root:root /logs

# Initialize log files
echo "NFS Central Log Started at $(date)" > $LOGFILE
touch $LOGINFILE

# Monitor login.txt for new activity
inotifywait -m $LOGINFILE -e modify |
while read -r path action file; do
  echo "$(date): User activity logged -> $(tail -n 1 $LOGINFILE)" >> $LOGFILE
done &