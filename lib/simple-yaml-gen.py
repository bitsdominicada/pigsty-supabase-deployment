#!/usr/bin/env python3
"""
Simple YAML Configuration Generator for Pigsty Supabase

Takes official supabase.yml from Pigsty and substitutes values from .env
This is much simpler than the current yaml-update.py approach.
"""

import os
import re
import sys
from pathlib import Path


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
                env[key.strip()] = value.strip().strip('"').strip("'")

    return env


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
            (
                r'(:\s*)["\']?your@email\.com["\']?',
                rf"\g<1>{env.get('LETSENCRYPT_EMAIL', 'your@email.com')}",
            ),
            # Enable certbot auto-sign if USE_LETSENCRYPT is true
            (
                r"^(\s*certbot_sign:\s*)false",
                rf"\g<1>{env.get('USE_LETSENCRYPT', 'false').lower()}",
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
        ]

        for pattern, replacement in patterns:
            line = re.sub(pattern, replacement, line)

    return line


def process_yaml(input_file, env):
    """Process YAML file line by line, substituting values"""
    output_lines = []

    with open(input_file) as f:
        for line in f:
            # Preserve exact formatting but substitute values
            new_line = substitute_line(line, env)
            output_lines.append(new_line)

    return "".join(output_lines)


def main():
    if len(sys.argv) < 2:
        print("Usage: simple-yaml-gen.py <supabase.yml> [.env]", file=sys.stderr)
        print("", file=sys.stderr)
        print("Example:", file=sys.stderr)
        print(
            "  ./lib/simple-yaml-gen.py /tmp/supabase.yml > pigsty.yml", file=sys.stderr
        )
        sys.exit(1)

    input_file = sys.argv[1]
    env_file = sys.argv[2] if len(sys.argv) > 2 else ".env"

    if not Path(input_file).exists():
        print(f"Error: Input file {input_file} not found", file=sys.stderr)
        sys.exit(1)

    # Load environment variables
    env = load_env(env_file)

    # Process YAML
    output = process_yaml(input_file, env)

    # Output to stdout
    print(output, end="")


if __name__ == "__main__":
    main()
