#!/bin/bash
#
#

echo "Deleting Kube cluster services"
sudo kubectl delete -f ./Kubernetes/nfs-deployment.yaml
sudo kubectl delete -f ./Kubernetes/nfs-pvc.yaml
sudo kubectl delete -f ./Kubernetes/nfs-pv.yaml

echo "Deleting Kind cluster"
sudo kind delete cluster

echo "Stopping nfs-server"
sudo docker stop nfs-server

echo "Stopping and removing the logging container..."
docker stop logging-container
docker rm logging-container

echo "Stopping nfs-network"
sudo docker network rm nfs-network