#!/bin/bash
# Description: Helper script to mount the NFS share directly to the control plane for inspection.

sudo apt update && sudo apt install -y nfs-common

# Create a local directory for the mount
sudo mkdir -p /var/data

# Mount the NFS share (IP specific to the lab environment)
sudo mount -t nfs -o nfsvers=3 172.30.2.2:/data /var/data

echo "NFS share mounted at /var/data on the host."
