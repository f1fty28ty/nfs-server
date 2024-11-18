#!/bin/bash

# Constants
NFS_NETWORK="nfs-network"

# Function to check and create the Docker network
create_nfs_network() {
    echo "Checking NFS network..."
    if sudo docker network inspect "$NFS_NETWORK" >/dev/null 2>&1; then
        echo "NFS network already exists."
    else
        echo "Creating NFS network..."
        sudo docker network create --driver bridge --subnet 172.25.0.0/16 "$NFS_NETWORK"
    fi
}

# Function to start the NFS server
start_nfs_server() {
    echo "Starting NFS server..."
    sudo docker-compose up -d --force-recreate
}

# Function to set up the Kubernetes cluster
setup_kubernetes_cluster() {
    echo "Creating Kubernetes cluster..."
    sudo kind create cluster --config ./Kubernetes/kind-config.yaml

    echo "Loading Docker image into Kind..."
    sudo kind load docker-image nfs-server:latest --name kind
}

# Function to connect Kubernetes nodes to the Docker network
connect_nodes_to_network() {
    echo "Connecting Kind nodes to the NFS network..."
    for node in kind-control-plane kind-worker kind-worker2; do
        sudo docker network connect "$NFS_NETWORK" "$node"
    done
}

# Function to apply PV, PVC, and deployment
apply_kubernetes_resources() {
    echo "Applying PersistentVolume, PersistentVolumeClaim, and Deployment..."
    sudo kubectl apply -f ./Kubernetes/nfs-pv.yaml
    sudo kubectl apply -f ./Kubernetes/nfs-pvc.yaml
    sudo kubectl apply -f ./Kubernetes/nfs-deployment.yaml
}

# Main execution
create_nfs_network
start_nfs_server
setup_kubernetes_cluster
connect_nodes_to_network
apply_kubernetes_resources

echo "NFS server and Kubernetes cluster setup complete!"
sudo docker ps
sudo kubectl get nodes