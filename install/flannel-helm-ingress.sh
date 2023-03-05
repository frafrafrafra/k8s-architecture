#!/bin/bash

echo "Installing flannel network"
wget -O /usr/local/kube-flannel.yml https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml
# sed -i 's#10.244.0.0/16#10.240.0.0/24#g' /usr/local/kube-flannel.yml
kubectl apply -f /usr/local/kube-flannel.yml
kubectl get pods --all-namespaces

echo "Installing helm"
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

echo "Install the Helm (v3) chart for nginx ingress controller"
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

# helm upgrade --install ...
helm install ingress ingress-nginx/ingress-nginx \
     --namespace ingress-nginx \
     --create-namespace \
     --set controller.replicaCount=2

exit