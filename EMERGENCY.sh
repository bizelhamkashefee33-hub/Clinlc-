#!/bin/bash

# 🚨 EMERGENCY - اگر چیزی اشتباه پیش رفت
# Emergency Recovery Script

echo "🚨 EMERGENCY RECOVERY MODE"
echo "==================================="

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Menu
echo ""
echo "لطفا انتخاب کنید:"
echo ""
echo "1. 🔄 Restart All Services"
echo "2. 🗑️  Remove All Containers"
echo "3. 🔧 Reset Database"
echo "4. 🧹 Clean Everything (DANGEROUS!)"
echo "5. 📋 Show Status"
echo "6. 📊 Show Logs"
echo ""
read -p "Enter option (1-6): " option

case $option in
    1)
        echo -e "${YELLOW}Restarting all services...${NC}"
        docker-compose restart
        echo -e "${GREEN}✓ Done!${NC}"
        ;;
    2)
        echo -e "${RED}Removing all containers...${NC}"
        docker-compose down
        echo -e "${GREEN}✓ Containers removed!${NC}"
        echo "Use 'docker-compose up -d' to restart"
        ;;
    3)
        echo -e "${RED}Resetting database...${NC}"
        docker-compose exec -T postgres dropdb -U clinlc_user clinlc_db
        docker-compose exec -T postgres createdb -U clinlc_user clinlc_db
        docker-compose exec -T postgres psql -U clinlc_user clinlc_db < database/init.sql
        echo -e "${GREEN}✓ Database reset!${NC}"
        ;;
    4)
        echo -e "${RED}⚠️  DANGEROUS: This will delete EVERYTHING!${NC}"
        read -p "Type 'yes' to continue: " confirm
        if [ "$confirm" = "yes" ]; then
            docker-compose down -v
            rm -rf postgres_data redis_data
            npm install
            docker-compose up -d
            echo -e "${GREEN}✓ Full reset complete!${NC}"
        else
            echo "Cancelled."
        fi
        ;;
    5)
        echo -e "${BLUE}Current status:${NC}"
        docker-compose ps
        ;;
    6)
        echo -e "${BLUE}Service logs:${NC}"
        docker-compose logs -f
        ;;
    *)
        echo -e "${RED}Invalid option!${NC}"
        ;;
esac
