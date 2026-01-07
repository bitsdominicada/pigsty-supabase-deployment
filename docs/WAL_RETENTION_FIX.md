# WAL Retention Fix - Replication Slots

Este documento describe cómo diagnosticar y resolver el problema de acumulación excesiva de WAL causado por replication slots huérfanos o atascados.

## Problema

PostgreSQL retiene archivos WAL (Write-Ahead Log) mientras existan replication slots que los necesiten. Si un slot se "atasca" (no consume los cambios), el WAL crece indefinidamente hasta llenar el disco.

### Síntomas

- Disco llenándose progresivamente
- Directorio `/pg/data/pg_wal` con muchos GB
- Replication slots con alto "lag"

### Causa Raíz Común

Supabase Analytics (Logflare) crea un replication slot `cainophile_*` que puede quedarse atascado si:
- La conexión se interrumpe pero el slot persiste
- La publicación `logflare_pub` no tiene tablas configuradas
- El servicio Analytics no está consumiendo los cambios correctamente

## Diagnóstico

### 1. Verificar uso de WAL

```bash
# Tamaño del directorio WAL
sudo du -sh /pg/data/pg_wal

# Número de archivos WAL
sudo ls /pg/data/pg_wal/*.* 2>/dev/null | wc -l
```

### 2. Verificar replication slots

```bash
sudo -u postgres psql -c "
SELECT 
    slot_name,
    database,
    active,
    restart_lsn,
    pg_size_pretty(pg_wal_lsn_diff(pg_current_wal_lsn(), restart_lsn)) as retained_wal,
    wal_status
FROM pg_replication_slots;
"
```

**Ejemplo de slot problemático:**
```
      slot_name      | database | active | restart_lsn | retained_wal | wal_status
---------------------+----------+--------+-------------+--------------+------------
 cainophile_lsbnyc35 | supabase | t      | F/32120     | 21 GB        | reserved
```

### 3. Verificar conexión de replicación

```bash
sudo -u postgres psql -c "
SELECT pid, application_name, state, sent_lsn, flush_lsn,
       pg_size_pretty(pg_wal_lsn_diff(sent_lsn, flush_lsn)) as pending
FROM pg_stat_replication;
"
```

### 4. Verificar publicación (para Analytics)

```bash
# Ver tablas en la publicación logflare_pub
sudo -u postgres psql -d supabase -c "
SELECT schemaname, tablename 
FROM pg_publication_tables 
WHERE pubname = 'logflare_pub';
"
```

## Solución

### Paso 1: Identificar el PID de la conexión

```bash
sudo -u postgres psql -c "
SELECT pid, datname, usename, application_name, state
FROM pg_stat_activity 
WHERE pid IN (SELECT active_pid FROM pg_replication_slots WHERE active);
"
```

### Paso 2: Terminar la conexión de replicación

```bash
# Reemplaza <PID> con el PID obtenido
sudo -u postgres psql -c "SELECT pg_terminate_backend(<PID>);"
```

### Paso 3: Verificar que el slot se eliminó o recreó

```bash
sudo -u postgres psql -c "
SELECT slot_name, pg_size_pretty(pg_wal_lsn_diff(pg_current_wal_lsn(), restart_lsn)) as lag
FROM pg_replication_slots;
"
```

> **Nota**: Al terminar la conexión, el servicio (Analytics/Realtime) automáticamente:
> 1. Elimina el slot viejo
> 2. Crea uno nuevo con posición actualizada

### Paso 4: Forzar limpieza de WAL

```bash
sudo -u postgres psql -c "CHECKPOINT;"

# Verificar que el WAL se redujo
sudo du -sh /pg/data/pg_wal
```

### Paso 5: Verificar estado final

```bash
# El nuevo slot debe tener lag mínimo
sudo -u postgres psql -c "
SELECT slot_name, database, active,
       pg_size_pretty(pg_wal_lsn_diff(pg_current_wal_lsn(), restart_lsn)) as lag
FROM pg_replication_slots;
"
```

## Script de Diagnóstico Rápido

Crear archivo `/usr/local/bin/check-wal-retention`:

