#!/bin/bash

cd /usr/local
sudo apt update -y && sudo apt upgrade -y

echo "Downloading and installing containerd."
echo "For docs: https://github.com/containerd/containerd/blob/main/docs/getting-started.md"
echo " "

echo "Step 1: Installing containerd."
wget -O /usr/local/containerd.tar.gz https://github.com/containerd/containerd/releases/download/v1.6.6/containerd-1.6.6-linux-amd64.tar.gz
tar Cxzvf /usr/local /usr/local/containerd.tar.gz
 
wget -O /usr/local/containerd.service https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
mkdir -p /usr/local/lib/systemd/system/
mv /usr/local/containerd.service /usr/local/lib/systemd/system/

systemctl daemon-reload
systemctl enable --now containerd
echo " "

echo "Step 2: Installing runc."
wget -O /usr/local/runc.amd64 https://github.com/opencontainers/runc/releases/download/v1.1.4/runc.amd64
install -m 755 /usr/local/runc.amd64 /usr/local/sbin/runc

wget -O /usr/local/cni-plugins.tgz https://github.com/containernetworking/plugins/releases/download/v1.2.0/cni-plugins-linux-amd64-v1.2.0.tgz
mkdir -p /opt/cni/bin && tar Cxzvf /opt/cni/bin /usr/local/cni-plugins.tgz
echo " "

echo "Step 3: Customizing containerd."
mkdir /etc/containerd && containerd config default > /etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
sudo systemctl restart containerd
echo " "

echo "Containerd successfully installed :)"
echo " "

echo "Installing kubeadm, kubelet and kubectl"
sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update && sudo apt-get install -y kubelet kubeadm kubectl && sudo apt-mark hold kubelet kubeadm kubectl

echo "Requirements for kubeadm"
#
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
sudo modprobe overlay && sudo modprobe br_netfilter
# 
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
sudo sysctl --system

echo "kubeadm, kubelet and kubectl successfully installed."
echo " "