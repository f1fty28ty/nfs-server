#!/bin/bash
#
#

echo "Deleting Kube cluster services"
sudo kubectl delete -f ./Kubernetes/nfs-deployment.yaml
sudo kubectl delete -f ./Kubernetes/nfs-pvc.yaml
sudo kubectl delete -f ./Kubernetes/nfs-pv.yaml

echo "Deleting Kind cluster"
sudo kind delete cluster

# Remove Flannel CNI plugin resources (if necessary)
echo "Removing Flannel CNI plugin resources..."
if kubectl get nodes > /dev/null 2>&1; then
    kubectl delete -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml || echo "Flannel CNI already removed or not found."
else
    echo "Kubernetes cluster not available for Flannel cleanup."
fi
echo "Cluster and CNI cleaned up successfully."

echo "Stopping nfs-server"
sudo docker stop nfs-server

echo "Stopping nfs-network"
sudo docker network rm nfs-network