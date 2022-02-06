#!/bin/sh
sudo snap install microk8s --classic
sudo usermod -a -G microk8s pi
sudo chown -f -R pi ~/.kube
newgrp microk8s

sudo ufw allow in on cni0 && sudo ufw allow out on cni0
sudo ufw default allow routed

microk8s enable dashboard dns registry istio
microk8s enable ingress dns istio

echo 'alias mkubectl="microk8s kubectl"' >> ~/.bashrc