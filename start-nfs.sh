#!/bin/bash

echo "Starting RPC and NFS services..."
rpcbind
service rpcbind start
service nfs-kernel-server start

echo "Setting up log directory and Git repository..."
cd /mnt/logs
if [ ! -d .git ]; then
    git init
    git add .
    git commit -m "Initial commit"
fi

echo "Exporting NFS directories..."
exportfs -r

echo "NFS server is running."