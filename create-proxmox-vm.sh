#!/bin/bash
set -e

echo "============================================="
echo "   Proxmox VM Creator (Ubuntu Cloud-Init)    "
echo "============================================="

# Prompt for user inputs
read -p "Enter VM ID (e.g., 250): " VM_ID
read -p "Enter VM Name (e.g., harbor-vm): " VM_NAME
read -p "Enter Username for the new VM (e.g., ubuntu): " VM_USER
read -s -p "Enter Password for the new VM: " VM_PASSWORD
echo "" # For newline after hidden password prompt
read -p "Enter Static IP for VM (e.g., 192.168.1.50/24): " VM_IP
read -p "Enter Gateway IP (e.g., 192.168.1.1): " VM_GW

echo "---------------------------------------------"
echo "Preparing to create VM: $VM_ID ($VM_NAME)"
echo "Username: $VM_USER"
echo "Static IP: $VM_IP"
echo "---------------------------------------------"
read -p "Press Enter to start building, or Ctrl+C to cancel..."

# Use Ubuntu 22.04 Jammy Cloud Image
IMAGE_URL="https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
IMAGE_FILE="ubuntu2204-cloud.img"

if [ ! -f "$IMAGE_FILE" ]; then
    echo "=> Downloading Ubuntu 22.04 Cloud Image..."
    wget -O "$IMAGE_FILE" "$IMAGE_URL"
else
    echo "=> Image $IMAGE_FILE already exists! Skipping download."
fi

echo "=> Creating VM Structure (2GB RAM, 2 Cores)..."
qm create $VM_ID --name $VM_NAME --memory 2048 --cores 2 --net0 virtio,bridge=vmbr0

echo "=> Importing disk to local-lvm..."
qm importdisk $VM_ID $IMAGE_FILE local-lvm

echo "=> Configuring hardware and Cloud-Init..."
qm set $VM_ID --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-${VM_ID}-disk-0
qm set $VM_ID --ide2 local-lvm:cloudinit
qm set $VM_ID --boot c --bootdisk scsi0
qm set $VM_ID --serial0 socket --vga serial0

echo "=> Injecting Username, Password, and Static IP securely..."
qm set $VM_ID --ciuser $VM_USER --cipassword $VM_PASSWORD --ipconfig0 ip=$VM_IP,gw=$VM_GW

echo "=> Expanding disk to 20GB..."
qm resize $VM_ID scsi0 20G

echo "=> Starting VM $VM_ID..."
qm start $VM_ID

echo ""
echo "============================================="
echo " SUCCESS! The VM is starting up."
echo " It will take about 30 seconds for Cloud-Init to install the OS."
echo " To find the IP address, check your router or Proxmox GUI."
echo " Once it boots, you can connect using: ssh $VM_USER@<VM_IP_ADDRESS>"
echo "============================================="
