#!/usr/bin/env python3
"""
YAML Configuration Updater for Pigsty Supabase
Properly updates pigsty.yml with credentials and SSL configuration
"""

import os
import sys
from pathlib import Path

import yaml


def update_pigsty_config(pigsty_file, env_vars):
    """
    Update pigsty.yml with credentials and SSL configuration from environment

    Args:
        pigsty_file: Path to pigsty.yml
        env_vars: Dictionary of environment variables
    """

    # Load current config
    with open(pigsty_file, "r") as f:
        config = yaml.safe_load(f)

    # Ensure structure exists
    if "all" not in config:
        config["all"] = {}
    if "vars" not in config["all"]:
        config["all"]["vars"] = {}

    all_vars = config["all"]["vars"]

    # 1. Update passwords
    if env_vars.get("GRAFANA_ADMIN_PASSWORD"):
        all_vars["grafana_admin_password"] = env_vars["GRAFANA_ADMIN_PASSWORD"]

    if env_vars.get("PG_ADMIN_PASSWORD"):
        all_vars["pg_admin_password"] = env_vars["PG_ADMIN_PASSWORD"]

    if env_vars.get("POSTGRES_PASSWORD"):
        all_vars["pg_dbsu_password"] = env_vars["POSTGRES_PASSWORD"]

    if env_vars.get("MINIO_ROOT_PASSWORD"):
        all_vars["minio_secret_key"] = env_vars["MINIO_ROOT_PASSWORD"]

    # 2. Update infra_portal with SSL domain
    if env_vars.get("USE_LETSENCRYPT") == "true" and env_vars.get("SUPABASE_DOMAIN"):
        domain = env_vars["SUPABASE_DOMAIN"]
        vps_host = env_vars.get("VPS_HOST", "10.10.10.10")

        # Update certbot email
        if env_vars.get("LETSENCRYPT_EMAIL"):
            all_vars["certbot_email"] = env_vars["LETSENCRYPT_EMAIL"]

        # Update or create infra_portal
        if "infra_portal" not in all_vars:
            all_vars["infra_portal"] = {}

        # Update supa entry with correct domain
        all_vars["infra_portal"]["supa"] = {
            "domain": domain,
            "endpoint": f"{vps_host}:8000",
            "websocket": True,
            "certbot": domain,
        }

    # 3. Update Supabase app configuration
    if "apps" not in config:
        config["apps"] = {}
    if "supabase" not in config["apps"]:
        config["apps"]["supabase"] = {}
    if "conf" not in config["apps"]["supabase"]:
        config["apps"]["supabase"]["conf"] = {}

    supa_conf = config["apps"]["supabase"]["conf"]

    # JWT credentials
    if env_vars.get("JWT_SECRET"):
        supa_conf["JWT_SECRET"] = env_vars["JWT_SECRET"]
    if env_vars.get("ANON_KEY"):
        supa_conf["ANON_KEY"] = env_vars["ANON_KEY"]
    if env_vars.get("SERVICE_ROLE_KEY"):
        supa_conf["SERVICE_ROLE_KEY"] = env_vars["SERVICE_ROLE_KEY"]

    # Dashboard credentials
    if env_vars.get("DASHBOARD_USERNAME"):
        supa_conf["DASHBOARD_USERNAME"] = env_vars["DASHBOARD_USERNAME"]
    if env_vars.get("DASHBOARD_PASSWORD"):
        supa_conf["DASHBOARD_PASSWORD"] = env_vars["DASHBOARD_PASSWORD"]

    # Logflare (Analytics) tokens
    if env_vars.get("LOGFLARE_PUBLIC_ACCESS_TOKEN"):
        supa_conf["LOGFLARE_PUBLIC_ACCESS_TOKEN"] = env_vars[
            "LOGFLARE_PUBLIC_ACCESS_TOKEN"
        ]
    if env_vars.get("LOGFLARE_PRIVATE_ACCESS_TOKEN"):
        supa_conf["LOGFLARE_PRIVATE_ACCESS_TOKEN"] = env_vars[
            "LOGFLARE_PRIVATE_ACCESS_TOKEN"
        ]

    # Database connection
    if env_vars.get("VPS_HOST"):
        supa_conf["POSTGRES_HOST"] = env_vars["VPS_HOST"]
    supa_conf["POSTGRES_PORT"] = "5436"
    supa_conf["POSTGRES_DB"] = "postgres"
    if env_vars.get("POSTGRES_PASSWORD"):
        supa_conf["POSTGRES_PASSWORD"] = env_vars["POSTGRES_PASSWORD"]

    # S3 Storage configuration (works with any S3-compatible provider)
    # Simply pass through all S3_* variables from .env to pigsty.yml
    if env_vars.get("S3_BUCKET"):
        supa_conf["S3_BUCKET"] = env_vars["S3_BUCKET"]
    if env_vars.get("S3_ENDPOINT"):
        supa_conf["S3_ENDPOINT"] = env_vars["S3_ENDPOINT"]
    if env_vars.get("S3_REGION"):
        supa_conf["S3_REGION"] = env_vars["S3_REGION"]
    if env_vars.get("S3_ACCESS_KEY"):
        supa_conf["S3_ACCESS_KEY"] = env_vars["S3_ACCESS_KEY"]
    if env_vars.get("S3_SECRET_KEY"):
        supa_conf["S3_SECRET_KEY"] = env_vars["S3_SECRET_KEY"]
    if env_vars.get("S3_FORCE_PATH_STYLE"):
        # Convert string "true"/"false" to boolean
        supa_conf["S3_FORCE_PATH_STYLE"] = (
            env_vars["S3_FORCE_PATH_STYLE"].lower() == "true"
        )
    if env_vars.get("S3_PROTOCOL"):
        supa_conf["S3_PROTOCOL"] = env_vars["S3_PROTOCOL"]

    # MINIO_DOMAIN_IP only needed if using MinIO (sss.pigsty domain)
    if env_vars.get("VPS_HOST") and "sss.pigsty" in env_vars.get("S3_ENDPOINT", ""):
        supa_conf["MINIO_DOMAIN_IP"] = env_vars["VPS_HOST"]

    # HTTPS URLs if SSL is enabled
    if env_vars.get("USE_LETSENCRYPT") == "true" and env_vars.get("SUPABASE_DOMAIN"):
        domain = env_vars["SUPABASE_DOMAIN"]
        supa_conf["SITE_URL"] = f"https://{domain}"
        supa_conf["API_EXTERNAL_URL"] = f"https://{domain}"
        supa_conf["SUPABASE_PUBLIC_URL"] = f"https://{domain}"

    # SMTP configuration (optional)
    if env_vars.get("SMTP_HOST"):
        supa_conf["SMTP_HOST"] = env_vars["SMTP_HOST"]
        supa_conf["SMTP_PORT"] = env_vars.get("SMTP_PORT", "587")
        if env_vars.get("SMTP_USER"):
            supa_conf["SMTP_USER"] = env_vars["SMTP_USER"]
        if env_vars.get("SMTP_PASSWORD"):
            supa_conf["SMTP_PASS"] = env_vars["SMTP_PASSWORD"]
        if env_vars.get("SMTP_SENDER_NAME"):
            supa_conf["SMTP_SENDER_NAME"] = env_vars["SMTP_SENDER_NAME"]

    # Save back to file
    with open(pigsty_file, "w") as f:
        yaml.dump(config, f, default_flow_style=False, sort_keys=False, width=120)

    print(f"✓ Configuration updated: {pigsty_file}")


