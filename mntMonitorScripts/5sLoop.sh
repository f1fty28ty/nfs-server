#!/bin/bash

# Get the directory of this script
DIR="$(dirname "$(realpath "$0")")"
TARGET_SCRIPT="$DIR/mnt_monitor.sh"

# Start an infinite loop
while true; do
    # Run the target script or command
    "$TARGET_SCRIPT"
    
    # Sleep for 5 seconds before the next iteration
    sleep 5
done