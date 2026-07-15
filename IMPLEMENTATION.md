# Implementation Walkthrough

This guide provides a visual, step-by-step reference for deploying the Harbor Registry. Follow these visual cues to ensure exact reproducibility in your own Proxmox environment.

### 1. VM Provisioning via Cloud-Init
Run `./create-proxmox-vm.sh` on your Proxmox Host. Provide a unique VM ID, name, and a static IP (e.g., `192.168.1.51/24`) when prompted to automatically provision the Ubuntu 22.04 base.
<img src="assets/01-proxmox-vm-creation-start.png" alt="Proxmox VM Creation Prompts" width="800"/>
<br>

Wait for the "SUCCESS" message. The script handles downloading the Cloud-Init image, injecting the credentials, and expanding the disk automatically.
<img src="assets/01-proxmox-vm-creation-success.png" alt="Proxmox VM Creation Output" width="800"/>

### 2. Host Setup & Docker Installation
SSH into your newly created VM (`ssh ubuntu@<Static-IP>`). Clone this repository and execute `sudo ./setup-host.sh` to begin the system hardening.
<img src="assets/02-host-setup-start.png" alt="Host Setup Started" width="800"/>
<br>

The script will automatically allocate a 6GB Swap file (critical for the Trivy scanner) and install the latest Docker engine. Reboot or re-login once complete.
<img src="assets/02-host-setup-success.png" alt="Host Setup and Swap Creation" width="800"/>

### 3. Harbor Registry Installation
Edit the configuration file using `nano harbor.yml.template`. Set your `hostname` and `external_url` to your target domain, and configure secure database/admin passwords. Leave HTTPS commented out.
<img src="assets/03-harbor-install-config.png" alt="Harbor Configuration" width="800"/>
<br>

Execute `sudo ./install-harbor.sh`. The script will download Harbor v2.12.2 and initialize the installation with the Trivy vulnerability scanner enabled.
<img src="assets/03-harbor-install-start.png" alt="Harbor Installation Started" width="800"/>
<br>

Wait until all 10 microservice containers are successfully spun up and you receive the final completion message.
<img src="assets/03-harbor-install-success.png" alt="Harbor Installation Completed" width="800"/>

### 4. Cloudflare DNS Routing
From your Proxmox ingress container, run `./configure-cloudflare.sh`. Provide your Cloudflare Tunnel UUID, your Harbor domain, and the local Harbor VM IP to safely expose the registry without opening firewall ports.
<img src="assets/04-cloudflare-route-success.png" alt="Cloudflare Route Configuration" width="800"/>

### 5. Final Harbor Web Interface
Navigate to your configured domain in any web browser. You can now log in securely using your configured admin credentials and begin managing your artifacts.
<img src="assets/05-harbor-web-ui.png" alt="Harbor Web Dashboard" width="800"/>
