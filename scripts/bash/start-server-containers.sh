#!/usr/bin/bash

# 🚀 OpenLDAP + Custom Server Podman Launch Script

set -e

echo "🛠️ Creating isolated network: my-network"
podman network create my-network

echo "🧱 Creating persistent volume for OpenLDAP data"
podman volume create openldap_data

echo "📡 Starting OpenLDAP server container..."
podman run -d \
  --name myldap \
  --net my-network \
  -v openldap_data:/bitnami/openldap:z \
  -p 1389:1389 -p 1636:1636 \
  --env-file ldap.env \
  --health-cmd='ldapsearch -x -H ldap://localhost -b dc=example,dc=com || exit 1' \
  --health-interval=30s \
  --health-timeout=10s \
  --health-retries=3 \
  bitnami/openldap:latest

echo "💻 Launching custom server (my-server1)..."
podman run -d \
  --name my-server1 \
  --net my-network \
  -p 1722:22 \
  custom-server

echo "✅ All systems go. LDAP and server are humming inside my-network."
