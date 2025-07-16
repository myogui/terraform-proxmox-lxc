<!-- BEGIN_TF_DOCS -->
# proxmox-lxc

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg?style=flat-square)](LICENSE)

Opinionated Terraform module to create an LXC container on a Proxmox node and, optionally, set labels for Traefik reverse proxy [discovery plugin for Proxmox](https://github.com/NX211/traefik-proxmox-provider).

---

## Requirements

The default values are set to create a Debian container using a CT template located in `local:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst`. Make sure to download this or to set another value to the `os_template` argument.

Creating mount points on unprivileged container requires to connect to the node using the `root@pam` account.

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

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | >= 3.0.1-rc8 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_proxmox"></a> [proxmox](#provider\_proxmox) | >= 3.0.1-rc8 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | ~> 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_this"></a> [this](#module\_this) | cloudposse/label/null | 0.25.0 |

## Resources

| Name | Type |
|------|------|
| [proxmox_lxc.default](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/resources/lxc) | resource |
| [tls_private_key.default](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional key-value pairs to add to each map in `tags_as_list_of_maps`. Not added to `tags` or `id`.<br/>This is for some rare cases where resources want additional configuration of tags<br/>and therefore take a list of maps with tag key, value, and additional configuration. | `map(string)` | `{}` | no |
| <a name="input_arch"></a> [arch](#input\_arch) | Sets the container OS architecture type. | `string` | `"amd64"` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`,<br/>in the order they appear in the list. New attributes are appended to the<br/>end of the list. The elements of the list are joined by the `delimiter`<br/>and treated as a single ID element. | `list(string)` | `[]` | no |
| <a name="input_bw_limit"></a> [bw\_limit](#input\_bw\_limit) | A number for setting the override I/O bandwidth limit (in KiB/s). | `number` | `null` | no |
| <a name="input_clone"></a> [clone](#input\_clone) | The lxc vmid to clone. | `number` | `null` | no |
| <a name="input_clone_storage"></a> [clone\_storage](#input\_clone\_storage) | Target storage for full clone. | `string` | `null` | no |
| <a name="input_console"></a> [console](#input\_console) | A boolean to attach a console device to the container. | `bool` | `true` | no |
| <a name="input_console_mode"></a> [console\_mode](#input\_console\_mode) | Configures console mode. `tty` tries to open a connection to one of the available tty devices. `console` tries to attach to `/dev/console` instead. `shell` simply invokes a shell inside the container (no login). | `string` | `"tty"` | no |
| <a name="input_container_root_password"></a> [container\_root\_password](#input\_container\_root\_password) | Password to set on the container. | `any` | n/a | yes |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br/>See description of individual variables for details.<br/>Leave string and numeric variables as `null` to use default value.<br/>Individual variable settings (non-null) override settings in context object,<br/>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br/>  "additional_tag_map": {},<br/>  "attributes": [],<br/>  "delimiter": null,<br/>  "descriptor_formats": {},<br/>  "enabled": true,<br/>  "environment": null,<br/>  "id_length_limit": null,<br/>  "label_key_case": null,<br/>  "label_order": [],<br/>  "label_value_case": null,<br/>  "labels_as_tags": [<br/>    "unset"<br/>  ],<br/>  "name": null,<br/>  "namespace": null,<br/>  "regex_replace_chars": null,<br/>  "stage": null,<br/>  "tags": {},<br/>  "tenant": null<br/>}</pre> | no |
| <a name="input_cores"></a> [cores](#input\_cores) | The number of cores assigned to the container. 2 by default. | `number` | `2` | no |
| <a name="input_cpu_limit"></a> [cpu\_limit](#input\_cpu\_limit) | A number to limit CPU usage by. | `number` | `0` | no |
| <a name="input_cpu_units"></a> [cpu\_units](#input\_cpu\_units) | A number of the CPU weight that the container possesses. | `number` | `1024` | no |
| <a name="input_create_ssh_keys"></a> [create\_ssh\_keys](#input\_create\_ssh\_keys) | Flag to create SSH key pair. | `bool` | `true` | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between ID elements.<br/>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | Description that will be displayed on the web UI in the Summary/Notes section. | `string` | `""` | no |
| <a name="input_descriptor_formats"></a> [descriptor\_formats](#input\_descriptor\_formats) | Describe additional descriptors to be output in the `descriptors` output map.<br/>Map of maps. Keys are names of descriptors. Values are maps of the form<br/>`{<br/>   format = string<br/>   labels = list(string)<br/>}`<br/>(Type is `any` so the map values can later be enhanced to provide additional options.)<br/>`format` is a Terraform format string to be passed to the `format()` function.<br/>`labels` is a list of labels, in order, to pass to `format()` function.<br/>Label values will be normalized before being passed to `format()` so they will be<br/>identical to how they appear in `id`.<br/>Default is `{}` (`descriptors` output will be empty). | `any` | `{}` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_features"></a> [features](#input\_features) | An object for allowing the container to access advanced features. | <pre>object({<br/>    fuse    = optional(bool)<br/>    keyctl  = optional(bool)<br/>    mount   = optional(string)<br/>    nesting = optional(bool)<br/>  })</pre> | <pre>{<br/>  "nesting": true<br/>}</pre> | no |
| <a name="input_force"></a> [force](#input\_force) | A boolean that allows the overwriting of pre-existing containers. | `bool` | `false` | no |
| <a name="input_full"></a> [full](#input\_full) | When cloning, create a full copy of all disks. This is always done when you clone a normal CT. For CT template it creates a linked clone by default. | `bool` | `null` | no |
| <a name="input_ha_group"></a> [ha\_group](#input\_ha\_group) | The HA group identifier the resource belongs to (requires `hastate` to be set!). | `string` | `null` | no |
| <a name="input_ha_state"></a> [ha\_state](#input\_ha\_state) | Requested HA state for the resource. One of 'started', 'stopped', 'enabled', 'disabled', or 'ignored'. | `string` | `null` | no |
| <a name="input_hook_script"></a> [hook\_script](#input\_hook\_script) | A string containing [a volume identifier to a script](https://pve.proxmox.com/pve-docs/pve-admin-guide.html#_hookscripts_2) that will be executed during various steps throughout the container's lifetime. | `string` | `null` | no |
| <a name="input_hostname"></a> [hostname](#input\_hostname) | Specifies the host name of the container. | `string` | `null` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br/>Set to `0` for unlimited length.<br/>Set to `null` for keep the existing setting, which defaults to `0`.<br/>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_ignore_unpack_errors"></a> [ignore\_unpack\_errors](#input\_ignore\_unpack\_errors) | A boolean that determines if template extraction errors are ignored during container creation. | `bool` | `false` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | Controls the letter case of the `tags` keys (label names) for tags generated by this module.<br/>Does not affect keys of tags passed in via the `tags` input.<br/>Possible values: `lower`, `title`, `upper`.<br/>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The order in which the labels (ID elements) appear in the `id`.<br/>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br/>You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | Controls the letter case of ID elements (labels) as included in `id`,<br/>set as tag values, and output by this module individually.<br/>Does not affect values of tags passed in via the `tags` input.<br/>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br/>Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs.<br/>Default value: `lower`. | `string` | `null` | no |
| <a name="input_labels_as_tags"></a> [labels\_as\_tags](#input\_labels\_as\_tags) | Set of labels (ID elements) to include as tags in the `tags` output.<br/>Default is to include all labels.<br/>Tags with empty values will not be included in the `tags` output.<br/>Set to `[]` to suppress all generated tags.<br/>**Notes:**<br/>  The value of the `name` tag, if included, will be the `id`, not the `name`.<br/>  Unlike other `null-label` inputs, the initial setting of `labels_as_tags` cannot be<br/>  changed in later chained modules. Attempts to change it will be silently ignored. | `set(string)` | <pre>[<br/>  "default"<br/>]</pre> | no |
| <a name="input_lock"></a> [lock](#input\_lock) | A string for locking or unlocking the VM. | `string` | `null` | no |
| <a name="input_memory"></a> [memory](#input\_memory) | A number containing the amount of RAM to assign to the container (in MB). 1024 by default. | `number` | `1024` | no |
| <a name="input_mount_points"></a> [mount\_points](#input\_mount\_points) | An object for defining a volume to use as a container mount point. Can be specified multiple times. | <pre>list(object({<br/>    mp        = string<br/>    size      = string<br/>    slot      = string<br/>    key       = string<br/>    storage   = string<br/>    acl       = optional(bool, false)<br/>    backup    = optional(bool, false)<br/>    quota     = optional(bool, false)<br/>    replicate = optional(bool, false)<br/>    shared    = optional(bool, false)<br/>  }))</pre> | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | ID element. Usually the component or solution name, e.g. 'app' or 'service'.<br/>This is the only ID element not also included as a `tag`.<br/>The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input. | `string` | `null` | no |
| <a name="input_name_server"></a> [name\_server](#input\_name\_server) | The DNS server IP address used by the container. If neither `name_server` nor `search_domain` are specified, the values of the Proxmox host will be used by default. | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique | `string` | `null` | no |
| <a name="input_networks"></a> [networks](#input\_networks) | An object defining a network interface for the container. Can be specified multiple times. | <pre>list(object({<br/>    name     = string<br/>    bridge   = optional(string)<br/>    firewall = optional(bool)<br/>    gw       = optional(string)<br/>    gw6      = optional(string)<br/>    hwaddr   = optional(string)<br/>    ip       = optional(string)<br/>    ip6      = optional(string)<br/>    mtu      = optional(string)<br/>    rate     = optional(number)<br/>    tag      = optional(number)<br/>  }))</pre> | <pre>[<br/>  {<br/>    "bridge": "vmbr0",<br/>    "ip": "dhcp",<br/>    "name": "eth0"<br/>  }<br/>]</pre> | no |
| <a name="input_on_boot"></a> [on\_boot](#input\_on\_boot) | A boolean that determines if the container will start on boot. | `bool` | `true` | no |
| <a name="input_os_template"></a> [os\_template](#input\_os\_template) | The [volume identifier](https://pve.proxmox.com/pve-docs/pve-admin-guide.html#_volumes) that points to the OS template or backup file. | `string` | `"local:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst"` | no |
| <a name="input_os_type"></a> [os\_type](#input\_os\_type) | The operating system type, used by LXC to set up and configure the container. Automatically determined if not set. | `string` | `null` | no |
| <a name="input_pool"></a> [pool](#input\_pool) | The name of the Proxmox resource pool to add this container to. | `string` | `null` | no |
| <a name="input_protection"></a> [protection](#input\_protection) | A boolean that enables the protection flag on this container. Stops the container and its disk from being removed/updated. | `bool` | `false` | no |
| <a name="input_proxmox_target_node"></a> [proxmox\_target\_node](#input\_proxmox\_target\_node) | Node name to deploy the container on. | `string` | `"pve"` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Terraform regular expression (regex) string.<br/>Characters matching the regex will be removed from the ID elements.<br/>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_restore"></a> [restore](#input\_restore) | A boolean to mark the container creation/update as a restore task. | `bool` | `false` | no |
| <a name="input_rootfs"></a> [rootfs](#input\_rootfs) | An object for configuring the root mount point of the container. Can only be specified once. 8GB by default. | <pre>object({<br/>    size    = string<br/>    storage = string<br/>  })</pre> | <pre>{<br/>  "size": "8G",<br/>  "storage": "local-lvm"<br/>}</pre> | no |
| <a name="input_search_domain"></a> [search\_domain](#input\_search\_domain) | Sets the DNS search domains for the container. If neither `nameserver` nor `searchdomain` are specified, the values of the Proxmox host will be used by default. | `string` | `null` | no |
| <a name="input_service_domain"></a> [service\_domain](#input\_service\_domain) | Domain that will be used on the reverse proxy to expose the installed service. Required for Traefik reverse DNS discovery labels. | `any` | `null` | no |
| <a name="input_service_ip"></a> [service\_ip](#input\_service\_ip) | Static IP reserved for the containerer. Required for Traefik reverse DNS discovery labels. | `any` | `null` | no |
| <a name="input_service_port"></a> [service\_port](#input\_service\_port) | Port on which the installed service is running (ie: 80). Required for Traefik reverse DNS discovery labels. | `any` | `null` | no |
| <a name="input_service_protocol"></a> [service\_protocol](#input\_service\_protocol) | Protocol the installed service uses (ie: http). Required for Traefik reverse DNS discovery labels. | `any` | `null` | no |
| <a name="input_ssh_public_keys"></a> [ssh\_public\_keys](#input\_ssh\_public\_keys) | List of public SSH keys that will be used to access the container. | `list(string)` | `[]` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_start"></a> [start](#input\_start) | A boolean that determines if the container is started after creation. | `bool` | `true` | no |
| <a name="input_startup"></a> [startup](#input\_startup) | The [startup and shutdown behaviour](https://pve.proxmox.com/pve-docs/pve-admin-guide.html#pct_startup_and_shutdown) of the container. | `string` | `null` | no |
| <a name="input_swap"></a> [swap](#input\_swap) | A number that sets the amount of swap memory available to the container. | `number` | `1024` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).<br/>Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |
| <a name="input_template"></a> [template](#input\_template) | A boolean that determines if this container is a template. | `bool` | `false` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | ID element \_(Rarely used, not included by default)\_. A customer identifier, indicating who this instance of a resource is for | `string` | `null` | no |
| <a name="input_traefik_entrypoints"></a> [traefik\_entrypoints](#input\_traefik\_entrypoints) | Entrypoints set for Traefik discovery. Defaults to `.websecure` | `string` | `"websecure"` | no |
| <a name="input_traefik_router_name"></a> [traefik\_router\_name](#input\_traefik\_router\_name) | Optional name for Traefik router. | `any` | `null` | no |
| <a name="input_traefik_service_name"></a> [traefik\_service\_name](#input\_traefik\_service\_name) | Optional name for Traefik service. | `any` | `null` | no |
| <a name="input_traefik_tls"></a> [traefik\_tls](#input\_traefik\_tls) | Enable TLS for Traefik discovery. Defaults to `true` | `string` | `"true"` | no |
| <a name="input_traefik_tls_cert_resolver"></a> [traefik\_tls\_cert\_resolver](#input\_traefik\_tls\_cert\_resolver) | Certificate resolver settings for Traefik discovery. Defaults to `myresolver` | `string` | `"myresolver"` | no |
| <a name="input_tty"></a> [tty](#input\_tty) | A number that specifies the TTYs available to the container. | `number` | `2` | no |
| <a name="input_unique"></a> [unique](#input\_unique) | A boolean that determines if a unique random ethernet address is assigned to the container. | `bool` | `false` | no |
| <a name="input_unprivileged"></a> [unprivileged](#input\_unprivileged) | A boolean that makes the container run as an unprivileged user. | `bool` | `true` | no |
| <a name="input_use_traefik_discovery"></a> [use\_traefik\_discovery](#input\_use\_traefik\_discovery) | Flag to enable Traefik discovery labels to be appended to the container Notes field. | `bool` | `false` | no |
| <a name="input_vmid"></a> [vmid](#input\_vmid) | A number that sets the VMID of the container. If set to 0, the next available VMID is used. | `number` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | Id of the created Proxmox LXC container. |
| <a name="output_network"></a> [network](#output\_network) | The network interfaces created for the container. |
| <a name="output_ssh_private_key"></a> [ssh\_private\_key](#output\_ssh\_private\_key) | The value of the private SSH key generated for the container. |

<!-- END_TF_DOCS -->
