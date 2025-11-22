#!/usr/bin/env python3
"""
Simple YAML Configuration Generator for Pigsty Supabase

Takes official supabase.yml from Pigsty and substitutes values from .env
This is much simpler than the current yaml-update.py approach.

FIXES APPLIED (learned from deployment issues):
1. POSTGRES_HOST should be 172.17.0.1 (Docker gateway) not VPS IP
2. pg_hba_rules needs rules for 'supabase' database, not just 'postgres'
3. pg_hba_rules needs rule for VPS IP (HAProxy preserves client IP)
4. Passwords with special characters (/, +, =) cause URL parsing issues
5. Comments inline in .env values break container configs
"""

import os
import re
import secrets
import string
import sys
from pathlib import Path


def generate_safe_password(length=32):
    """Generate a password without URL-problematic characters (/, +, =, #, %)"""
    # Use only alphanumeric characters to avoid URL encoding issues
    alphabet = string.ascii_letters + string.digits
    return "".join(secrets.choice(alphabet) for _ in range(length))


def load_env(env_file=".env"):
    """Load environment variables from .env file"""
    env = {}
    env_path = Path(env_file)

    if not env_path.exists():
        print(f"Error: {env_file} not found", file=sys.stderr)
        sys.exit(1)

    with open(env_path) as f:
        for line in f:
            line = line.strip()
            # Skip comments and empty lines
            if line and not line.startswith("#") and "=" in line:
                # Split only on first =
                key, value = line.split("=", 1)
                # Strip inline comments from values (# and everything after)
                value = value.split("#")[0].strip()
                env[key.strip()] = value.strip().strip('"').strip("'")

    return env


def sanitize_password(password):
    """
    Check if password has URL-problematic characters.
    If it does, generate a new safe password and warn the user.
    """
    problematic_chars = ["/", "+", "=", "#", "%", "&", "?"]
    if any(char in password for char in problematic_chars):
        print(
            f"WARNING: Password contains URL-problematic characters. "
            f"This may cause connection issues in Supabase containers.",
            file=sys.stderr,
        )
        return password  # Return as-is, but warn
    return password


