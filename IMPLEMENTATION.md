# Implementation Walkthrough

This guide provides a visual, step-by-step reference for deploying the Harbor Registry. Follow these visual cues to ensure exact reproducibility in your own Proxmox environment.

### 1. VM Provisioning via Cloud-Init

*Executing the automated provisioning script to define VM resources and static IP configuration.*

<img src="assets/01-proxmox-vm-creation-start.png" alt="Proxmox VM Creation Prompts" width="800"/>
<br>

*Successful Cloud-Init injection and VM boot sequence on the Proxmox host.*

<img src="assets/01-proxmox-vm-creation-success.png" alt="Proxmox VM Creation Output" width="800"/>

### 2. Host Setup & Docker Installation

*SSH into your newly created VM and execute the setup script to begin the system hardening.*

<img src="assets/02-host-setup-start.png" alt="Host Setup Started" width="800"/>
<br>

*System updated, 6GB swap space allocated for Trivy, and Docker engine successfully installed.*

<img src="assets/02-host-setup-success.png" alt="Host Setup and Swap Creation" width="800"/>

### 3. Harbor Registry Installation

*Configuring the Harbor template with the target domain and secure credentials.*

<img src="assets/03-harbor-install-config.png" alt="Harbor Configuration" width="800"/>
<br>

*Pulling the required Harbor v2.12.2 and Trivy scanner container images.*

<img src="assets/03-harbor-install-start.png" alt="Harbor Installation Started" width="800"/>
<br>

*All 10 Harbor microservices successfully deployed and running on the host.*

<img src="assets/03-harbor-install-success.png" alt="Harbor Installation Completed" width="800"/>

### 4. Cloudflare DNS Routing

*Injecting the Harbor VM local IP into the Cloudflare Zero Trust Tunnel configuration.*

<img src="assets/04-cloudflare-route-success.png" alt="Cloudflare Route Configuration" width="800"/>

### 5. Final Harbor Web Interface

*The fully secured, production-ready Harbor Registry interface accessed via Cloudflare.*

<img src="assets/05-harbor-web-ui.png" alt="Harbor Web Dashboard" width="800"/>
