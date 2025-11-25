# setup-secrets.ps1 - Version simplifiée
Write-Host "🔐 Generation des secrets MedInsight" -ForegroundColor Green

# Fonction de génération de mot de passe ultra-simplifiée
function Generate-Password {
    param([int]$Length = 16)
    
    # Caractères simples sans problèmes
    $chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    $result = ""
    
    for ($i = 0; $i -lt $Length; $i++) {
        $random = Get-Random -Maximum $chars.Length
        $result += $chars[$random]
    }
    
    return $result
}

Write-Host "🔧 Generation des secrets..." -ForegroundColor Yellow

# Génération des secrets
$KEYCLOAK_DB_PASSWORD = Generate-Password 16
$KEYCLOAK_ADMIN_PASSWORD = Generate-Password 16
$KONG_DB_PASSWORD = Generate-Password 16
$KONG_ADMIN_PASSWORD = Generate-Password 16
$KONG_SESSION_SECRET = Generate-Password 32
$IDENTITY_SERVICE_SECRET = Generate-Password 24
$JWT_SECRET = Generate-Password 32
$ENCRYPTION_KEY = Generate-Password 32

# Création du fichier .env
$envContent = @"
# KEYCLOAK CONFIGURATION
KEYCLOAK_DB_PASSWORD=$KEYCLOAK_DB_PASSWORD
KEYCLOAK_ADMIN_USER=admin
KEYCLOAK_ADMIN_PASSWORD=$KEYCLOAK_ADMIN_PASSWORD
KEYCLOAK_HOSTNAME=localhost

# KONG CONFIGURATION
KONG_DB_PASSWORD=$KONG_DB_PASSWORD
KONG_ADMIN_PASSWORD=$KONG_ADMIN_PASSWORD
KONG_SESSION_SECRET=$KONG_SESSION_SECRET

# APPLICATION CONFIGURATION
IDENTITY_SERVICE_PORT=8081
IDENTITY_SERVICE_SECRET=$IDENTITY_SERVICE_SECRET

# SECURITY CONFIGURATION
JWT_SECRET=$JWT_SECRET
ENCRYPTION_KEY=$ENCRYPTION_KEY

# NETWORK CONFIGURATION
MEDINSIGHT_DOMAIN=medinsight.local
API_GATEWAY_DOMAIN=api.medinsight.local
"@

# Écrire le fichier
$envContent | Out-File -FilePath .env -Encoding UTF8

Write-Host "✅ Fichier .env genere avec succes!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Secrets generes:" -ForegroundColor Cyan
Write-Host "Keycloak DB: $KEYCLOAK_DB_PASSWORD"
Write-Host "Keycloak Admin: $KEYCLOAK_ADMIN_PASSWORD"
Write-Host "Kong DB: $KONG_DB_PASSWORD"
Write-Host "Kong Admin: $KONG_ADMIN_PASSWORD"
Write-Host ""
Write-Host "🔧 Prochaine etape: docker-compose -f infrastructure/docker-compose.security.yml up -d" -ForegroundColor Green
