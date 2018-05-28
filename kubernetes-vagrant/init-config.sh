#!/bin/bash

echo "update OS and install necessary packages after boot"
#update OS after boot
sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile

sudo apt-get -y update > /dev/null 2>&1

#Install vim 
sudo apt-get install -y vim tree wget > /dev/null 2>&1

#turn off swap
echo "Turning off swap for kubernetes" 
swapoff -a > /dev/null 2>&1

#Uninstall older version of docker if exists.
echo "Remove/update Docker to version 17.03"
apt-get remove -y docker docker-engine docker.io > /dev/null 2>&1

#Installing Docker CE
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common > /dev/null 2>&1
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - 
apt-key fingerprint 0EBFCD88 
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /dev/null 2>&1
apt-get update -y > /dev/null 2>&1
apt-get install -y docker-ce=17.03.2~ce-0~ubuntu-xenial > /dev/null 2>&1

#Install 'kubeadm' 'kubelet' and 'kubectl'
echo "Install 'kubeadm' 'kubelet' and 'kubectl'"
apt-get update > /dev/null 2>&1
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - 

cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update -y > /dev/null 2>&1

apt-get install -y kubelet kubeadm kubectl > /dev/null 2>&1



