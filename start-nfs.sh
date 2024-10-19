#!/bin/bash
#


modprobe nfs || true
modprobe nfsd || true

if ! mountpoint -q /proc/fs/nfsd; then
	mount -t nfsd nfsd /proc/fs/nfsd || true
fi

rpcbind

exportfs -ra

service nfs-kernel-server start

tail -f /dev/null
