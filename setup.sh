#!/bin/bash

# 🚀 MASTAN CLINIC FACTORY - Auto Setup & Install Script
# برای نصب و اجرا خودکار پروژه

set -e

echo "═══════════════════════════════════════════════════════════════"
echo "🧠 MASTAN AI FACTORY - Clinic Management System"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}📋 Step 1: Checking Requirements...${NC}"
echo ""

# Check Node.js
if ! command -v node &> /dev/null; then
    echo -e "${RED}✗ Node.js not found!${NC}"
    echo "Download from: https://nodejs.org/"
    exit 1
fi
echo -e "${GREEN}✓ Node.js $(node --version)${NC}"

# Check Docker
if ! command -v docker &> /dev/null; then
    echo -e "${RED}✗ Docker not found!${NC}"
    echo "Download from: https://www.docker.com/products/docker-desktop"
    exit 1
fi
echo -e "${GREEN}✓ Docker $(docker --version)${NC}"

# Check Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}✗ Docker Compose not found!${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Docker Compose $(docker-compose --version)${NC}"

echo ""
echo -e "${BLUE}📦 Step 2: Creating Project Structure...${NC}"
echo ""

# Create directories
mkdir -p backend/src/{routes,controllers,models,middleware,config}
mkdir -p frontend/src/{components,pages,services,store}
mkdir -p database/migrations database/seeds
mkdir -p ai-factory/{generators,validators,templates}
mkdir -p docs/{prd,architecture,api}
mkdir -p scripts logs

echo -e "${GREEN}✓ Directory structure created${NC}"

echo ""
echo -e "${BLUE}📝 Step 3: Installing Root Dependencies...${NC}"
echo ""

npm install

echo ""
echo -e "${BLUE}🔧 Step 4: Setting up Backend...${NC}"
echo ""

cd backend
cat > package.json << 'EOF'
{
  "name": "clinlc-backend",
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "dev": "nodemon --exec node src/index.js",
    "build": "tsc",
    "start": "node dist/index.js",
    "test": "jest",
    "migrate": "node scripts/migrate.js",
    "seed": "node scripts/seed.js"
  },
  "dependencies": {
    "express": "^4.18.2",
    "dotenv": "^16.3.1",
    "pg": "^8.11.2",
    "cors": "^2.8.5",
    "jsonwebtoken": "^9.1.0",
    "bcryptjs": "^2.4.3",
    "axios": "^1.6.0",
    "redis": "^4.6.11"
  },
  "devDependencies": {
    "nodemon": "^3.0.1",
    "typescript": "^5.2.2",
    "@types/node": "^20.5.0",
    "@types/express": "^4.17.17",
    "jest": "^29.7.0"
  }
}
EOF

npm install

cat > src/index.js << 'EOF'
import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Health Check
app.get('/api/health', (req, res) => {
  res.json({
    status: 'ok',
    timestamp: new Date(),
    version: '1.0.0',
    name: 'MASTAN Clinic Factory API'
  });
});

// API Routes
app.get('/api', (req, res) => {
  res.json({
    message: '🧠 MASTAN AI FACTORY API',
    endpoints: {
      health: '/api/health',
      generators: '/api/generators',
      projects: '/api/projects',
      docs: '/api/docs'
    }
  });
});

// Start Server
app.listen(PORT, () => {
  console.log(`\n🚀 Backend running on http://localhost:${PORT}`);
  console.log(`📊 Health check: http://localhost:${PORT}/api/health\n`);
});
EOF

cat > .env << 'EOF'
NODE_ENV=development
PORT=3000
DB_HOST=localhost
DB_PORT=5432
DB_NAME=clinlc_db
DB_USER=clinlc_user
DB_PASSWORD=clinlc_password_2026
REDIS_URL=redis://localhost:6379
JWT_SECRET=dev_jwt_secret_key_change_in_production
EOF

echo -e "${GREEN}✓ Backend initialized${NC}"

cd ..

echo ""
echo -e "${BLUE}⚛️  Step 5: Setting up Frontend...${NC}"
echo ""

mkdir -p frontend
cd frontend

cat > package.json << 'EOF'
{
  "name": "clinlc-frontend",
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview",
    "test": "vitest"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "axios": "^1.6.0",
    "react-router-dom": "^6.15.0"
  },
  "devDependencies": {
    "vite": "^4.5.0",
    "@vitejs/plugin-react": "^4.0.3",
    "typescript": "^5.2.2",
    "vitest": "^0.34.5"
  }
}
EOF

npm install

mkdir -p src/{components,pages,services}

cat > src/main.jsx << 'EOF'
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App.jsx'

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
)
EOF

cat > src/App.jsx << 'EOF'
import { useEffect, useState } from 'react'
import './App.css'

