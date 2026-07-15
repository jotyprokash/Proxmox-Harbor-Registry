#!/bin/bash
set -e

echo "=> Updating system..."
export DEBIAN_FRONTEND=noninteractive
sudo -E apt update
sudo -E apt upgrade -y -q

echo "=> Creating 6GB Swap File (Critical for Trivy on low RAM)..."
if [ ! -f /swapfile ]; then
    sudo fallocate -l 6G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
    echo "Swap file created successfully."
else
    echo "Swap file already exists."
fi

echo "=> Installing Docker and Docker Compose..."
# Install prerequisites
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg || true
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add Docker repo
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "=> Adding current user to docker group..."
sudo usermod -aG docker $USER

echo "=> Host setup complete! Reboot or re-login for docker group to take effect."
echo "=> You can now run install-harbor.sh"
