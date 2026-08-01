# 📦 MASTAN AI FACTORY - Complete Setup Guide

## 🎯 System Requirements

### Minimum Requirements
- **RAM**: 4 GB
- **Storage**: 10 GB free space
- **Internet**: Stable connection for Docker image downloads

### Software Requirements

#### Required
| Software | Version | Download |
|----------|---------|----------|
| Node.js | 18+ | https://nodejs.org/ |
| Docker | 20.10+ | https://www.docker.com/ |
| Docker Compose | 2.0+ | Included with Docker Desktop |
| Git | Any | https://git-scm.com/ |

#### Optional
| Software | Purpose | Download |
|----------|---------|----------|
| VS Code | Code Editor | https://code.visualstudio.com/ |
| Postman | API Testing | https://www.postman.com/ |
| DataGrip | Database Client | https://www.jetbrains.com/datagrip/ |
| Ollama | Local LLM | https://ollama.ai/ |

---

## 🚀 Installation Methods

### Method 1: Automatic (Recommended)

#### Windows
```cmd
INSTALL.bat
```

#### macOS
```bash
chmod +x INSTALL.sh
bash INSTALL.sh
```

#### Linux
```bash
chmod +x INSTALL_LINUX.sh
bash INSTALL_LINUX.sh
```

### Method 2: Manual

```bash
# 1. Clone repository
git clone https://github.com/bizelhamkashefee33-hub/Clinlc-.git
cd Clinlc-

# 2. Install dependencies
npm install

# 3. Start services
docker-compose up -d

# 4. Verify
curl http://localhost:3000/api/health
```

---

## ✅ Verification Checklist

After installation, verify everything is working:

### Frontend
```bash
# ✅ Should display welcome page
open http://localhost:5173
```

### Backend API
```bash
# ✅ Should return health status
curl http://localhost:3000/api/health

# Response should be:
# {"status":"ok","version":"1.0.0","name":"MASTAN Clinic Factory API"}
```

### Database
```bash
# ✅ Should connect successfully
docker-compose exec postgres psql -U clinlc_user -d clinlc_db -c "SELECT 1;"
```

### Docker Services
```bash
# ✅ All should show "healthy" or "running"
docker-compose ps
```

---

## 📖 Configuration

### Backend Configuration

Edit `backend/.env`:

```env
# Application
NODE_ENV=development
PORT=3000
LOG_LEVEL=debug

# Database
DB_HOST=postgres
DB_PORT=5432
DB_NAME=clinlc_db
DB_USER=clinlc_user
DB_PASSWORD=clinlc_password_2026

# Redis
REDIS_URL=redis://redis:6379/0

# Security
JWT_SECRET=your_secret_key_here
JWT_EXPIRY=24h

# CORS
CORS_ORIGIN=http://localhost:5173

# API Documentation
API_DOCS_ENABLED=true
```

### Frontend Configuration

Edit `frontend/.env`:

```env
VITE_API_URL=http://localhost:3000
VITE_ENV=development
```

### Docker Configuration

Edit `docker-compose.yml` to customize:
- Port mappings
- Environment variables
- Volume mounts
- Resource limits

---

## 🔄 Development Workflow

### Local Development (without Docker)

```bash
# Terminal 1 - Backend
cd backend
npm run dev
# Backend runs on http://localhost:3000

# Terminal 2 - Frontend  
cd frontend
npm run dev
# Frontend runs on http://localhost:5173

# Terminal 3 - Database
# Use local PostgreSQL or docker-compose up postgres
```

### Docker Development

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Edit code - changes are hot-reloaded
# Backend: src/
# Frontend: src/

# Rebuild if needed
docker-compose build --no-cache backend frontend
```

---

## 🧪 Testing

### Run Tests

```bash
# All tests
npm test

# Backend tests
cd backend && npm test

# Frontend tests
cd frontend && npm test

# With coverage
npm test -- --coverage
```

### Test API Manually

```bash
# Using curl
curl -X GET http://localhost:3000/api/health

# Using httpie
http GET localhost:3000/api/health

# Using Postman (import collection from docs/postman/)
```

---

## 📊 Database Management

### Access Database

```bash
# Using psql
docker-compose exec postgres psql -U clinlc_user -d clinlc_db

# Using DataGrip or similar GUI
# Host: localhost
# Port: 5432
# Username: clinlc_user
# Password: clinlc_password_2026
```

### Run Migrations

```bash
# Run all migrations
cd backend
npm run migrate

# Seed database
npm run seed

# Rollback
npm run migrate:rollback
```

### Backup Database

```bash
# Create backup
docker-compose exec postgres pg_dump -U clinlc_user clinlc_db > backup.sql

# Restore backup
docker-compose exec -T postgres psql -U clinlc_user clinlc_db < backup.sql
```

---

## 🐛 Troubleshooting

### Common Issues

#### 1. Port Already in Use
```bash
# Find process using port
lsof -i :3000

# Kill process
kill -9 <PID>

# Or change port in docker-compose.yml
```

#### 2. Docker Daemon Not Running
```bash
# macOS
open /Applications/Docker.app

# Linux
sudo systemctl start docker

# Windows
# Restart Docker Desktop
```

#### 3. Permission Denied
```bash
# macOS/Linux
sudo chown -R $USER:$USER .
chmod +x setup.sh INSTALL*.sh
```

#### 4. Database Connection Failed
```bash
# Check postgres is running
docker-compose ps postgres

# Check logs
docker-compose logs postgres

# Restart
docker-compose restart postgres
```

#### 5. Out of Memory
```bash
# Increase Docker memory allocation
# Docker Desktop -> Settings -> Resources -> Memory
# Increase to 4GB or more
```

### Debug Mode

```bash
# Enable debug logging
export DEBUG=*
docker-compose up

# View all service logs
docker-compose logs

# Watch specific service
docker-compose logs -f backend
```

---

## 📚 Documentation

- [Quick Start](./docs/QUICKSTART.md)
- [Installation](./docs/INSTALLATION.md)
- [Farsi Guide](./INSTALL_FA.md)
- [API Documentation](./docs/api/)
- [Architecture](./docs/architecture/)

---

## 🔐 Security

### Before Production

1. ✅ Change all default passwords
2. ✅ Update JWT_SECRET
3. ✅ Enable HTTPS
4. ✅ Configure CORS properly
5. ✅ Set up firewall rules
6. ✅ Enable database backups
7. ✅ Review environment variables

### Security Checklist

```bash
# Generate secure JWT secret
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"

# Test CORS
curl -i -X OPTIONS http://localhost:3000 -H "Origin: http://example.com"

# Check for exposed secrets
grep -r "password\|secret\|key" backend/.env
```

---

## 📞 Support

### Getting Help

1. **Check Documentation**: See `./docs/`
2. **Search Issues**: GitHub Issues
3. **Ask Community**: GitHub Discussions
4. **Report Bugs**: Create new issue with details
5. **Contact Support**: support@clinlc.local

### Reporting Issues

Include:
- OS and version
- Node.js and npm versions
- Docker version
- Error message and stack trace
- Steps to reproduce
- Your environment (.env values - without secrets)

---

## 🚀 Next Steps

1. ✅ **Installation Complete**
2. 📖 Read [QUICKSTART.md](./docs/QUICKSTART.md)
3. 🔧 Configure `.env` files
4. 🏗️ Start building features
5. 🧪 Write tests
6. 📦 Deploy to production

---

**Version 1.0.0** | Last Updated: 2026-08-01