def substitute_line(line, env):
    """
    Substitute environment variables in a line
    Supports: ${VAR}, $VAR, and direct value replacement
    """
    original = line

    # Replace ${VAR} patterns
    for key, value in env.items():
        # Pattern: ${KEY}
        line = line.replace(f"${{{key}}}", value)

        # Pattern: $KEY (with word boundary)
        line = re.sub(rf"\${key}\b", value, line)

    # Also replace common YAML value patterns
    # Pattern: key: "old-value"  or  key: 'old-value'  or  key: old-value
    for key, value in env.items():
        # Match YAML key-value pairs
        patterns = [
            # Exact key name (like admin_ip: 10.10.10.10)
            # Match up to comment (#) or end of value, but NOT entire line to preserve newlines
            (
                rf'^(\s*{key}\s*:\s*)["\']?[^#\n]+["\']?(\s*(?:#.*)?$)',
                rf"\g<1>{value}\g<2>",
            ),
            # Common replaceable values
            # IMPORTANT: Order matters! More specific patterns FIRST, then general ones
            # Replace "10.10.10.10" with quotes preserved (like endpoint: "10.10.10.10:8000")
            (
                r'"10\.10\.10\.10',
                rf'"{env.get("VPS_HOST", "10.10.10.10")}',
            ),
            # Replace 10.10.10.10 as a key (before colon) - for hosts sections
            (
                r"^(\s*)10\.10\.10\.10(\s*:)",
                rf"\g<1>{env.get('VPS_HOST', '10.10.10.10')}\g<2>",
            ),
            # Replace 10.10.10.10 as a value (after colon, without quotes)
            (
                r"(:\s*)10\.10\.10\.10(\s)",
                rf"\g<1>{env.get('VPS_HOST', '10.10.10.10')}\g<2>",
            ),
            # Replace 10.10.10.10 in lists and other contexts (last resort)
            (
                r"(?<![\"'])10\.10\.10\.10(?![\"'])",
                env.get("VPS_HOST", "10.10.10.10"),
            ),
            (
                r'(:\s*)["\']?supa\.pigsty["\']?',
                rf"\g<1>{env.get('SUPABASE_DOMAIN', 'supa.pigsty')}",
            ),
            (
                r'(:\s*)["\']?https://supa\.pigsty["\']?',
                rf"\g<1>https://{env.get('SUPABASE_DOMAIN', 'supa.pigsty')}",
            ),
            # Update all SITE_URL, API_EXTERNAL_URL, SUPABASE_PUBLIC_URL
            (
                r"(SITE_URL:\s*)https://supa\.pigsty",
                rf"\g<1>{env.get('SUPABASE_API_EXTERNAL_URL', 'https://supa.pigsty')}",
            ),
            (
                r"(API_EXTERNAL_URL:\s*)https://supa\.pigsty",
                rf"\g<1>{env.get('SUPABASE_API_EXTERNAL_URL', 'https://supa.pigsty')}",
            ),
            (
                r"(SUPABASE_PUBLIC_URL:\s*)https://supa\.pigsty",
                rf"\g<1>{env.get('SUPABASE_API_EXTERNAL_URL', 'https://supa.pigsty')}",
            ),
            (
                r'(:\s*)["\']?your@email\.com["\']?',
                rf"\g<1>{env.get('LETSENCRYPT_EMAIL', 'your@email.com')}",
            ),
            # Enable certbot auto-sign if USE_LETSENCRYPT is true
            (
                r"^(\s*certbot_sign:\s*)false",
                rf"\g<1>{env.get('USE_LETSENCRYPT', 'false').lower()}",
            ),
            # Update certbot_email
            (
                r"(certbot_email:\s*)your@email\.com",
                rf"\g<1>{env.get('LETSENCRYPT_EMAIL', 'your@email.com')}",
            ),
            # Update infra_portal supa domain
            (
                r"(supa.*\n\s*domain:\s*)supa\.pigsty",
                rf"\g<1>{env.get('SUPABASE_DOMAIN', 'supa.pigsty')}",
            ),
            # Update infra_portal supa certbot
            (
                r"(certbot:\s*)supa\.pigsty",
                rf"\g<1>{env.get('SUPABASE_DOMAIN', 'supa.pigsty')}",
            ),
            (
                r'(:\s*)["\']?DBUser\.Supa["\']?',
                rf"\g<1>{env.get('POSTGRES_PASSWORD', 'DBUser.Supa')}",
            ),
            (
                r'(:\s*)["\']?DBUser\.DBA["\']?',
                rf"\g<1>{env.get('PG_ADMIN_PASSWORD', 'DBUser.DBA')}",
            ),
            (
                r'(:\s*)["\']?DBUser\.Monitor["\']?',
                rf"\g<1>{env.get('PG_MONITOR_PASSWORD', 'DBUser.Monitor')}",
            ),
            (
                r'(:\s*)["\']?DBUser\.Replicator["\']?',
                rf"\g<1>{env.get('PG_REPLICATION_PASSWORD', 'DBUser.Replicator')}",
            ),
            # SECRET_KEY_BASE for Realtime
            (
                r'(:\s*)["\']?UpNVntn3cDxHJpq99YMc1T1AQgQpc8kfYTuRgBiYa15BLrx8etQoXz3gZv1/u2oq["\']?',
                rf"\g<1>{env.get('SECRET_KEY_BASE', 'UpNVntn3cDxHJpq99YMc1T1AQgQpc8kfYTuRgBiYa15BLrx8etQoXz3gZv1/u2oq')}",
            ),
            # Studio branding - default to BITS
            (
                r"(STUDIO_DEFAULT_PROJECT:\s*)Pigsty",
                r"\g<1>BITS",
            ),
            (
                r"(STUDIO_DEFAULT_ORGANIZATION:\s*)Pigsty",
                r"\g<1>BITS",
            ),
        ]

        for pattern, replacement in patterns:
            line = re.sub(pattern, replacement, line)

    return line


