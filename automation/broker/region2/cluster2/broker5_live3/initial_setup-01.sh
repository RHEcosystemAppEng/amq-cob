#!/bin/sh

echo "Setting hostname..."
sudo hostnamectl set-hostname r2-broker5-live3

# Register the system
insights-client --register

echo "Installing nfs utils..."
sudo dnf install -y nfs-utils

# Install Java and other s/w
echo "Trying to install Java 11..."
sudo dnf install -y java-11-openjdk

echo "trying to install zip/unzip..."
sudo dnf install -y zip unzip

echo "Creating amq_runner user with sudo access"
sudo useradd -G wheel -p $(echo amq_password | openssl passwd -1 -stdin) amq_runner

# *********
# Setup mount point
# *********
LOCAL_MOUNT_DIR="/mnt/nfs_mount/amq"

# Create mount directory
echo "Creating $LOCAL_MOUNT_DIR dir..."
sudo mkdir -p $LOCAL_MOUNT_DIR
sudo chown -R amq_runner:amq_runner /mnt/nfs_mount

echo "Adding nfs server to hosts..."
sudo echo "10.76.64.60  nfs-server" >> /etc/hosts

echo "Adding mount point in etc/fstab..."
# Creaet persistent mount of "/mnt/nfs_shares/amq" server directory to "/mnt/nfs_mount/amq" local dir
sudo echo "nfs-server:/mnt/nfs_shares/amq /mnt/nfs_mount/amq  nfs defaults  0 0" >> /etc/fstab

# Perform the mount
sudo mount -a
