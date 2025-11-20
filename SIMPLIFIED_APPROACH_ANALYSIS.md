# Análisis: Enfoque Simplificado usando Pigsty Oficial

## 🎯 Objetivo
Simplificar el deployment usando el flujo oficial de Pigsty para Supabase, reemplazando nuestra configuración personalizada por la configuración oficial de Pigsty.

## 📊 Comparación de Enfoques

### Enfoque Actual (main branch)
```bash
./scripts/deploy all
```

**Pasos internos:**
1. Preparar VPS (SSH, usuario, dependencias)
2. Descargar Pigsty
3. Generar pigsty.yml desde scratch con yaml-update.py
4. Bootstrap Ansible
5. Ejecutar install.yml
6. Ejecutar docker.yml
7. Ejecutar app.yml
8. **Post-deployment fixes** (06-post-supabase.sh):
   - Corregir POSTGRES_HOST
   - Agregar pg_hba.conf rules
   - Corregir docker-compose.yml
   - Actualizar passwords
9. Configurar SSL manualmente
10. Configurar Backblaze B2

**Problemas:**
- Configuración personalizada difícil de mantener
- Muchos fixes post-deployment
- yaml-update.py complejo
- Divergencia de la configuración oficial de Pigsty

### Enfoque Simplificado Propuesto
```bash
./scripts/deploy-simple all
```

**Pasos internos:**
1. Preparar VPS (SSH, usuario, dependencias)
2. Descargar Pigsty
3. **Descargar conf/supabase.yml oficial de Pigsty**
4. **Automatizar edición de supabase.yml** con valores de .env:
   - Domain names → desde SUPABASE_DOMAIN
   - Passwords → desde .env (generados)
   - JWT tokens → desde .env (generados)
   - IP addresses → desde VPS_HOST
   - Backblaze B2 → desde .env
   - Email → desde LETSENCRYPT_EMAIL
5. Copiar supabase.yml editado → ~/pigsty/pigsty.yml
6. Bootstrap Ansible
7. Ejecutar install.yml
8. Ejecutar docker.yml
9. Ejecutar app.yml
10. ✅ **Listo!** Sin fixes post-deployment

**Ventajas:**
- ✅ Usa configuración oficial probada
- ✅ Menos código personalizado
- ✅ Más fácil de mantener
- ✅ Se actualiza automáticamente con Pigsty
- ✅ Sin fixes post-deployment necesarios
- ✅ Mejor documentación (la oficial de Pigsty)

## 🔧 Automatización Requerida

### Parámetros a Sustituir en supabase.yml

Basado en https://github.com/pgsty/pigsty/blob/main/conf/supabase.yml:

#### 1. Network & Domain (8 sustituciones)
```yaml
# Desde .env
SITE_URL: "${SUPABASE_DOMAIN}"
API_EXTERNAL_URL: "${SUPABASE_DOMAIN}"
SUPABASE_PUBLIC_URL: "${SUPABASE_DOMAIN}"

infra_portal:
  supa:
    domain: "${SUPABASE_DOMAIN}"
    certbot: "${SUPABASE_DOMAIN}"

admin_ip: "${VPS_HOST}"
POSTGRES_HOST: "${VPS_HOST}"
MINIO_DOMAIN_IP: "${VPS_HOST}"
```

#### 2. Security Credentials (11 sustituciones)
```yaml
# JWT & Keys (desde .env - ya los generamos)
JWT_SECRET: "${JWT_SECRET}"
ANON_KEY: "${ANON_KEY}"
SERVICE_ROLE_KEY: "${SERVICE_ROLE_KEY}"

# PostgreSQL passwords (desde .env - ya los generamos)
POSTGRES_PASSWORD: "${POSTGRES_PASSWORD}"
pg_admin_password: "${PG_ADMIN_PASSWORD}"
pg_monitor_password: "${PG_MONITOR_PASSWORD}"
pg_replication_password: "${PG_REPLICATION_PASSWORD}"

# Dashboard (desde .env)
DASHBOARD_USERNAME: "${DASHBOARD_USERNAME}"
DASHBOARD_PASSWORD: "${DASHBOARD_PASSWORD}"

# Grafana/HAProxy (desde .env - ya los generamos)
grafana_admin_password: "${GRAFANA_ADMIN_PASSWORD}"
haproxy_admin_password: "${HAPROXY_ADMIN_PASSWORD}"
```

#### 3. Backblaze B2 Storage (5 sustituciones)
```yaml
# Reemplazar MinIO local con Backblaze B2
S3_BUCKET: "${S3_BUCKET}"
S3_ENDPOINT: "${S3_ENDPOINT}"
S3_ACCESS_KEY: "${S3_ACCESS_KEY}"
S3_SECRET_KEY: "${S3_SECRET_KEY}"
S3_REGION: "${S3_REGION}"

# También actualizar pgBackRest para usar B2
pgbackrest:
  repo1-type: s3
  repo1-s3-endpoint: "${S3_ENDPOINT}"
  repo1-s3-bucket: "${S3_BUCKET}"
  repo1-s3-key: "${S3_ACCESS_KEY}"
  repo1-s3-key-secret: "${S3_SECRET_KEY}"
```

#### 4. SSL Configuration (1 sustitución)
```yaml
certbot_email: "${LETSENCRYPT_EMAIL}"
```

#### 5. Otros tokens (2 sustituciones)
```yaml
LOGFLARE_PUBLIC_ACCESS_TOKEN: "${LOGFLARE_PUBLIC_ACCESS_TOKEN}"
LOGFLARE_PRIVATE_ACCESS_TOKEN: "${LOGFLARE_PRIVATE_ACCESS_TOKEN}"
```

