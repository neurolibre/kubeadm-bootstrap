#!/bin/bash

sudo docker login $1 --username $2 --password $3
nodes=$(kubectl get nodes --selector='!node-role.kubernetes.io/master' -o jsonpath='{range .items[*].status.addresses[?(@.type=="InternalIP")]}{.address} {end}')

for n in $nodes;
do 
	sudo scp /home/ubuntu/.docker/config.json root@$n:/var/lib/kubelet/config.json
done
