# 🚀 Production Deployment Guide

> Enterprise-Grade Deployment for MASTAN Clinic Factory

---

## 📋 Pre-Deployment Checklist

### Environment Preparation

```bash
# 1. Update system
sudo apt update && sudo apt upgrade -y

# 2. Install dependencies
sudo apt install -y curl wget git vim htop

# 3. Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# 4. Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# 5. Add user to docker group
sudo usermod -aG docker $USER
newgrp docker

# 6. Verify installation
docker --version
docker-compose --version
```

### Server Hardening

```bash
# 1. Configure firewall
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable

# 2. Configure SSH
sudo sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo systemctl restart sshd

# 3. Enable fail2ban
sudo apt install -y fail2ban
sudo systemctl enable fail2ban
sudo systemctl start fail2ban

# 4. Set up automatic security updates
sudo apt install -y unattended-upgrades
sudo systemctl enable unattended-upgrades
```

---

## 🔐 SSL/TLS Configuration

### Setup Let's Encrypt

```bash
# 1. Install Certbot
sudo apt install -y certbot python3-certbot-nginx

# 2. Generate certificate
sudo certbot certonly --standalone -d clinic.example.com -d www.clinic.example.com

# 3. Auto-renewal
sudo systemctl enable certbot.timer
```

### Nginx Configuration

```nginx
# /etc/nginx/sites-available/clinic-production

upstream backend {
    least_conn;
    server backend-1:3000 weight=1 max_fails=3 fail_timeout=30s;
    server backend-2:3000 weight=1 max_fails=3 fail_timeout=30s;
    server backend-3:3000 weight=1 max_fails=3 fail_timeout=30s;
}

server {
    listen 80;
    server_name clinic.example.com www.clinic.example.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name clinic.example.com www.clinic.example.com;

    # SSL Certificates
    ssl_certificate /etc/letsencrypt/live/clinic.example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/clinic.example.com/privkey.pem;

    # SSL Configuration
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;

    # Security Headers
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;

    # Gzip Compression
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
    gzip_comp_level 6;
    gzip_vary on;

    # Proxy Settings
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_read_timeout 90;

    # API Endpoints
    location /api/ {
        proxy_pass http://backend;
        proxy_buffering off;
    }

    # Frontend
    location / {
        proxy_pass http://frontend:5173;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }

    # Health Check
    location /health {
        access_log off;
        proxy_pass http://backend/api/health;
    }
}
```

---

## 🐳 Docker Production Configuration

### docker-compose.prod.yml

```yaml
version: '3.9'

services:
  nginx:
    image: nginx:alpine
    container_name: clinlc-nginx
    restart: always
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
      - ./ssl:/etc/nginx/ssl:ro
      - ./logs/nginx:/var/log/nginx
    depends_on:
      - backend
      - frontend
    networks:
      - clinlc-network

  postgres:
    image: postgres:15-alpine
    container_name: clinlc-postgres
    restart: always
    environment:
      POSTGRES_USER: ${DB_USER}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
      POSTGRES_DB: ${DB_NAME}
      PGDATA: /var/lib/postgresql/data/pgdata
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./database/init.sql:/docker-entrypoint-initdb.d/init.sql
    networks:
      - clinlc-network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${DB_USER}"]
      interval: 10s
      timeout: 5s
      retries: 5
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"

  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile.prod
    container_name: clinlc-backend
    restart: always
    environment:
      NODE_ENV: production
      PORT: 3000
      DB_HOST: postgres
      DB_USER: ${DB_USER}
      DB_PASSWORD: ${DB_PASSWORD}
      DB_NAME: ${DB_NAME}
      REDIS_URL: redis://redis:6379/0
      JWT_SECRET: ${JWT_SECRET}
      LOG_LEVEL: info
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
    networks:
      - clinlc-network
    deploy:
      replicas: 3
      resources:
        limits:
          cpus: '1'
          memory: 512M
        reservations:
          cpus: '0.5'
          memory: 256M
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"

  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile.prod
    container_name: clinlc-frontend
    restart: always
    environment:
      VITE_API_URL: https://api.clinic.example.com
    networks:
      - clinlc-network
    deploy:
      replicas: 2
      resources:
        limits:
          cpus: '0.5'
          memory: 256M
        reservations:
          cpus: '0.25'
          memory: 128M

  redis:
    image: redis:7-alpine
    container_name: clinlc-redis
    restart: always
    command: redis-server --appendonly yes --requirepass ${REDIS_PASSWORD}
    volumes:
      - redis_data:/data
    networks:
      - clinlc-network
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5

  prometheus:
    image: prom/prometheus:latest
    container_name: clinlc-prometheus
    restart: always
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml:ro
      - prometheus_data:/prometheus
    networks:
      - clinlc-network
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'

  grafana:
    image: grafana/grafana:latest
    container_name: clinlc-grafana
    restart: always
    environment:
      GF_SECURITY_ADMIN_PASSWORD: ${GRAFANA_PASSWORD}
      GF_SERVER_ROOT_URL: https://grafana.clinic.example.com
    volumes:
      - grafana_data:/var/lib/grafana
    networks:
      - clinlc-network
    depends_on:
      - prometheus

volumes:
  postgres_data:
  redis_data:
  prometheus_data:
  grafana_data:

networks:
  clinlc-network:
    driver: bridge
```

