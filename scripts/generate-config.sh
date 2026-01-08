#!/usr/bin/env bash
#==============================================================================#
# Generate pigsty.yml from template with our variables
#==============================================================================#

generate_pigsty_yml() {
    cat << PIGSTY_YAML
#==============================================================================#
# Pigsty Supabase Configuration
# Generated: $(date)
# Client: ${CLIENT_NAME}
# Domain: ${SUPABASE_DOMAIN}
#==============================================================================#

all:
  vars:
    version: v4.0.0-c1
    admin_ip: ${VPS_HOST}
    region: default
    etcd_cluster: etcd

    #--------------------------------------------------------------------------#
    # Nginx / Portal
    #--------------------------------------------------------------------------#
    infra_portal:
      home: { domain: ${SUPABASE_DOMAIN}, path: "/" }
      grafana: { domain: grafana.${SUPABASE_DOMAIN}, endpoint: "127.0.0.1:3000" }
      prometheus: { domain: prom.${SUPABASE_DOMAIN}, endpoint: "127.0.0.1:9090" }
      supabase: { domain: studio.${SUPABASE_DOMAIN}, endpoint: "127.0.0.1:3001", websocket: true }
      supabase-api: { domain: api.${SUPABASE_DOMAIN}, endpoint: "127.0.0.1:8000", websocket: true }

    #--------------------------------------------------------------------------#
    # PostgreSQL Settings
    #--------------------------------------------------------------------------#
    pg_version: 18
    pg_users:
      # Supabase roles (no login)
      - { name: anon, login: false }
      - { name: authenticated, login: false }
      - { name: dashboard_user, login: false, superuser: true }
      - { name: service_role, login: false, bypassrls: true }
      # Supabase service accounts
      - { name: supabase_admin, password: "${POSTGRES_PASSWORD}", superuser: true, roles: [pg_monitor, pg_signal_backend] }
      - { name: authenticator, password: "${POSTGRES_PASSWORD}", roles: [anon, authenticated, service_role, dashboard_user, supabase_admin] }
      - { name: supabase_auth_admin, password: "${POSTGRES_PASSWORD}", createrole: true, createdb: true, bypassrls: true }
      - { name: supabase_storage_admin, password: "${POSTGRES_PASSWORD}", createrole: true, createdb: true, bypassrls: true }
      - { name: supabase_functions_admin, password: "${POSTGRES_PASSWORD}", createrole: true }
      - { name: supabase_replication_admin, password: "${PG_REPLICATION_PASSWORD}", replication: true }
      - { name: supabase_realtime_admin, password: "${POSTGRES_PASSWORD}" }
      - { name: supabase_read_only_user, password: "${POSTGRES_PASSWORD}" }
      - { name: postgres, password: "${POSTGRES_PASSWORD}", superuser: true }

    pg_databases:
      - name: postgres
        baseline: supabase.sql
        owner: supabase_admin
        schemas: [extensions, auth, realtime, storage, graphql_public, supabase_functions, _analytics, _realtime]
        extensions:
          - { name: pgcrypto, schema: extensions }
          - { name: pg_net, schema: extensions }
          - { name: pgjwt, schema: extensions }
          - { name: uuid-ossp, schema: extensions }
          - { name: pgsodium, schema: extensions }
          - { name: supabase_vault, schema: extensions }
          - { name: pg_graphql, schema: extensions }
          - { name: pg_jsonschema, schema: extensions }
          - { name: wrappers, schema: extensions }
          - { name: http, schema: extensions }
          - { name: pg_cron, schema: extensions }
          - { name: timescaledb, schema: extensions }
          - { name: pg_tle, schema: extensions }
          - { name: vector, schema: extensions }
          - { name: pgmq, schema: extensions }

    pg_libs: 'timescaledb, pgsodium, pg_cron, pg_net, pg_stat_statements, auto_explain'
    pg_extensions: [pg18-main, pg18-time, pg18-gis, pg18-rag, pg18-fts, pg18-feat, pg18-func, pg18-admin, pg18-stat, pg18-sec]
    pg_parameters:
      cron.database_name: postgres

    pg_hba_rules:
      - { user: all, db: postgres, addr: 172.17.0.0/16, auth: pwd, title: 'Docker network access' }
      - { user: all, db: postgres, addr: ${VPS_HOST}/32, auth: pwd, title: 'Local access' }
      - { user: all, db: postgres, addr: 0.0.0.0/0, auth: pwd, title: 'Remote access' }

    #--------------------------------------------------------------------------#
    # Supabase Application
    #--------------------------------------------------------------------------#
    app: supabase
    app.supabase:
      conf:
        POSTGRES_HOST: ${VPS_HOST}
        POSTGRES_PORT: 5432
        POSTGRES_PASSWORD: "${POSTGRES_PASSWORD}"
        JWT_SECRET: "${JWT_SECRET}"
        ANON_KEY: "${ANON_KEY}"
        SERVICE_ROLE_KEY: "${SERVICE_ROLE_KEY}"
        DASHBOARD_USERNAME: "${DASHBOARD_USERNAME}"
        DASHBOARD_PASSWORD: "${DASHBOARD_PASSWORD}"
        SITE_URL: "https://${SUPABASE_DOMAIN}"
        API_EXTERNAL_URL: "https://api.${SUPABASE_DOMAIN}"
        SUPABASE_PUBLIC_URL: "https://${SUPABASE_DOMAIN}"
        PG_META_CRYPTO_KEY: "${PG_META_CRYPTO_KEY}"
        SECRET_KEY_BASE: "${SECRET_KEY_BASE}"
        LOGFLARE_API_KEY: "${LOGFLARE_API_KEY}"
$(if [[ -n "${S3_BUCKET}" ]]; then cat << S3CONF
        # Backblaze B2 Storage
        S3_BUCKET: "${S3_BUCKET}"
        S3_ENDPOINT: "${S3_ENDPOINT}"
        S3_REGION: "${S3_REGION}"
        S3_ACCESS_KEY: "${S3_ACCESS_KEY}"
        S3_SECRET_KEY: "${S3_SECRET_KEY}"
        S3_FORCE_PATH_STYLE: "false"
        S3_PROTOCOL: "https"
        TUS_ALLOW_S3_TAGS: "false"
S3CONF
fi)
$(if [[ -n "${SMTP_HOST}" ]]; then cat << SMTPCONF
        # SMTP
        SMTP_HOST: "${SMTP_HOST}"
        SMTP_PORT: "${SMTP_PORT}"
        SMTP_USER: "${SMTP_USER}"
        SMTP_PASS: "${SMTP_PASSWORD}"
        SMTP_SENDER_NAME: "${SMTP_SENDER_NAME}"
        SMTP_ADMIN_EMAIL: "${SMTP_ADMIN_EMAIL}"
SMTPCONF
fi)

    #--------------------------------------------------------------------------#
    # Backup (pgBackRest)
    #--------------------------------------------------------------------------#
$(if [[ -n "${S3_BUCKET}" ]]; then cat << BACKUPCONF
    pgbackrest_enabled: true
    pgbackrest_repo:
      repo1:
        type: s3
        s3_endpoint: "${S3_ENDPOINT#https://}"
        s3_region: "${S3_REGION}"
        s3_bucket: "${S3_BUCKET}"
        s3_key: "${S3_ACCESS_KEY}"
        s3_key_secret: "${S3_SECRET_KEY}"
        path: /pgbackrest
        cipher_type: aes-256-cbc
        cipher_pass: "${PGBACKREST_CIPHER_PASS}"
        retention_full: 14
        retention_full_type: time
BACKUPCONF
else
    echo "    pgbackrest_enabled: false"
fi)

    #--------------------------------------------------------------------------#
    # Monitoring
    #--------------------------------------------------------------------------#
    grafana_admin_password: "${GRAFANA_ADMIN_PASSWORD}"

  children:
    infra:
      hosts: { ${VPS_HOST}: { infra_seq: 1 } }
    etcd:
      hosts: { ${VPS_HOST}: { etcd_seq: 1 } }
    minio:
      hosts: { ${VPS_HOST}: { minio_seq: 1 } }
    pg-meta:
      hosts: { ${VPS_HOST}: { pg_seq: 1, pg_role: primary } }
      vars:
        pg_cluster: pg-meta
PIGSTY_YAML
}
