# 🚀 Quick Start - Instalación en 3 Pasos

Guía ultra-simplificada para deployment desde cero.

---

## Prerequisitos

✅ Mac con SSH  
✅ VPS con Ubuntu 22.04/24.04 (4GB+ RAM, 2+ CPU)  
✅ Acceso root al VPS  
✅ (Opcional) Dominio apuntando al VPS para HTTPS  

---

## Paso 1: Generar Configuración (Interactivo)

```bash
./scripts/generate-secrets
```

**El script te preguntará:**
1. ✅ IP del VPS
2. ✅ Contraseña root del VPS
3. ❓ ¿Quieres HTTPS? (opcional)
   - Tu dominio (ej: bitsflaredb.bits.do)
   - Email para Let's Encrypt
4. ❓ ¿Configurar SMTP? (opcional)

**Resultado:**
- Genera `.env` con todas las contraseñas seguras
- Crea JWT tokens automáticamente
- ¡No necesitas editar nada manualmente!

---

## Paso 2: Desplegar Todo

```bash
./scripts/deploy all
```

**Duración:** 15-25 minutos

**Qué hace:**
- ✅ Configura VPS (usuario deploy, SSH keys, firewall)
- ✅ Instala Pigsty (PostgreSQL 17 + HA)
- ✅ Instala Supabase (Docker Compose)
- ✅ Configura monitoring (Grafana + Prometheus)
- ✅ Verifica que todo funcione

---

## Paso 3: Configurar SSL (Si elegiste HTTPS)

**Espera a que el Paso 2 termine completamente**, luego:

```bash
./scripts/deploy ssl:setup
```

**Qué hace:**
- ✅ Verifica DNS
- ✅ Solicita certificado Let's Encrypt
- ✅ Configura nginx automáticamente
- ✅ Actualiza Supabase a HTTPS
- ✅ Configura auto-renovación

---

## 🎉 ¡Listo!

### Accede a tus servicios:

| Servicio | URL | Usuario | Contraseña |
|----------|-----|---------|------------|
| **Supabase Studio** | `http://IP:8000` o `https://tu-dominio` | - | - |
| **Grafana** | `http://IP` | `admin` | Ver `.env` |
| **PostgreSQL** | `IP:5436` | `supabase_admin` | Ver `.env` |

---

## 📋 Comandos Útiles

```bash
# Ver estado de servicios
./scripts/deploy verify

# Ver logs
./scripts/deploy logs

# Verificar certificado SSL
./scripts/deploy ssl:status

# Backup manual
ssh deploy@IP
sudo -u postgres /pg/bin/pg-backup full
```

---

## 🔧 Troubleshooting

### Error de conexión SSH
```bash
# Verifica conectividad
ping TU_VPS_IP

# Prueba SSH manualmente
ssh root@TU_VPS_IP
```

### SSL no funciona
```bash
# Verifica DNS
host tu-dominio.com

# Debe mostrar tu IP del VPS
# Si no, espera propagación DNS (5-30 min)
```

### Ver logs de instalación
```bash
./scripts/deploy all 2>&1 | tee install.log
```

---

## 🆘 Necesitas Ayuda?

1. **Ver documentación completa:** `README.md`
2. **Ver configuración avanzada:** `config/README.md`
3. **Reportar problemas:** https://github.com/tu-repo/issues

---

## 🔄 Reinstalación Limpia

Si necesitas empezar de cero:

```bash
# 1. Reiniciar VPS (en tu proveedor: Hetzner, DigitalOcean, etc.)

# 2. Regenerar configuración
./scripts/generate-secrets

# 3. Desplegar nuevamente
./scripts/deploy all
```

---

**Tiempo total:** ~20-30 minutos  
**Complejidad:** ⭐️ (1/5 - Muy fácil)  
**Edición manual de archivos:** ❌ Ninguna  
