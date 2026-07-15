#!/bin/bash
set -e

HARBOR_VERSION="v2.12.2"
HARBOR_INSTALL_DIR="/opt/harbor"

# Save the repo directory before changing paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

echo "=> Downloading Harbor Online Installer $HARBOR_VERSION..."
cd /tmp
wget https://github.com/goharbor/harbor/releases/download/${HARBOR_VERSION}/harbor-online-installer-${HARBOR_VERSION}.tgz
tar xzvf harbor-online-installer-${HARBOR_VERSION}.tgz
sudo mv harbor ${HARBOR_INSTALL_DIR}

echo "=> Applying configuration template..."
cd ${HARBOR_INSTALL_DIR}

if [ -f "$SCRIPT_DIR/harbor.yml.template" ]; then
    sudo cp "$SCRIPT_DIR/harbor.yml.template" ${HARBOR_INSTALL_DIR}/harbor.yml
    echo "Template copied successfully."
else
    echo "Error: harbor.yml.template not found in $SCRIPT_DIR!"
    exit 1
fi

echo "=> Running Harbor installer with Trivy..."
sudo ./install.sh --with-trivy

echo "=> Harbor installation completed!"
