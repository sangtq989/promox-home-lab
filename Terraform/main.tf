locals {
  nodes = var.nodes
  types = var.node_types

  specs = [for node in local.nodes : {
    spec = lookup(local.types, node.type)
    name = node.name,
    ip = node.ip_cidr
    }  
  ]
}

# output "spec" {
#   value = local.specs
# }

resource "proxmox_vm_qemu" "kubenetes_cluster" {

        count = length(var.nodes)
        name = local.specs[count.index].name
        target_node = var.proxmox_node
        os_type = "cloud-init"
        onboot = true
        agent = 1

        clone =  var.template
        cores = local.specs[count.index].spec.core
        sockets = 1
        cpu = "host"
        memory = local.specs[count.index].spec.ram

        network{
            bridge = "vmbr1"
            model = "virtio"
        }
        
        disk{
            storage = "local"
            type = "scsi"
            size = local.specs[count.index].spec.disk
            format = "qcow2"
        }

        ciuser     = var.root_username
        cipassword = var.root_password
        sshkeys    = <<-EOF
        %{for key in var.public_ssh_keys~}
            ${key}
        %{endfor~}
        EOF

        ipconfig0 = "gw=${var.gateway4},ip=${local.specs[count.index].ip}"
        tags = "kube"
}