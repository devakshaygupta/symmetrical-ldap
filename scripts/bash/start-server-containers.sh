#!/usr/bin/bash

# 🚀 OpenLDAP + Custom Server Podman Launch Script

set -e # 🚫 Abort on error

# 🚀 Step 1: Create Isolated Network
echo "🛠️ Creating isolated network: my-network"
podman network create my-network

# 🧱 Step 2: Persistent Volume for LDAP Data
echo "🧱 Creating persistent volume for OpenLDAP data"
podman volume create openldap_data

# 📡 Step 3: Launch OpenLDAP Container
echo "📡 Starting OpenLDAP server container..."
podman run -d \
  --name myldap \
  --net my-network \
  -v openldap_data:/bitnami/openldap:z \
  -p 1389:1389 -p 1636:1636 \
  --env-file ldap.env \
  --health-cmd='ldapsearch -x -H ldap://localhost -b dc=akshaygupta,dc=click || exit 1' \
  --health-interval=30s \
  --health-timeout=10s \
  --health-retries=3 \
  bitnami/openldap:latest

# 💻 Step 4: Launch Custom Server
echo "💻 Launching custom server (my-server1)..."
podman run -d \
  --name my-server1 \
  --net my-network \
  -p 1422:22 \
  custom-server

echo "✅ All systems go. LDAP and server are humming inside my-network."

# 🔐 Step 5: Initialize user SSH setup inside container
echo "🔐 Setting up SSH for user02 inside my-server1..."
podman exec -it my-server1 su - user02 <<'EOF'
mkdir -pv ~/.ssh
EOF

# 🗝️ Step 6: Deploy Public Key for SSH Access
echo "🗝️ Copying public key into container for user02..."
podman cp ~/.ssh/ansible.pub my-server1:/home/user02/.ssh/authorized_keys

# 🚪 Step 7: SSH into container
echo "🚪 Connecting to my-server1 as user02..."
ssh -p 1422 user02@localhost
