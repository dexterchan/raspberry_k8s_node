#!/bin/bash
host_name=$1

sudo sed -i 's/# en_US.UTF-8/en_US.UTF-8/g' /etc/locale.gen
sudo locale-gen

#Then edit  /etc/default/locale 
cat <<EOF > /tmp/locale 
LANG=en_US.UTF-8
LC_MESSAGES=en_US.UTF-8
EOF
sudo mv /tmp/locale /etc/default/locale 

if [ -z "$host_name" ]; then
    host_name="ant-node"
fi
sudo apt-get update -y
sudo apt-get upgrade -y

sudo apt install -y ufw avahi-daemon curl

cd /tmp
curl -fsSL https://get.docker.com -o get-docker.sh

#Amend /etc/avahi/avahi-daemon.conf
sudo sed -i 's/#host-name=foo/host-name='${host_name}'/g' /etc/avahi/avahi-daemon.conf