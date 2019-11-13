#!/bin/bash

num=0
nodes=$(kubectl get nodes -o jsonpath='{range .items[*].status.addresses[?(@.type=="InternalIP")]}{.address} {end}')

echo "" >> /home/ubuntu/.ssh/config;

for n in $nodes;
do 
	echo "Host node"$num >> /home/ubuntu/.ssh/config;
	echo "        HostName "$n >> /home/ubuntu/.ssh/config;
	echo "        User ubuntu" >> /home/ubuntu/.ssh/config; 
	num=$((num + 1))
done
