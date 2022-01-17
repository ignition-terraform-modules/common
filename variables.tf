variable "hostname" {
  description = "The hostname of the virtual machine."
  type = string
  default = "fedora-coreos"
}

variable "public_ssh_key_path" {
  description = "File path to an SSH public key used to access virtual machines."
  type = string
  default = "~/.ssh/id_rsa.pub"
}

variable "open_vm_tools_container_image_uri" {
  description = "The container image to use for Open VM Tools."
  default = "ghcr.io/nccurry/open-vm-tools:latest"
}

variable "podman_dns_suffix" {
  description = "The DNS suffix of the podman internal network."
  type = string
  default = "container.domain"
}