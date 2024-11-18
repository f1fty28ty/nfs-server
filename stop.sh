#!/bin/bash

# Constants
FLANNEL_CNI_URL="https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml"
NFS_NETWORK="nfs-network"

# Function to delete Kubernetes resources
delete_kubernetes_resources() {
    echo "Deleting Kubernetes resources..."
    sudo kubectl delete -f ./Kubernetes/nfs-deployment.yaml --ignore-not-found
    sudo kubectl delete -f ./Kubernetes/nfs-pvc.yaml --ignore-not-found
    sudo kubectl delete -f ./Kubernetes/nfs-pv.yaml --ignore-not-found
}

# Function to delete the Kind cluster
delete_kind_cluster() {
    echo "Deleting Kind cluster..."
    sudo kind delete cluster
}

# Function to clean up Flannel CNI
remove_flannel_cni() {
    echo "Removing Flannel CNI..."
    if sudo kubectl get nodes >/dev/null 2>&1; then
        sudo kubectl delete -f "$FLANNEL_CNI_URL" --ignore-not-found || echo "Flannel CNI already removed or not found."
    else
        echo "Kubernetes cluster not available for Flannel cleanup."
    fi
}

# Function to stop and remove the NFS server
stop_nfs_server() {
    echo "Stopping NFS server..."
    sudo docker-compose down
}

# Function to remove the Docker network
remove_nfs_network() {
    echo "Removing NFS network..."
    if sudo docker network inspect "$NFS_NETWORK" >/dev/null 2>&1; then
        sudo docker network rm "$NFS_NETWORK"
    else
        echo "NFS network already removed or not found."
    fi
}

# Main execution
delete_kubernetes_resources
delete_kind_cluster
remove_flannel_cni
stop_nfs_server
remove_nfs_network

echo "Cleanup complete!"