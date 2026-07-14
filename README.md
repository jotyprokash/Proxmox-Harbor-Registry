# Self-Hosted Harbor Registry Deployment

Zero-touch bash automation for deploying a highly-optimized, low-resource Harbor Container Registry on Proxmox, secured via Cloudflare Zero Trust Tunnels.

## Architecture
* **Platform:** Proxmox VE (Ubuntu 22.04 Cloud-Init VM)
* **Resources:** 2 vCPUs, 2GB RAM, 20GB Disk, 6GB Swap
* **Network:** Cloudflare Tunnel for SSL termination + Static IP

---

## Phase 1: Create the VM (Run on Proxmox Host)

You do not need to clone the entire repository on your Proxmox host. Run this single command to download and execute the interactive VM creation script:

```bash
wget -qO create-proxmox-vm.sh https://raw.githubusercontent.com/jotyprokash/Proxmox-Harbor-Registry/main/create-proxmox-vm.sh && chmod +x create-proxmox-vm.sh && ./create-proxmox-vm.sh
```

---

## Phase 2: Setup Harbor (Run inside the new VM)

Once the VM is running, SSH into it (`ssh username@<Static-IP>`) and clone this full repository:

```bash
git clone https://github.com/jotyprokash/Proxmox-Harbor-Registry.git harbor-deployment
cd harbor-deployment
```

### 1. Prepare the Host Environment
This script upgrades the OS, creates the critical 6GB Swap file, and installs Docker.
```bash
chmod +x setup-host.sh
sudo ./setup-host.sh
```

### 2. Configure Harbor
Edit the template file to match your domain and secure passwords:
```bash
nano harbor.yml.template
```
*(Update `hostname`, `external_url`, `database.password`, and `harbor_admin_password`)*

### 3. Install Harbor
Execute the final script to deploy Harbor with Trivy vulnerability scanning enabled:
```bash
chmod +x install-harbor.sh
sudo ./install-harbor.sh
```

---

## Phase 3: Expose to the Internet (Run on internal-ingress)

You do not need to clone the entire repository on your ingress server! Just SSH into your `internal-ingress` container (or run `pct enter 151` from Proxmox) and run this single command to download and execute the configurator:

```bash
wget -qO configure-cloudflare.sh https://raw.githubusercontent.com/jotyprokash/Proxmox-Harbor-Registry/main/configure-cloudflare.sh && chmod +x configure-cloudflare.sh && ./configure-cloudflare.sh
```

**Done!** Your Harbor registry is now live, secure, and fully routed.
