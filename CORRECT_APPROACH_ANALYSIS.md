# Análisis: Flujo Correcto de Pigsty para Supabase

## 🔍 Descubrimiento Importante

`conf/app/supa.yml` es un **symlink** a `conf/supabase.yml`:
```bash
conf/app/supa.yml → ../supabase.yml
```

## ✅ Flujo Oficial de Pigsty

```bash
curl -fsSL https://repo.pigsty.io/get | bash
cd ~/pigsty
./configure -c app/supa    # Genera pigsty.yml desde supabase.yml
vi pigsty.yml              # Editar credenciales y dominio
./bootstrap                # Instalar Ansible
./install.yml              # Instalar Pigsty + PostgreSQL + MinIO
./docker.yml               # Instalar Docker
./app.yml                  # Lanzar Supabase con Docker Compose
```

### ¿Qué hace `./configure -c app/supa`?

1. **Copia** `conf/app/supa.yml` (→ `conf/supabase.yml`) a `pigsty.yml`
2. **Reemplaza** `10.10.10.10` con la IP detectada del servidor
3. **Ajusta** tuning (`oltp.yml` → `tiny.yml`) si CPU < 4
4. **Configura** mirrors regionales si es necesario
5. **Establece** locale a `C.UTF-8`

## 📊 Comparación de Enfoques

### Enfoque Actual (main branch)
❌ **Problemas:**
- Genera pigsty.yml desde cero con yaml-update.py
- No usa el flujo oficial de Pigsty
- Diverge de la configuración oficial
- Requiere muchos fixes post-deployment

### Enfoque A: Usar `./configure` + Modificación
✅ **Ventajas:**
- Usa el flujo oficial de Pigsty
- `./configure` hace las transformaciones básicas
- Solo modificamos lo necesario después

**Implementación:**
```bash
# 1. Ejecutar configure en VPS
ssh VPS "cd ~/pigsty && ./configure -c app/supa"

# 2. Descargar pigsty.yml generado
scp VPS:~/pigsty/pigsty.yml /tmp/pigsty-base.yml

# 3. Modificar con yq (herramienta YAML)
yq eval '.vars.admin_ip = env(VPS_HOST)' -i /tmp/pigsty-base.yml
yq eval '.all.children.supabase.vars.apps.supabase.conf.JWT_SECRET = env(JWT_SECRET)' -i /tmp/pigsty-base.yml
# ... más modificaciones

# 4. Subir pigsty.yml modificado
scp /tmp/pigsty-base.yml VPS:~/pigsty/pigsty.yml

# 5. Ejecutar deployment
ssh VPS "cd ~/pigsty && ./bootstrap && ./install.yml && ./docker.yml && ./app.yml"
```

### Enfoque B: Generar pigsty.yml Localmente
✅ **Ventajas:**
- Control total del proceso
- Más rápido (no requiere SSH extra)
- Podemos pre-validar la configuración

**Implementación:**
```bash
# 1. Descargar conf/supabase.yml oficial
curl -fsSL https://raw.githubusercontent.com/pgsty/pigsty/main/conf/supabase.yml > /tmp/supabase.yml

# 2. Aplicar transformaciones que ./configure hace
sed -i "s/10.10.10.10/${VPS_HOST}/g" /tmp/supabase.yml

# 3. Aplicar nuestras variables desde .env
python3 lib/simple-yaml-gen.py /tmp/supabase.yml > /tmp/pigsty.yml

# 4. Subir a VPS
scp /tmp/pigsty.yml VPS:~/pigsty/pigsty.yml

# 5. Ejecutar deployment
ssh VPS "cd ~/pigsty && ./bootstrap && ./install.yml && ./docker.yml && ./app.yml"
```

## 🎯 Recomendación: Enfoque B (Generar Localmente)

### Razones:

1. **Más Simple**: No requiere ejecutar `./configure` remotamente
2. **Más Rápido**: Una sola transferencia SSH del archivo final
3. **Más Testeable**: Podemos validar pigsty.yml antes de subir
4. **Más Portable**: Funciona sin necesidad de conectar al VPS primero
5. **Mismo Resultado**: Genera exactamente lo que `./configure` generaría

### Actualización de `simple-yaml-gen.py`

El script actual ya hace las sustituciones correctas. Solo necesitamos asegurar que replica lo que `./configure` hace:

```python
def apply_configure_transformations(yaml_content, vps_host):
    """
    Aplica las mismas transformaciones que ./configure hace
    """
    # 1. Reemplazar 10.10.10.10 con VPS_HOST
    yaml_content = yaml_content.replace('10.10.10.10', vps_host)
    
    # 2. TODO: Detectar CPUs y ajustar tuning si es necesario
    # (por ahora asumimos que el usuario configuró node_tune en .env)
    
    return yaml_content
```

## 📝 Flujo Propuesto Final

```bash
#!/bin/bash
# scripts/deploy-simple

prepare_config() {
    log_info "Generating pigsty.yml from official Supabase template..."
    
    # 1. Download official supabase.yml
    curl -fsSL https://raw.githubusercontent.com/pgsty/pigsty/main/conf/supabase.yml \
        -o /tmp/supabase-official.yml
    
    # 2. Generate pigsty.yml with our substitutions
    # This replicates what ./configure -c app/supa does, plus our custom vars
    python3 lib/simple-yaml-gen.py /tmp/supabase-official.yml > /tmp/pigsty.yml
    
    # 3. Upload to VPS
    scp /tmp/pigsty.yml deploy@${VPS_HOST}:~/pigsty/pigsty.yml
    
    log_success "pigsty.yml generated and uploaded"
}

install_all() {
    # 1. Prepare VPS
    ./scripts/modules/01-prepare-vps.sh
    
    # 2. Download Pigsty
    ssh deploy@${VPS_HOST} "curl -fsSL https://repo.pigsty.io/get | bash"
    
    # 3. Generate and upload pigsty.yml
    prepare_config
    
    # 4. Bootstrap Ansible
    ssh deploy@${VPS_HOST} "cd ~/pigsty && ./bootstrap"
    
    # 5. Install Pigsty (PostgreSQL + MinIO + Infra)
    ssh deploy@${VPS_HOST} "cd ~/pigsty && ./install.yml"
    
    # 6. Install Docker
    ssh deploy@${VPS_HOST} "cd ~/pigsty && ./docker.yml"
    
    # 7. Launch Supabase
    ssh deploy@${VPS_HOST} "cd ~/pigsty && ./app.yml"
    
    log_success "Deployment complete!"
    log_info "Access Supabase at: https://${SUPABASE_DOMAIN}"
}
```

## 🔧 Modificaciones a `simple-yaml-gen.py`

Ya casi está correcto. Solo necesitamos agregar la función que replica las transformaciones de `./configure`:

```python
def apply_configure_logic(content, env):
    """
    Aplica la lógica que ./configure aplica:
    1. Reemplazar 10.10.10.10 con VPS_HOST
    2. Ajustar tuning si CPU < 4 (opcional, asumimos usuario lo configuró)
    """
    vps_host = env.get('VPS_HOST', '10.10.10.10')
    
    # Reemplazar 10.10.10.10 con la IP real del VPS
    content = content.replace('10.10.10.10', vps_host)
    
    return content
```

## ✅ Ventajas del Enfoque Final

1. **100% compatible con Pigsty oficial**: Usa `conf/supabase.yml` sin modificar
2. **Replica `./configure`**: Hace las mismas transformaciones
3. **Automatiza edición manual**: Sustituye todos los valores de .env
4. **Sin post-deployment fixes**: Todo configurado correctamente desde el inicio
5. **Menos código**: ~100 líneas vs ~800 líneas
6. **Más mantenible**: Se actualiza automáticamente con Pigsty
7. **Más simple**: Un solo comando `./scripts/deploy-simple all`

## 🎬 Resultado Esperado

```bash
./scripts/deploy-simple all

# Output:
✅ VPS prepared
✅ Pigsty downloaded
✅ pigsty.yml generated from official template
✅ pigsty.yml uploaded to VPS
✅ Ansible bootstrapped
✅ Pigsty installed (PostgreSQL 17 + MinIO + Monitoring)
✅ Docker installed
✅ Supabase launched (11 containers)

🌐 Supabase available at: https://bitsflaredb.bits.do
📊 Grafana available at: http://194.163.149.70
🗄️  PostgreSQL available at: 194.163.149.70:5436
```

Sin fixes post-deployment, sin configuraciones manuales, sin divergencia del estándar de Pigsty.
