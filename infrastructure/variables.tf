variable "proxmox_api_url" {
  type        = string
  description = "Proxmox API URL (e.g., https://proxmox01:8006/api2/json)"
}

variable "proxmox_api_token_id" {
  type        = string
  description = "Proxmox API token ID (format: user@realm!tokenid)"
  sensitive   = true
}

variable "pm_tls_insecure" {
  type        = bool
  description = "Whether to skip the TLS verification step"
  default     = false
}

variable "vms" {
  type        = map(any)
  description = "List of virtual machines to be deployed"
}
