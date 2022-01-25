#!/bin/sh

echo "Setting the hostname..."
sudo hostnamectl set-hostname spoke-router5

echo "Creating amq_runner user with sudo access"
sudo useradd -G wheel -p $(echo amq_password | openssl passwd -1 -stdin) amq_runner

echo "Adding hub router and AMQ brokers to hosts..."
sudo cat <<- HOSTS_EOT >> /etc/hosts
## For hub1, live1 (broker01) and live2 (broker03)
10.110.128.100 amq-hub-router-01
10.110.0.51    amq-live-broker-01
10.110.128.51  amq-live-broker-02
HOSTS_EOT
