#!/usr/bin/env bash
set -euo pipefail

# ============================================
# GENERATE PIGSTY CONFIGURATION FOR SUPABASE
# ============================================

if [ ! -f .env ]; then
    echo "Error: .env file not found!"
    exit 1
fi

source .env

echo "Generating Pigsty configuration for Supabase..."

# Create main pigsty.yml
cat > config/pigsty.yml << YAML_EOF
---
#==============================================================#
# File      :   pigsty.yml
# Desc      :   Pigsty configuration for Supabase deployment
# Ctime     :   $(date +%Y-%m-%d)
# Mtime     :   $(date +%Y-%m-%d)
# Path      :   pigsty.yml
# License   :   AGPLv3
# Generated :   By pigsty-supabase-deployment
#==============================================================#

# Infrastructure
infra_portal:
  home         : { domain: home.pigsty }
  grafana      : { domain: g.pigsty,  endpoint: "\${grafana}" }
  prometheus   : { domain: p.pigsty,  endpoint: "\${prometheus}" }
  alertmanager : { domain: a.pigsty,  endpoint: "\${alertmanager}" }
  supabase     : { domain: supa.pigsty, endpoint: "http://\${admin_ip}:8000", websocket: true }

# Meta database configuration
pg_cluster: pg-meta
pg_version: ${POSTGRES_VERSION}

# Node configuration
node_tune: tiny
node_timezone: America/Santo_Domingo

# PostgreSQL HA configuration
patroni_mode: default
patroni_watchdog_mode: off
pg_conf: auto

# Connection pooling
pgbouncer_enabled: true
pgbouncer_port: 6432

# Admin credentials
grafana_admin_password: ${GRAFANA_ADMIN_PASSWORD}
pg_admin_username: dbuser_dba
pg_admin_password: ${PG_ADMIN_PASSWORD}

# MinIO Configuration (S3-compatible storage for Supabase)
minio_enabled: true
minio_cluster: minio
minio_access_key: ${MINIO_ROOT_USER}
minio_secret_key: ${MINIO_ROOT_PASSWORD}

# Backup configuration
pgbackrest_enabled: true
pgbackrest_method: local
node_crontab:
  - '00 01 * * * postgres /pg/bin/pg-backup full'

# Supabase-specific PostgreSQL users
pg_users:
  # DBA user
  - { name: dbuser_dba, password: '${PG_ADMIN_PASSWORD}', pgbouncer: true, roles: [ dbrole_admin ] }
  
  # Supabase users
  - { name: supabase_admin, password: '${POSTGRES_PASSWORD}', pgbouncer: true, roles: [ dbrole_admin ], comment: 'Supabase admin user' }
  - { name: authenticator, password: '${POSTGRES_PASSWORD}', pgbouncer: true, comment: 'Supabase authenticator' }
  - { name: supabase_auth_admin, password: '${POSTGRES_PASSWORD}', pgbouncer: true, comment: 'Supabase auth admin' }
  - { name: supabase_storage_admin, password: '${POSTGRES_PASSWORD}', pgbouncer: true, comment: 'Supabase storage admin' }
  - { name: supabase_functions_admin, password: '${POSTGRES_PASSWORD}', pgbouncer: true, comment: 'Supabase functions admin' }
  - { name: dashboard_user, password: '${POSTGRES_PASSWORD}', pgbouncer: true, comment: 'Supabase dashboard user' }

# Supabase-specific database
pg_databases:
  - {name: meta}
  - name: supa
    owner: supabase_admin
    comment: Supabase main database
    schemas: [auth, storage, realtime, public]
    extensions:
      - { name: pg_stat_statements }
      - { name: pgcrypto }
      - { name: pgjwt }
      - { name: uuid-ossp }
      - { name: pg_net }
      - { name: pgsodium }
      - { name: http }
      - { name: pg_graphql }
      - { name: pg_jsonschema }
      - { name: vector }
      - { name: timescaledb }
      - { name: pg_cron }

# PostgreSQL HBA rules for Supabase
pg_hba_rules:
  - { user: 'all', db: all, addr: intra, auth: pwd, title: 'allow intra cluster password access' }
  - { user: 'all', db: all, addr: world, auth: pwd, title: 'allow world password access' }

# Inventory: Single node deployment
all:
  children:
    infra:
      hosts:
        ${VPS_HOST}: { infra_seq: 1, admin_ip: ${VPS_HOST} }
    
    etcd:
      hosts:
        ${VPS_HOST}: { etcd_seq: 1 }
    
    minio:
      hosts:
        ${VPS_HOST}: { minio_seq: 1 }
    
    pgsql:
      hosts:
        ${VPS_HOST}: { pg_seq: 1, pg_role: primary }
      vars:
        pg_cluster: pg-meta
        pg_version: ${POSTGRES_VERSION}

  vars:
    version: v3.6.1
    admin_ip: ${VPS_HOST}
    region: default
    proxy_env:
      no_proxy: "localhost,127.0.0.1,10.0.0.0/8,192.168.0.0/16,*.pigsty,*.svc,*.cluster.local"
YAML_EOF

# Create Supabase environment configuration
cat > config/supabase-env.yml << SUPAENV_EOF

#==============================================================#
# SUPABASE DOCKER COMPOSE ENVIRONMENT
#==============================================================#

app_list:
  - { name: supabase, state: enabled }

app_supabase:
  # JWT Configuration
  JWT_SECRET: "${JWT_SECRET}"
  ANON_KEY: "${ANON_KEY}"
  SERVICE_ROLE_KEY: "${SERVICE_ROLE_KEY}"
  
  # API Configuration
  SITE_URL: "${SUPABASE_API_EXTERNAL_URL}"
  API_EXTERNAL_URL: "${SUPABASE_API_EXTERNAL_URL}"
  
  # PostgreSQL Connection
  POSTGRES_HOST: "${VPS_HOST}"
  POSTGRES_PORT: "5436"
  POSTGRES_DB: "supa"
  POSTGRES_USER: "supabase_admin"
  POSTGRES_PASSWORD: "${POSTGRES_PASSWORD}"
  
  # S3 Storage (MinIO)
  S3_ENDPOINT: "http://${VPS_HOST}:9000"
  S3_PROTOCOL: "http"
  S3_BUCKET: "supabase"
  S3_REGION: "us-east-1"
  S3_ACCESS_KEY: "${MINIO_ROOT_USER}"
  S3_SECRET_KEY: "${MINIO_ROOT_PASSWORD}"
  
  # SMTP Configuration (optional)
  SMTP_HOST: "${SMTP_HOST:-}"
  SMTP_PORT: "${SMTP_PORT:-587}"
  SMTP_USER: "${SMTP_USER:-}"
  SMTP_PASS: "${SMTP_PASSWORD:-}"
  SMTP_SENDER_NAME: "${SMTP_SENDER_NAME:-Supabase}"
SUPAENV_EOF

echo "Configuration files generated:"
echo "  - config/pigsty.yml"
echo "  - config/supabase-env.yml"
