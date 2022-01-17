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
          "source": "data:,${hostname}"
        },
        "mode": 420
      },
      {
        "path": "/etc/sysctl.d/20-silence-audit.conf",
        "overwrite": true,
        "contents": {
          "source": "data:text/plain;base64,${twenty_silence_audit_source}"

        },
        "mode": 420
      },
      {
        "path": "/etc/zincati/config.d/90-updates-strategy.toml",
        "overwrite": true,
        "contents": {
          "source": "data:text/plain;base64,${thirty_updates_strategy_source}"
        },
        "mode": 420
      },
      {
        "path": "/etc/cni/net.d/87-podman.conflist",
        "overwrite": true,
        "contents": {
          "source": "data:text/plain;base64,${eighty_seven_podman_conflist}"
        },
        "mode": 420
      }
    ]
  },
  "systemd": {
    "units": [
      {
        "name": "open-vm-tools.service",
        "enabled": true,
        "contents": ${open_vm_tools_systemd_contents}
      }
    ]
  },
  "passwd": {
    "users": [
      {
        "name": "core",
        "sshAuthorizedKeys": [
          "${public_ssh_key}"
        ]
      }
    ]
  }
}