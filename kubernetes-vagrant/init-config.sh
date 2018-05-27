#!/bin/bash

#update OS after boot
sudo apt-get -y update

#Install vim 
sudo apt-get install -y vim tree 

#turn off swap
swapoff -a

#Uninstall older version of docker if exists.

apt-get remove -y docker docker-engine docker.io

#Installing Docker CE
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

apt-key fingerprint 0EBFCD88

add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

apt-get update -y

apt-get install -y docker-ce=17.03.2~ce-0~ubuntu-xenial

#Install 'kubeadm' 'kubelet' and 'kubectl'
apt-get update && apt-get install -y apt-transport-https curl

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update

apt-get install -y kubelet kubeadm kubectl


