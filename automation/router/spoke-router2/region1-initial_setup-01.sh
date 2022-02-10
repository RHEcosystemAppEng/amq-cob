#!/bin/sh

echo "Setting the hostname..."
sudo hostnamectl set-hostname r1-spoke-router2

echo "Creating amq_runner user with sudo access"
sudo useradd -G wheel -p $(echo amq_password | openssl passwd -1 -stdin) amq_runner

echo "Adding hub router and AMQ brokers to hosts..."
sudo cat <<- HOSTS_EOT >> /etc/hosts
## For hub1, live1 (broker01) and live2 (broker03)
10.70.128.100 amq-hub-router-01
10.70.0.51    amq-live-broker-01
10.70.128.51  amq-live-broker-02
HOSTS_EOT
