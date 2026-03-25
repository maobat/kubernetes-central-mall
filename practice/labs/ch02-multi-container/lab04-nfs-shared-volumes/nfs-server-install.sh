#!/bin/bash
# Description: Helper script to install and configure an NFS Server on a worker node.

echo "Installing NFS Server..."
sudo apt update && sudo apt install -y nfs-kernel-server

echo "Creating shared directory /data..."
sudo mkdir -p /data
sudo chown nobody:nogroup /data
sudo chmod 777 /data

echo "Configuring /etc/exports..."
echo "/data *(rw,sync,no_subtree_check)" | sudo tee /etc/exports

echo "Restarting NFS service..."
sudo systemctl restart nfs-kernel-server

echo "NFS Server setup complete on /data."
