#!/bin/bash
set -e

# By now the master node should be ready!
# Initialize kubeadm
sysctl net.bridge.bridge-nf-call-iptables=1
kubeadm init --pod-network-cidr=10.244.0.0/16

# To use the cluster
mkdir -p $HOME/.kube
cp --remove-destination /etc/kubernetes/admin.conf $HOME/.kube/config
chown ${SUDO_UID} $HOME/.kube/config

# Install flannel
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml

# Make master node a running worker node too!
# FIXME: Use taint tolerations instead in the future
kubectl taint nodes --all node-role.kubernetes.io/master-

# Install helm
curl https://storage.googleapis.com/kubernetes-helm/helm-v2.14.0-linux-amd64.tar.gz | tar xvz
mv linux-amd64/helm /usr/local/bin
rm -rf linux-amd64

kubectl --namespace kube-system create serviceaccount tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller --override spec.selector.matchLabels.'name'='tiller',spec.selector.matchLabels.'app'='helm' --output yaml | sed 's@apiVersion: extensions/v1beta1@apiVersion: apps/v1@' | kubectl apply -f -
kubectl --namespace=kube-system patch deployment tiller-deploy --type=json --patch='[{"op": "add", "path": "/spec/template/spec/containers/0/command", "value": ["/tiller", "--listen=localhost:44134"]}]'

# Wait for tiller to be ready!
kubectl rollout status --namespace=kube-system deployment/tiller-deploy --watch
