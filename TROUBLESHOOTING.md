# Troubleshooting Guide

Problemas comunes y soluciones basadas en experiencia real de deployment.

---

## 🔴 Contenedores Supabase no inician

### Síntoma
```bash
docker compose ps
# Muestra solo 3 contenedores: analytics, imgproxy, vector
# Los demás están en estado "Created" o "Exited"
```

### Diagnóstico
```bash
cd /opt/supabase
docker compose logs analytics | tail -50
```

### Causa Común 1: Falta regla pg_hba.conf
**Error en logs**:
```
no pg_hba.conf entry for host "194.163.149.70", user "supabase_admin", database "postgres"
```

**Solución**:
```bash
# Verificar que pigsty.yml tenga las reglas
grep -A 3 "pg_hba_rules:" ~/pigsty/pigsty.yml

# Debe mostrar:
#   - { user: all, db: postgres, addr: intra, auth: pwd }
#   - { user: all, db: postgres, addr: 172.17.0.0/16, auth: pwd }

# Si faltan, regenerar configuración y reaplicar
cd ~/pigsty
./configure -c app/supa -i $(hostname -I | awk '{print $1}') -n
./install.yml -t pg_hba,pg_reload
```

### Causa Común 2: Usuario o contraseña incorrecta
**Error en logs**:
```
password authentication failed for user "supabase_storage_admin"
```

**Solución**:
```bash
# Verificar que todos los usuarios usen la misma contraseña
sudo -u postgres psql -c "ALTER USER supabase_admin WITH PASSWORD 'DBUser.Supa';"
sudo -u postgres psql -c "ALTER USER supabase_auth_admin WITH PASSWORD 'DBUser.Supa';"
sudo -u postgres psql -c "ALTER USER supabase_storage_admin WITH PASSWORD 'DBUser.Supa';"
sudo -u postgres psql -c "ALTER USER supabase_functions_admin WITH PASSWORD 'DBUser.Supa';"

# Reiniciar contenedores
cd /opt/supabase
docker compose restart
```

### Causa Común 3: Base de datos incorrecta
**Error en logs**:
```
database "supabase" does not exist
```

**Solución**:
```bash
# Verificar qué bases de datos existen
sudo -u postgres psql -l

# Debe mostrar "postgres" y "supabase"
# Si falta "supabase":
sudo -u postgres psql -c "CREATE DATABASE supabase OWNER supabase_admin;"
```

---

## 🔴 Docker no funciona correctamente

### Síntoma
```bash
docker: command not found
# O
Error response from daemon: Unavailable: connection error
```

### Solución
```bash
# Ejecutar el playbook oficial de Docker
cd ~/pigsty
./docker.yml

# Si ya está instalado pero no funciona:
sudo systemctl restart docker
sleep 5
docker ps
```

---

## 🔴 No puedo acceder a Supabase Studio

### Síntoma
```bash
curl http://<VPS_IP>:8000
# Timeout o Connection refused
```

### Diagnóstico
```bash
# 1. Verificar que Kong esté running
docker compose ps | grep kong

# 2. Verificar que el puerto esté abierto
sudo netstat -tlnp | grep 8000

# 3. Probar desde el VPS
curl http://localhost:8000
```

### Solución
```bash
# Si Kong no está running:
cd /opt/supabase
docker compose up -d kong

# Si el puerto no está abierto, verificar firewall
sudo ufw status
sudo ufw allow 8000/tcp
```

---

## 🔴 Contenedores en loop de reinicio

### Síntoma
```bash
docker compose ps
# Muestra "Restarting" constantemente
```

### Diagnóstico
```bash
# Ver logs del contenedor problemático
docker compose logs -f <nombre_contenedor>
```

### Causa Común: Health check falla
**Solución**:
```bash
# Verificar conectividad a PostgreSQL
docker compose exec analytics curl -v http://localhost:4000/health

# Si falla, verificar que el contenedor pueda resolver el host de PostgreSQL
docker compose exec analytics ping -c 3 194.163.149.70

# Si no puede pingear, problema de networking Docker
docker network ls
docker network inspect supabase_default
```

---

## 🔴 Cambios en .env no se aplican

### Síntoma
Editas `/opt/supabase/.env` pero los contenedores siguen usando valores antiguos.

### Causa
`app.yml` sobrescribe `.env` desde `pigsty.yml`

### Solución Correcta
```bash
# 1. Editar pigsty.yml en tu Mac
vim config/generated/pigsty.yml

# 2. Buscar la sección apps.supabase.conf
# 3. Actualizar valores
# 4. Subir y reaplicar
scp config/generated/pigsty.yml user@vps:~/pigsty/pigsty.yml
ssh user@vps "cd ~/pigsty && ./app.yml -t app_config,app_launch"
```

---

## 🔴 PostgreSQL no acepta conexiones

### Síntoma
```bash
psql: could not connect to server: Connection refused
```

### Diagnóstico
```bash
# Verificar que PostgreSQL esté corriendo
sudo systemctl status patroni
sudo systemctl status pgbouncer

# Verificar que escuche en el puerto correcto
sudo netstat -tlnp | grep 5432
sudo netstat -tlnp | grep 5436
```

### Solución
```bash
# Si Patroni no está corriendo:
sudo systemctl start patroni

# Si pgbouncer no está corriendo:
sudo systemctl start pgbouncer

# Verificar logs
sudo journalctl -u patroni -f
```

---

## 🔴 "Out of memory" al ejecutar install.yml

### Síntoma
```
TASK [...] ***
fatal: [...] Killed
```

### Causa
VPS con poca RAM (< 2GB)

### Solución
```bash
# Crear swap temporal
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Volver a ejecutar
./install.yml

# Desactivar swap después (opcional)
sudo swapoff /swapfile
sudo rm /swapfile
```

---

## 🛠️ Comandos Útiles de Diagnóstico

### Verificar estado completo
```bash
# PostgreSQL
sudo systemctl status patroni
sudo -u postgres psql -c "SELECT version();"

# Docker
docker --version
docker compose ps

# Supabase
cd /opt/supabase
docker compose ps --format json | jq -r '.[] | "\(.Name): \(.State) - \(.Health)"'
```

### Ver todos los logs
```bash
# Logs de PostgreSQL
sudo journalctl -u patroni -n 100

# Logs de Supabase
cd /opt/supabase
docker compose logs -f --tail=100

# Logs de contenedor específico
docker compose logs -f analytics
```

### Reinicio limpio
```bash
# Reiniciar solo Supabase (sin tocar PostgreSQL)
cd /opt/supabase
docker compose down
docker compose up -d

# Reinicio completo del sistema
sudo systemctl restart patroni pgbouncer haproxy
cd /opt/supabase
docker compose restart
```

---

## 📞 Obtener Ayuda

Si ninguna solución funciona:

1. **Ejecutar script de verificación**:
   ```bash
   ./scripts/deploy verify
   ```

2. **Recopilar información**:
   ```bash
   # En el VPS
   cd ~/pigsty
   cat pigsty.yml > debug-info.txt
   docker compose ps >> debug-info.txt
   docker compose logs --tail=200 >> debug-info.txt
   sudo cat /pg/data/pg_hba.conf >> debug-info.txt
   ```

3. **Consultar documentación oficial**:
   - Pigsty: https://pigsty.io/docs/
   - Supabase: https://supabase.com/docs/guides/self-hosting

4. **Issues conocidos**:
   - https://github.com/pgsty/pigsty/issues
   - https://github.com/supabase/supabase/issues
