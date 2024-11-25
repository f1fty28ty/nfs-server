FROM ubuntu:latest

# Install necessary packages
RUN apt-get update && \
    apt-get install -y nfs-kernel-server rpcbind git cron && \
    mkdir -p /mnt/shared/uploads /mnt/shared/data /mnt/logs && \
    chmod -R 777 /mnt/shared /mnt/logs && \
    cd /mnt/logs && git init 

# Add cron job to commit logs every minute
RUN echo "*/1 * * * * cd /mnt/logs && git add . && git commit -m 'Automated log commit' >> /mnt/logs/git_cron.log 2>&1" > /etc/cron.d/git-log-cron && \
    chmod 0644 /etc/cron.d/git-log-cron && \
    crontab /etc/cron.d/git-log-cron

# Enable and start NFS and RPC services
RUN systemctl enable rpcbind nfs-kernel-server

# Copy NFS exports configuration
COPY exports /etc/exports

# Expose necessary ports
EXPOSE 111/udp 2049/tcp

# Copy the startup script
COPY start-nfs.sh /start-nfs.sh
RUN chmod +x /start-nfs.sh

# Start NFS server and cron services
CMD ["/bin/bash", "-c", "/start-nfs.sh && cron -f"]