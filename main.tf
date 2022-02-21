data template_file "open_vm_tools_service" {
  template = file("${path.module}/open-vm-tools/open-vm-tools.service.tpl")
  vars = {
    open_vm_tools_container_image_uri = var.open_vm_tools_container_image_uri
  }
}

data template_file "ignition" {
  template = <<-EOI
    {
      "ignition": {
        "version": "3.3.0"
      },
      "storage": {
        "files": [
          {
            "path": "/etc/hostname",
            "overwrite": true,
            "contents": {
              "source": "data:,${var.hostname}"
            },
            "mode": 420
          },
          {
            "path": "/etc/sysctl.d/98-ip-unprivileged-port-start.conf",
            "overwrite": true,
            "contents": {
              "source": "data:,net.ipv4.ip_unprivileged_port_start=${var.ip_unprivileged_port_start}"
            }
          },
          {
            "path": "/etc/sysctl.d/20-silence-audit.conf",
            "overwrite": true,
            "contents": {
              "source": "data:text/plain;base64,${base64encode(file("${path.module}/sysctl/20-silence-audit.conf"))}"

            },
            "mode": 420
          },
          {
            "path": "/etc/zincati/config.d/90-updates-strategy.toml",
            "overwrite": true,
            "contents": {
              "source": "data:text/plain;base64,${base64encode(file("${path.module}/zincati/90-updates-strategy.toml"))}"
            },
            "mode": 420
          },
    %{~ for idx, config in var.podman_cni_configurations ~}
          {
    %{~ if config.user == "root" ~}
            "path": "/etc/cni/net.d/87-podman.conflist",
    %{~ else ~}
            "path": "/home/${config.user}/.config/cni/net.d/87-podman.conflist",
    %{~ endif ~}
            "overwrite": true,
            "contents": {
              "source": "data:text/plain;base64,${base64encode(templatefile("${path.module}/podman/87-podman.conflist.tpl", { dns_name = config.dns_name }))}"
            },
            "mode": 420
          },
    %{~ endfor ~}
    %{~ for user in var.additional_users ~}
          {
            "path": "/var/lib/systemd/linger/${user}",
            "mode": 420
          },
    %{~ endfor ~}
          {
            "path": "/var/lib/systemd/linger/core",
            "mode": 420
          }
        ]
      },
      "systemd": {
        "units": [
          {
            "name": "open-vm-tools.service",
            "enabled": true,
            "contents": ${jsonencode(data.template_file.open_vm_tools_service.rendered)}
          }
        ]
      },
      "passwd": {
        "users": [
    %{~ for user in var.additional_users ~}
          {
            "name": "${user}"
          },
    %{~ endfor ~}
          {
            "sshAuthorizedKeys": [
              "${chomp(file(pathexpand(var.core_public_ssh_key_path)))}"
            ],
            "name": "core"
          }
        ]
      }
    }
    EOI
}

locals {
  # Checks that ignition is valid JSON. Helps spot simple serialization bugs.
  validate_ignition = jsondecode(data.template_file.ignition.rendered)
}

