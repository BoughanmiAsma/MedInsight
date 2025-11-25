#!/bin/bash

# health-check.sh
# Script de vérification santé des services

set -e

# Couleurs
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "🔍 Vérification santé des services MedInsight Sprint 0-1"
echo "========================================================"

check_service() {
    local name=$1
    local url=$2
    local expected_status=${3:-200}

    if curl -s -o /dev/null -w "%{http_code}" "$url" | grep -q "$expected_status"; then
        echo -e "${GREEN}✅${NC} $name: HEALTHY"
        return 0
    else
        echo -e "${RED}❌${NC} $name: UNHEALTHY"
        return 1
    fi
}

# Vérification des services
echo
echo "📊 STATUT DES SERVICES:"

check_service "Keycloak IAM" "http://localhost:8080/health/ready"
check_service "Kong Admin API" "http://localhost:8001/status"
check_service "Kong Proxy" "http://localhost:8000"
check_service "Kong Manager" "http://localhost:8002"

# Vérification des bases de données
echo
echo "🗃 STATUT DES BASES DE DONNÉES:"

if docker exec keycloak-db pg_isready -U keycloak &>/dev/null; then
    echo -e "${GREEN}✅${NC} Keycloak Database: HEALTHY"
else
    echo -e "${RED}❌${NC} Keycloak Database: UNHEALTHY"
fi

if docker exec kong-db pg_isready -U kong &>/dev/null; then
    echo -e "${GREEN}✅${NC} Kong Database: HEALTHY"
else
    echo -e "${RED}❌${NC} Kong Database: UNHEALTHY"
fi

# Vérification des conteneurs
echo
echo "🐳 STATUT DES CONTENEURS:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep -E "(keycloak|kong)"

echo
echo "🔍 Vérification terminée"