#!/bin/bash
#
#

echo "creating NFS Network"
sudo docker network create --driver bridge --subnet 172.25.0.0/16 nfs-network

echo "Starting NFS server and EFK stack..."

# Start NFS server and EFK stack using docker-compose
sudo docker-compose -f docker-compose.yml up -d --force-recreate
sudo docker-compose -f ./efk/docker-compose.yml up -d --force-recreate

echo "Creating Kubernetes cluster..."

# Create the Kubernetes cluster with kind
sudo kind create cluster --config ./kubeclust/kind-config.yaml

echo "Connecting Kind nodes to the NFS network..."

# Connect Kind nodes to the Docker network
# sudo docker network connect nfs-network elasticsearch
# sudo docker network connect nfs-network fluentd
# sudo docker network connect nfs-network kibana
sudo docker network connect nfs-network kind-control-plane
sudo docker network connect nfs-network kind-worker
sudo docker network connect nfs-network kind-worker2

echo "Starting up PV, PVC, and Kubernetes deployment for NFS..."

# Apply Kubernetes configurations for NFS
sudo kubectl apply -f ./kubeclust/nfs-pv.yaml
sudo kubectl apply -f ./kubeclust/nfs-pvc.yaml
sudo kubectl apply -f ./kubeclust/nfs-deployment.yaml

echo "Applying Filebeat ConfigMap..."

# Apply the Filebeat ConfigMap from the /efk folder
sudo kubectl apply -f ./efk/filebeat-config.yaml
sudo kubectl apply -f ./efk/auditd-rules.yaml

echo "NFS server, EFK stack, and Kubernetes cluster setup complete!"

# Display the status of Docker containers and Kubernetes nodes
sudo docker ps
sudo kubectl get nodes