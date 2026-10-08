---
# ============================================================================
# Generic VM Deployment Variables
# ============================================================================

# vars_files:
#  - ../vars/deploy-(apphere).yml

# Required variables:

# Proxmox API
proxmox_api_host: devproxn2.ph-cov.local
proxmox_api_user: "{{ lookup('bitwarden.secrets.lookup', '9a6d8b32-7528-413b-a046-b4db010859a9', access_token=bws_access_token) }}"
proxmox_api_token_id: "{{ lookup('bitwarden.secrets.lookup', 'fc074f09-edcf-43d4-9ffa-b4db01089e8f', access_token=bws_access_token) }}"
proxmox_api_token_secret: "{{ lookup('bitwarden.secrets.lookup', '8571f211-1376-4b30-8999-b4db0108b59c', access_token=bws_access_token) }}"

# Template / Target
proxmox_node: devproxn2
template_name: ubuntu24-template
template_vmid: 9000

# VM Configuration
vmid: 1100
vm_description---------
vm_name: --------
vm_cores: 4
vm_memory: 8192

# Cloud-Init Networking
vm_ip: 10.25.x.x/2x
vm_gateway: 10.25.x.1
vm_dns: 10.25.4.11
vm_searchdomain: ph-cov.local
storage_ip: 10.25.7.x/24

Disk Resize (optional)
disk_resize: "+10G"

# Inventory
inventory_group: deployed_vms

