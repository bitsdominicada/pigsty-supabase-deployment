#!/bin/bash
set -e

# Script to update Supabase Docker images to latest official versions
# Compares Pigsty's versions with official Supabase docker-compose.yml

echo "=========================================="
echo "Update Supabase to Latest Versions"
echo "=========================================="
echo

# Check if .env file exists
if [ ! -f .env ]; then
    echo "❌ Error: .env file not found"
    exit 1
fi

# Source environment variables
source .env

if [ -z "$VPS_ROOT_PASSWORD" ] || [ -z "$VPS_HOST" ]; then
    echo "❌ Error: VPS_ROOT_PASSWORD or VPS_HOST not set in .env"
    exit 1
fi

# Check if sshpass is available
if ! command -v sshpass &> /dev/null; then
    echo "❌ Error: sshpass is required but not installed"
    exit 1
fi

# SSH helper function
ssh_root() {
    sshpass -p "$VPS_ROOT_PASSWORD" \
        ssh -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        -o LogLevel=ERROR \
        root@"$VPS_HOST" "$@"
}

echo "Current Versions (Pigsty):"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
ssh_root << 'REMOTE'
cd /opt/supabase
grep -E "image: (supabase|postgrest|kong|darthsim|timberio)" docker-compose.yml | sed 's/^[ ]*//' | head -15
REMOTE

echo
echo "Latest Versions (Supabase Official):"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
cat << 'VERSIONS'
studio:        supabase/studio:2025.11.10-sha-5291fe3
auth:          supabase/gotrue:v2.182.1
rest:          postgrest/postgrest:v13.0.7
realtime:      supabase/realtime:v2.63.0
storage:       supabase/storage-api:v1.29.0
imgproxy:      darthsim/imgproxy:v3.8.0
meta:          supabase/postgres-meta:v0.93.1
functions:     supabase/edge-runtime:v1.69.23
analytics:     supabase/logflare:1.22.6
vector:        timberio/vector:0.28.1-alpine
kong:          kong:2.8.1
VERSIONS

echo
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo
read -p "¿Actualizar a las últimas versiones? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Actualización cancelada."
    exit 0
fi

echo
echo "Actualizando docker-compose.yml en VPS..."

ssh_root << 'REMOTE'
set -e
cd /opt/supabase

# Backup
cp docker-compose.yml docker-compose.yml.backup.$(date +%Y%m%d_%H%M%S)

# Update versions
sed -i 's|supabase/studio:.*|supabase/studio:2025.11.10-sha-5291fe3|g' docker-compose.yml
sed -i 's|supabase/gotrue:.*|supabase/gotrue:v2.182.1|g' docker-compose.yml
sed -i 's|postgrest/postgrest:.*|postgrest/postgrest:v13.0.7|g' docker-compose.yml
sed -i 's|supabase/realtime:.*|supabase/realtime:v2.63.0|g' docker-compose.yml
sed -i 's|supabase/storage-api:.*|supabase/storage-api:v1.29.0|g' docker-compose.yml
sed -i 's|supabase/postgres-meta:.*|supabase/postgres-meta:v0.93.1|g' docker-compose.yml
sed -i 's|supabase/edge-runtime:.*|supabase/edge-runtime:v1.69.23|g' docker-compose.yml
sed -i 's|supabase/logflare:.*|supabase/logflare:1.22.6|g' docker-compose.yml

echo "✅ Versiones actualizadas en docker-compose.yml"
REMOTE

echo
echo "Descargando nuevas imágenes..."

ssh_root << 'REMOTE'
set -e
cd /opt/supabase

docker compose pull

echo "✅ Imágenes descargadas"
REMOTE

echo
echo "⚠️  IMPORTANTE: Recrear contenedores"
echo
echo "Opciones:"
echo "  1. Recrear TODOS los contenedores (downtime ~2 minutos)"
echo "  2. Recrear uno por uno (menos downtime)"
echo "  3. Cancelar (solo descargar imágenes)"
echo
read -p "Selecciona opción (1/2/3): " -n 1 -r
echo

case $REPLY in
    1)
        echo
        echo "Recreando TODOS los contenedores..."
        ssh_root << 'REMOTE'
cd /opt/supabase
docker compose down
docker compose up -d
REMOTE
        ;;
    2)
        echo
        echo "Recreando contenedores uno por uno..."

        SERVICES="studio auth rest realtime storage meta functions analytics"

        for service in $SERVICES; do
            echo "→ Recreando $service..."
            ssh_root << REMOTE
cd /opt/supabase
docker compose stop $service
docker compose rm -f $service
docker compose up -d $service
sleep 5
REMOTE
        done
        ;;
    3)
        echo
        echo "Cancelado. Imágenes descargadas pero contenedores no actualizados."
        echo "Para actualizar después:"
        echo "  ssh root@$VPS_HOST 'cd /opt/supabase && docker compose up -d --force-recreate'"
        exit 0
        ;;
    *)
        echo "Opción inválida"
        exit 1
        ;;
esac

echo
echo "Esperando a que los servicios estén listos..."
sleep 15

echo
echo "Verificando servicios..."
ssh_root << 'REMOTE'
cd /opt/supabase
docker compose ps
REMOTE

echo
echo "=========================================="
echo "✅ Actualización Completa"
echo "=========================================="
echo
echo "Versiones actualizadas:"
echo "  • Studio: 2025.11.10"
echo "  • Auth: v2.182.1"
echo "  • Rest: v13.0.7"
echo "  • Realtime: v2.63.0"
echo "  • Storage: v1.29.0"
echo "  • Meta: v0.93.1"
echo "  • Functions: v1.69.23"
echo "  • Analytics: 1.22.6"
echo
echo "Verifica que todo funcione:"
echo "  https://${SUPABASE_DOMAIN:-$VPS_HOST:8000}"
echo
echo "Si hay problemas, restaura el backup:"
echo "  ssh root@$VPS_HOST 'cd /opt/supabase && cp docker-compose.yml.backup.* docker-compose.yml && docker compose up -d'"
echo
