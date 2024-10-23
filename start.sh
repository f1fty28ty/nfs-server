#!/bin/bash
#
#

echo "Starting NFS server..."

sudo docker-compose up -d --force-recreate

echo "Creating Kubernetes cluster..."
sudo kind create cluster --config ./kubeclust/kind-config.yaml

echo "Connecting Kind nodes to the NFS network..."
sudo docker network connect nfs-server_nfs-network kind-control-plane
sudo docker network connect nfs-server_nfs-network kind-worker
sudo docker network connect nfs-server_nfs-network kind-worker2


echo "Starting up PV, PVC , and KubDeployment"
sudo kubectl apply -f ./kubeclust/nfs-pv.yaml
sudo kubectl apply -f ./kubeclust/nfs-pvc.yaml
sudo kubectl apply -f ./kubeclust/nfs-deployment.yaml

echo "NFS server and Kube cluster setup complete!"
sudo docker ps
sudo kubectl get nodes