def main():
    if len(sys.argv) != 2:
        print("Usage: yaml-update.py <pigsty.yml>")
        sys.exit(1)

    pigsty_file = sys.argv[1]

    if not os.path.exists(pigsty_file):
        print(f"Error: File not found: {pigsty_file}")
        sys.exit(1)

    # Read environment variables
    env_vars = {
        "GRAFANA_ADMIN_PASSWORD": os.getenv("GRAFANA_ADMIN_PASSWORD"),
        "PG_ADMIN_PASSWORD": os.getenv("PG_ADMIN_PASSWORD"),
        "POSTGRES_PASSWORD": os.getenv("POSTGRES_PASSWORD"),
        "MINIO_ROOT_PASSWORD": os.getenv("MINIO_ROOT_PASSWORD"),
        "JWT_SECRET": os.getenv("JWT_SECRET"),
        "ANON_KEY": os.getenv("ANON_KEY"),
        "SERVICE_ROLE_KEY": os.getenv("SERVICE_ROLE_KEY"),
        "DASHBOARD_USERNAME": os.getenv("DASHBOARD_USERNAME"),
        "DASHBOARD_PASSWORD": os.getenv("DASHBOARD_PASSWORD"),
        "LOGFLARE_PUBLIC_ACCESS_TOKEN": os.getenv("LOGFLARE_PUBLIC_ACCESS_TOKEN"),
        "LOGFLARE_PRIVATE_ACCESS_TOKEN": os.getenv("LOGFLARE_PRIVATE_ACCESS_TOKEN"),
        "S3_BUCKET": os.getenv("S3_BUCKET"),
        "S3_ENDPOINT": os.getenv("S3_ENDPOINT"),
        "S3_REGION": os.getenv("S3_REGION"),
        "S3_ACCESS_KEY": os.getenv("S3_ACCESS_KEY"),
        "S3_SECRET_KEY": os.getenv("S3_SECRET_KEY"),
        "S3_FORCE_PATH_STYLE": os.getenv("S3_FORCE_PATH_STYLE"),
        "S3_PROTOCOL": os.getenv("S3_PROTOCOL"),
        "VPS_HOST": os.getenv("VPS_HOST"),
        "SUPABASE_DOMAIN": os.getenv("SUPABASE_DOMAIN"),
        "USE_LETSENCRYPT": os.getenv("USE_LETSENCRYPT"),
        "LETSENCRYPT_EMAIL": os.getenv("LETSENCRYPT_EMAIL"),
        "SMTP_HOST": os.getenv("SMTP_HOST"),
        "SMTP_PORT": os.getenv("SMTP_PORT"),
        "SMTP_USER": os.getenv("SMTP_USER"),
        "SMTP_PASSWORD": os.getenv("SMTP_PASSWORD"),
        "SMTP_SENDER_NAME": os.getenv("SMTP_SENDER_NAME"),
    }

    update_pigsty_config(pigsty_file, env_vars)


if __name__ == "__main__":
    main()
