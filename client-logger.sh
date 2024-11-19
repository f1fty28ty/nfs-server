#!/bin/sh

LOGIN_FILE="/mnt/logs/login.txt"
LOG_FILE="/mnt/logs/log.txt"

while true; do
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    CLIENT_NAME=$(hostname)

    # Log login information
    echo "$TIMESTAMP: Client $CLIENT_NAME logged in" >> "$LOGIN_FILE"

    # Append the latest login to log.txt
    tail -n 1 "$LOGIN_FILE" >> "$LOG_FILE"

    sleep 60
done