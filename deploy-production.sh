#!/bin/bash

# 🚀 PRODUCTION DEPLOYMENT SCRIPT
# با 10+ سال تجربه در deployment

set -e

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
echo -e "${BLUE}🚀 MASTAN CLINIC FACTORY - Production Deployment${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
echo ""

# Configuration
APP_NAME="clinlc"
APP_DIR="/opt/clinlc"
BACKUP_DIR="/backups"
LOG_DIR="/var/log/clinlc"
DOMAIN="clinic.example.com"

# Colors for status
echo -e "${YELLOW}📋 Pre-deployment Checklist${NC}\n"

# 1. Check root access
if [ "$EUID" -ne 0 ]; then
   echo -e "${RED}✗ This script must be run as root${NC}"
   exit 1
fi
echo -e "${GREEN}✓ Running as root${NC}"

# 2. Check Docker
if ! command -v docker &> /dev/null; then
    echo -e "${RED}✗ Docker not found${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Docker $(docker --version | awk '{print $3}')${NC}"

# 3. Check Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}✗ Docker Compose not found${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Docker Compose installed${NC}"

# 4. Check Git
if ! command -v git &> /dev/null; then
    echo -e "${RED}✗ Git not found${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Git installed${NC}"

# 5. Check free space
FREE_SPACE=$(df /opt | tail -1 | awk '{print $4}')
if [ "$FREE_SPACE" -lt 10485760 ]; then
    echo -e "${RED}✗ Less than 10GB free space${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Sufficient disk space ($((FREE_SPACE / 1048576))GB)${NC}"

echo ""
echo -e "${YELLOW}📁 Setting up directories${NC}\n"

# Create directories
mkdir -p $APP_DIR
mkdir -p $BACKUP_DIR
mkdir -p $LOG_DIR
echo -e "${GREEN}✓ Directories created${NC}"

echo ""
echo -e "${YELLOW}📦 Cloning repository${NC}\n"

# Clone or pull
if [ -d "$APP_DIR/.git" ]; then
    echo "Updating existing repository..."
    cd $APP_DIR
    git pull origin main
else
    echo "Cloning repository..."
    git clone https://github.com/bizelhamkashefee33-hub/Clinlc-.git $APP_DIR
fi
echo -e "${GREEN}✓ Repository ready${NC}"

echo ""
echo -e "${YELLOW}🔐 Setting up environment variables${NC}\n"

# Create .env file
if [ ! -f "$APP_DIR/.env" ]; then
    echo "Creating .env file..."
    cat > $APP_DIR/.env << EOF
# Production Environment
NODE_ENV=production
PORT=3000

# Database
DB_HOST=postgres
DB_PORT=5432
DB_NAME=clinlc_db
DB_USER=clinlc_user
DB_PASSWORD=$(openssl rand -base64 32)

# Redis
REDIS_URL=redis://redis:6379/0
REDIS_PASSWORD=$(openssl rand -base64 32)

# JWT
JWT_SECRET=$(openssl rand -base64 64)

# API
API_URL=https://$DOMAIN
FRONTEND_URL=https://$DOMAIN

# Monitoring
LOG_LEVEL=info
PROMETHEUS_ENABLED=true

# Email (Optional)
SMTP_HOST=
SMTP_PORT=587
SMTP_USER=
SMTP_PASSWORD=
EOF
    chmod 600 $APP_DIR/.env
    echo -e "${GREEN}✓ .env file created (secure file, change SMTP settings)${NC}"
else
    echo -e "${YELLOW}⚠ .env file already exists, skipping${NC}"
fi

echo ""
echo -e "${YELLOW}💾 Creating backup${NC}\n"

# Backup database if exists
if docker-compose -f $APP_DIR/docker-compose.yml ps postgres 2>/dev/null | grep -q running; then
    BACKUP_FILE="$BACKUP_DIR/backup-$(date +%Y%m%d-%H%M%S).sql.gz"
    echo "Backing up database..."
    docker-compose -f $APP_DIR/docker-compose.yml exec -T postgres pg_dump -U clinlc_user clinlc_db | gzip > $BACKUP_FILE
    echo -e "${GREEN}✓ Backup created: $BACKUP_FILE${NC}"
else
    echo -e "${YELLOW}⚠ No existing database, skipping backup${NC}"
fi

echo ""
echo -e "${YELLOW}🐳 Building Docker images${NC}\n"

cd $APP_DIR
docker-compose -f docker-compose.yml build --no-cache
echo -e "${GREEN}✓ Docker images built${NC}"

echo ""
echo -e "${YELLOW}🚀 Deploying services${NC}\n"

# Stop existing services
echo "Stopping existing services..."
docker-compose -f docker-compose.yml down || true

# Start new services
echo "Starting services..."
docker-compose -f docker-compose.yml up -d

# Wait for services to be ready
echo "Waiting for services to be ready..."
sleep 30

echo -e "${GREEN}✓ Services deployed${NC}"

echo ""
echo -e "${YELLOW}✅ Verification${NC}\n"

# Check services
echo "Checking service status..."
if docker-compose -f $APP_DIR/docker-compose.yml ps | grep -q "running"; then
    echo -e "${GREEN}✓ All services running${NC}"
else
    echo -e "${RED}✗ Some services not running${NC}"
    docker-compose -f $APP_DIR/docker-compose.yml logs
    exit 1
fi

# Check API
echo "Testing API..."
if curl -s http://localhost:3000/api/health | grep -q "ok"; then
    echo -e "${GREEN}✓ API responding${NC}"
else
    echo -e "${RED}✗ API not responding${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}📊 Setting up monitoring${NC}\n"

# Setup log rotation
cat > /etc/logrotate.d/clinlc << EOF
$LOG_DIR/*.log {
    daily
    rotate 14
    compress
    delaycompress
    missingok
    notifempty
    create 0640 nobody nobody
    sharedscripts
}
EOF
echo -e "${GREEN}✓ Log rotation configured${NC}"

# Setup backup cron job
cat > /etc/cron.d/clinlc-backup << EOF
# Backup database daily at 2 AM
0 2 * * * root cd $APP_DIR && docker-compose exec -T postgres pg_dump -U clinlc_user clinlc_db | gzip > $BACKUP_DIR/backup-\$(date +\%Y\%m\%d).sql.gz

# Cleanup old backups (keep 30 days)
0 3 * * * root find $BACKUP_DIR -mtime +30 -delete
EOF
echo -e "${GREEN}✓ Backup cron jobs configured${NC}"

echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ DEPLOYMENT COMPLETE!${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}📌 Next Steps:${NC}"
echo ""
echo "1. Configure SSL/TLS:"
echo -e "   ${YELLOW}sudo certbot certonly --standalone -d $DOMAIN${NC}"
echo ""
echo "2. Setup Nginx reverse proxy:"
echo -e "   ${YELLOW}Copy nginx.conf from docs/ to /etc/nginx/sites-available/${NC}"
echo ""
echo "3. Access the application:"
echo -e "   ${YELLOW}Frontend: https://$DOMAIN${NC}"
echo -e "   ${YELLOW}API: https://$DOMAIN/api${NC}"
echo ""
echo "4. View logs:"
echo -e "   ${YELLOW}docker-compose -f $APP_DIR/docker-compose.yml logs -f${NC}"
echo ""
echo "5. Database credentials:"
echo -e "   ${YELLOW}Check $APP_DIR/.env${NC}"
echo ""
echo -e "${GREEN}🎉 Happy coding!${NC}"
echo ""
