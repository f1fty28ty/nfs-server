#!/bin/bash

echo "Starting NFS server..."
# Start required services for NFS
service rpcbind start
service nfs-kernel-server start

echo "Running initial logrotate..."
# Perform initial logrotate to ensure setup is working
logrotate /etc/logrotate.d/nfs-logs

echo "Setting up logrotate cron job..."
# Create a cron job for logrotate to run daily
echo "0 0 * * * /usr/sbin/logrotate /etc/logrotate.d/nfs-logs" > /etc/cron.d/nfs-logrotate
chmod 0644 /etc/cron.d/nfs-logrotate
crontab /etc/cron.d/nfs-logrotate

echo "Starting cron service..."
# Start cron in the foreground for containerized environments
cron

echo "NFS server is ready and logging system is active."