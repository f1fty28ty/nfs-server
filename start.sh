#!/bin/bash
#
#

echo "creating NFS Network"
if [ "$(sudo docker network ls | grep nfs-network)"]; then
    echo "NFS network already exists"
else
    sudo docker network create --driver bridge --subnet 172.25.0.0/16 nfs-network
fi

echo "Starting NFS server" 

# Start NFS server 
sudo docker-compose -f docker-compose.yml up -d --force-recreate

echo "Creating Kubernetes cluster..."

# Create the Kubernetes cluster with kind
sudo kind create cluster --config ./Kubernetes/kind-config.yaml

echo "Waiting for Kubernetes control-plane to be ready..."
sudo kubectl wait --for=condition=Ready node/kind-control-plane --timeout=120s
sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.ymlecho "Flannel CNI applied successfully."

echo "Connecting Kind nodes to the NFS network..."

# Connect Kind nodes to the Docker network
sudo docker network connect nfs-network kind-control-plane
sudo docker network connect nfs-network kind-worker
sudo docker network connect nfs-network kind-worker2

echo "Starting up PV, PVC, and Kubernetes deployment for NFS..."

# Apply Kubernetes configurations for NFS
sudo kubectl apply -f ./Kubernetes/nfs-pv.yaml
sudo kubectl apply -f ./Kubernetes/nfs-pvc.yaml
sudo kubectl apply -f ./Kubernetes/nfs-deployment.yaml

echo "NFS server, and Kubernetes cluster setup complete!"

# Display the status of Docker containers and Kubernetes nodes
sudo docker ps
sudo kubectl get nodes
