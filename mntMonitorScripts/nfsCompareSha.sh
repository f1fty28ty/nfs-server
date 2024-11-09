#!/bin/bash

# Ensure script is run with sudo
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (use sudo)"
  exit 1
fi

DIR="$(dirname "$(realpath "$0")")"
SHA_FILE="$DIR/shanames.txt"
SHA_BACKUP="$DIR/shanames_backup.txt"
LOG_FILE="/mnt/log.txt"
#EVENT_LOG="$DIR/event_log.txt"
USER=$(hostname -s)

# Log start of checksum comparison
#echo "$(date '+%Y-%m-%d %H:%M:%S') - Starting checksum comparison" | tee -a "$EVENT_LOG"

# Ensure SHA_BACKUP exists; if not, create it as a copy of SHA_FILE
if [[ ! -f "$SHA_BACKUP" ]]; then
    cp "$SHA_FILE" "$SHA_BACKUP"
    #echo "$(date '+%Y-%m-%d %H:%M:%S') - Initial backup created as $SHA_BACKUP" | tee -a "$EVENT_LOG"
    exit 0
fi

modification_found=false
deletion_detected=false

# Loop through each line in shanames.txt to check against all lines in shanames_backup.txt
while IFS= read -r current_line; do
    current_path=$(echo "$current_line" | awk -F " - SHA: " '{print $1}')
    current_sha=$(echo "$current_line" | awk -F " - SHA: " '{print $2}')
    
    match_found=false
    modified=false

    # Log the file currently being compared
    #echo "$(date '+%Y-%m-%d %H:%M:%S') - Comparing file: $current_path" | tee -a "$EVENT_LOG"
    
    while IFS= read -r backup_line; do
        backup_path=$(echo "$backup_line" | awk -F " - SHA: " '{print $1}')
        backup_sha=$(echo "$backup_line" | awk -F " - SHA: " '{print $2}')

        if [[ "$current_path" == "$backup_path" ]]; then
            match_found=true
            if [[ "$current_sha" != "$backup_sha" ]]; then
                modified=true
            fi
            break
        fi
    done < "$SHA_BACKUP"

    if [[ "$match_found" == true && "$modified" == true ]]; then
        current_date=$(date '+%Y-%m-%d %H:%M:%S')
        echo "$current_date $USER modified $current_path - SHA: $current_sha" >> "$LOG_FILE"
        #echo "$(date '+%Y-%m-%d %H:%M:%S') - Modification detected for $current_path, updated in $LOG_FILE" | tee -a "$EVENT_LOG"
        modification_found=true
    fi

done < "$SHA_FILE"

# Check for deleted files by iterating over each entry in shanames_backup.txt
while IFS= read -r backup_line; do
    backup_path=$(echo "$backup_line" | awk -F " - SHA: " '{print $1}')
    backup_sha=$(echo "$backup_line" | awk -F " - SHA: " '{print $2}')

    # If a path in shanames_backup.txt is not found in shanames.txt, it was deleted
    if ! grep -q "$backup_path" "$SHA_FILE"; then
        current_date=$(date '+%Y-%m-%d %H:%M:%S')
        echo "$current_date $USER deleted $backup_path - Last known SHA: $backup_sha" >> "$LOG_FILE"
        #echo "$(date '+%Y-%m-%d %H:%M:%S') - Deletion detected for $backup_path, logged in $LOG_FILE" | tee -a "$EVENT_LOG"
        deletion_detected=true
    fi
done < "$SHA_BACKUP"

# Update the SHA backup if modifications or deletions were found
if [[ "$modification_found" == true || "$deletion_detected" == true ]]; then
    cp "$SHA_FILE" "$SHA_BACKUP"
    #echo "$(date '+%Y-%m-%d %H:%M:%S') - Backup updated with latest checksums in $SHA_BACKUP" | tee -a "$EVENT_LOG"
    #echo "$(date '+%Y-%m-%d %H:%M:%S') - No modifications or deletions detected, backup unchanged" | tee -a "$EVENT_LOG"
fi

# Log completion of checksum comparison
#echo "$(date '+%Y-%m-%d %H:%M:%S') - Checksum comparison completed" | tee -a "$EVENT_LOG"