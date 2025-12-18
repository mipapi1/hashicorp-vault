////////////////////////////
/// Cloud-Init Variables ///
////////////////////////////

variable "cloud_init_image_url" {
  description = "The URL of the cloud-init image to use"
  type        = string
  default = "https://cloud-images.ubuntu.com/noble/20251213/noble-server-cloudimg-amd64.img"
}

variable "cloud_init_image_checksum" { 
  description = "The checksum of the cloud-init image to use"
  type        = string
  default = "2b5f90ffe8180def601c021c874e55d8303e8bcbfc66fee2b94414f43ac5eb1f"
}

variable "cloud_init_image_file_name" {
  description = "The name of the cloud-init image file"
  type        = string
  default     = "noble-server-cloudimg-amd64.qcow2"
}

/////////////////////////////////
/// Virtual Machine Variables ///
/////////////////////////////////

variable "name" {
  description = "The name of the virtual machine"
  type        = string
}

variable "node_name" {
  description = "The Proxmox node where the VM will be created"
  type        = string
}

variable "ip" {
  description = "The IPv4 address and subnet for the VM"
  type        = string
}

variable "vcpu" {
  description = "Number of virtual CPUs for the VM"
  type        = number
  default     = 2
}

variable "memory" {
  description = "Amount of memory (in MB) for the VM"
  type        = number
  default     = 2048
}

variable "template_vm_id" {
  description = "The VM ID of the template to clone from"
  type        = number
}

variable "disk_size" {
  description = "The Disk size (in GB) for the VM"
  type = number
}


variable "vm_datastore_id" {
  description = "Datastore to use for VM disks"
  type        = string
  default     = "rpool"  
}

variable "cloud_init_datastore_id" {
  description = "Datastore to use for cloud-init files and images"
  type        = string
  default     = "local"
}

variable "disk_interface" {
  description = "Disk interface type"
  type        = string
  default     = "virtio0"
}

variable "disk_file_format" {
  description = "Disk file format"
  type        = string
  default     = "raw"
}

variable "disk_discard" {
  description = "Enable discard on VM disk"
  type        = string
  default     = "on"
}

variable "disk_iothread" {
  description = "Enable IO thread on VM disk"
  type        = bool
  default     = true
}

variable "bridge" {
  description = "Network bridge for VM"
  type        = string
  default     = "vmbr0"
}

variable "gateway" {
  description = "IPv4 gateway for VM"
  type        = string
  default     = "192.168.1.1"
}