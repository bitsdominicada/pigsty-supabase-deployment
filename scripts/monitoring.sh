#!/usr/bin/env bash
#==============================================================================#
# Monitoring setup: blackbox probes, custom alerts, alertmanager email
#==============================================================================#

setup_monitoring_alerts() {
    if [[ -z "${SUPABASE_DOMAIN:-}" ]]; then
        log_warn "SUPABASE_DOMAIN not set, skipping monitoring HTTP probe setup"
        return 0
    fi

    local tmp_dir
    tmp_dir="$(mktemp -d)"
    local app_domain="${APP_DOMAIN:-${SUPABASE_DOMAIN}}"
    local api_domain="${API_DOMAIN:-api.${SUPABASE_DOMAIN}}"
    local studio_domain="${STUDIO_DOMAIN:-studio.${SUPABASE_DOMAIN}}"

    cat > "${tmp_dir}/endpoints.yml" <<EOF
---
- labels: { ip: ${api_domain}, ins: api-health, cls: supabase }
  targets: [ https://${api_domain}/auth/v1/health ]
- labels: { ip: ${studio_domain}, ins: studio-home, cls: supabase }
  targets: [ https://${studio_domain}/ ]
- labels: { ip: ${app_domain}, ins: app-home, cls: supabase }
  targets: [ https://${app_domain}/ ]
EOF

    cat > "${tmp_dir}/custom.yml" <<'EOF'
---
groups:
  - name: custom-production-alerts
    rules:
      - alert: PgBackRestBackupStale
        expr: pgbackrest_backup_since_last_completion_seconds{backup_type="incr"} > 18000
        for: 15m
        labels: { level: 0, severity: CRIT, category: pgsql }
        annotations:
          summary: "CRIT PgBackRestBackupStale {{ $labels.ins }}"
          description: |
            No successful incremental backup in >5h.
            pgbackrest_backup_since_last_completion_seconds={{ $value | printf "%.0f" }}

      - alert: PgBackRestBackupError
        expr: pgbackrest_backup_last_error_status{backup_type="incr"} > 0
        for: 5m
        labels: { level: 0, severity: CRIT, category: pgsql }
        annotations:
          summary: "CRIT PgBackRestBackupError {{ $labels.ins }}"
          description: |
            Last incremental backup returned non-zero status.
            pgbackrest_backup_last_error_status={{ $value | printf "%.0f" }}

      - alert: SupabaseApiHealthDown
        expr: probe_success{job="http_probe",ins="api-health"} < 1
        for: 2m
        labels: { level: 0, severity: CRIT, category: infra }
        annotations:
          summary: "CRIT SupabaseApiHealthDown"
          description: "Blackbox probe to API endpoint is failing."

      - alert: SupabaseStudioDown
        expr: probe_success{job="http_probe",ins="studio-home"} < 1
        for: 2m
        labels: { level: 1, severity: WARN, category: infra }
        annotations:
          summary: "WARN SupabaseStudioDown"
          description: "Blackbox probe to Studio endpoint is failing."

      - alert: SupabaseAppDown
        expr: probe_success{job="http_probe",ins="app-home"} < 1
        for: 2m
        labels: { level: 1, severity: WARN, category: infra }
        annotations:
          summary: "WARN SupabaseAppDown"
          description: "Blackbox probe to App endpoint is failing."
EOF

    cat > "${tmp_dir}/blackbox.yml" <<'EOF'
---
modules:
  icmp:
    prober: icmp
  icmp_ttl5:
    prober: icmp
    timeout: 5s
    icmp:
      ttl: 5
  http_2xx:
    prober: http
  http_post_2xx:
    prober: http
    http:
      method: POST
  http_ok_auth:
    prober: http
    http:
      valid_status_codes: [200, 204, 301, 302, 307, 401, 403]
  tcp_connect:
    prober: tcp
...
EOF

    scp_file "${tmp_dir}/endpoints.yml" "/tmp/endpoints.yml"
    scp_file "${tmp_dir}/custom.yml" "/tmp/custom.yml"
    scp_file "${tmp_dir}/blackbox.yml" "/tmp/blackbox.yml"
    rm -rf "${tmp_dir}"

    ssh_cmd "sudo mkdir -p /infra/targets/http"
    ssh_cmd "sudo install -o victoria -g infra -m 0644 /tmp/endpoints.yml /infra/targets/http/endpoints.yml"
    ssh_cmd "sudo install -o victoria -g infra -m 0644 /tmp/custom.yml /infra/rules/custom.yml"
    ssh_cmd "sudo install -o prometheus -g infra -m 0644 /tmp/blackbox.yml /etc/blackbox.yml"
    ssh_cmd "rm -f /tmp/endpoints.yml /tmp/custom.yml /tmp/blackbox.yml"

    ssh_cmd "sudo bash -s" <<'EOF'
set -euo pipefail

PROM=/infra/prometheus.yml
if grep -q 'job_name: http_probe' "$PROM"; then
  tmp_file="$(mktemp)"
  awk '
    /job_name:[[:space:]]*http_probe/ { in_http=1 }
    in_http && /params:[[:space:]]*\{module:[[:space:]]*\[http_2xx\]\}/ { gsub(/http_2xx/, "http_ok_auth") }
    in_http && /^  - job_name:/ && $0 !~ /http_probe/ { in_http=0 }
    { print }
  ' "$PROM" > "$tmp_file"
  install -o victoria -g infra -m 0644 "$tmp_file" "$PROM"
  rm -f "$tmp_file"
else
  tmp_file="$(mktemp)"
  awk '
    /^\.{3}$/ && !added {
      print ""
      print "  #--------------------------------------------------------------#"
      print "  # job: http_probe"
      print "  # blackbox exporter HTTP probes for public endpoints"
      print "  #--------------------------------------------------------------#"
      print "  - job_name: http_probe"
      print "    metrics_path: /probe"
      print "    params: {module: [http_ok_auth]}"
      print "    file_sd_configs:"
      print "      - files: [ /infra/targets/http/*.yml ]"
      print "    relabel_configs:"
      print "      - source_labels: [__address__]"
      print "        target_label: __param_target"
      print "      - source_labels: [__param_target]"
      print "        target_label: instance"
      print "      - target_label: __address__"
      print "        replacement: 127.0.0.1:9115"
      print ""
      added=1
    }
    { print }
    END {
      if (!added) {
        print ""
        print "  #--------------------------------------------------------------#"
        print "  # job: http_probe"
        print "  # blackbox exporter HTTP probes for public endpoints"
        print "  #--------------------------------------------------------------#"
        print "  - job_name: http_probe"
        print "    metrics_path: /probe"
        print "    params: {module: [http_ok_auth]}"
        print "    file_sd_configs:"
        print "      - files: [ /infra/targets/http/*.yml ]"
        print "    relabel_configs:"
        print "      - source_labels: [__address__]"
        print "        target_label: __param_target"
        print "      - source_labels: [__param_target]"
        print "        target_label: instance"
        print "      - target_label: __address__"
        print "        replacement: 127.0.0.1:9115"
        print "..."
      }
    }
  ' "$PROM" > "$tmp_file"
  install -o victoria -g infra -m 0644 "$tmp_file" "$PROM"
  rm -f "$tmp_file"
fi

systemctl restart blackbox_exporter
systemctl reload vmetrics
systemctl restart vmalert
EOF

    if ssh_cmd "curl -fsS http://127.0.0.1:8428/api/v1/query --data-urlencode 'query=up{job=\"http_probe\"}' | jq -e '.data.result | length > 0' >/dev/null"; then
        log_success "Monitoring alerts configured (http_probe + custom rules)"
    else
        log_warn "Monitoring alert setup completed, but http_probe verification returned no series yet"
    fi
}

configure_alertmanager_email() {
    if [[ -z "${SMTP_HOST:-}" ]] || [[ -z "${SMTP_USER:-}" ]] || [[ -z "${SMTP_PASSWORD:-}" ]]; then
        log_warn "SMTP vars not fully set, skipping alertmanager email receiver setup"
        return 0
    fi

    local smtp_port="${SMTP_PORT:-587}"
    local alert_to="${ALERT_EMAIL_TO:-${SMTP_ADMIN_EMAIL:-}}"
    if [[ -z "${alert_to}" ]]; then
        log_warn "ALERT_EMAIL_TO / SMTP_ADMIN_EMAIL missing, skipping alertmanager receiver setup"
        return 0
    fi

    if ! ssh_cmd "timeout 6 bash -lc '</dev/tcp/${SMTP_HOST}/${smtp_port}' >/dev/null 2>&1"; then
        log_warn "SMTP ${SMTP_HOST}:${smtp_port} unreachable from server, skipping alertmanager email receiver setup"
        return 0
    fi

    local tmp_file
    tmp_file="$(mktemp)"
    cat > "${tmp_file}" <<EOF
---
global:
  resolve_timeout: 5m
  smtp_smarthost: '${SMTP_HOST}:${smtp_port}'
  smtp_from: '${SMTP_ADMIN_EMAIL:-${alert_to}}'
  smtp_auth_username: '${SMTP_USER}'
  smtp_auth_password: '${SMTP_PASSWORD}'
  smtp_require_tls: true

route:
  receiver: 'email-default'
  group_by: ['alertname','ins','ip','category']
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 4h
  routes:
    - receiver: 'email-critical'
      matchers: [ level="0" ]
      group_wait: 15s
      repeat_interval: 1h

receivers:
  - name: 'email-default'
    email_configs:
      - to: '${alert_to}'
        send_resolved: true
  - name: 'email-critical'
    email_configs:
      - to: '${alert_to}'
        send_resolved: true

inhibit_rules:
  - source_matchers: [ alertname="NodeDown" ]
    target_matchers: [ category="node" ]
    equal: ['ip']
...
EOF

    scp_file "${tmp_file}" "/tmp/alertmanager.yml"
    rm -f "${tmp_file}"
    ssh_cmd "sudo install -o prometheus -g infra -m 0640 /tmp/alertmanager.yml /etc/alertmanager.yml && rm -f /tmp/alertmanager.yml"
    ssh_cmd "sudo systemctl restart alertmanager"
    log_success "Alertmanager email configured (SMTP connectivity OK)"
}
