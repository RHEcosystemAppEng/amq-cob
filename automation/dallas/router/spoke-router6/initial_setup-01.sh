#!/bin/sh

echo "Setting the hostname..."
sudo hostnamectl set-hostname spoke-router6

echo "Creating amq_runner user with sudo access"
sudo useradd -G wheel -p $(echo amq_password | openssl passwd -1 -stdin) amq_runner

echo "Adding hub router and AMQ brokers to hosts..."
sudo cat <<- HOSTS_EOT >> /etc/hosts
## For hub2, live7 (broker13) and live8 (broker15)
10.200.128.100 amq-hub-router-04
10.200.0.51    amq-live-broker-07
10.200.128.51  amq-live-broker-08
HOSTS_EOT
