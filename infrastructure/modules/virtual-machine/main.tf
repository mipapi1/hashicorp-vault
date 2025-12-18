terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">=0.85.1"
    }
  }
}

# VM
resource "proxmox_virtual_environment_vm" "virtual_machine" {
  name      = var.name
  node_name = var.node_name

  # serial_device {
  #   device = "socket"
  # }

  agent {
    enabled = true
  }

  cpu {
    cores = var.vcpu
  }

  memory {
    dedicated = var.memory
  }

  # Boot disk
  disk {
    datastore_id = var.vm_datastore_id
    import_from  = proxmox_virtual_environment_download_file.cloud_image.id
    interface    = var.disk_interface
    iothread     = var.disk_iothread
    file_format  = var.disk_file_format
    discard      = var.disk_discard
    size         = var.disk_size
  }
  # Cloud-init
  initialization {
    user_data_file_id = proxmox_virtual_environment_file.cloud_config.id
    datastore_id      = var.vm_datastore_id
    ip_config {
      ipv4 {
        address = var.ip
        gateway = var.gateway
      }
    }
  }

  network_device {
    bridge = var.bridge
  }
}

# # Output VM IP
# output "vm_ipv4_address" {
#   value = proxmox_virtual_environment_vm.virtual_machine.ipv4_addresses[1][0]
# }