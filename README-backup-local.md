# MedInsight-PDS

# 🏥 MedInsight - Sprint 0-1 : Sécurité & Authentification

## 📋 Description
Ce sprint établit les fondations de sécurité pour la plateforme MedInsight :
- **Keycloak** : Gestion centralisée des identités et accès (IAM)
- **Kong** : API Gateway avec sécurité avancée
- **PostgreSQL** : Bases de données sécurisées avec audit

## 🚀 Déploiement Rapide

### Prérequis
- Docker & Docker Compose
- 4GB RAM minimum
- Ports 5432, 5433, 8080, 8000-8002 disponibles

### Installation
```bash
# 1. Cloner le projet
git clone <repository>
cd medinsight-sprint-0

# 2. Générer les secrets
chmod +x scripts/setup-secrets.sh
./scripts/setup-secrets.sh

# 3. Déployer
./scripts/deploy-sprint0-1.sh
```


### Vérification
```bash
# Vérifier la santé des services
./scripts/health-check.sh

# Voir les logs
docker-compose -f docker-compose.security.yml logs -f
```

### URLs d'Accès

#### Service :

Keycloak Admin : http://localhost:8080	admin / (voir .env)
Kong Admin API : http://localhost:8001	(API Key)
Kong Manager : http://localhost:8002	(Basic Auth)                                                                                         
Kong Proxy : http://localhost:8000	


### Architecture

Client      →      Kong Gateway     →     Keycloak IAM → Microservices                                                                   
│...................│.......................└── PostgreSQL (Keycloak)                                                           
│...................└── PostgreSQL (Kong)                                                           
└── React/Angular Frontend



---

## 🚀 **SCRIPT DE DÉPLOIEMENT COMPLET**


```bash
# 1. Rendre les scripts exécutables
chmod +x scripts/*.sh

# 2. Générer les secrets automatiquement
./scripts/setup-secrets.sh

# 3. Déployer l'infrastructure
./scripts/deploy-sprint0-1.sh

# 4. Vérifier que tout fonctionne
./scripts/health-check.sh
```