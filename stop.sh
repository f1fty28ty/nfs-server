#!/bin/bash
#
#

echo "Deleting Kube cluster services"
sudo kubectl delete -f ./kubeclust/nfs-deployment.yaml
sudo kubectl delete -f ./kubeclust/nfs-pvc.yaml
sudo kubectl delete -f ./kubeclust/nfs-pv.yaml

echo "Deleting Kind cluster"
sudo kind delete cluster

echo "Stopping nfs-server"
sudo docker stop nfs-server

echo "Stopping nfs-network"
sudo docker network rm nfs-server_nfs-network