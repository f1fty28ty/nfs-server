#!/bin/bash

# Prepopulate /mnt from /mnt-copy
echo "Copying default files from /mnt-copy to /mnt..."
cp -R /mnt/* /mnt/ || echo "No files to copy from /mnt-copy"

# Ensure necessary directories exist
mkdir -p /mnt/logs /mnt/clients /mnt/shared
chmod 777 /mnt/logs /mnt/clients /mnt/shared

# Start RPC and NFS services
echo "Starting RPC and NFS services..."
service rpcbind start
service nfs-kernel-server start

# Export NFS directories
echo "Exporting NFS directories..."
exportfs -rav

# Start log-watcher in the background
echo "Starting log watcher..."
nohup /log-watcher.sh &

# Confirmation
echo "NFS server started and configured successfully."