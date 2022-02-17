#!/bin/sh

echo "Setting the hostname..."
sudo hostnamectl set-hostname r2-spoke-router3

echo "Creating amq_runner user with sudo access"
sudo useradd -G wheel -p $(echo amq_password | openssl passwd -1 -stdin) amq_runner

echo "Adding hub router and AMQ brokers to hosts..."
sudo cat <<- HOSTS_EOT >> /etc/hosts
## For hub1, live3 (broker05) and live4 (broker07)
10.75.128.100 amq-hub-router-01
10.76.128.61  amq-live-broker-03
10.76.64.61   amq-live-broker-04
HOSTS_EOT
