#!/bin/bash
host_name=$1

if [ -z "$host_name" ]; then
    host_name="k8s-node"
fi
sudo apt-get update -y
sudo apt-get upgrade -y

sudo apt install -y ufw avahi-daemon curl snapd

cd /tmp
curl -fsSL https://get.docker.com -o get-docker.sh


sudo sh get-docker.sh
sudo usermod -aG docker ${USER}

sudo snap install core

#Amend /etc/avahi/avahi-daemon.conf


sudo sed -i 's/#host-name=foo/host-name='${host_name}'/g' /etc/avahi/avahi-daemon.conf