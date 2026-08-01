#!/bin/bash

# 🚀 MASTAN CLINIC FACTORY - macOS Installation Script

echo "================================================="
echo "🧠 MASTAN AI FACTORY - macOS Setup"
echo "================================================="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}Checking Homebrew...${NC}"
if ! command -v brew &> /dev/null; then
    echo -e "${YELLOW}Installing Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo -e "${BLUE}Installing Node.js via Homebrew...${NC}"
brew install node

echo -e "${BLUE}Installing Docker Desktop...${NC}"
echo "Please install Docker Desktop manually from: https://www.docker.com/products/docker-desktop"
echo "Then run this script again."

echo ""
echo "Continuing with project setup..."
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
echo -e "${GREEN}Happy coding! 🚀${NC}"
