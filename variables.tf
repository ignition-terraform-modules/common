variable "hostname" {
  description = "The hostname of the virtual machine."
  type = string
  default = "fedora-coreos"
}

variable "core_public_ssh_key_path" {
  description = "Path to the public SSH key for the default core user."
  type = string
  default = "~/.ssh/id_rsa.pub"
}

variable "additional_users" {
  description = "List of additional users to create."
  type = list(string)
  default = []
}

variable "open_vm_tools_container_image_uri" {
  description = "The container image to use for Open VM Tools."
  default = "ghcr.io/nccurry/open-vm-tools:latest"
}

variable "podman_cni_configurations" {
  description = "List of podman CNI configurations"
  type = list(object({
    user = string
    dns_name = string
  }))
  default = []
}

variable "ip_unprivileged_port_start" {
  description = "The lowest port unprivileged workloads can bind to."
  type = number
  default = "1024"
}