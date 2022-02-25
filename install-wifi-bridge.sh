#!/bin/sh
#https://www.raspberrypi.com/documentation/computers/configuration.html#setting-up-a-bridged-wireless-access-point
SSID=$1
SSID_PWD=$2

if [ -z "$SSID" ]; then
    echo "No SSID defined"
fi

if [ -z "$SSID_PWD" ]; then
    echo "No SSID_PWD defined"
fi

sudo apt install -y hostapd bridge-utils
sudo systemctl unmask hostapd
sudo systemctl enable hostapd


cat <<EOF | sudo tee -a /etc/systemd/network/bridge-br0.netdev
[NetDev]
Name=br0
Kind=bridge
EOF

cat <<EOF | sudo tee -a /etc/systemd/network/br0-member-eth0.network
[Match]
Name=eth0

[Network]
Bridge=br0
EOF

sudo systemctl enable systemd-networkd

echo denyinterfaces wlan0 eth0 > /tmp/dhcpcd.conf
sudo cat /etc/dhcpcd.conf >> /tmp/dhcpcd.conf
echo interface br0 >> /tmp/dhcpcd.conf
sudo cp /tmp/dhcpcd.conf /etc/dhcpcd.conf

sudo rfkill unblock wlan


#Configure WIFI /etc/hostapd/hostapd.conf
#sudo cp /boot/wifi2g_config.conf /tmp/hostapd.conf
sudo cp /boot/wifi5g_config2.conf /tmp/hostapd.conf
sudo chown pi:pi /tmp/hostapd.conf
sed -i "s|<ssid_to_be_replaced>|${SSID}|g" /tmp/hostapd.conf
sed -i "s|<pwd_to_be_replaced>|${SSID_PWD}|g" /tmp/hostapd.conf

sudo cp /tmp/hostapd.conf /etc/hostapd/hostapd.conf

cat << EOF | sudo tee -a /etc/default/hostapd
DAEMON_CONF="/etc/hostapd/hostapd.conf"
EOF
