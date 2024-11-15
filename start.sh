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

echo "Starting NFS server" 
# Start NFS server with static IP
sudo docker-compose -f docker-compose.yml up -d --force-recreate
sudo docker network connect --ip 172.25.0.2 nfs-network nfs-server

echo "Creating Kubernetes cluster..."

# Create the Kubernetes cluster with kind
sudo kind create cluster --config ./Kubernetes/kind-config.yaml

echo "Applying Flannel CNI..."
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml --validate=false
echo "Waiting for Flannel CNI to be ready..."
kubectl -n kube-system wait --for=condition=Ready pod -l app=flannel --timeout=300s


# Wait for the CNI to initialize (add a 15-second delay)
sleep 15

echo "Connecting Kind nodes to the NFS network..."

# Connect Kind nodes to the Docker network
sudo docker network connect nfs-network kind-control-plane
sudo docker network connect nfs-network kind-worker
sudo docker network connect nfs-network kind-worker2

echo "Starting up PV, PVC, and Kubernetes deployment for NFS..."

# Test network connectivity between Kubernetes nodes and NFS server
echo "Testing connectivity..."
sudo docker exec kind-control-plane ping -c 4 172.25.0.2 || echo "Control-plane unable to reach NFS server."
sudo docker exec kind-worker ping -c 4 172.25.0.2 || echo "Worker node 1 unable to reach NFS server."
sudo docker exec kind-worker2 ping -c 4 172.25.0.2 || echo "Worker node 2 unable to reach NFS server."

# Apply Kubernetes configurations for NFS
sudo kubectl apply -f ./Kubernetes/nfs-pv.yaml
sudo kubectl apply -f ./Kubernetes/nfs-pvc.yaml
sudo kubectl apply -f ./Kubernetes/nfs-deployment.yaml

echo "NFS server, and Kubernetes cluster setup complete!"

# Display the status of Docker containers and Kubernetes nodes
sudo docker ps
sudo kubectl get nodes
