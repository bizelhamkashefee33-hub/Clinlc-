# 🚀 Installation & Setup Guide

## Prerequisites

Before you start, ensure you have installed:

### Required
- **Node.js** (v18+) - [Download](https://nodejs.org/)
- **Docker** - [Download](https://www.docker.com/products/docker-desktop)
- **Docker Compose** - Included with Docker Desktop
- **Git** - [Download](https://git-scm.com/)

### Optional
- **PostgreSQL Client** (psql) - For direct database access
- **Redis CLI** - For cache management
- **VS Code** - [Download](https://code.visualstudio.com/)

---

## Installation Steps

### 1. Clone Repository
```bash
git clone https://github.com/bizelhamkashefee33-hub/Clinlc-.git
cd Clinlc-
```

### 2. Run Auto Setup Script
```bash
chmod +x setup.sh
bash setup.sh
```

This will automatically:
- ✅ Check all requirements
- ✅ Create project structure
- ✅ Install dependencies
- ✅ Configure backend
- ✅ Configure frontend
- ✅ Setup database schemas

### 3. Start Services

#### Option A: Docker (Recommended)
```bash
docker-compose up -d
```

#### Option B: Local Development
```bash
# Terminal 1 - Backend
cd backend
npm run dev

# Terminal 2 - Frontend
cd frontend
npm run dev
```

### 4. Verify Installation

#### Check Backend
```bash
curl http://localhost:3000/api/health
```

Expected response:
```json
{
  "status": "ok",
  "timestamp": "2026-08-01T...",
  "version": "1.0.0",
  "name": "MASTAN Clinic Factory API"
}
```

#### Check Frontend
Open browser: `http://localhost:5173`

You should see the MASTAN AI Factory welcome page.

---

## Services Access

| Service | URL | Purpose |
|---------|-----|----------|
| Frontend | http://localhost:5173 | Web UI |
| Backend API | http://localhost:3000 | REST API |
| Database | localhost:5432 | PostgreSQL |
| Redis Cache | localhost:6379 | Caching |
| API Docs | http://localhost:3000/api | API Reference |

---

## Database Access

### Using psql
```bash
psql -h localhost -U clinlc_user -d clinlc_db -W
# Password: clinlc_password_2026
```

### Using Docker
```bash
docker-compose exec postgres psql -U clinlc_user -d clinlc_db
```

### View Logs
```bash
docker-compose logs postgres
```

---

## Common Commands

### Docker Management
```bash
# Start all services
docker-compose up -d

# Stop all services
docker-compose down

# View logs (all services)
docker-compose logs -f

# View specific service logs
docker-compose logs -f backend
docker-compose logs -f frontend

# Rebuild images
docker-compose build --no-cache

# Remove everything (including volumes)
docker-compose down -v
```

### Local Development
```bash
# Install dependencies
npm install

# Run development server
npm run dev

# Run tests
npm test

# Build for production
npm run build
```

---

## Troubleshooting

### Port Already in Use
```bash
# Kill process on port 3000
lsof -i :3000 | grep LISTEN | awk '{print $2}' | xargs kill -9

# Kill process on port 5173
lsof -i :5173 | grep LISTEN | awk '{print $2}' | xargs kill -9
```

### Docker Issues
```bash
# Remove all stopped containers
docker container prune

# Remove all unused images
docker image prune

# Remove all unused networks
docker network prune
```

### Database Connection Failed
```bash
# Check if postgres is running
docker-compose ps postgres

# Restart postgres
docker-compose restart postgres

# View postgres logs
docker-compose logs postgres
```

### Dependencies Installation Issues
```bash
# Clear npm cache
npm cache clean --force

# Remove node_modules and lock file
rm -rf node_modules package-lock.json

# Reinstall
npm install
```

---

## Configuration Files

### Backend (.env)
Location: `backend/.env`

Key variables:
- `NODE_ENV`: development/production
- `PORT`: API port (default 3000)
- `DB_HOST`: Database host
- `DB_USER`: Database user
- `JWT_SECRET`: Authentication secret

### Frontend (vite.config.js)
Location: `frontend/vite.config.js`

Key settings:
- `port`: Dev server port (default 5173)
- `host`: Bind address
- `API_URL`: Backend URL

### Docker (docker-compose.yml)
Location: `docker-compose.yml`

Services:
- PostgreSQL
- Redis
- Backend API
- Frontend

---

## Deployment

### Production Build
```bash
npm run build
```

### Environment Setup
```bash
# Copy environment template
cp backend/.env.example backend/.env.production

# Edit with production values
vim backend/.env.production
```

### Docker Production
```bash
# Build images
docker-compose build

# Start with production config
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

---

## Getting Help

- 📚 **Documentation**: See `./docs/` directory
- 🐛 **Issues**: GitHub Issues
- 💬 **Discussion**: GitHub Discussions
- 📧 **Email**: support@clinlc.local

---

**Version 1.0.0** | Last Updated: 2026-08-01
