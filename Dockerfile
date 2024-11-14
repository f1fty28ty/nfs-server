FROM arm64v8/ubuntu:latest

# Install necessary packages
RUN apt-get update && \
    apt-get install -y nfs-kernel-server rpcbind kmod git cron && \
    rm -rf /var/lib/apt/lists/*

# Create and set permissions for directories
RUN mkdir -p /mnt /logs && \
    chmod 777 /mnt /logs

# Copy NFS exports configuration
COPY exports /etc/exports

# Expose necessary ports
EXPOSE 111/udp 2049/tcp

# Copy the startup and Git logging scripts and make them executable
COPY start-nfs.sh /start-nfs.sh
COPY git_log.sh /git_log.sh
RUN chmod +x /start-nfs.sh /git_log.sh

# Add cron job to execute git_log.sh every minute
RUN echo "*/1 * * * * /git_log.sh >> /logs/log.txt 2>&1" > /etc/cron.d/git-log-cron && \
    chmod 0644 /etc/cron.d/git-log-cron && \
    crontab /etc/cron.d/git-log-cron

# Start both NFS and cron services
CMD ["/bin/bash", "-c", "/start-nfs.sh && cron -f"]