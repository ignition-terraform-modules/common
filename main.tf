data template_file "eighty_seven_podman_conflist" {
  template = file("${path.module}/podman/87-podman.conflist.tpl")
  vars = {
    podman_dns_suffix = var.podman_dns_suffix
  }
}

data template_file "open_vm_tools_service" {
  template = file("${path.module}/open-vm-tools/open-vm-tools.service.tpl")
  vars = {
    open_vm_tools_container_image_uri = var.open_vm_tools_container_image_uri
  }
}

data template_file "ignition" {
  template = file("${path.module}/ignition/ignition.json.tpl")
  vars = {
    open_vm_tools_systemd_contents = jsonencode(data.template_file.open_vm_tools_service.rendered)
    thirty_updates_strategy_source = base64encode(file("${path.module}/zincati/90-updates-strategy.toml"))
    twenty_silence_audit_source = base64encode(file("${path.module}/sysctl/20-silence-audit.conf"))
    eighty_seven_podman_conflist = base64encode(data.template_file.eighty_seven_podman_conflist.rendered)
    public_ssh_key = chomp(file(pathexpand(var.public_ssh_key_path)))
    hostname = var.hostname
    ip_unprivileged_port_start = var.ip_unprivileged_port_start
  }
}

locals {
  # Checks that ignition is valid JSON. Helps spot simple serialization bugs.
  validate_ignition = jsondecode(data.template_file.ignition.rendered)
}

