# Ignition CoreOS Base

## What is this module for?

This is a Terraform module to generate an ignition configuration that deploys common Fedora CoreOS configurations, systemd units, etc. 

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
            "source": "data:text/json;base64,${base64encode(module.ignition_coreos_app.ignition)}"
          }
        ]
      }
    }
  }
}
```

## What is in this module?

* Open VM Tools
** A [systemd unit](open-vm-tools/open-vm-tools.service.tpl) that deploys a container running [Open VM Tools](https://github.com/vmware/open-vm-tools)
* Podman Customization
** A [custom configuration](podman/87-podman.conflist.tpl) for podman networking
* Sysctl Customization
** A [sysctl configuration](sysctl/20-silence-audit.conf) that suppresses debug logs
* Zincati Customization
** A [custom upgrade schedule](zincati/90-updates-strategy.toml) for [Zincati](https://github.com/coreos/zincati) auto-upgrades