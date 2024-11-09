#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (use sudo)"
  exit 1
fi

DIR="$(dirname "$(realpath "$0")")"
LOG_FILE="$DIR/event_log.txt"

echo "$(date '+%Y-%m-%d %H:%M:%S') - Starting main script execution" >> "$LOG_FILE"

# Main script to run all tasks
/bin/mnt_monitor/nfsGenerateSha.sh
/bin/mnt_monitor/nfsCompareSha.sh

echo "$(date '+%Y-%m-%d %H:%M:%S') - Main script execution completed" >> "$LOG_FILE"