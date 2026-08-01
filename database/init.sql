-- MASTAN Clinic Factory Database Setup

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

-- Seed Data (Optional)
INSERT INTO users (username, email, password_hash, role) VALUES
  ('admin', 'admin@clinlc.local', 'hashed_password', 'admin'),
  ('demo', 'demo@clinlc.local', 'hashed_password', 'user')
ON CONFLICT (email) DO NOTHING;
