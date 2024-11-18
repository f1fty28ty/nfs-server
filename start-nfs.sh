#!/bin/bash

# Export the shared directory
exportfs -rv
rpcbind
nfsd -d
echo "NFS Server started."