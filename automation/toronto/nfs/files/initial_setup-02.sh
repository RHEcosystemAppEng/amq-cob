#!/bin/sh

echo "Setting hostname..."
sudo hostnamectl set-hostname nfs-server-tor-02

insights-client --register

# install nfs-utils (Dandified YUM is the next-generation version of the Yellowdog Updater, Modified (yum))
echo "Installing nfs-utils..."
sudo dnf install nfs-utils -y

# Once the nfs-utils is installed, start and enable nfs-server service
echo "Starting/enabling nfs-server..."
sudo systemctl start nfs-server.service
sudo systemctl enable nfs-server.service

# Create NFS share and make it world writable
echo "Creating Mount directories and changing their permissions..."
sudo mkdir -p /mnt/nfs_shares/amq/files
sudo chown -R nobody: /mnt/nfs_shares/amq
sudo chmod -R 777 /mnt/nfs_shares/amq

# add following line in /etc/exports
echo "Adding mount entries in /etc/exportfs..."
sudo cat <<- EXPORTS_EOF >> /etc/exports
## For Tor1 / Tor2 / Tor3
/mnt/nfs_shares/amq 10.111.0.0/24(rw,insecure,sync,no_all_squash,root_squash) \
                    10.111.64.0/24(rw,insecure,sync,no_all_squash,root_squash) \
                    10.111.128.0/24(rw,insecure,sync,no_all_squash,root_squash)
EXPORTS_EOF

# export above created folder
echo "Exports listing..."
sudo exportfs -arv
