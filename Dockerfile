FROM arm64v8/ubuntu:latest

# Install necessary packages
RUN apt-get update && \
    apt-get install -y nfs-kernel-server rpcbind kmod git cron inotify-tools && \
    rm -rf /var/lib/apt/lists/*

# Create directories for NFS
RUN mkdir -p /mnt /logs && chmod 777 /mnt /logs

# Copy default /mnt-copy content to initialize /mnt
COPY ./mnt-copy /mnt

# Copy NFS exports configuration
COPY exports /etc/exports

# Copy scripts for logging and startup
COPY start-nfs.sh /start-nfs.sh
COPY log-watcher.sh /log-watcher.sh
COPY log-client-login.sh /log-client-login.sh
RUN chmod +x /start-nfs.sh /log-watcher.sh /log-client-login.sh

# Add cron job for log rotation
RUN echo "*/1 * * * * /log-watcher.sh >> /mnt/logs/changes.log 2>&1" > /etc/cron.d/log-watcher-cron && \
    chmod 0644 /etc/cron.d/log-watcher-cron && \
    crontab /etc/cron.d/log-watcher-cron

# Expose necessary ports
EXPOSE 111/udp 2049/tcp

# Start both NFS server and cron services
CMD ["/bin/bash", "-c", "/start-nfs.sh && cron -f"]