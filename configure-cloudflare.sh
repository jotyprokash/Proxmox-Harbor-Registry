#!/bin/bash
set -e

echo "============================================="
echo "   Cloudflare Tunnel Auto-Configurator       "
echo "============================================="

# Ensure this is being run on the correct server
if ! command -v cloudflared &> /dev/null; then
    echo "ERROR: cloudflared is not installed here!"
    echo "Please run this script inside your 'internal-ingress' container."
    exit 1
fi

read -p "Enter your Cloudflare Tunnel ID (UUID): " TUNNEL_ID
read -p "Enter the new Domain Name (e.g., registry.example.com): " DOMAIN_NAME
read -p "Enter the Harbor VM IP (e.g., 192.168.1.50): " HARBOR_IP

CONFIG_FILE="$HOME/.cloudflared/config.yml"

if [ ! -f "$CONFIG_FILE" ]; then
    CONFIG_FILE="/etc/cloudflared/config.yml"
fi

if [ ! -f "$CONFIG_FILE" ]; then
    echo "ERROR: Could not find cloudflared config.yml"
    exit 1
fi

echo "---------------------------------------------"
echo "Routing: $DOMAIN_NAME ---> http://$HARBOR_IP:80"
echo "Config File: $CONFIG_FILE"
echo "---------------------------------------------"
read -p "Press Enter to apply this configuration..."

# Inject the new route above the 404 catch-all line
# Creates a backup of the config file just in case
cp $CONFIG_FILE ${CONFIG_FILE}.bak

# Use awk to insert the new config right before the 404 rule
awk -v dom="$DOMAIN_NAME" -v ip="$HARBOR_IP" '
/- service: http_status:404/ {
    print "  - hostname: " dom
    print "    service: http://" ip ":80"
    print ""
}
{print}' ${CONFIG_FILE}.bak > $CONFIG_FILE

echo "=> Config updated successfully!"

echo "=> Adding DNS Route to Cloudflare..."
cloudflared tunnel route dns $TUNNEL_ID $DOMAIN_NAME

echo "=> Restarting Cloudflare Tunnel..."
systemctl restart cloudflared || echo "Note: Run 'systemctl restart cloudflared' manually if you don't have root."

echo "============================================="
echo " SUCCESS! Your domain is now live and routing."
echo "============================================="
