#!/bin/sh
cp wpa_supplicant.conf /Volumes/boot
echo cgroup_memory=1 cgroup_enable=memory $(cat /Volumes/boot/cmdline.txt ) > /Volumes/boot/cmdline.txt
touch /Volumes/boot/ssh