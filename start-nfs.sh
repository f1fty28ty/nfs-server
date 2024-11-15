#!/bin/bash

# Start rpcbind and NFS server
service rpcbind start
service nfs-kernel-server start

# Ensure /mnt is initialized as a Git repository if not already done
cd /mnt
if [ ! -d ".git" ]; then
    git init
    echo "Git repository initialized in /mnt."
fi

# Schedule git_log.sh to run every minute to log file changes
echo "* * * * * /git_log.sh" > /etc/cron.d/gitlog
chmod 0644 /etc/cron.d/gitlog
crontab /etc/cron.d/gitlog
service cron start

# Keep the container running
tail -f /dev/null