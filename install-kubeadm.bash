#!/bin/bash
apt-get update
apt-get install -y apt-transport-https ca-certificates curl software-properties-common gnupg2
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-$(lsb_release -cs) main
deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable
EOF

# Install Docker CE
sudo apt-get update && sudo apt-get install -y \
  containerd.io=1.2.13-2 \
  docker-ce=5:19.03.11~3-0~ubuntu-$(lsb_release -cs) \
  docker-ce-cli=5:19.03.11~3-0~ubuntu-$(lsb_release -cs)
# Set up the Docker daemon
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
# Create /etc/systemd/system/docker.service.d
sudo mkdir -p /etc/systemd/system/docker.service.d
# Restart Docker
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo systemctl enable docker
#systemctl stop docker
#modprobe overlay
#echo '{"storage-driver": "overlay2"}' > /etc/docker/daemon.json
#rm -rf /var/lib/docker/*
#systemctl start docker

# Install kubernetes components!
apt-get install -y kubernetes-cni=0.8.7-00
apt-get install -y \
  kubelet=1.19.3-00 \
  kubeadm=1.19.3-00 \
  kubectl=1.19.3-00
sudo apt-mark hold kubelet kubeadm kubectl

