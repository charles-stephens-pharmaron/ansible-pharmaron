# Ansible Infrastructure
 
Infrastructure automation repository for Pharmaron.

# Getting Started

Clone the repository to /opt/ansible-pharmaron, run bootstrap.sh, and provide Bitwarden Secrets Manager access token.
The bootstrap script installs all required Ansible collections and packages and prompts for the Bitwarden Secrets Manager access token.

To run playbooks
cd /opt/ansible-pharmaron
run the contents of ./scripts/beforerun.sh in terminal to run scripts directly.

Ex. "ansible-playbook build-ubuntu24-template.yml"

To run playbooks automatically
cd /opt/ansible-pharmaron/scripts
Run any script from here for the playbook.
 
## Available playbooks

#### build-ubuntu24-template.yml
Builds and configures the Ubuntu 24 Proxmox VM template used for automated server deployments.

## Secrets Management
This repository does not store any secrets.
Secrets are retrieved from Bitwarden Secrets Manager at runtime. The Bitwarden access token is stored locally on the Ansible control host.