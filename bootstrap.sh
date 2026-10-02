#!/bin/bash

set -euo pipefail

echo "======================================="
echo " Pharmaron Ansible Bootstrap"
echo "======================================="

# Verify root
if [[ $EUID -ne 0 ]]; then
    echo "ERROR: Run as root."
    exit 1
fi

# Verify repository location
if [[ ! -f "./bootstrap.sh" ]]; then
    echo "ERROR: Run this script from the ansible-pharmaron repository."
    exit 1
fi

echo ""
echo "Updating package repositories..."
apt update

echo ""
echo "Installing required packages..."

apt install -y \
    ansible \
    curl \
    git \
    unzip \
    python3-pip \
    python3-venv \
    python3-requests

echo ""
echo "Installing Bitwarden Secrets Manager CLI..."

if ! command -v bws >/dev/null 2>&1; then

    TMPDIR=$(mktemp -d)

    curl -L \
        -o "$TMPDIR/bws.zip" \
        "https://github.com/bitwarden/sdk-sm/releases/latest/download/bws-x86_64-unknown-linux-gnu.zip"

    unzip -o "$TMPDIR/bws.zip" -d "$TMPDIR"

    install -m 755 "$TMPDIR/bws" /usr/local/bin/bws

    rm -rf "$TMPDIR"

    echo "Bitwarden CLI installed."
else
    echo "Bitwarden CLI already installed."
fi

echo ""
echo "Installing Python dependencies..."

pip3 install --break-system-packages proxmoxer

echo ""
echo "Installing Ansible collections..."

ansible-galaxy collection install bitwarden.secrets
ansible-galaxy collection install community.general
ansible-galaxy collection install community.proxmox
ansible-galaxy collection install community.docker

echo ""
echo "Paste the Bitwarden Secrets Manager machine account token."
echo ""

read -rsp "BWS Access Token: " BWS_ACCESS_TOKEN
echo ""

cat >/opt/ansible-pharmaron/bws.env <<EOF
export BWS_ACCESS_TOKEN="${BWS_ACCESS_TOKEN}"
EOF

chmod 600 /opt/ansible-pharmaron/bws.env
chown root:root /opt/ansible-pharmaron/bws.env

echo ""
echo "Creating helper command..."

cat >/usr/local/bin/pharmaron-ansible <<'EOF'
#!/bin/bash

source /opt/ansible-pharmaron/bws.env

cd /opt/ansible-pharmaron

exec "$@"
EOF

chmod 755 /usr/local/bin/pharmaron-ansible

echo ""
echo "Validating Bitwarden token..."

source /opt/ansible-pharmaron/bws.env

if bws secret list >/dev/null 2>&1; then
    echo "Bitwarden authentication successful."
else
    echo ""
    echo "WARNING: Unable to validate the token."
    echo "Verify the machine account token manually."
fi

echo "Installing Proxmox SSH key..."

SSH_KEY_UUID="39946abd-1150-486b-894d-b4d7012fb248"

mkdir -p "$HOME/.ssh"

bws secret get "$SSH_KEY_UUID" --output json \
| jq -r '.value' \
> "$HOME/.ssh/proxmox_ansible"

chmod 600 "$HOME/.ssh/proxmox_ansible"

echo "Bootstrap complete."

echo "" 
echo "Next steps:" 
echo " cd /opt/ansible-pharmaron" 
echo " source ./bws.env" 
echo " ansible-playbook <playbook>"