#!/bin/bash

echo "update OS and install necessary packages after boot"
#update OS after boot

sudo apt-get -y update

#Install vim 
sudo apt-get install -y vim tree wget

#turn off swap
echo "Turning off swap for kubernetes"
swapoff -a

#Uninstall older version of docker if exists.
echo "Remove/update Docker to version 17.03"
apt-get remove -y docker docker-engine docker.io

#Installing Docker CE
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update -y
apt-get install -y docker-ce=17.03.2~ce-0~ubuntu-xenial

#Install GoLang
echo "Installing GoLang for Kubernetes Config"
wget https://dl.google.com/go/go1.10.1.linux-amd64.tar.gz

sudo tar -xvf go1.10.1.linux-amd64.tar.gz
sudo mv go /usr/local

echo "export GOROOT=/usr/local/go" >> ~/.bashrc
echo "export GOPATH=$HOME/golang/gocode " >> ~/.bashrc
echo "export PATH=$GOPATH/bin:$GOROOT/bin:$PATH" >> ~/.bashrc

source ~/.bashrc

#Install 'kubeadm' 'kubelet' and 'kubectl'
echo "Install 'kubeadm' 'kubelet' and 'kubectl'"
apt-get update && apt-get install -y apt-transport-https curl

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update

apt-get install -y kubelet kubeadm kubectl

#Getting 'crictl' for kubernetes dependency

go get github.com/kubernetes-incubator/cri-tools/cmd/crictl