**Total: ~27 sustituciones automatizables**

## 🚀 Implementación

### Script Simple de Sustitución

```python
#!/usr/bin/env python3
import os
import sys
import yaml
from pathlib import Path

def load_env():
    """Load .env file"""
    env = {}
    with open('.env') as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith('#') and '=' in line:
                key, value = line.split('=', 1)
                env[key.strip()] = value.strip()
    return env

def substitute_values(config, env):
    """Recursively substitute ${VAR} with values from env"""
    if isinstance(config, dict):
        return {k: substitute_values(v, env) for k, v in config.items()}
    elif isinstance(config, list):
        return [substitute_values(item, env) for item in config]
    elif isinstance(config, str):
        # Simple substitution ${VAR} -> value
        for key, value in env.items():
            config = config.replace(f"${{{key}}}", value)
            # Also replace direct references
            if config == key:
                return value
        return config
    return config

# Load official supabase.yml
with open('supabase.yml') as f:
    config = yaml.safe_load(f)

# Load .env
env = load_env()

# Substitute values
config = substitute_values(config, env)

# Write to pigsty.yml
with open('pigsty.yml', 'w') as f:
    yaml.dump(config, f, default_flow_style=False, sort_keys=False)

print("✅ pigsty.yml generated from official supabase.yml")
```

### Ventajas de este Script
- ✅ **Simple**: ~30 líneas de Python
- ✅ **Mantenible**: No necesita actualizarse cuando Pigsty actualiza supabase.yml
- ✅ **Genérico**: Funciona con cualquier estructura YAML
- ✅ **Sin hardcoding**: No tiene rutas hardcodeadas a campos específicos

## 📝 Flujo Propuesto

```bash
#!/bin/bash
# scripts/deploy-simple

case "$1" in
  all)
    # 1. Prepare VPS
    ./scripts/modules/01-prepare-vps.sh
    
    # 2. Download Pigsty
    ssh deploy@$VPS_HOST "curl -fsSL https://repo.pigsty.io/get | bash"
    
    # 3. Download official supabase.yml
    curl -fsSL https://raw.githubusercontent.com/pgsty/pigsty/main/conf/supabase.yml \
      -o /tmp/supabase.yml
    
    # 4. Generate pigsty.yml with substitutions
    python3 lib/simple-yaml-gen.py /tmp/supabase.yml > /tmp/pigsty.yml
    
    # 5. Upload to VPS
    scp /tmp/pigsty.yml deploy@$VPS_HOST:~/pigsty/pigsty.yml
    
    # 6. Bootstrap & Install
    ssh deploy@$VPS_HOST "cd ~/pigsty && ./bootstrap"
    ssh deploy@$VPS_HOST "cd ~/pigsty && ./install.yml"
    ssh deploy@$VPS_HOST "cd ~/pigsty && ./docker.yml"
    ssh deploy@$VPS_HOST "cd ~/pigsty && ./app.yml"
    
    echo "✅ Deployment complete!"
    echo "🌐 Access at: https://${SUPABASE_DOMAIN}"
    ;;
esac
```

## 🔍 Diferencias Clave

### Lo que ELIMINAMOS:
- ❌ `lib/yaml-update.py` (500+ líneas complejas)
- ❌ `scripts/modules/02-pigsty-config.sh` (configuración personalizada)
- ❌ `scripts/modules/06-post-supabase.sh` (fixes post-deployment)
- ❌ Lógica compleja de merge de configuraciones

### Lo que AGREGAMOS:
- ✅ `lib/simple-yaml-gen.py` (~30 líneas simples)
- ✅ Uso de configuración oficial de Pigsty
- ✅ Sustitución simple de variables

## 🎯 Resultados Esperados

### Métricas de Simplificación
- **Código eliminado**: ~800 líneas
- **Código agregado**: ~100 líneas
- **Reducción neta**: ~700 líneas (87.5% menos código)
- **Complejidad**: Mucho menor (usa estándar de Pigsty)
- **Mantenibilidad**: Mucho mejor (se actualiza con Pigsty)

### Funcionalidad
- ✅ PostgreSQL 17 con Patroni
- ✅ Supabase con todos los servicios
- ✅ SSL/HTTPS automático
- ✅ Backblaze B2 storage
- ✅ Backup configurado
- ✅ Monitoring (Grafana)

## 🤔 Consideraciones

### Posibles Problemas
1. **Valores hardcodeados en supabase.yml oficial**
   - Solución: El script de sustitución los reemplaza todos

2. **Estructura YAML puede cambiar**
   - Solución: El script es genérico, funciona con cualquier estructura

3. **Necesitamos configuraciones adicionales**
   - Solución: Podemos hacer un merge post-sustitución si es necesario

### Validación Necesaria
- [ ] Probar con supabase.yml oficial actual
- [ ] Verificar que todas las sustituciones funcionen
- [ ] Confirmar que no se necesitan fixes post-deployment
- [ ] Validar con instalación limpia

## 💡 Recomendación

**PROCEDER CON ENFOQUE SIMPLIFICADO**

**Razones:**
1. ✅ Menos código = menos bugs
2. ✅ Configuración oficial = mejor soporte
3. ✅ Se actualiza automáticamente con Pigsty
4. ✅ Más fácil de entender y mantener
5. ✅ Sin divergencia del estándar de Pigsty

**Plan de Acción:**
1. Crear `lib/simple-yaml-gen.py`
2. Probar sustituciones localmente
3. Crear `scripts/deploy-simple`
4. Probar en VPS limpio
5. Si funciona → mergear a main y deprecar enfoque actual
6. Si no funciona → volver a main (sin pérdida)