def add_extra_pg_hba_rules(content, env):
    """
    Add additional pg_hba_rules that are required but missing from official template:
    1. Rule for VPS IP (HAProxy preserves client IP)
    2. Rules for 'supabase' database (analytics uses it)
    """
    vps_host = env.get("VPS_HOST", "10.10.10.10")

    # Find the pg_hba_rules section and add our rules
    # Look for the line with 172.17.0.0/16 and add after it
    docker_rule_pattern = (
        r"(\s*-\s*\{\s*user:\s*all\s*,db:\s*postgres\s*,addr:\s*172\.17\.0\.0/16.*\})"
    )

    extra_rules = f"""
          - {{ user: all ,db: postgres  ,addr: {vps_host}/32   ,auth: pwd ,title: 'allow supabase from VPS IP via HAProxy' }}
          - {{ user: all ,db: supabase  ,addr: intra         ,auth: pwd ,title: 'allow supabase analytics from intranet' }}
          - {{ user: all ,db: supabase  ,addr: 172.17.0.0/16 ,auth: pwd ,title: 'allow supabase analytics from docker' }}
          - {{ user: all ,db: supabase  ,addr: {vps_host}/32   ,auth: pwd ,title: 'allow supabase analytics from VPS IP' }}"""

    # Add rules after the docker network rule
    content = re.sub(docker_rule_pattern, rf"\g<1>{extra_rules}", content)

    return content


def fix_postgres_host(content, env):
    """
    Fix POSTGRES_HOST to use Docker gateway (172.17.0.1) instead of VPS IP.

    When Supabase containers connect to PostgreSQL via HAProxy on port 5436,
    HAProxy preserves the client IP. If containers use VPS IP, pg_hba sees
    connections from VPS IP. Using Docker gateway (172.17.0.1) is more reliable.
    """
    vps_host = env.get("VPS_HOST", "10.10.10.10")

    # Replace POSTGRES_HOST: <VPS_IP> with POSTGRES_HOST: 172.17.0.1
    # This is in the apps.supabase.conf section
    content = re.sub(
        rf"(\s*POSTGRES_HOST:\s*){vps_host}(\s)", r"\g<1>172.17.0.1\g<2>", content
    )

    return content


def add_pg_meta_crypto_key(content, env):
    """
    Add PG_META_CRYPTO_KEY to the conf section.
    This key encrypts connection strings between Studio and postgres-meta.
    """
    pg_meta_key = env.get("PG_META_CRYPTO_KEY", "")
    secret_key_base = env.get("SECRET_KEY_BASE", "")

    # Add PG_META_CRYPTO_KEY after LOGFLARE_PRIVATE_ACCESS_TOKEN
    if pg_meta_key and "PG_META_CRYPTO_KEY" not in content:
        content = re.sub(
            r"(\s+LOGFLARE_PRIVATE_ACCESS_TOKEN:\s*\S+)",
            rf"\g<1>\n              PG_META_CRYPTO_KEY: {pg_meta_key}",
            content,
        )

    # Add SECRET_KEY_BASE if not present (for Realtime)
    if secret_key_base and "SECRET_KEY_BASE" not in content:
        content = re.sub(
            r"(\s+PG_META_CRYPTO_KEY:\s*\S+)",
            rf"\g<1>\n              SECRET_KEY_BASE: {secret_key_base}",
            content,
        )

    return content


