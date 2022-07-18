# Kubernetes cluster installation steps:

1.  Create controller node.

2.  Pull k8s-architecture repo.
    - git clone https://github.com/frafrafrafra/k8s-architecture.git

3.  Install kubeadm.
    - bash ./k8s-architecture/install/kubeadm-install.sh

4.  Run kubeadm-init.
    - bash ./k8s-architecture/install/kubeadm-init.sh

5. Grab command to make worker nodes join the control plane.
    - kubeadm join 159.65.186.90:6443 --token nb5he1.s1zuk3sw5c7f6ak0 \
	--discovery-token-ca-cert-hash sha256:c7ccb073c84420d78e330efe66363e6814151041e5c6c41068f8d95167286a0e 
    
6. Install flannel, helm and nginx-ingress.
    - bash ./k8s-architecture/install/flannel-helm-ingress.sh

7. Create worker node.

8. Pull k8s-architecture and install kubeadm.
    1. git clone https://github.com/frafrafrafra/k8s-architecture.git
    2. bash ./k8s-architecture/install/kubeadm-install.sh

9. Make worker node join control plane.
    1. Run command: command from step-5..
    2. Run command: kubectl -n kube-system rollout restart deployment coredns
