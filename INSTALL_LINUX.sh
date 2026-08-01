#!/bin/bash

# 🚀 MASTAN CLINIC FACTORY - Linux Installation Script

echo "================================================="
echo "🧠 MASTAN AI FACTORY - Linux Setup"
echo "================================================="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

set -e

# Detect Linux distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
fi

echo -e "${BLUE}Detected OS: $OS${NC}"

# Update package manager
echo -e "${BLUE}Updating package manager...${NC}"
if command -v apt-get &> /dev/null; then
    sudo apt-get update
    sudo apt-get install -y curl gnupg2 lsb-release ubuntu-keyring
elif command -v yum &> /dev/null; then
    sudo yum check-update
fi

# Install Node.js
echo -e "${BLUE}Installing Node.js...${NC}"
if command -v apt-get &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt-get install -y nodejs
elif command -v yum &> /dev/null; then
    curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -
    sudo yum install -y nodejs
fi

# Install Docker
echo -e "${BLUE}Installing Docker...${NC}"
if command -v apt-get &> /dev/null; then
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
elif command -v yum &> /dev/null; then
    sudo yum install -y docker
fi

# Add user to docker group
echo -e "${BLUE}Adding user to docker group...${NC}"
sudo usermod -aG docker $USER

# Install project dependencies
echo -e "${BLUE}Installing project dependencies...${NC}"
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
echo -e "${YELLOW}Note: Log out and log in again for Docker permission changes to take effect.${NC}"
echo ""
echo -e "${GREEN}Happy coding! 🚀${NC}"