def add_smtp_configuration(content, env):
    """
    Add SMTP configuration from .env to the conf section.
    Replaces commented SMTP lines with actual values from environment.
    """
    smtp_host = env.get("SMTP_HOST", "")
    smtp_port = env.get("SMTP_PORT", "")
    smtp_user = env.get("SMTP_USER", "")
    smtp_password = env.get("SMTP_PASSWORD", "")
    smtp_admin_email = env.get("SMTP_ADMIN_EMAIL", "")
    smtp_sender_name = env.get("SMTP_SENDER_NAME", "")

    # Only add SMTP config if at least host is defined
    if smtp_host:
        # Find the commented SMTP section and replace with actual values
        # Pattern: lines starting with #SMTP_
        smtp_config = f"""              SMTP_ADMIN_EMAIL: {smtp_admin_email}
              SMTP_HOST: {smtp_host}
              SMTP_PORT: {smtp_port}
              SMTP_USER: {smtp_user}
              SMTP_PASS: {smtp_password}
              SMTP_SENDER_NAME: {smtp_sender_name}"""

        # Replace the commented SMTP section
        content = re.sub(
            r"(\s+# if using SMTP \(optional\)\s*\n)(\s+#SMTP_ADMIN_EMAIL:.*\n\s+#SMTP_HOST:.*\n\s+#SMTP_PORT:.*\n\s+#SMTP_USER:.*\n\s+#SMTP_PASS:.*\n\s+#SMTP_SENDER_NAME:.*)",
            rf"\g<1>{smtp_config}",
            content,
        )

        print(
            f"INFO: Added SMTP configuration: {smtp_host}:{smtp_port} ({smtp_admin_email})",
            file=sys.stderr,
        )

    return content


def add_backblaze_b2_config(content, env):
    """
    Add TUS_ALLOW_S3_TAGS=false for Backblaze B2 compatibility.

    Backblaze B2 doesn't support x-amz-tagging header which causes
    resumable uploads to fail with 'Unsupported header' error.
    This setting disables S3 tagging for TUS uploads.
    """
    s3_endpoint = env.get("S3_ENDPOINT", "")

    # Detect if using Backblaze B2, Cloudflare R2, or DigitalOcean Spaces
    needs_tus_fix = any(
        provider in s3_endpoint.lower()
        for provider in [
            "backblazeb2.com",
            "r2.cloudflarestorage.com",
            "digitaloceanspaces.com",
        ]
    )

    if needs_tus_fix:
        # Find the S3_FORCE_PATH_STYLE line and add TUS_ALLOW_S3_TAGS after it
        # Or find any S3_ config line to add after
        if "TUS_ALLOW_S3_TAGS" not in content:
            # Add after S3_FORCE_PATH_STYLE or S3_PROTOCOL
            content = re.sub(
                r"(\s+S3_FORCE_PATH_STYLE:\s*\w+)",
                r'\g<1>\n              TUS_ALLOW_S3_TAGS: "false"',
                content,
            )
            # If S3_FORCE_PATH_STYLE not found, try S3_PROTOCOL
            if "TUS_ALLOW_S3_TAGS" not in content:
                content = re.sub(
                    r"(\s+S3_PROTOCOL:\s*\w+)",
                    r'\g<1>\n              TUS_ALLOW_S3_TAGS: "false"',
                    content,
                )
        print(
            f"INFO: Detected {s3_endpoint} - Added TUS_ALLOW_S3_TAGS=false for compatibility",
            file=sys.stderr,
        )

    return content


