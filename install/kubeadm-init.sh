#!/bin/bash

echo "Initializing kubeadm init"
# Create kubeadm-config.yaml
cat << 'EOF' > /usr/local/kubeadm-config.yaml
kind: ClusterConfiguration
apiVersion: kubeadm.k8s.io/v1beta3
kubernetesVersion: v1.24.0
# controlPlaneEndpoint: <ip/dns> # --control-plane-endpoint (load balancer ip/dns)
networking:
  podSubnet: "10.240.0.0/24" # --pod-network-cidr
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