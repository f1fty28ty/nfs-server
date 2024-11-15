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
kubectl delete -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml || echo "Flannel CNI already removed or not found."
echo "Cluster and CNI cleaned up successfully."

echo "Stopping nfs-server"
sudo docker stop nfs-server

echo "Stopping nfs-network"
sudo docker network rm nfs-network