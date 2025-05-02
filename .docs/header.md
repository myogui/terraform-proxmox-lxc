# proxmox-lxc

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg?style=flat-square)](LICENSE)

Opinionated Terraform module to create an LXC container on a Proxmox node and, optionally, set labels for Traefik reverse proxy [discovery plugin for Proxmox](https://github.com/NX211/traefik-proxmox-provider).

---

## Requirements

The default values are set to create a Debian container using a CT template located in `local:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst`. Make sure to download this or to set another value to the `os_template`
 argument.

## Usage

Make sure to set either the `name` variable or the `context = module.this.resource` where `this` is a [null-label](https://github.com/cloudposse/terraform-null-label) module.

> [!IMPORTANT]
>
> We do not pin modules to versions in our examples because of the difficulty of keeping the versions in
> the documentation in sync with the latest released versions. We highly recommend that in your code you pin the version
> to the exact version you are using so that your infrastructure remains stable, and update versions in a systematic way
> so that they do not catch you by surprise.

### With Traefik discovery labels

```hcl
locals {
  my_reserved_static_ip = "10.0.0.7"
}

module "my_lxc_container" {
  source = "guillaume-dussault/lxc/proxmox"
  # We recommend pinning every module to a specific version
  # version = "x.x.x"

  name                    = "my-lxc-container"
  container_root_password = "P4ssw0rd!"

  service_protocol      = "http"
  service_ip            = local.my_reserved_static_ip
  service_port          = "8080"
  service_domain        = "my-lxc-container.example.local"
  use_traefik_discovery = true
}
```

### Without Traefik discovery labels

```hcl
module "my_lxc_container" {
  source = "guillaume-dussault/lxc/proxmox"
  # We recommend pinning every module to a specific version
  # version = "x.x.x"

  name                    = "my-lxc-container"
  container_root_password = "P4ssw0rd!"
}
```
