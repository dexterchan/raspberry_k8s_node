#!/bin/bash

sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt-get install openvpn openssl openresolv -y

user=$(cat /boot/surfshark.credential | jq -r ".user")
password=$(cat /boot/surfshark.credential | jq -r ".password")

cd /etc/openvpn
sudo wget https://my.surfshark.com/vpn/api/v1/server/configurations
sudo unzip configurations
sudo rm configurations
#Pick Spain setting
ovpnfile=$(find . -name "es*.ovpn" | grep tcp)
cat <<EOF | sudo tee /etc/openvpn/user.txt
$user
$password
EOF

sudo cp $ovpnfile active_ovpn.conf
sudo sed -i "s|auth-user-pass|auth-user-pass /etc/openvpn/user.txt|g" active_ovpn.conf
sudo sed -i 's|verb 3|verb 4|g' active_ovpn.conf
sudo sed -i 's|#AUTOSTART="all"|AUTOSTART="active_ovpn"|g' /etc/default/openvpn

#check resolv conf for dns server
cat /etc/resolv.conf

sudo update-rc.d openvpn enable
sudo service openvpn start

echo "please reboot to take effect"