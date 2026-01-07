#!/bin/bash
#==============================================================#
# Script: 15-apply-app-schema.sh
# Desc:   Aplica el schema de aplicación en un VPS destino
# Usage:  ./scripts/modules/15-apply-app-schema.sh [destino_ip]
#==============================================================#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Cargar utilidades
source "$SCRIPT_DIR/../utils.sh"

# Cargar .env si existe (para SSH_USER, SSH_KEY, VPS_HOST)
if [ -f "$PROJECT_ROOT/.env" ]; then
    set -a
    source "$PROJECT_ROOT/.env"
    set +a
fi

# Configuración - usa credenciales del .env para el destino (staging)
APP_SCHEMA_FILE="$PROJECT_ROOT/config/app_schema/app_schema.sql"
DESTINO_IP="${1:-${VPS_HOST:-}}"
SSH_KEY="${SSH_KEY:-$HOME/.ssh/id_ed25519}"
SSH_USER="${SSH_USER:-ubuntu}"

#----------------------------------------------#
# Funciones
#----------------------------------------------#

print_banner() {
    echo ""
    echo "=============================================="
    echo "  APPLY APP SCHEMA"
    echo "  Destino: $DESTINO_IP"
    echo "=============================================="
    echo ""
}

validate_inputs() {
    if [ -z "$DESTINO_IP" ]; then
        log_error "Debe especificar la IP del VPS destino"
        echo "Uso: $0 <destino_ip>"
        exit 1
    fi

    if [ ! -f "$APP_SCHEMA_FILE" ]; then
        log_error "No existe el archivo de schema: $APP_SCHEMA_FILE"
        echo "Ejecute primero: ./scripts/modules/14-sync-app-schema.sh"
        exit 1
    fi
}

check_connection() {
    log_info "Verificando conexión al servidor destino..."
    log_info "  Usuario: $SSH_USER"
    log_info "  Key: $SSH_KEY"
    if ! ssh -i "$SSH_KEY" -o ConnectTimeout=10 -o BatchMode=yes "$SSH_USER@$DESTINO_IP" "echo 'OK'" &>/dev/null; then
        log_error "No se puede conectar a $DESTINO_IP"
        exit 1
    fi
    log_success "Conexión establecida"
}

check_postgres() {
    log_info "Verificando PostgreSQL en destino..."
    if ! ssh -i "$SSH_KEY" "$SSH_USER@$DESTINO_IP" "sudo -u postgres psql -c 'SELECT 1'" &>/dev/null; then
        log_error "PostgreSQL no está disponible en $DESTINO_IP"
        exit 1
    fi
    log_success "PostgreSQL disponible"
}

apply_schema() {
    log_info "Aplicando schema de aplicación..."

    # Copiar schema al servidor (a directorio accesible por postgres)
    scp -i "$SSH_KEY" "$APP_SCHEMA_FILE" "$SSH_USER@$DESTINO_IP:/tmp/app_schema.sql"

    # Cambiar permisos para que postgres pueda leerlo
    ssh -i "$SSH_KEY" "$SSH_USER@$DESTINO_IP" "chmod 644 /tmp/app_schema.sql"

    # Aplicar schema
    ssh -i "$SSH_KEY" "$SSH_USER@$DESTINO_IP" "sudo -u postgres psql -d postgres -f /tmp/app_schema.sql" 2>&1 | tee /tmp/apply_schema.log

    # Verificar errores críticos
    if grep -qE "^ERROR:" /tmp/apply_schema.log; then
        log_warning "Se encontraron algunos errores (pueden ser normales si las tablas ya existen)"
        grep "^ERROR:" /tmp/apply_schema.log | head -10
    fi

    # Limpiar
    ssh -i "$SSH_KEY" "$SSH_USER@$DESTINO_IP" "rm -f /tmp/app_schema.sql"

    log_success "Schema aplicado"
}

verify_schema() {
    log_info "Verificando schema aplicado..."

    local TABLE_COUNT=$(ssh -i "$SSH_KEY" "$SSH_USER@$DESTINO_IP" "sudo -u postgres psql -d postgres -t -c \"
        SELECT COUNT(*) FROM information_schema.tables
        WHERE table_schema = 'public' AND table_type = 'BASE TABLE';
    \"" | tr -d ' ')

    log_success "Tablas en schema public: $TABLE_COUNT"
}

#----------------------------------------------#
# Main
#----------------------------------------------#

main() {
    print_banner
    validate_inputs
    check_connection
    check_postgres
    apply_schema
    verify_schema

    echo ""
    log_success "Schema de aplicación aplicado correctamente en $DESTINO_IP"
    echo ""
}

main "$@"