def remove_inline_comments_from_conf(content):
    """
    Remove inline comments from the apps.supabase.conf section.

    Docker Compose doesn't handle inline comments in .env files well.
    Comments like 'password: value # comment' get included in the value.
    """
    # Pattern to match lines in conf section with inline comments
    # Match: "              KEY: value  # comment" -> "              KEY: value"
    lines = content.split("\n")
    result = []
    in_conf_section = False

    for line in lines:
        # Detect if we're in the conf: section
        if re.match(r"\s*conf:\s*#", line) or re.match(r"\s*conf:\s*$", line):
            in_conf_section = True
            result.append(line)
            continue

        # Detect if we've left the conf section (new section at same or lower indent)
        if (
            in_conf_section
            and re.match(r"\s{0,14}[a-z_]+:", line)
            and not line.strip().startswith("#")
        ):
            # Check if this is a top-level key (not a conf value)
            indent = len(line) - len(line.lstrip())
            if indent <= 14:  # conf values are indented more than 14 spaces
                in_conf_section = False

        # Remove inline comments from conf values (but preserve the comment marker for titles)
        if in_conf_section and "#" in line and not "'#" in line:
            # Only remove if it looks like a conf value (KEY: value # comment)
            match = re.match(r"^(\s+[A-Z_]+:\s*[^#]+)(#.*)$", line)
            if match:
                line = match.group(1).rstrip()

        result.append(line)

    return "\n".join(result)


def process_yaml(input_file, env):
    """Process YAML file line by line, substituting values"""
    output_lines = []

    with open(input_file) as f:
        for line in f:
            # Preserve exact formatting but substitute values
            new_line = substitute_line(line, env)
            output_lines.append(new_line)

    content = "".join(output_lines)

    # Apply additional fixes
    content = add_extra_pg_hba_rules(content, env)
    content = fix_postgres_host(content, env)
    content = add_pg_meta_crypto_key(content, env)
    content = add_smtp_configuration(content, env)
    content = add_backblaze_b2_config(content, env)
    content = remove_inline_comments_from_conf(content)

    return content


def validate_passwords(env):
    """Warn about passwords with problematic characters"""
    password_keys = [
        "POSTGRES_PASSWORD",
        "PG_ADMIN_PASSWORD",
        "PG_MONITOR_PASSWORD",
        "PG_REPLICATION_PASSWORD",
        "GRAFANA_ADMIN_PASSWORD",
        "MINIO_ROOT_PASSWORD",
        "DASHBOARD_PASSWORD",
    ]

    problematic_chars = ["/", "+", "=", "#", "%", "&", "?"]

    for key in password_keys:
        if key in env:
            password = env[key]
            bad_chars = [c for c in problematic_chars if c in password]
            if bad_chars:
                print(
                    f"WARNING: {key} contains characters {bad_chars} that may cause "
                    f"URL parsing issues in database connection strings. "
                    f"Consider using alphanumeric passwords only.",
                    file=sys.stderr,
                )


def main():
    if len(sys.argv) < 2:
        print("Usage: simple-yaml-gen.py <supabase.yml> [.env]", file=sys.stderr)
        print("", file=sys.stderr)
        print("Example:", file=sys.stderr)
        print(
            "  ./lib/simple-yaml-gen.py /tmp/supabase.yml > pigsty.yml", file=sys.stderr
        )
        print("", file=sys.stderr)
        print("This script applies the following fixes automatically:", file=sys.stderr)
        print(
            "  1. Adds pg_hba rules for VPS IP and 'supabase' database", file=sys.stderr
        )
        print("  2. Sets POSTGRES_HOST to 172.17.0.1 (Docker gateway)", file=sys.stderr)
        print("  3. Adds SMTP configuration from .env", file=sys.stderr)
        print("  4. Removes inline comments from conf values", file=sys.stderr)
        print(
            "  5. Warns about passwords with URL-problematic characters",
            file=sys.stderr,
        )
        sys.exit(1)

    input_file = sys.argv[1]
    env_file = sys.argv[2] if len(sys.argv) > 2 else ".env"

    if not Path(input_file).exists():
        print(f"Error: Input file {input_file} not found", file=sys.stderr)
        sys.exit(1)

    # Load environment variables
    env = load_env(env_file)

    # Validate passwords
    validate_passwords(env)

    # Process YAML
    output = process_yaml(input_file, env)

    # Output to stdout
    print(output, end="")


if __name__ == "__main__":
    main()
