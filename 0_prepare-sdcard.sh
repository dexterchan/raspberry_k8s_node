#!/bin/sh
cp ~/.ssh/wpa_supplicant.conf /Volumes/boot
echo cgroup_memory=1 cgroup_enable=memory $(cat /Volumes/boot/cmdline.txt ) > /Volumes/boot/cmdline.txt
touch /Volumes/boot/ssh
cp 1_soup-base.setup.sh /Volumes/boot
cp 1_soup-base.setup_no_docker.sh /Volumes/boot
cp install-wifiap.sh /Volumes/boot
cp wifi2g_config.conf /Volumes/boot
cp wifi5g_config.conf /Volumes/boot
cp install-nfs.sh /Volumes/boot
cp install-k3s.sh /Volumes/boot
cp install-torrent.sh /Volumes/boot
cp install-microk8s.sh /Volumes/boot
cp install-wifi-bridge.sh /Volumes/boot