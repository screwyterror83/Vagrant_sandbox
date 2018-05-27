#!/bin/bash

#IP address set up during init process for hostonly network.
ipaddress=$(ifconfig enp0s9 | sed -n '/inet addr/s/.*inet addr: *\([^[:space:]]\+\).*/\1/p')

#Initializing 'kubeadm'

kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=$ipaddress
