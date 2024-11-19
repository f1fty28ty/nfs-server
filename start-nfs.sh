#!/bin/bash

echo "Starting NFS server..."
service rpcbind start
service nfs-kernel-server start

echo "Ensuring /mnt/logs exists and is writable..."
mkdir -p /mnt/logs && chmod 777 /mnt/logs

echo "Linking timezone for correct time sync..."
ln -sf /usr/share/zoneinfo/$(cat /etc/timezone) /etc/localtime

echo "Setting up login tracking script..."
cat <<'EOF' > /usr/local/bin/log-client-login.sh
#!/bin/bash
echo "$(date -u '+%Y-%m-%d %H:%M:%S UTC'): Client $(hostname) (IP: $(hostname -i)) logged in" >> /mnt/logs/login.txt
EOF
chmod +x /usr/local/bin/log-client-login.sh

echo "Starting cron service..."
cron

echo "NFS server is ready and logging system is active."