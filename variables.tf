variable "description" {
  description = "Description that will be displayed on the web UI in the Summary/Notes section."
  default     = ""
}

variable "proxmox_target_node" {
  description = "Node name to deploy the container on."
  default     = "pve"
}

variable "container_root_password" {
  description = "Password to set on the container."
  sensitive   = true
}

variable "create_ssh_keys" {
  description = "Flag to create SSH key pair."
  default     = true
}

variable "ssh_public_keys" {
  description = "List of public SSH keys that will be used to access the container."
  type        = list(string)
  default     = []
}

variable "os_template" {
  description = "The [volume identifier](https://pve.proxmox.com/pve-docs/pve-admin-guide.html#_volumes) that points to the OS template or backup file."
  default     = "local:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst"
}

variable "service_protocol" {
  description = "Protocol the installed service uses (ie: http). Required for Traefik reverse DNS discovery labels."
  default     = null
}

variable "service_ip" {
  description = "Static IP reserved for the containerer. Required for Traefik reverse DNS discovery labels."
  default     = null
}

variable "service_port" {
  description = "Port on which the installed service is running (ie: 80). Required for Traefik reverse DNS discovery labels."
  default     = null
}

variable "service_domain" {
  description = "Domain that will be used on the reverse proxy to expose the installed service. Required for Traefik reverse DNS discovery labels."
  default     = null
}

variable "use_traefik_discovery" {
  description = "Flag to enable Traefik discovery labels to be appended to the container Notes field."
  default     = false
}

variable "arch" {
  description = "Sets the container OS architecture type."
  type        = string
  default     = "amd64"
}

variable "bw_limit" {
  description = "A number for setting the override I/O bandwidth limit (in KiB/s)."
  type        = number
  default     = null
}

variable "clone" {
  description = "The lxc vmid to clone."
  type        = number
  default     = null
}

variable "clone_storage" {
  description = "Target storage for full clone."
  type        = string
  default     = null
}

variable "console_mode" {
  description = "Configures console mode. `tty` tries to open a connection to one of the available tty devices. `console` tries to attach to `/dev/console` instead. `shell` simply invokes a shell inside the container (no login)."
  type        = string
  default     = "tty"
}

variable "console" {
  description = "A boolean to attach a console device to the container."
  type        = bool
  default     = true
}

variable "cores" {
  description = "The number of cores assigned to the container. 2 by default."
  type        = number
  default     = 2
}

variable "cpu_limit" {
  description = "A number to limit CPU usage by."
  type        = number
  default     = 0
}

variable "cpu_units" {
  description = "A number of the CPU weight that the container possesses."
  type        = number
  default     = 1024
}

variable "features" {
  description = "An object for allowing the container to access advanced features."
  type = object({
    fuse    = optional(bool)
    keyctl  = optional(bool)
    mount   = optional(string)
    nesting = optional(bool)
  })
  default = { nesting = true }
}

variable "force" {
  description = "A boolean that allows the overwriting of pre-existing containers."
  type        = bool
  default     = false
}

variable "full" {
  description = "When cloning, create a full copy of all disks. This is always done when you clone a normal CT. For CT template it creates a linked clone by default."
  type        = bool
  default     = null
}

variable "ha_state" {
  description = "Requested HA state for the resource. One of 'started', 'stopped', 'enabled', 'disabled', or 'ignored'."
  type        = string
  default     = null
}

variable "ha_group" {
  description = "The HA group identifier the resource belongs to (requires `hastate` to be set!)."
  type        = string
  default     = null
}

variable "hook_script" {
  description = "A string containing [a volume identifier to a script](https://pve.proxmox.com/pve-docs/pve-admin-guide.html#_hookscripts_2) that will be executed during various steps throughout the container's lifetime."
  type        = string
  default     = null
}

variable "hostname" {
  description = "Specifies the host name of the container."
  type        = string
  default     = null
}

variable "ignore_unpack_errors" {
  description = "A boolean that determines if template extraction errors are ignored during container creation."
  type        = bool
  default     = false
}

variable "lock" {
  description = "A string for locking or unlocking the VM."
  type        = string
  default     = null
}

