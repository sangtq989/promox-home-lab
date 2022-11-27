
# Promox variable
variable "proxmox_api_url" {
  type = string
  description = "Proxmox api url"
}

variable "proxmox_token_id" {
  type = string
  sensitive = true
}

variable "proxmox_token_secret" {
  type = string
  sensitive = true
}
variable "proxmox_node" {
  type = string
  description = "Target node name for create proxmox VM"
}

# VM variable
variable "template" {
  type = string
  description = "VM template using to clone"
}

variable "public_ssh_keys" {
  type        = list(string)
  description = "The public keys of the local administrator. This is set during the cloud-init process. If this is null, admin_password must be set."
  default     = []
}

variable "root_username" {
  type        = string  
  description = "The password of the local administrator. This is set during the cloud-init process. If this is null, admin_ssh_public_keys must be set."
  default     = null
}

variable "root_password" {
  type        = string 
  sensitive   = true
  description = "The password of the local administrator. This is set during the cloud-init process. If this is null, admin_ssh_public_keys must be set."
  default     = null
}

variable "gateway4" {
  type = string
  description = "Gateway ipv4 address for VM"
}

variable "nodes" {
  type = list(object({
    name           = string
    ip_cidr        = string
    type           = string
  }))
  description = "List of node want to create"
}

variable "node_types" {
  type = map(object({
     core = number
     ram  = string
     disk = string
  }))
  description = "List of VM type with it specification"
}