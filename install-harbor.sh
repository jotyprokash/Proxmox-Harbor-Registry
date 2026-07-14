#!/bin/bash
set -e

HARBOR_VERSION="v2.10.3"
HARBOR_INSTALL_DIR="/opt/harbor"

echo "=> Downloading Harbor Online Installer $HARBOR_VERSION..."
cd /tmp
wget https://github.com/goharbor/harbor/releases/download/${HARBOR_VERSION}/harbor-online-installer-${HARBOR_VERSION}.tgz
tar xzvf harbor-online-installer-${HARBOR_VERSION}.tgz
sudo mv harbor ${HARBOR_INSTALL_DIR}

echo "=> Configuring Harbor..."
cd ${HARBOR_INSTALL_DIR}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

if [ -f "$SCRIPT_DIR/harbor.yml.template" ]; then
    sudo cp "$SCRIPT_DIR/harbor.yml.template" ${HARBOR_INSTALL_DIR}/harbor.yml
    echo "Template copied successfully."
else
    echo "Error: harbor.yml.template not found in $SCRIPT_DIR!"
    exit 1
fi

echo "=> Note: You might need to edit /opt/harbor/harbor.yml if you need to change domain or passwords."
echo "=> Running Harbor installer with Trivy..."
sudo ./install.sh --with-trivy

echo "=> Harbor installation completed!"
