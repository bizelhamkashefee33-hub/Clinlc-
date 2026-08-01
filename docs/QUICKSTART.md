# ⚡ Quick Start (5 Minutes)

## One Command Setup

```bash
bash setup.sh
```

This single command:
1. ✅ Verifies all requirements
2. ✅ Creates project structure
3. ✅ Installs dependencies
4. ✅ Configures database
5. ✅ Sets up Docker

## Start Services

```bash
# Using Docker (Recommended)
docker-compose up -d
```

## Access Applications

- **Frontend**: http://localhost:5173
- **API**: http://localhost:3000/api/health
- **Database**: localhost:5432

## What's Running?

```
✅ PostgreSQL Database (port 5432)
✅ Redis Cache (port 6379)
✅ Node.js Backend API (port 3000)
✅ React Frontend (port 5173)
```

## Next Steps

1. Open http://localhost:5173 in your browser
2. Backend automatically connects
3. Start building features!

## Stop Services

```bash
docker-compose down
```

---

For detailed setup: See [INSTALLATION.md](./INSTALLATION.md)
