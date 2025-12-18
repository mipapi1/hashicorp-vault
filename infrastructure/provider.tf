terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">=0.85.1"
    }
  }
}

provider "proxmox" {
  endpoint  = var.proxmox_api_url
  api_token = var.proxmox_api_token_id
  insecure  = var.pm_tls_insecure
  ssh {
    username    = "root"
    private_key = file("~/.ssh/id_ed25519")
  }
}
