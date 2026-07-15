# Proxmox Harbor Registry

<p>
  <img alt="Proxmox" src="https://img.shields.io/badge/Proxmox-E57000?style=flat&logo=proxmox&logoColor=white" />
  <img alt="Ubuntu" src="https://img.shields.io/badge/Ubuntu-E95420?style=flat&logo=ubuntu&logoColor=white" />
  <img alt="Docker" src="https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white" />
  <img alt="Harbor" src="https://img.shields.io/badge/Harbor-60B932?style=flat&logo=harbor&logoColor=white" />
  <img alt="Trivy" src="https://img.shields.io/badge/Trivy-1E90FF?style=flat&logo=aquasecurity&logoColor=white" />
  <img alt="Cloudflare" src="https://img.shields.io/badge/Cloudflare-F38020?style=flat&logo=cloudflare&logoColor=white" />
  <img alt="Tailscale" src="https://img.shields.io/badge/Tailscale-FFFFFF?style=flat&logo=tailscale&logoColor=black" />
  <img alt="Bash" src="https://img.shields.io/badge/Bash-4EAA25?style=flat&logo=gnu-bash&logoColor=white" />
</p>

Zero-touch bash automation for deploying a highly-optimized, low-resource Harbor Container Registry on Proxmox, secured via Cloudflare Zero Trust Tunnels.

## Architecture
- **Platform:** Proxmox VE (Ubuntu 22.04 Cloud-Init VM)
- **Resources:** 2 vCPUs, 2GB RAM, 20GB Disk, 6GB Swap
- **Network:** Cloudflare Tunnel (SSL Termination) + Static IP

---

## Phase 1: Proxmox Provisioning
Run this command on your **Proxmox Host** to interactively build and configure the VM:
```bash
wget -qO create-proxmox-vm.sh https://raw.githubusercontent.com/jotyprokash/Proxmox-Harbor-Registry/main/create-proxmox-vm.sh && chmod +x create-proxmox-vm.sh && ./create-proxmox-vm.sh
```

---

## Phase 2: Harbor Deployment
SSH into the newly created VM (`ssh username@<Static-IP>`) and execute:
```bash
git clone https://github.com/jotyprokash/Proxmox-Harbor-Registry.git
cd Proxmox-Harbor-Registry

# 1. Prepare Host (Installs Docker & builds Swap memory)
sudo ./setup-host.sh

# 2. Configure Harbor (Update domain and passwords)
nano harbor.yml.template

# 3. Install Harbor (Deploys registry with Trivy scanner)
sudo ./install-harbor.sh
```

---

## Phase 3: Cloudflare Routing
To expose Harbor securely, SSH into your **internal-ingress** container and run:
```bash
wget -qO configure-cloudflare.sh https://raw.githubusercontent.com/jotyprokash/Proxmox-Harbor-Registry/main/configure-cloudflare.sh && chmod +x configure-cloudflare.sh && ./configure-cloudflare.sh
```
**Done!** Your Harbor registry is now fully secured, routed, and live.

---

[View Implementation Walkthrough](IMPLEMENTATION.md)
