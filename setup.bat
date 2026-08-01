#!/bin/bash

# 🚀 MASTAN CLINIC FACTORY - Windows Installation Script
# برای سیستم‌های Windows (با Git Bash یا WSL)

echo "================================================="
echo "🧠 MASTAN AI FACTORY - Windows Setup"
echo "================================================="
echo ""

# Colors for Windows Git Bash
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check Node.js
echo -e "${BLUE}Checking Node.js...${NC}"
if command -v node &> /dev/null; then
    echo -e "${GREEN}✓ Node.js $(node --version)${NC}"
else
    echo -e "${RED}✗ Node.js not found!${NC}"
    echo "Download from: https://nodejs.org/"
    exit 1
fi

# Check Docker
echo -e "${BLUE}Checking Docker...${NC}"
if command -v docker &> /dev/null; then
    echo -e "${GREEN}✓ Docker installed${NC}"
else
    echo -e "${RED}✗ Docker not found!${NC}"
    echo "Download: https://www.docker.com/products/docker-desktop"
    exit 1
fi

# Install root dependencies
echo -e "${BLUE}Installing dependencies...${NC}"
npm install

echo ""
echo -e "${YELLOW}=================================================${NC}"
echo -e "${GREEN}✓ Setup Complete!${NC}"
echo -e "${YELLOW}=================================================${NC}"
echo ""
echo -e "${BLUE}📋 Next Steps:${NC}"
echo ""
echo "1️⃣  Start Docker Services:"
echo -e "   ${YELLOW}docker-compose up -d${NC}"
echo ""
echo "2️⃣  Access Applications:"
echo -e "   Frontend:  ${YELLOW}http://localhost:5173${NC}"
echo -e "   Backend:   ${YELLOW}http://localhost:3000/api/health${NC}"
echo ""
echo "3️⃣  View Logs:"
echo -e "   ${YELLOW}docker-compose logs -f${NC}"
echo ""
echo -e "${GREEN}Happy coding! 🚀${NC}"
