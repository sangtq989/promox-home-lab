terraform {
  required_version = ">=0.14"
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "~>2.9.0"
    }
  }
}

provider "proxmox" {
    pm_api_url = var.proxmox_api_url
    pm_api_token_id = var.proxmox_token_id
    pm_api_token_secret = var.proxmox_token_secret
    pm_tls_insecure = true
}