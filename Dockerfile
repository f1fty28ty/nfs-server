FROM arm64v8/ubuntu:latest

# Install necessary packages
RUN apt-get update && \
    apt-get install -y nfs-kernel-server rpcbind kmod git && \
    rm -rf /var/lib/apt/lists/*

# Create and set permissions for directories
RUN mkdir -p /mnt /logs && \
    chmod 777 /mnt /logs

# Copy NFS exports configuration
COPY exports /etc/exports

# Expose necessary ports
EXPOSE 111/udp 2049/tcp

# Copy the startup script and make it executable
COPY start-nfs.sh /start-nfs.sh
RUN chmod +x /start-nfs.sh

# Copy the Git logging script
COPY git_log.sh /git_log.sh
RUN chmod +x /git_log.sh

# Set the entrypoint
CMD ["/start-nfs.sh"]