
### Enable ssh
After flashing the image, run following under "/Volumes/boot"
Prepare your WIFI config file "wpa_supplicant.conf"
```
country=us
update_config=1
ctrl_interface=/var/run/wpa_supplicant

network={
 scan_ssid=1
 ssid="<ssid>"
 psk="<password>"
}
```
```
./prepare-sdcard.sh
```

### Prepare the "Soup-base" for the K8s node with raspberry
```
./soup-base.setup.sh
```

# Reference
https://ubuntu.com/tutorials/how-to-kubernetes-cluster-on-raspberry-pi#4-installing-microk8s
https://microk8s.io/
https://wiki.archlinux.org/title/avahi
https://ubuntu.com/tutorials/install-a-local-kubernetes-with-microk8s#3-enable-addons

https://k3s.io/