```bash
#!/bin/bash
# Check WAL retention and replication slot health

echo "=== WAL Size ==="
du -sh /pg/data/pg_wal

echo ""
echo "=== Replication Slots ==="
sudo -u postgres psql -t -c "
SELECT 
    slot_name || ': ' || 
    pg_size_pretty(pg_wal_lsn_diff(pg_current_wal_lsn(), restart_lsn)) || 
    ' retained (' || wal_status || ')'
FROM pg_replication_slots;
"

echo ""
echo "=== Disk Usage ==="
df -h / | tail -1
```

## Script de Fix Automático

Crear archivo `/usr/local/bin/fix-wal-retention`:

```bash
#!/bin/bash
# Fix WAL retention by resetting stuck replication slots
# Usage: fix-wal-retention [--force]

set -e

FORCE=${1:-""}
THRESHOLD_GB=5

echo "=== Checking WAL retention ==="

# Get slots with high retention
STUCK_SLOTS=$(sudo -u postgres psql -t -A -c "
SELECT slot_name || ':' || active_pid
FROM pg_replication_slots
WHERE pg_wal_lsn_diff(pg_current_wal_lsn(), restart_lsn) > ${THRESHOLD_GB}::bigint * 1024 * 1024 * 1024;
")

if [ -z "$STUCK_SLOTS" ]; then
    echo "No stuck slots found (threshold: ${THRESHOLD_GB}GB)"
    exit 0
fi

echo "Found stuck slots:"
echo "$STUCK_SLOTS"

if [ "$FORCE" != "--force" ]; then
    echo ""
    echo "Run with --force to fix these slots"
    exit 0
fi

echo ""
echo "=== Fixing stuck slots ==="

for SLOT_INFO in $STUCK_SLOTS; do
    SLOT_NAME=$(echo $SLOT_INFO | cut -d: -f1)
    PID=$(echo $SLOT_INFO | cut -d: -f2)
    
    echo "Terminating connection for slot: $SLOT_NAME (PID: $PID)"
    sudo -u postgres psql -c "SELECT pg_terminate_backend($PID);" > /dev/null
done

sleep 2

echo ""
echo "=== Running CHECKPOINT ==="
sudo -u postgres psql -c "CHECKPOINT;"

echo ""
echo "=== New slot status ==="
sudo -u postgres psql -c "
SELECT slot_name, pg_size_pretty(pg_wal_lsn_diff(pg_current_wal_lsn(), restart_lsn)) as lag
FROM pg_replication_slots;
"

echo ""
echo "=== WAL size after fix ==="
du -sh /pg/data/pg_wal
```

## Configuración de PostgreSQL Relacionada

Estos parámetros afectan la retención de WAL:

```sql
-- Ver configuración actual
SHOW wal_keep_size;      -- Mínimo WAL a mantener (default: 0)
SHOW max_wal_size;       -- Máximo antes de forzar checkpoint (default: 1GB)
SHOW min_wal_size;       -- Mínimo reservado (default: 80MB)
```

**En Pigsty típicamente:**
```
wal_keep_size = 128MB
max_wal_size = 40GB
min_wal_size = 10GB
```

> **Nota**: `min_wal_size=10GB` significa que PostgreSQL siempre mantendrá al menos 10GB de WAL, incluso después de limpiar slots problemáticos.

## Monitoreo Preventivo

### Agregar alerta en Prometheus/Grafana

```yaml
# prometheus/rules/postgres.yml
groups:
  - name: postgres_wal
    rules:
      - alert: PostgresWALRetentionHigh
        expr: pg_wal_size_bytes > 20e9  # 20GB
        for: 10m
        labels:
          severity: warning
        annotations:
          summary: "High WAL retention on {{ $labels.instance }}"
          description: "WAL size is {{ $value | humanize1024 }}"

      - alert: PostgresReplicationSlotLagging
        expr: pg_replication_slot_wal_lag_bytes > 5e9  # 5GB
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Replication slot lagging on {{ $labels.instance }}"
          description: "Slot {{ $labels.slot_name }} has {{ $value | humanize1024 }} lag"
```

## Resumen de Comandos

