FROM arm64v8/ubuntu:latest

# Install necessary packages
RUN apt-get update && \
    apt-get install -y nfs-kernel-server rpcbind kmod cron && \
    rm -rf /var/lib/apt/lists/*

# Create and set permissions for directories
RUN mkdir -p /mnt /logs && \
    chmod 777 /mnt /logs

# Copy NFS exports configuration
COPY exports /etc/exports

# Expose necessary ports
EXPOSE 111/udp 2049/tcp

# Copy the startup script
COPY start-nfs.sh /start-nfs.sh
RUN chmod +x /start-nfs.sh

# Set timezone to match host
RUN ln -sf /usr/share/zoneinfo/$(cat /etc/timezone) /etc/localtime

# Start NFS and cron services
CMD ["/bin/bash", "-c", "/start-nfs.sh && cron -f"]