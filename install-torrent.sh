#!/bin/sh
#Reference https://pimylifeup.com/raspberry-pi-transmission/
sudo apt install -y transmission-daemon jq
sudo systemctl stop transmission-daemon

# Files written into /mnt/download/Downloads/
# Modify /etc/transmission-daemon/settings.json
sudo cp /etc/transmission-daemon/settings.json /tmp/settings.json
sudo chown pi:pi /tmp/settings.json
folder=/mnt/download/Downloads
tmp=$(mktemp)
jq --arg a "$folder" '."download-dir" = $a' /tmp/settings.json  > "$tmp" && mv "$tmp" /tmp/settings.json
jq --arg a "$folder" '."incomplete-dir" = $a' /tmp/settings.json  > "$tmp" && mv "$tmp" /tmp/settings.json

user=pi
jq --arg a "$user" '."rpc-username" = $a' /tmp/settings.json  > "$tmp" && mv "$tmp" /tmp/settings.json
jq --arg a "$user" '."rpc-password" = $a' /tmp/settings.json  > "$tmp" && mv "$tmp" /tmp/settings.json

whitelistip=192.168.*.*
jq --arg a "$whitelistip" '."rpc-whitelist" = $a' /tmp/settings.json  > "$tmp" && mv "$tmp" /tmp/settings.json

sudo cp  /tmp/settings.json /etc/transmission-daemon/settings.json

#obselete
# sed -i "s|${org_value}|${folder}|g" /tmp/settings.json
# org_value=/var/lib/transmission-daemon/downloads
# sed -i "s|${org_value}|${folder}|g" /tmp/settings.json
# sudo cp /tmp/settings.json /etc/transmission-daemon/settings.json


sudo cp /etc/init.d/transmission-daemon /tmp/transmission-daemon
sudo chown pi:pi /tmp/transmission-daemon

sed -i "s|USER=debian-transmission|USER=pi|g" /tmp/transmission-daemon
sudo cp /tmp/transmission-daemon /etc/init.d/transmission-daemon

sudo cp /etc/systemd/system/multi-user.target.wants/transmission-daemon.service /tmp/transmission-daemon.service
sudo chown pi:pi /tmp/transmission-daemon.service
sed -i "s|User=debian-transmission|User=pi|g" /tmp/transmission-daemon.service
sudo cp /tmp/transmission-daemon.service /etc/systemd/system/multi-user.target.wants/transmission-daemon.service

sudo systemctl daemon-reload
sudo chown -R pi:pi /etc/transmission-daemon

sudo mkdir -p /home/pi/.config/transmission-daemon/
sudo ln -s /etc/transmission-daemon/settings.json /home/pi/.config/transmission-daemon/
sudo chown -R pi:pi /home/pi/.config/transmission-daemon/

sudo systemctl start transmission-daemon

echo "access with http://<IPADDRESS>:9091"