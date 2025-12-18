module "virtual_machines" {
  source = "./modules/virtual-machine"

  providers = {
    proxmox = proxmox
  }

  for_each = var.vms

  name = each.value.name
  # vm_id         = each.value.vm_id
  node_name      = each.value.node_name
  ip             = each.value.ip
  vcpu           = each.value.vcpu
  memory         = each.value.memory
  template_vm_id = each.value.template_vm_id
  disk_size      = each.value.disk_size
}