| Acción | Comando |
|--------|---------|
| Ver tamaño WAL | `sudo du -sh /pg/data/pg_wal` |
| Ver slots | `sudo -u postgres psql -c "SELECT * FROM pg_replication_slots;"` |
| Ver lag de slot | `sudo -u postgres psql -c "SELECT slot_name, pg_size_pretty(pg_wal_lsn_diff(pg_current_wal_lsn(), restart_lsn)) FROM pg_replication_slots;"` |
| Terminar conexión | `sudo -u postgres psql -c "SELECT pg_terminate_backend(<PID>);"` |
| Forzar limpieza | `sudo -u postgres psql -c "CHECKPOINT;"` |
| Eliminar slot manual | `sudo -u postgres psql -c "SELECT pg_drop_replication_slot('nombre');"` |

## Configuracion Preventiva (Template Base)

Para evitar que este problema ocurra en nuevas instalaciones, se deben agregar los siguientes parametros de PostgreSQL al template base.

### Parametros Recomendados

```yaml
# En config/templates/base.yml -> pg_parameters
pg_parameters:
  # ... otros parametros ...
  
  # WAL Slot Protection (PostgreSQL 17+)
  max_slot_wal_keep_size: 20GB        # Limite maximo de WAL por slot (invalida slot si excede)
  idle_replication_slot_timeout: 1h   # Invalida slots inactivos despues de 1 hora
```

### Explicacion de Parametros

| Parametro | Valor | Descripcion |
|-----------|-------|-------------|
| `max_slot_wal_keep_size` | `20GB` | Limite maximo de WAL que un slot puede retener. Si se excede, el slot se invalida automaticamente. Default Pigsty: 60GB (muy alto). |
| `idle_replication_slot_timeout` | `1h` | Tiempo maximo que un slot puede estar inactivo antes de ser invalidado. Solo PG17+. Default: 0 (deshabilitado). |

### Por que estos valores?

1. **`max_slot_wal_keep_size: 20GB`**
   - Suficiente para operaciones normales de Realtime/Analytics
   - Protege contra slots atascados que llenen el disco
   - Si un slot necesita mas de 20GB, algo esta mal

2. **`idle_replication_slot_timeout: 1h`**
   - Supabase Realtime/Analytics reconectan automaticamente
   - 1 hora es suficiente para manejar reinicios de servicios
   - Elimina slots huerfanos automaticamente

### Aplicar en Servidor Existente

```bash
# Aplicar cambios sin reiniciar
sudo -u postgres psql -c "ALTER SYSTEM SET max_slot_wal_keep_size = '20GB';"
sudo -u postgres psql -c "ALTER SYSTEM SET idle_replication_slot_timeout = '1h';"
sudo -u postgres psql -c "SELECT pg_reload_conf();"

# Verificar
sudo -u postgres psql -c "SHOW max_slot_wal_keep_size; SHOW idle_replication_slot_timeout;"
```

### Monitoreo de Slots Invalidados

Cuando un slot se invalida por exceder limites, aparece en los logs:

```
LOG: terminating walsender process due to replication slot "slot_name" exceeding max_slot_wal_keep_size
```

Y el slot cambia a estado `lost`:

```sql
SELECT slot_name, wal_status FROM pg_replication_slots WHERE wal_status = 'lost';
```

## Script de Aplicacion para Template

Agregar al deployment un script que configure estos parametros post-instalacion:

```bash
#!/bin/bash
# scripts/modules/XX-configure-wal-protection.sh

echo "Configuring WAL slot protection..."

ssh -i "$SSH_KEY" "$SSH_USER@$VPS_HOST" "
sudo -u postgres psql -c \"ALTER SYSTEM SET max_slot_wal_keep_size = '20GB';\"
sudo -u postgres psql -c \"ALTER SYSTEM SET idle_replication_slot_timeout = '1h';\"
sudo -u postgres psql -c \"SELECT pg_reload_conf();\"
echo 'WAL protection configured'
"
```

## Referencias

- [PostgreSQL Replication Slots](https://www.postgresql.org/docs/current/warm-standby.html#STREAMING-REPLICATION-SLOTS)
- [PostgreSQL 17 idle_replication_slot_timeout](https://www.postgresql.org/docs/17/runtime-config-replication.html)
- [Supabase Realtime](https://supabase.com/docs/guides/realtime)
- [Pigsty WAL Configuration](https://doc.pigsty.cc/#/PGSQL-CONF)
