FROM arm64v8/ubuntu:latest

# Install necessary packages
RUN apt-get update && \
    apt-get install -y nfs-kernel-server rpcbind kmod git cron logrotate && \
    rm -rf /var/lib/apt/lists/*

# Create and set permissions for directories
RUN mkdir -p /mnt/logs && chmod 777 /mnt/logs

# Copy NFS exports configuration
COPY exports /etc/exports

# Expose necessary ports
EXPOSE 111/udp 2049/tcp

# Copy the startup, log monitoring, and Git logging scripts
COPY start-nfs.sh /start-nfs.sh
COPY log-watcher.sh /log-watcher.sh
RUN chmod +x /start-nfs.sh /log-watcher.sh

# Start NFS and log watcher
CMD ["/bin/bash", "-c", "/start-nfs.sh & /log-watcher.sh & cron -f"]