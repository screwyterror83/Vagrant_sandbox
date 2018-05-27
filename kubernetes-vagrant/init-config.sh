#!/bin/bash

#update OS after boot
sudo apt-get -y update

#Install vim 
sudo apt-get install -y vim tree 

#turn off swap
swapoff -a
