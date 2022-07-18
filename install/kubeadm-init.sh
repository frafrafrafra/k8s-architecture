#!/bin/bash

echo "Initializing kubeadm init"
read -p "Enter the ip of controller node: " controller_ip

# Create kubeadm-config.yaml
cat << 'EOF' > /usr/local/kubeadm-config.yaml
kind: ClusterConfiguration
apiVersion: kubeadm.k8s.io/v1beta3
kubernetesVersion: v1.24.0
networking:
  podSubnet: "$controller_ip" # --pod-network-cidr
# controlPlaneEndpoint: <ip/dns> # --control-plane-endpoint (load balancer ip/dns)
---
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
cgroupDriver: systemd
EOF
echo " "
sudo kubeadm init --config=/usr/local/kubeadm-config.yaml

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
echo " "

exit