---

## 📊 Monitoring & Alerting

### Prometheus Configuration

```yaml
# prometheus.yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s
  external_labels:
    cluster: 'production'
    environment: 'prod'

scrape_configs:
  - job_name: 'backend'
    static_configs:
      - targets: ['backend:3000']
    metrics_path: '/metrics'
    scrape_interval: 5s

  - job_name: 'postgres'
    static_configs:
      - targets: ['postgres:5432']

  - job_name: 'redis'
    static_configs:
      - targets: ['redis:6379']

alert_rules:
  - alert: HighErrorRate
    expr: rate(http_request_total{status=~"5.."}[5m]) > 0.05
    for: 5m
    annotations:
      summary: "High error rate detected"
```

---

## 🔄 Database Replication

### PostgreSQL Master-Replica Setup

```bash
# On Master
sudo -u postgres psql << EOF
ALTER SYSTEM SET wal_level = replica;
ALTER SYSTEM SET max_wal_senders = 3;
ALTER SYSTEM SET max_replication_slots = 3;
CREATE USER replicator WITH REPLICATION ENCRYPTED PASSWORD 'replicator_password';
EOF

sudo systemctl restart postgresql

# On Replica
pg_basebackup -h master-ip -D /var/lib/postgresql/15/main -U replicator -v -P -W
```

---

## 📈 Auto-Scaling

### Kubernetes Deployment (Optional)

```yaml
# clinlc-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: clinlc-backend
spec:
  replicas: 3
  selector:
    matchLabels:
      app: clinlc-backend
  template:
    metadata:
      labels:
        app: clinlc-backend
    spec:
      containers:
      - name: backend
        image: registry.example.com/clinlc-backend:latest
        ports:
        - containerPort: 3000
        env:
        - name: NODE_ENV
          value: production
        resources:
          requests:
            memory: "256Mi"
            cpu: "500m"
          limits:
            memory: "512Mi"
            cpu: "1000m"
        livenessProbe:
          httpGet:
            path: /api/health
            port: 3000
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /api/health
            port: 3000
          initialDelaySeconds: 5
          periodSeconds: 5
---
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: clinlc-backend-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: clinlc-backend
  minReplicas: 3
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
```

---

## 🆘 Incident Response

### Runbook for Common Issues

```markdown
## Issue: Database Connection Failed

**Symptoms**: API returning 500 errors, logs show "connect ECONNREFUSED"

**Step 1**: Check database status
```bash
docker-compose ps postgres
docker-compose logs postgres
```

**Step 2**: Verify connectivity
```bash
docker-compose exec postgres pg_isready -U clinlc_user
```

**Step 3**: Restart service
```bash
docker-compose restart postgres
```

**Step 4**: Check disk space
```bash
df -h /var/lib/postgresql/data
```

**Step 5**: If still failing, restore from backup
```bash
bash scripts/restore-database.sh latest
```

---

## ✅ Final Verification

```bash
#!/bin/bash

echo "🔍 Running production verification checks..."

# Check all services are running
echo "✓ Checking services..."
docker-compose ps

# Test API health
echo "✓ Testing API..."
curl -s https://clinic.example.com/api/health | jq .

# Check SSL certificate
echo "✓ Checking SSL..."
openssl s_client -connect clinic.example.com:443 -servername clinic.example.com

# Verify backups
echo "✓ Checking backups..."
ls -lh /backups/

# Check logs for errors
echo "✓ Checking logs..."
docker-compose logs --tail=100 | grep -i error

echo "✅ Production verification complete!"
```

---

**Deployment completed successfully! 🎉**

For additional support, contact: infrastructure@clinlc.local
