#!/bin/bash

echo "Starting NFS server..."
service rpcbind start
service nfs-kernel-server start

echo "Running initial logrotate..."
logrotate /etc/logrotate.d/nfs-logs

echo "Setting up logrotate cron job..."
echo "0 0 * * * /usr/sbin/logrotate /etc/logrotate.d/nfs-logs" > /etc/cron.d/nfs-logrotate
chmod 0644 /etc/cron.d/nfs-logrotate
crontab /etc/cron.d/nfs-logrotate

echo "Starting cron service..."
cron

echo "Ensuring /mnt/logs exists and is writable..."
mkdir -p /mnt/logs && chmod 777 /mnt/logs

echo "NFS server is ready and logging system is active."