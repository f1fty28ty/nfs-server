# Use an ARM-based Ubuntu image instead of Alpine
FROM arm64v8/ubuntu:latest

# Install necessary packages for NFS
RUN apt-get update && \
    apt-get install -y nfs-kernel-server rpcbind

# Create the export directory and set permissions
RUN mkdir -p ./mnt && chmod 777 ./mnt

# Copy export file for NFS config
COPY exports /etc/exports

# Expose the necessary ports for NFS
EXPOSE 111/udp 2049/tcp

# Start the NFS services and keep the container running
CMD [ "/bin/bash", "-c", "rpcbind && service nfs-kernel-server start && tail -f /dev/null" ]