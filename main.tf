locals {
  hostname             = var.hostname != null ? var.hostname : module.this.id
  description = var.description == "" ? "# ${module.this.name}" : var.description

  set_traefik_labels   = var.use_traefik_discovery && var.service_domain != null && var.service_ip != null && var.service_protocol != null && var.service_port != null
  traefik_router_name  = var.traefik_router_name != null ? var.traefik_router_name : module.this.id
  traefik_service_name = var.traefik_service_name != null ? var.traefik_service_name : module.this.id
  traefik_labels       = local.set_traefik_labels == false ? "" : <<-EOT
traefik.enable=true
traefik.http.routers.${local.traefik_router_name}.rule=Host(`${var.service_domain}`)
traefik.http.routers.${local.traefik_router_name}.entrypoints=${var.traefik_entrypoints}
traefik.http.routers.${local.traefik_router_name}.tls=${var.traefik_tls}
traefik.http.routers.${local.traefik_router_name}.tls.certresolver=${var.traefik_tls_cert_resolver}
traefik.http.routers.${local.traefik_router_name}.service=${local.traefik_service_name}
traefik.http.services.${local.traefik_service_name}.loadbalancer.server.url=${var.service_protocol}://${var.service_ip}:${var.service_port}
traefik.http.services.${local.traefik_service_name}.loadbalancer.server.passHostHeader=true
EOT
}

resource "tls_private_key" "default" {
  count     = var.create_ssh_keys ? 1 : 0
  algorithm = "ED25519"
}

resource "proxmox_lxc" "default" {
  target_node = var.proxmox_target_node

  description = join("\n\n", [local.description, local.traefik_labels])

  hostname             = local.hostname
  ostemplate           = var.os_template
  password             = var.container_root_password
  ostype               = var.os_type
  arch                 = var.arch
  bwlimit              = var.bw_limit
  clone                = var.clone
  clone_storage        = var.clone_storage
  cmode                = var.console_mode
  console              = var.console
  force                = var.force
  full                 = var.full
  hastate              = var.ha_state
  hagroup              = var.ha_group
  hookscript           = var.hook_script
  ignore_unpack_errors = var.ignore_unpack_errors
  lock                 = var.lock
  nameserver           = var.name_server
  onboot               = var.on_boot
  pool                 = var.pool
  protection           = var.protection
  restore              = var.restore
  searchdomain         = var.search_domain
  start                = var.start
  startup              = var.startup
  template             = var.template
  tty                  = var.tty
  unique               = var.unique
  unprivileged         = var.unprivileged
  vmid                 = var.vmid

  cores  = var.cores
  memory = var.memory
  swap   = var.swap

  ssh_public_keys = <<-EOT
    ${join("", tls_private_key.default.*.public_key_openssh)}
    ${join("\n", var.ssh_public_keys)}
  EOT

  rootfs {
    size    = coalesce(var.rootfs.size, "8G")
    storage = coalesce(var.rootfs.storage, "local-zfs")
  }

  dynamic "mountpoint" {
    for_each = var.mount_points
    content {
      mp        = mountpoint.value["mp"]
      size      = mountpoint.value["size"]
      slot      = mountpoint.value["slot"]
      key       = mountpoint.value["key"]
      storage   = mountpoint.value["storage"]
      volume    = mountpoint.value["volume"]
      acl       = mountpoint.value["acl"]
      backup    = mountpoint.value["backup"]
      quota     = mountpoint.value["quota"]
      replicate = mountpoint.value["replicate"]
      shared    = mountpoint.value["shared"]
    }
  }

  dynamic "network" {
    for_each = var.networks
    content {
      name     = network.value["name"]
      bridge   = network.value["bridge"]
      firewall = network.value["firewall"]
      gw       = network.value["gw"]
      gw6      = network.value["gw6"]
      hwaddr   = network.value["hwaddr"]
      ip       = network.value["ip"]
      ip6      = network.value["ip6"]
      mtu      = network.value["mtu"]
      rate     = network.value["rate"]
      tag      = network.value["tag"]
    }
  }

  features {
    fuse    = var.features.fuse
    keyctl  = var.features.keyctl
    mount   = var.features.mount
    nesting = var.features.nesting
  }
}
