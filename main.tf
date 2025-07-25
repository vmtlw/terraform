terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}


provider "libvirt" {
  uri = "qemu:///system"
}


resource "libvirt_volume" "vm_disk" {
  count  = var.vm_count
  name   = "node${count.index}.qcow2"
  pool   = "default"
  source = var.base_img_url
  format = "qcow2"
}

data "template_file" "user_data" {
  count    = var.vm_count
  template = file("${path.module}/cloud_init.yml")
  vars = {
    hostname = "k8s-${count.index}"
  }
}

resource "libvirt_cloudinit_disk" "cloudinit" {
  count     = var.vm_count
  name      = "cloudinit-node${count.index}.iso"
  user_data = data.template_file.user_data[count.index].rendered
  pool      = "default"
}

resource "libvirt_domain" "k8s_vm" {
  count     = var.vm_count
  name      = "node${count.index}"
  memory    = var.vm_memory
  vcpu      = var.vm_vcpu
  autostart = true

  disk {
    volume_id = libvirt_volume.vm_disk[count.index].id
  }

  network_interface {
    bridge         = "br0"


  }

  cloudinit = libvirt_cloudinit_disk.cloudinit[count.index].id

}

output "vm_ips" {
  value = [
    for d in libvirt_domain.k8s_vm : try(d.network_interface[0].addresses[0], null)
  ]
}
