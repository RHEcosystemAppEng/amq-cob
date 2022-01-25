#!/bin/sh

echo "Setting the hostname..."
sudo hostnamectl set-hostname spoke-router5

echo "Creating amq_runner user with sudo access"
sudo useradd -G wheel -p $(echo amq_password | openssl passwd -1 -stdin) amq_runner

echo "Adding hub router and AMQ brokers to hosts..."
sudo cat <<- HOSTS_EOT >> /etc/hosts
## For hub2, live5 (broker09) and live6 (broker11)
10.200.128.100 amq-hub-router-04
10.200.0.51    amq-live-broker-05
10.200.128.51  amq-live-broker-06
HOSTS_EOT