variable "memory" {
  description = "A number containing the amount of RAM to assign to the container (in MB). 1024 by default."
  type        = number
  default     = 1024
}

variable "mount_points" {
  description = "An object for defining a volume to use as a container mount point. Can be specified multiple times."
  type = list(object({
    mp        = string
    slot      = number
    key       = string
    storage   = string
    volume    = string
    size      = optional(string, null)
    acl       = optional(bool, false)
    backup    = optional(bool, false)
    quota     = optional(bool, false)
    replicate = optional(bool, false)
    shared    = optional(bool, false)
  }))
  default = []
}

variable "name_server" {
  description = "The DNS server IP address used by the container. If neither `name_server` nor `search_domain` are specified, the values of the Proxmox host will be used by default."
  type        = string
  default     = null
}

variable "networks" {
  description = "An object defining a network interface for the container. Can be specified multiple times."
  type = list(object({
    name     = string
    bridge   = optional(string)
    firewall = optional(bool)
    gw       = optional(string)
    gw6      = optional(string)
    hwaddr   = optional(string)
    ip       = optional(string)
    ip6      = optional(string)
    mtu      = optional(string)
    rate     = optional(number)
    tag      = optional(number)
  }))
  default = [{
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "dhcp"
  }]
}

variable "on_boot" {
  description = "A boolean that determines if the container will start on boot."
  type        = bool
  default     = true
}

variable "os_type" {
  description = "The operating system type, used by LXC to set up and configure the container. Automatically determined if not set."
  type        = string
  default     = null
}

variable "pool" {
  description = "The name of the Proxmox resource pool to add this container to."
  type        = string
  default     = null
}

variable "protection" {
  description = "A boolean that enables the protection flag on this container. Stops the container and its disk from being removed/updated."
  type        = bool
  default     = false
}

variable "restore" {
  description = "A boolean to mark the container creation/update as a restore task."
  type        = bool
  default     = false
}

variable "rootfs" {
  description = "An object for configuring the root mount point of the container. Can only be specified once. 8GB by default."
  type = object({
    size    = string
    storage = string
  })
  default = {
    storage = "local-lvm"
    size    = "8G"
  }
}

variable "search_domain" {
  description = "Sets the DNS search domains for the container. If neither `nameserver` nor `searchdomain` are specified, the values of the Proxmox host will be used by default."
  type        = string
  default     = null
}

variable "start" {
  description = "A boolean that determines if the container is started after creation."
  type        = bool
  default     = true
}

variable "startup" {
  description = "The [startup and shutdown behaviour](https://pve.proxmox.com/pve-docs/pve-admin-guide.html#pct_startup_and_shutdown) of the container."
  type        = string
  default     = null
}

variable "swap" {
  description = "A number that sets the amount of swap memory available to the container."
  type        = number
  default     = 1024
}

variable "template" {
  description = "A boolean that determines if this container is a template."
  type        = bool
  default     = false
}

variable "tty" {
  description = "A number that specifies the TTYs available to the container."
  type        = number
  default     = 2
}

variable "unique" {
  description = "A boolean that determines if a unique random ethernet address is assigned to the container."
  type        = bool
  default     = false
}

variable "unprivileged" {
  description = "A boolean that makes the container run as an unprivileged user."
  type        = bool
  default     = true
}

variable "vmid" {
  description = "A number that sets the VMID of the container. If set to 0, the next available VMID is used."
  type        = number
  default     = null
}

variable "traefik_router_name" {
  description = "Optional name for Traefik router."
  default     = null
}

variable "traefik_service_name" {
  description = "Optional name for Traefik service."
  default     = null
}

variable "traefik_entrypoints" {
  description = "Entrypoints set for Traefik discovery. Defaults to `.websecure`"
  default     = "websecure"
}

variable "traefik_tls" {
  description = "Enable TLS for Traefik discovery. Defaults to `true`"
  default     = "true"
}

variable "traefik_tls_cert_resolver" {
  description = "Certificate resolver settings for Traefik discovery. Defaults to `myresolver`"
  default     = "myresolver"
}
