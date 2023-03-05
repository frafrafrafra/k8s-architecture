#!/bin/bash

echo "Initializing kubeadm init"
# Get current node ip
controller_ip=$(hostname -I | awk '{print $1}')

# Create kubeadm-config.yaml
cat << EOF > /usr/local/kubeadm-config.yaml
kind: ClusterConfiguration
apiVersion: kubeadm.k8s.io/v1beta3
kubernetesVersion: v1.26.0
networking:
  podSubnet: "10.244.0.0/16" # --pod-network-cidr
# controlPlaneEndpoint: <ip/dns> # --control-plane-endpoint (load balancer ip/dns)
clusterName: "k8s-cluster"
---
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
cgroupDriver: systemd
EOF
echo " "

sudo kubeadm init --config=/usr/local/kubeadm-config.yaml --ignore-preflight-errors=NumCPU

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
echo " "

exit