#!/bin/bash
#
#

echo "creating NFS Network"
if [ "$(sudo docker network ls | grep nfs-network)" ]; then
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
# Load the Docker image into Kind
sudo kind load docker-image nfs-server:latest --name kind

# Apply the Flannel CNI with a local file
echo "Applying Flannel CNI..."
curl -o kube-flannel.yml https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl apply -f kube-flannel.yml --validate=false

# Ensure nodes are connected to nfs-network
echo "Connecting Kind nodes to the NFS network..."
sudo docker network connect nfs-network kind-control-plane
sudo docker network connect nfs-network kind-worker
sudo docker network connect nfs-network kind-worker2

# Start PV, PVC, and Deployment
echo "Applying PV, PVC, and NFS Deployment..."
sudo kubectl apply -f ./Kubernetes/nfs-pv.yaml
sudo kubectl apply -f ./Kubernetes/nfs-pvc.yaml
sudo kubectl apply -f ./Kubernetes/nfs-deployment.yaml

echo "NFS server, and Kubernetes cluster setup complete!"

# Display the status of Docker containers and Kubernetes nodes
sudo docker ps
sudo kubectl get nodes