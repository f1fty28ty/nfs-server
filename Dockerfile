FROM arm64v8/ubuntu:latest

RUN apt-get update && \
apt-get install -y nfs-kernel-server rpcbind kmod

RUN mkdir -p ./mnt && chmod 777 ./mnt

COPY exports /etc/exports

EXPOSE 111/udp 2049/tcp

COPY start-nfs.sh /start-nfs.sh
RUN chmod +x /start-nfs.sh

CMD [ "/start-nfs.sh" ]