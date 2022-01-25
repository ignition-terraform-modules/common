# Ignition Terraform Modules: Common

## What is this module for?

This is a [Terraform module](https://www.terraform.io/language/modules) to generate a [CoreOS ignition](https://coreos.github.io/ignition/) configuration that deploys common [Fedora CoreOS](https://getfedora.org/en/coreos?stream=stable) configurations, systemd units, etc. 

This module is intended to be merged in with other ignition configurations. For example:

```hcl
module "ignition_coreos_common" {
  source = "github.com/ignition-terraform-modules/common"
  hostname = "fcos"
  public_ssh_key_path = "/home/user/.ssh/fcos.pub"
  open_vm_tools_container_image_uri = "ghcr.io/nccurry/open-vm-tools:latest"
  podman_dns_suffix = "containers.local"
}

locals {
  ignition = {
    "ignition": {
      "version": "3.3.0",
      "config": {
        "merge": [
          {
            "source": "data:text/json;base64,${base64encode(module.ignition_coreos_common.ignition)}"
          },
          {
            "source": "data:text/json;base64,${base64encode(module.ignition_coreos_traefik.ignition)}"
          }
        ]
      }
    }
  }
}
```

You can then feed ```local.ignition``` into a Terraform provider that is deploying a Fedora CoreOS server. For example:

```hcl
resource "vsphere_virtual_machine" "fedora_coreos_vm" {
  name = var.hostname
  resource_pool_id = var.vsphere_resource_pool_id
  datastore_id = data.vsphere_datastore.datastore.id
  folder = var.vsphere_folder
  
  # ...
  
  clone {
    template_uuid = var.ova_content_library_item_id
  }
  extra_config = {
    "guestinfo.ignition.config.data"          = base64encode(local.ignition)
    "guestinfo.ignition.config.data.encoding" = "base64"
  }
}
```

## What is in this module?

* Open VM Tools
  * A [systemd unit](open-vm-tools/open-vm-tools.service.tpl) that deploys a container running [Open VM Tools](https://github.com/vmware/open-vm-tools)
* Podman Customization
  * A [custom configuration](podman/87-podman.conflist.tpl) for podman networking
* Sysctl Customization
  * A [sysctl configuration](sysctl/20-silence-audit.conf) that suppresses debug logs
* Zincati Customization
  * A [custom upgrade schedule](zincati/90-updates-strategy.toml) for [Zincati](https://github.com/coreos/zincati) auto-upgrades