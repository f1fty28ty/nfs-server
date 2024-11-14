#!/bin/bash

# Set the hostname to check against (replace 'nfs-server' with your actual NFS server hostname)
NFS_SERVER_HOSTNAME="nfs-server"
LOG_FILE="/mnt/logs/log.txt"

# Get the current hostname
CURRENT_HOSTNAME=$(hostname)

# Navigate to the /mnt directory
cd /mnt

# Check for changes and stage them if there are any
if [ -n "$(git status --porcelain)" ]; then
    git add .

    # Determine commit message based on hostname
    if [ "$CURRENT_HOSTNAME" == "$NFS_SERVER_HOSTNAME" ]; then
        COMMIT_MSG="Automated commit from NFS server"
    else
        COMMIT_MSG="Autocommit from host $CURRENT_HOSTNAME"
    fi

    # Commit the changes
    git commit -m "$COMMIT_MSG"

    # Append commit details to the log file
    echo "$(date): $COMMIT_MSG" >> "$LOG_FILE"
else
    # Log if there were no changes
    echo "$(date): No changes to commit." >> "$LOG_FILE"
fi