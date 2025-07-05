variable "vm_count" {
  default = 4
}

variable "vm_memory" {
  default = 2048
}

variable "vm_vcpu" {
  default = 2
}

variable "vm_image" {
  default = "./qcow/debian-12.qcow2"
}

variable "base_img_url" {
  description = "URL to debian cloud img qcow2"
  type        = string
  default     = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2"
}
