# Kubernetes cluster installation steps:

1.  Create controller node & worker node.
    - Ubuntu v20.04 (LTS) x64
    - Connect to instances:
        - Controller node:
            - ssh -i ~/.ssh/"k8s-architecture-dev.pem" ubuntu@
        - Worker nodes:
            - ssh -i ~/.ssh/"k8s-architecture-dev.pem" ubuntu@

2.  Pull k8s-architecture repo.
    - sudo su
    - cd /usr/local && git clone https://github.com/frafrafrafra/k8s-architecture.git

3.  Install kubeadm.
    - bash ./k8s-architecture/install/kubeadm-install.sh

4.  Run kubeadm-init.
    - bash ./k8s-architecture/install/kubeadm-init.sh

5. Grab command to make worker nodes join the control plane (on each as root).
    - kubeadm join <controller-ip>:6443 --token <token> \
	--discovery-token-ca-cert-hash sha256:<sha256>
    
6. Install flannel, helm and nginx-ingress (on control plane).
    - bash ./k8s-architecture/install/flannel-helm-ingress.sh

7. Pull k8s-architecture in worker-node and install kubeadm.
    1. cd /usr/local && git clone https://github.com/frafrafrafra/k8s-architecture.git
    2. bash ./k8s-architecture/install/kubeadm-install.sh

8. Make worker node join control plane.
    1. Run command (worker node): command grabbed from step-5.
    2. Run command (controller node): kubectl -n kube-system rollout restart deployment coredns

9. (Optional) Allow control plane to run workloads as well.
    - Run command (controller node): kubectl taint nodes --all node-role.kubernetes.io/master-