#!/bin/bash

# Ensure script is run with sudo
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (use sudo)"
  exit 1
fi

DIR="$(dirname "$(realpath "$0")")"
SHA_FILE="$DIR/shanames.txt"
#LOG_FILE="$DIR/event_log.txt"

# Log start of checksum generation
#echo "$(date '+%Y-%m-%d %H:%M:%S') - Starting checksum generation" | tee -a "$LOG_FILE"

# Clear shanames.txt before generating new checksums
> "$SHA_FILE"
#echo "$(date '+%Y-%m-%d %H:%M:%S') - Cleared previous checksums from $SHA_FILE" | tee -a "$LOG_FILE"

# Generate SHA-256 checksums for all files in /mnt (excluding log.txt, hidden files, and files matching specific patterns)
find /mnt -type f ! -name "log.txt" ! -name ".*" ! -name ".state_file*" -exec sha256sum {} \; | while read -r sha path; do
    echo "$path - SHA: $sha" >> "$SHA_FILE"
    #echo "$(date '+%Y-%m-%d %H:%M:%S') - Processed file: $path" | tee -a "$LOG_FILE"
done

# Log completion of checksum generation
#echo "$(date '+%Y-%m-%d %H:%M:%S') - Checksum generation completed and saved to $SHA_FILE" | tee -a "$LOG_FILE"