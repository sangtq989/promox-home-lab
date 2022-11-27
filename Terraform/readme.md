# Proxmox automation
This folder is the step needed to automate create VM instance in my Promox homelab, using Terraform to provision VM

## Cloud images in Proxmox
* [Preparing Cloud-Init Templates](https://pve.proxmox.com/pve-docs/qm.1.html)

### Steps for creating an minimal Ubuntu 20.04 cloud VM template, then using Terraform to finallize
* Using a ready-to-use Ubuntu image
* [Ubuntu 20.04 LTS (Focal Fossal) Daily Build](https://cloud-images.ubuntu.com/focal/current/)

```sh
wget https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img

#Export needed ENV
export VM_ID=100

# Create a VM with network card
qm create $VM_ID --name u2004-templ --memory 2048 --net0 virtio,bridge=vmbr1

# Import the disk in qcow2 format (as unused disk) 
qm importdisk $VM_ID focal-server-cloudimg-amd64.img local -format qcow2

# Attach the disk to the vm using VirtIO SCSI
qm set $VM_ID --scsihw virtio-scsi-pci --scsi0 /var/lib/vz/images/$VM_ID/vm-$VM_ID-disk-0.qcow2

# Create cloud init disk
qm set $VM_ID --ide2 local:cloudinit --boot c --bootdisk scsi0

# Create tempalte
qm template $VM_ID

# Remove if needed
rm -v focal-server-cloudimg-amd64.img
```

### Convert Images
https://docs.openstack.org/image-guide/convert-images.html
```
qemu-img convert -f raw -O qcow2 focal-server-cloudimg-amd64.img focal-server-cloudimg-amd64.qcow2
```

## Using Terraform to provision VM
### Install Terraform
* [Terraform installation](https://cloud-images.ubuntu.com/focal/current/)

### Prepare env variable in .tfvars file 
```
#Proxmox credentials
proxmox_api_url = "https://<proxmox_url>:8006/api2/json"
proxmox_token_id = "token_id"
proxmox_token_secret = "token_secret"
proxmox_node = "proxmox_node_name"
root_username="vm_root"
root_password="Pa$$w0rd"
public_ssh_keys = [
    "ssh-rsa <first ssh key>+/4qVn3jT8D0325jPJom...",
    "ssh-rsa <second ssh key>sdasdas+/4qVn3jT8D0325jPJom..."
]

# vm-config
gateway4 = "<network gateway for vm>"
vm_template = "<proxmox VM template name>"

node_types = {
  master = {core = 1, ram=1024, disk="50G"},
  worker = {core = 2, ram=1536, disk="50G"},
  worker-100 = {core = 1, ram=1536, disk="100G"},
}

nodes = [
  { name = "zaku", ip_cidr = "<xxx.xxx.xxx.xxx/yy>", type = "master"},
  { name = "astray", ip_cidr = "<xxx.xxx.xxx.xxx/yy>", type = "worker"},
  { name = "kryos", ip_cidr = "<xxx.xxx.xxx.xxx/yy>", type = "worker"},
  { name = "unicorn", ip_cidr = "<xxx.xxx.xxx.xxx/yy>", type = "worker-100"},
  { name = "providence", ip_cidr = "<xxx.xxx.xxx.xxx/yy>", type = "worker-100"},
]

```
### Terraform execution
* Execute below command to begin provisioning VM instance of proxmox

```sh
terraform init
terraform plan
terraform apply --auto-approve
```
