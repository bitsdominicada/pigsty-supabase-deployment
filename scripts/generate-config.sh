#!/usr/bin/env bash
#==============================================================================#
# Generate pigsty.yml from template with our variables
# Based on official Pigsty supabase.yml template
#==============================================================================#

generate_pigsty_yml() {
    cat << 'PIGSTY_YAML'
#==============================================================================#
# Pigsty Supabase Configuration
# Based on: https://github.com/Vonng/pigsty/blob/main/conf/supabase.yml
#==============================================================================#

all:
  children:

    #--------------------------------------------------------------------------#
    # INFRA: https://pigsty.io/docs/infra
    #--------------------------------------------------------------------------#
    infra:
      hosts:
PIGSTY_YAML
    echo "        ${VPS_HOST}: { infra_seq: 1 }"
    cat << 'PIGSTY_YAML'
      vars:
        repo_enabled: false
        infra_portal:
PIGSTY_YAML
    # Home serves Flutter app as main site
    echo "          home: { domain: ${SUPABASE_DOMAIN}, path: /var/www/${FLUTTER_APP_NAME:-neura}, certbot: ${SUPABASE_DOMAIN} }"
    echo "          grafana: { domain: grafana.${SUPABASE_DOMAIN}, endpoint: \"127.0.0.1:3000\" }"
    echo "          prometheus: { domain: prom.${SUPABASE_DOMAIN}, endpoint: \"127.0.0.1:9090\" }"
    echo "          supabase: { domain: studio.${SUPABASE_DOMAIN}, endpoint: \"127.0.0.1:3001\", websocket: true, certbot: studio.${SUPABASE_DOMAIN} }"
    echo "          supabase-api: { domain: api.${SUPABASE_DOMAIN}, endpoint: \"127.0.0.1:8000\", websocket: true, certbot: api.${SUPABASE_DOMAIN} }"
    cat << PIGSTY_YAML
        certbot_email: ${LETSENCRYPT_EMAIL:-admin@${SUPABASE_DOMAIN}}

    #--------------------------------------------------------------------------#
    # ETCD: https://pigsty.io/docs/etcd
    #--------------------------------------------------------------------------#
    etcd:
      hosts:
        ${VPS_HOST}: { etcd_seq: 1 }
      vars:
        etcd_cluster: etcd
        etcd_safeguard: false

    #--------------------------------------------------------------------------#
    # PostgreSQL cluster for Supabase
    #--------------------------------------------------------------------------#
    pg-${CLIENT_NAME}:
      hosts:
        ${VPS_HOST}: { pg_seq: 1, pg_role: primary }
      vars:
        pg_cluster: pg-${CLIENT_NAME}
        pg_users:
          - { name: anon, login: false }
          - { name: authenticated, login: false }
          - { name: dashboard_user, login: false, replication: true, createdb: true, createrole: true }
          - { name: service_role, login: false, bypassrls: true }
          - { name: supabase_admin, password: "${POSTGRES_PASSWORD}", pgbouncer: true, inherit: true, roles: [dbrole_admin], superuser: true, replication: true, createdb: true, createrole: true, bypassrls: true }
          - { name: authenticator, password: "${POSTGRES_PASSWORD}", pgbouncer: true, inherit: false, roles: [dbrole_admin, authenticated, anon, service_role] }
          - { name: supabase_auth_admin, password: "${POSTGRES_PASSWORD}", pgbouncer: true, inherit: false, roles: [dbrole_admin], createrole: true }
          - { name: supabase_storage_admin, password: "${POSTGRES_PASSWORD}", pgbouncer: true, inherit: false, roles: [dbrole_admin, authenticated, anon, service_role], createrole: true }
          - { name: supabase_functions_admin, password: "${POSTGRES_PASSWORD}", pgbouncer: true, inherit: false, roles: [dbrole_admin], createrole: true }
          - { name: supabase_replication_admin, password: "${POSTGRES_PASSWORD}", replication: true, roles: [dbrole_admin] }
          - { name: supabase_etl_admin, password: "${POSTGRES_PASSWORD}", replication: true, roles: [pg_read_all_data] }
          - { name: supabase_read_only_user, password: "${POSTGRES_PASSWORD}", bypassrls: true, roles: [pg_read_all_data, dbrole_readonly] }

        pg_databases:
          - name: postgres
            baseline: supabase.sql
            owner: supabase_admin
            comment: supabase postgres database
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
          - { name: supabase, owner: supabase_admin, comment: supabase analytics database, schemas: [extensions, _analytics] }

        pg_libs: 'timescaledb, pgsodium, plpgsql, plpgsql_check, pg_cron, pg_net, pg_stat_statements, auto_explain, pg_wait_sampling, pg_tle, plan_filter'
        pg_extensions: [pg18-main, pg18-time, pg18-gis, pg18-rag, pg18-fts, pg18-olap, pg18-feat, pg18-lang, pg18-type, pg18-util, pg18-func, pg18-admin, pg18-stat, pg18-sec, pg18-fdw, pg18-sim, pg18-etl]
        pg_parameters:
          cron.database_name: postgres

        pg_hba_rules:
          - { user: all, db: postgres, addr: intra, auth: pwd, title: 'allow supabase access from intranet' }
          - { user: all, db: postgres, addr: 172.17.0.0/16, auth: pwd, title: 'allow access from local docker network' }

        node_crontab:
          - '00 01 * * 0 postgres /pg/bin/pg-backup full'
          - '00 01 * * 1-6 postgres /pg/bin/pg-backup diff'
          - '*  *  * * * postgres /pg/bin/supa-kick'
PIGSTY_YAML

    # Add pgBackRest B2 config in pg-meta section if S3 is configured
    if [[ -n "${S3_BUCKET}" ]]; then
        cat << PIGSTY_YAML

        pgbackrest_method: b2
        pgbackrest_repo:
          local:
            path: /pg/backup
            retention_full_type: count
            retention_full: 2
          b2:
            type: s3
            s3_endpoint: s3.${S3_REGION}.backblazeb2.com
            s3_region: ${S3_REGION}
            s3_bucket: ${S3_BUCKET}
            s3_key: ${S3_ACCESS_KEY}
            s3_key_secret: ${S3_SECRET_KEY}
            s3_uri_style: path
            path: /pg-backups
            bundle: y
            bundle_limit: 20MiB
            bundle_size: 128MiB
            cipher_type: aes-256-cbc
            cipher_pass: ${POSTGRES_PASSWORD}
            retention_full_type: count
            retention_full: 2
PIGSTY_YAML
    fi

    cat << PIGSTY_YAML

    #--------------------------------------------------------------------------#
    # Supabase Application
    #--------------------------------------------------------------------------#
    supabase:
      hosts:
        ${VPS_HOST}: {}
      vars:
        docker_enabled: true
        app: supabase
        apps:
          supabase:
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
PIGSTY_YAML

    # Add S3/Backblaze config if configured
    if [[ -n "${S3_BUCKET}" ]]; then
        cat << PIGSTY_YAML
              S3_BUCKET: "${S3_BUCKET}"
              S3_ENDPOINT: "${S3_ENDPOINT}"
              S3_REGION: "${S3_REGION}"
              S3_ACCESS_KEY: "${S3_ACCESS_KEY}"
              S3_SECRET_KEY: "${S3_SECRET_KEY}"
              S3_FORCE_PATH_STYLE: "false"
              S3_PROTOCOL: "https"
              TUS_ALLOW_S3_TAGS: "false"
PIGSTY_YAML
    fi

    # Add SMTP config if configured
    if [[ -n "${SMTP_HOST}" ]]; then
        cat << PIGSTY_YAML
              SMTP_HOST: "${SMTP_HOST}"
              SMTP_PORT: "${SMTP_PORT}"
              SMTP_USER: "${SMTP_USER}"
              SMTP_PASS: "${SMTP_PASSWORD}"
              SMTP_SENDER_NAME: "${SMTP_SENDER_NAME}"
              SMTP_ADMIN_EMAIL: "${SMTP_ADMIN_EMAIL}"
PIGSTY_YAML
    fi

    cat << PIGSTY_YAML

  #----------------------------------------------------------------------------#
  # Global Variables
  #----------------------------------------------------------------------------#
  vars:
    version: v4.0.0
    admin_ip: ${VPS_HOST}
    region: default
    pg_version: 18

    # Use upstream repos instead of local repo
    node_repo_modules: node,infra,pgsql
    node_repo_remove: true

    grafana_admin_password: "${GRAFANA_ADMIN_PASSWORD}"
PIGSTY_YAML
}