function App() {
  const [status, setStatus] = useState('loading')
  const [data, setData] = useState(null)

  useEffect(() => {
    fetch('http://localhost:3000/api/health')
      .then(r => r.json())
      .then(d => {
        setData(d)
        setStatus('connected')
      })
      .catch(e => {
        console.error(e)
        setStatus('error')
      })
  }, [])

  return (
    <div className="App">
      <h1>🧠 MASTAN AI FACTORY</h1>
      <p>Clinic Management System</p>
      <div className="status">
        {status === 'loading' && <p>⏳ Connecting to API...</p>}
        {status === 'connected' && (
          <div className="success">
            <p>✅ Connected to Backend!</p>
            <pre>{JSON.stringify(data, null, 2)}</pre>
          </div>
        )}
        {status === 'error' && <p>❌ Backend not accessible</p>}
      </div>
    </div>
  )
}

export default App
EOF

cat > src/App.css << 'EOF'
.App {
  text-align: center;
  padding: 2rem;
  font-family: Arial, sans-serif;
}

h1 {
  color: #333;
  margin-bottom: 0.5rem;
}

p {
  color: #666;
  margin: 1rem 0;
}

.status {
  margin-top: 2rem;
  padding: 1rem;
  border: 2px solid #ddd;
  border-radius: 8px;
  background: #f9f9f9;
}

.success {
  color: #27ae60;
}

pre {
  text-align: left;
  background: #f0f0f0;
  padding: 1rem;
  border-radius: 4px;
  overflow-x: auto;
}
EOF

cat > vite.config.js << 'EOF'
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    port: 5173,
    host: true
  }
})
EOF

cat > index.html << 'EOF'
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>MASTAN Clinic Factory</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.jsx"></script>
  </body>
</html>
EOF

echo -e "${GREEN}✓ Frontend initialized${NC}"

cd ..

echo ""
echo -e "${BLUE}💾 Step 6: Setting up Database...${NC}"
echo ""

cat > database/init.sql << 'EOF'
-- MASTAN Clinic Factory Database

-- Users Table
CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(255) UNIQUE NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  role VARCHAR(50) DEFAULT 'user',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Projects Table
CREATE TABLE IF NOT EXISTS projects (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id),
  name VARCHAR(255) NOT NULL,
  description TEXT,
  status VARCHAR(50) DEFAULT 'draft',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- PRD Table
CREATE TABLE IF NOT EXISTS prds (
  id SERIAL PRIMARY KEY,
  project_id INTEGER REFERENCES projects(id),
  content TEXT NOT NULL,
  version INTEGER DEFAULT 1,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Architecture Table
CREATE TABLE IF NOT EXISTS architectures (
  id SERIAL PRIMARY KEY,
  project_id INTEGER REFERENCES projects(id),
  content TEXT NOT NULL,
  version INTEGER DEFAULT 1,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Code Artifacts
CREATE TABLE IF NOT EXISTS artifacts (
  id SERIAL PRIMARY KEY,
  project_id INTEGER REFERENCES projects(id),
  type VARCHAR(50),
  content TEXT NOT NULL,
  file_path VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Indexes
CREATE INDEX IF NOT EXISTS idx_projects_user_id ON projects(user_id);
CREATE INDEX IF NOT EXISTS idx_prds_project_id ON prds(project_id);
CREATE INDEX IF NOT EXISTS idx_architectures_project_id ON architectures(project_id);
CREATE INDEX IF NOT EXISTS idx_artifacts_project_id ON artifacts(project_id);
EOF

echo -e "${GREEN}✓ Database schemas created${NC}"

echo ""
echo -e "${BLUE}🐳 Step 7: Docker Setup Complete${NC}"
echo ""

echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ Setup Complete!${NC}"
echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BLUE}📝 Next Steps:${NC}"
echo ""
echo "1️⃣  Start Services with Docker:"
echo -e "   ${YELLOW}docker-compose up -d${NC}"
echo ""
echo "2️⃣  Access Applications:"
echo -e "   ${YELLOW}Frontend:  http://localhost:5173${NC}"
echo -e "   ${YELLOW}Backend:   http://localhost:3000/api/health${NC}"
echo -e "   ${YELLOW}Database:  localhost:5432${NC}"
echo ""
echo "3️⃣  View Logs:"
echo -e "   ${YELLOW}docker-compose logs -f${NC}"
echo ""
echo "4️⃣  Stop Services:"
echo -e "   ${YELLOW}docker-compose down${NC}"
echo ""
echo -e "${BLUE}🔑 Database Credentials:${NC}"
echo "   Username: clinlc_user"
echo "   Password: clinlc_password_2026"
echo "   Database: clinlc_db"
echo ""
echo -e "${GREEN}Happy coding! 🚀${NC}"
echo ""
