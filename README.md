# Ansible Infrastructure
 
Infrastructure automation repository for Pharmaron.

# Getting Started

Clone the repository to /opt/ansible-pharmaron, run bootstrap.sh, and provide Bitwarden Secrets Manager access token.
The bootstrap script installs all required Ansible collections and packages and prompts for the Bitwarden Secrets Manager access token.

To run playbooks
cd /opt/ansible-pharmaron
source ./bws.env
ansible-playbook <playbook>

Ex. "ansible-playbook build-ubuntu24-template.yml"
 
## Available playbooks

build-ubuntu24-template.yml
Builds and configures the Ubuntu 24 Proxmox VM template used for automated server deployments.

## Secrets Management
This repository does not store plaintext credentials.
Secrets are retrieved from Bitwarden Secrets Manager at runtime. The Bitwarden access token is stored locally on the Ansible control host and is not committed to the repository.