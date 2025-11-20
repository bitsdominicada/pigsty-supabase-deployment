# Configuración de Dominios - Pigsty + Supabase

## 🎯 Tipos de Dominios

Pigsty utiliza **dos tipos** de dominios:

### 1. 🔒 Dominios Internos (NO modificar)

Estos dominios son **internos** al VPS y **NO necesitan DNS público**:

```
h.pigsty         → Home dashboard
g.pigsty         → Grafana
p.pigsty         → Prometheus  
a.pigsty         → AlertManager
m.pigsty         → MinIO Web UI
sss.pigsty       → MinIO S3 API
adm.pigsty       → pgAdmin
ddl.pigsty       → Bytebase
```

**¿Por qué no cambiarlos?**
- ✅ Solo funcionan dentro del VPS
- ✅ Resueltos por `/etc/hosts` localmente
- ✅ No requieren certificados SSL
- ✅ No expuestos a Internet
- ⚠️ Cambiarlos puede romper la integración entre servicios

### 2. 🌍 Dominio Público (SÍ modificar)

Este es **TU dominio público** que apunta a tu VPS:

```
supa.pigsty      → ❌ Dominio por defecto (cambiar)
supa.bits.do     → ✅ Tu dominio real
```

**Este dominio:**
- ✅ Debe tener registro DNS → VPS IP
- ✅ Necesita SSL/TLS (Let's Encrypt)
- ✅ Es accesible desde Internet
- ✅ Es el que usan tus usuarios

## 🚀 Configuración Recomendada

### Opción 1: Subdominios de bits.do (Recomendado)

```bash
# En tu DNS provider (Cloudflare, etc.)
A    supa.bits.do     → 194.163.149.70
A    grafana.bits.do  → 194.163.149.70  (opcional - monitoreo)
```

```bash
# En .env
SUPABASE_DOMAIN=supa.bits.do
USE_LETSENCRYPT=true
LETSENCRYPT_EMAIL=tu@email.com
```

### Opción 2: Dominio Raíz

```bash
# En tu DNS
A    bits.do          → 194.163.149.70
```

```bash
# En .env
SUPABASE_DOMAIN=bits.do
USE_LETSENCRYPT=true
LETSENCRYPT_EMAIL=tu@email.com
```

### Opción 3: Solo IP (Sin SSL)

```bash
# En .env
SUPABASE_DOMAIN=194.163.149.70
USE_LETSENCRYPT=false
```

## 📝 Cómo Cambiar el Dominio

### Método 1: Durante Deployment Inicial

```bash
# 1. Configurar DNS primero
# A record: supa.bits.do → 194.163.149.70

# 2. Configurar .env
cat >> .env << 'EOF'
SUPABASE_DOMAIN=supa.bits.do
USE_LETSENCRYPT=true
LETSENCRYPT_EMAIL=admin@bits.do
EOF

# 3. Deploy completo
./scripts/deploy all

# ✅ Supabase estará en https://supa.bits.do
```

### Método 2: Cambiar Dominio en Deployment Existente

```bash
# 1. Actualizar .env local
nano .env
# Cambiar:
# SUPABASE_DOMAIN=supa.bits.do
# USE_LETSENCRYPT=true

# 2. Sincronizar configuración
./scripts/deploy config:sync

# 3. Aplicar cambios
./scripts/deploy apply:app

# 4. Configurar SSL
./scripts/deploy ssl:setup
```

## 🔧 Configuración Avanzada

### Múltiples Subdominios

Si quieres exponer otros servicios (Grafana, MinIO UI):

```bash
# DNS
A    supa.bits.do     → 194.163.149.70
A    grafana.bits.do  → 194.163.149.70
A    minio.bits.do    → 194.163.149.70
```

Luego edita `config/templates/base.yml`:

```yaml
infra_portal:
  grafana:
    domain: grafana.bits.do
    endpoint: "${admin_ip}:3000"
  minio:
    domain: minio.bits.do
    endpoint: "${admin_ip}:9001"
    scheme: https
  supabase:
    domain: supa.bits.do
    endpoint: "${admin_ip}:8000"
    certbot: supa.bits.do  # SSL para Supabase
```

Y aplica:
```bash
./scripts/deploy config:sync
./scripts/deploy apply:infra
```

## 🌐 Estructura Completa con bits.do

### Arquitectura Recomendada

```
┌─────────────────────────────────────────────────────┐
│ Internet (Usuarios)                                 │
└─────────────────┬───────────────────────────────────┘
                  │
                  │ HTTPS (Let's Encrypt)
                  ▼
┌─────────────────────────────────────────────────────┐
│ supa.bits.do → Nginx → Supabase Studio + APIs      │
│ (Puerto 443/80)                                     │
└─────────────────────────────────────────────────────┘
                  │
                  │ Proxy interno
                  ▼
┌─────────────────────────────────────────────────────┐
│ VPS (194.163.149.70)                                │
├─────────────────────────────────────────────────────┤
│ Dominios Internos (solo /etc/hosts):               │
│                                                     │
│  g.pigsty    → Grafana (3000)                       │
│  p.pigsty    → Prometheus (9090)                    │
│  sss.pigsty  → MinIO S3 API (9000)                  │
│  h.pigsty    → Home Dashboard                       │
│                                                     │
│ Servicios:                                          │
│  • PostgreSQL 17 (5432)                             │
│  • Supabase (8000 → proxy → 443)                    │
│  • MinIO (9000 interno)                             │
│  • Grafana (3000 interno)                           │
└─────────────────────────────────────────────────────┘
```

### Ventajas de Esta Arquitectura

✅ **Un solo dominio público:** `supa.bits.do`  
✅ **Dominios internos protegidos:** No accesibles desde Internet  
✅ **SSL automático:** Let's Encrypt para el dominio público  
✅ **Monitoreo interno:** Grafana accesible solo por SSH tunnel  

## 🔐 Acceso a Servicios Internos

### Opción 1: SSH Tunnel (Recomendado)

```bash
# Acceder a Grafana localmente
ssh -L 3000:localhost:3000 deploy@194.163.149.70

# Ahora abre: http://localhost:3000
# Grafana disponible en tu navegador local
```

### Opción 2: VPN

```bash
# Instalar WireGuard en el VPS
# Acceder a todos los servicios .pigsty a través de VPN
```

### Opción 3: Exponer con SSL (No recomendado)

Solo si realmente necesitas exponer Grafana públicamente:

```bash
# DNS
A    grafana.bits.do  → 194.163.149.70

# Configurar SSL
./scripts/deploy ssl:setup grafana.bits.do
```

## 🛠️ Variables de Entorno

### Configuración Mínima (Solo Supabase)

```bash
# .env
VPS_HOST=194.163.149.70
SUPABASE_DOMAIN=supa.bits.do
USE_LETSENCRYPT=true
LETSENCRYPT_EMAIL=admin@bits.do
```

### Configuración Completa

```bash
# .env
VPS_HOST=194.163.149.70

# Dominio público de Supabase
SUPABASE_DOMAIN=supa.bits.do
USE_LETSENCRYPT=true
LETSENCRYPT_EMAIL=admin@bits.do

# URLs de la API (generadas automáticamente)
# SUPABASE_API_EXTERNAL_URL=https://supa.bits.do
# SITE_URL=https://supa.bits.do
```

## ❓ FAQ

### ¿Puedo usar solo un dominio raíz?

**Sí:**
```bash
SUPABASE_DOMAIN=bits.do
```

Supabase estará en `https://bits.do`

### ¿Necesito DNS para los dominios .pigsty?

**No.** Los dominios `.pigsty` son internos y se resuelven en `/etc/hosts` del VPS.

### ¿Puedo cambiar sss.pigsty a sss.bits.do?

**No recomendado.** `sss.pigsty` es interno y usado solo por pgBackRest y servicios internos. Cambiarlos requiere:
- Modificar `/etc/hosts` en el VPS
- Regenerar certificados SSL internos
- Actualizar múltiples configuraciones

**Mejor:** Mantén los dominios internos como `.pigsty` y solo expón `supa.bits.do` públicamente.

### ¿Cómo verifico que mi dominio funciona?

```bash
# 1. Verificar DNS
dig supa.bits.do +short
# Debe mostrar: 194.163.149.70

# 2. Verificar SSL
curl -I https://supa.bits.do
# Debe responder con 200 OK

# 3. Acceder desde navegador
https://supa.bits.do
```

### ¿Qué pasa si no tengo dominio?

Usa la IP directamente (sin SSL):
```bash
SUPABASE_DOMAIN=194.163.149.70
USE_LETSENCRYPT=false
```

Acceso: `http://194.163.149.70:8000`

## 📋 Checklist de Configuración

- [ ] Registrar dominio (bits.do)
- [ ] Crear registro A: `supa.bits.do → VPS_IP`
- [ ] Esperar propagación DNS (5-30 minutos)
- [ ] Configurar `.env` con `SUPABASE_DOMAIN`
- [ ] Habilitar `USE_LETSENCRYPT=true`
- [ ] Agregar email válido `LETSENCRYPT_EMAIL`
- [ ] Ejecutar `./scripts/deploy all` o `./scripts/deploy ssl:setup`
- [ ] Verificar SSL: `https://supa.bits.do`
- [ ] Configurar OAuth redirects con tu dominio
- [ ] Actualizar CORS si es necesario

## 🎯 Resumen

| Tipo | Ejemplo | ¿Cambiar? | DNS Público | SSL |
|------|---------|-----------|-------------|-----|
| **Interno** | `sss.pigsty` | ❌ NO | ❌ NO | ❌ NO |
| **Interno** | `g.pigsty` | ❌ NO | ❌ NO | ❌ NO |
| **Público** | `supa.pigsty` | ✅ SÍ | ✅ SÍ | ✅ SÍ |
| **Tu dominio** | `supa.bits.do` | ✅ USAR | ✅ SÍ | ✅ SÍ |

---

## 🔗 Enlaces Útiles

- [Configurar DNS en Cloudflare](https://developers.cloudflare.com/dns/manage-dns-records/how-to/create-dns-records/)
- [Let's Encrypt Docs](https://letsencrypt.org/docs/)
- [Pigsty Portal Config](https://pigsty.io/docs/reference/config/#infra_portal)
