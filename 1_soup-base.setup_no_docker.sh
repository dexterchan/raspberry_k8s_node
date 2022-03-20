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
echo 'alias temp="vcgencmd measure_temp"' >> ~/.bashrc 
#Amend /etc/avahi/avahi-daemon.conf
sudo sed -i 's/#host-name=foo/host-name='${host_name}'/g' /etc/avahi/avahi-daemon.conf


sudo update-alternatives --set iptables  /usr/sbin/iptables-nft
echo "Reboot and allow below commands:"
echo sudo ufw allow from 192.168.1.0/24 proto tcp to any port 22
echo sudo ufw --force enable 
