terraform {
  required_version = ">= 1.9.0"
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = ">= 3.0.1-rc8"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}
