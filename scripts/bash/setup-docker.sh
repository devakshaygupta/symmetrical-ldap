#!/bin/bash

# This script installs docker and its dependencies on a Linux system.

sudo dnf remove -y podman runc && dnf update -y

sudo dnf install -y gcc gcc-c++ kernel-devel dnf-plugins-core python3

sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo

sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

systemctl enable --now docker

cat << 'EOF' > requirements.txt
python3-ldap

EOF

python -m venv .venv
