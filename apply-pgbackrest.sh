#!/bin/bash

# Script para aplicar pgBackRest en el VPS
# Ejecutar: ssh deploy@194.163.149.70 'bash -s' < apply-pgbackrest.sh

set -e

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Aplicando pgBackRest Configuration"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

cd ~/pigsty

echo "[1/4] Verificando pigsty.yml actualizado..."
if grep -q "pgbackrest_enabled: true" pigsty.yml; then
    echo "✓ Configuración de pgBackRest encontrada"
else
    echo "✗ Error: pgBackRest no está configurado en pigsty.yml"
    exit 1
fi

echo ""
echo "[2/4] Aplicando configuración de pgBackRest..."
./install.yml -t pgbackrest

echo ""
echo "[3/4] Verificando instalación de pgBackRest..."
sudo -iu postgres pgbackrest version

echo ""
echo "[4/4] Verificando configuración del stanza..."
sudo -iu postgres pgbackrest --stanza=pg-meta --log-level-console=info check

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✓ pgBackRest configurado exitosamente"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "Repositorios configurados:"
sudo -iu postgres pgbackrest --stanza=pg-meta info

echo ""
echo "Para ejecutar un backup manual:"
echo "  sudo -iu postgres /pg/bin/pg-backup full"
echo ""
echo "Los backups automáticos correrán diariamente a la 1:00 AM"
