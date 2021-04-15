# flux-multi-cluster-test

Inspired by post from [medium](https://berndonline.medium.com/how-to-manage-kubernetes-clusters-the-gitops-way-with-flux-cd-c5cf9103a315)

## Insall requirements

[VirtualBox](https://www.virtualbox.org/wiki/Downloads)  
[Vagrant](https://www.vagrantup.com/downloads)

## Cluster preparation 
In this example uses VirtualBox vm's with Vagrant

```bash
cd vagrant
vagrant up
```

We have two simple clusters with one control-plane and one worker node 

### Nodes:

* dev-master
* dev-worker
* prod-master
* prod-worker


## Cluster initialisation
To access to node by ssh you can use base Vagrant feature vagrant ssh to auth to node. For example to auth by ssh to node dev-master prompt command:

```bash
vagrant ssh dev-master
```
ssh to dev-master node

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
ssh to dev-worker node and add node to cluster by command printed by kubeadm

ssh to prod-master node

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

## Install flux
### Install flux on dev cluster

Install flux
```bash
curl -s https://toolkit.fluxcd.io/install.sh | sudo bash
```

Create flux kubernetes namespace
```bash
kubectl create ns flux
```

Generate flux manifests and apply them
```bash
fluxctl install --git-email=nightdesoul@gmail.com --git-url=git@github.com:nightdesoul/flux-multi-cluster-test.git --git-path=clusters/dev,common/dev --manifest-generation=true --git-branch=main --namespace=flux | kubectl apply -f -
```

Get public ssh key from flux and add it to github
```bash
fluxctl identity --k8s-fwd-ns flux
```

Sync cluster with github
```bash
fluxctl sync --k8s-fwd-ns flux
```

### Install flux on prod cluster

Install flux
```bash
curl -s https://toolkit.fluxcd.io/install.sh | sudo bash
```

Create flux kubernetes namespace
```bash
kubectl create ns flux
```

Generate flux manifests and apply them
```bash
fluxctl install --git-email=nightdesoul@gmail.com --git-url=git@github.com:nightdesoul/flux-multi-cluster-test.git --git-path=clusters/prod,common/prod --manifest-generation=true --git-branch=main --namespace=flux | kubectl apply -f -
```

Get public ssh key from flux and add it to github
```bash
fluxctl identity --k8s-fwd-ns flux
```

Sync cluster with github
```bash
fluxctl sync --k8s-fwd-ns flux
```
