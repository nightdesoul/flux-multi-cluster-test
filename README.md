# flux-multi-cluster-test

## Insall requirements

## Cluster preparation 
In this example uses VirtualBox vm's with Vagrant

```bash
cd vagrant
vagrant up
```

## Cluster initialisation
Init dev cluster with kubeadm
```bash
kubeadm init --apiserver-advertise-address 192.168.6.11 --cri-socket /var/run/containerd/containerd.sock --pod-network-cidr 10.10.0.0/16
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
curl https://docs.projectcalico.org/manifests/custom-resources.yaml -O
sed -i -e 's/192.168.0.0/10.10.0.0/' custom-resources.yaml
kubectl apply -f custom-resources.yaml
```
Init prod cluset with kubeadm
```bash
kubeadm init --apiserver-advertise-address 192.168.6.21 --cri-socket /var/run/containerd/containerd.sock --pod-network-cidr 10.10.0.0/16
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
curl https://docs.projectcalico.org/manifests/custom-resources.yaml -O
sed -i -e 's/192.168.0.0/10.10.0.0/' custom-resources.yaml
kubectl apply -f custom-resources.yaml
```

Inspired by https://berndonline.medium.com/how-to-manage-kubernetes-clusters-the-gitops-way-with-flux-cd-c5cf9103a315

Install flux
kubectl create ns flux