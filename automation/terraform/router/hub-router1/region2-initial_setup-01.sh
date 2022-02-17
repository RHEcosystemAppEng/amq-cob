#!/bin/sh

echo "Setting the hostname..."
sudo hostnamectl set-hostname r2-hub-router1

echo "Creating amq_runner user with sudo access"
sudo useradd -G wheel -p $(echo amq_password | openssl passwd -1 -stdin) amq_runner
