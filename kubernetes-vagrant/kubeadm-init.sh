#!/bin/bash


#Install GoLang
#echo "Installing GoLang for Kubernetes Config"
#wget https://dl.google.com/go/go1.10.1.linux-amd64.tar.gz

#sudo tar -xvf go1.10.1.linux-amd64.tar.gz
#sudo mv go /usr/local

#echo "export GOROOT=/usr/local/go" >> ~/.profile
#echo "export GOPATH=$HOME/golang/gocode " >> ~/.profile
#echo "export PATH=$GOPATH/bin:$GOROOT/bin:$PATH" >> ~/.profile

#source ~/.profile


#Getting 'crictl' for kubernetes dependency

#go get github.com/kubernetes-incubator/cri-tools/cmd/crictl

#IP address set up during init process for hostonly network.
echo "Getting APIServer IP address from host"
ipaddress=$(ifconfig enp0s9 | sed -n '/inet addr/s/.*inet addr: *\([^[:space:]]\+\).*/\1/p')

echo $ipaddress

#Initializing 'kubeadm'
echo "Initializing 'kubeadm'"
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=$ipaddress

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.10.0/Documentation/kube-flannel.yml

kubectl get pods --all-namespaces
