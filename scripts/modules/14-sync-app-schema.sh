#!/bin/bash
#==============================================================#
# Script: 14-sync-app-schema.sh
# Desc:   Sincroniza el schema de aplicación desde el servidor origen
# Usage:  ./scripts/modules/14-sync-app-schema.sh [origen_ip]
#==============================================================#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Cargar utilidades
source "$SCRIPT_DIR/../utils.sh"

# Configuración
APP_SCHEMA_DIR="$PROJECT_ROOT/config/app_schema"
APP_SCHEMA_FILE="$APP_SCHEMA_DIR/app_schema.sql"
ORIGEN_IP="${1:-${ORIGEN_IP:-194.163.149.70}}"

# Credenciales específicas para el servidor ORIGEN (producción)
# Estas NO deben ser sobrescritas por el .env (que es para staging)
ORIGEN_SSH_KEY="${ORIGEN_SSH_KEY:-$HOME/.ssh/pigsty_deploy}"
ORIGEN_SSH_USER="${ORIGEN_SSH_USER:-deploy}"

#----------------------------------------------#
# Funciones
#----------------------------------------------#

print_banner() {
    echo ""
    echo "=============================================="
    echo "  SYNC APP SCHEMA"
    echo "  Origen: $ORIGEN_IP"
    echo "=============================================="
    echo ""
}

check_connection() {
    log_info "Verificando conexión al servidor origen..."
    log_info "  Usuario: $ORIGEN_SSH_USER"
    log_info "  Key: $ORIGEN_SSH_KEY"
    if ! ssh -i "$ORIGEN_SSH_KEY" -o ConnectTimeout=10 -o BatchMode=yes "$ORIGEN_SSH_USER@$ORIGEN_IP" "echo 'OK'" &>/dev/null; then
        log_error "No se puede conectar a $ORIGEN_IP"
        exit 1
    fi
    log_success "Conexión establecida"
}

export_schema() {
    log_info "Exportando schema de aplicación..."

    mkdir -p "$APP_SCHEMA_DIR"

    # Crear archivo temporal
    local TEMP_FILE=$(mktemp)

    # Agregar header
    cat > "$TEMP_FILE" << 'HEADER'
-- ============================================
-- APP SCHEMA - Pigsty Supabase Deployment
-- ============================================
-- Este archivo contiene el schema de la aplicación
-- Se aplica DESPUÉS del baseline de Supabase
--
-- Generado automáticamente por: 14-sync-app-schema.sh
-- NO EDITAR MANUALMENTE - Los cambios se perderán
-- ============================================

HEADER

    # Agregar timestamp
    echo "-- Generado: $(date '+%Y-%m-%d %H:%M:%S')" >> "$TEMP_FILE"
    echo "-- Origen: $ORIGEN_IP" >> "$TEMP_FILE"
    echo "" >> "$TEMP_FILE"

    # Exportar schema (excluyendo schemas de Supabase)
    ssh -i "$ORIGEN_SSH_KEY" "$ORIGEN_SSH_USER@$ORIGEN_IP" "sudo -u postgres pg_dump -h /var/run/postgresql -p 5432 -d postgres \
        --schema-only \
        --no-owner \
        --no-privileges \
        -n public \
        -n app \
        -n util \
        -n tests \
        -n pgmq \
        2>/dev/null" >> "$TEMP_FILE"

    # Verificar que se exportó correctamente
    local LINE_COUNT=$(wc -l < "$TEMP_FILE")
    if [ "$LINE_COUNT" -lt 100 ]; then
        log_error "El schema exportado parece incompleto ($LINE_COUNT líneas)"
        rm -f "$TEMP_FILE"
        exit 1
    fi

    # Mover a ubicación final
    mv "$TEMP_FILE" "$APP_SCHEMA_FILE"

    log_success "Schema exportado: $LINE_COUNT líneas"
}

show_stats() {
    log_info "Estadísticas del schema:"
    echo ""
    echo "  Tablas:    $(grep -c '^CREATE TABLE' "$APP_SCHEMA_FILE" || echo 0)"
    echo "  Funciones: $(grep -c '^CREATE FUNCTION\|^CREATE OR REPLACE FUNCTION' "$APP_SCHEMA_FILE" || echo 0)"
    echo "  ENUMs:     $(grep -c '^CREATE TYPE.*AS ENUM' "$APP_SCHEMA_FILE" || echo 0)"
    echo "  Triggers:  $(grep -c '^CREATE TRIGGER' "$APP_SCHEMA_FILE" || echo 0)"
    echo "  Policies:  $(grep -c '^CREATE POLICY' "$APP_SCHEMA_FILE" || echo 0)"
    echo "  Índices:   $(grep -c '^CREATE INDEX\|^CREATE UNIQUE INDEX' "$APP_SCHEMA_FILE" || echo 0)"
    echo ""
}

create_diff_report() {
    log_info "Generando reporte de cambios..."

    local BACKUP_FILE="$APP_SCHEMA_DIR/app_schema.backup.sql"

    if [ -f "$BACKUP_FILE" ]; then
        # Comparar tablas
        local OLD_TABLES=$(grep '^CREATE TABLE' "$BACKUP_FILE" | wc -l)
        local NEW_TABLES=$(grep '^CREATE TABLE' "$APP_SCHEMA_FILE" | wc -l)

        if [ "$NEW_TABLES" -ne "$OLD_TABLES" ]; then
            log_info "Cambio en tablas: $OLD_TABLES -> $NEW_TABLES"
        fi

        rm -f "$BACKUP_FILE"
    fi
}

backup_current() {
    if [ -f "$APP_SCHEMA_FILE" ]; then
        cp "$APP_SCHEMA_FILE" "$APP_SCHEMA_DIR/app_schema.backup.sql"
    fi
}

#----------------------------------------------#
# Main
#----------------------------------------------#

main() {
    print_banner
    check_connection
    backup_current
    export_schema
    show_stats
    create_diff_report

    log_success "Schema sincronizado correctamente"
    echo ""
    echo "Archivo: $APP_SCHEMA_FILE"
    echo ""
    echo "Para aplicar en un nuevo VPS:"
    echo "  ./scripts/deploy-simple schema"
    echo ""
}

main "$@"
