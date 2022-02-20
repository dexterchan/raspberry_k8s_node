#!/bin/sh
#https://www.raspberrypi.com/documentation/computers/configuration.html
#https://www.raspberrypi.com/documentation/computers/configuration.html#install-ap-and-management-software
#https://thepi.io/how-to-use-your-raspberry-pi-as-a-wireless-access-point/

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

sudo apt install -y dnsmasq

sudo DEBIAN_FRONTEND=noninteractive apt install -y netfilter-persistent iptables-persistent

#Configure dhcpd service

cat <<EOF > /tmp/add.dhcpcd.conf
interface wlan0
    static ip_address=192.168.4.1/24
    nohook wpa_supplicant
    denyinterfaces eth0
    denyinterfaces wlan0
EOF
cat /tmp/add.dhcpcd.conf >> /etc/dhcpcd.conf

# Setup Internet routing
echo net.ipv4.ip_forward=1 > /tmp/routed-ap.conf
sudo cp /tmp/routed-ap.conf /etc/sysctl.d/routed-ap.conf
cat /tmp/routed-ap.conf | sudo tee -a /etc/sysctl.conf
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo netfilter-persistent save
# IP forward Route is found in  /etc/iptables/

#Configure the DHCP and DNS services for the wireless network
sudo cp /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
#The Raspberry Pi will deliver IP addresses between 192.168.4.2 and 192.168.4.20, 
#with a lease time of 24 hours, to wireless DHCP clients. 
#You should be able to reach the Raspberry Pi under the name gw.wlan from wireless clients.
cat <<EOF > /tmp/add.dnsmasq.conf
interface=wlan0 # Listening interface
dhcp-range=192.168.4.2,192.168.4.20,255.255.255.0,24h
                # Pool of IP addresses served via DHCP
domain=wlan     # Local wireless DNS domain
address=/gw.wlan/192.168.4.1
                # Alias for this router
EOF
cat /tmp/add.dnsmasq.conf | sudo tee -a /etc/dnsmasq.conf
sudo rfkill unblock wlan

# Add a bridge
sudo brctl addbr br0
sudo brctl addif br0 eth0
cat <<EOF > /tmp/bridge.setting
auto br0
iface br0 inet manual
bridge_ports eth0 wlan0
EOF
cat /tmp/bridge.setting | sudo tee -a /etc/network/interfaces


#Configure WIFI /etc/hostapd/hostapd.conf
#sudo cp /boot/wifi5g_config.conf /tmp/hostapd.conf
sudo cp /boot/wifi2g_config.conf /tmp/hostapd.conf
sudo chown pi:pi /tmp/hostapd.conf
sed -i "s|<ssid_to_be_replaced>|${SSID}|g" /tmp/hostapd.conf
sed -i "s|<pwd_to_be_replaced>|${SSID_PWD}|g" /tmp/hostapd.conf

sudo cp /tmp/hostapd.conf /etc/hostapd/hostapd.conf

cat << EOF | sudo tee -a /etc/default/hostapd
DAEMON_CONF="/etc/hostapd/hostapd.conf"
EOF

#sudo systemctl reboot







