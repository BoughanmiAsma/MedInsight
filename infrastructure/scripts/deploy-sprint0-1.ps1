Write-Host "🚀 Deploiement MedInsight" -ForegroundColor Green

# Verifier Docker
try {
    docker --version | Out-Null
    Write-Host "✅ Docker est disponible" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker non disponible" -ForegroundColor Red
    exit 1
}

# Verifier .env
if (-not (Test-Path .env)) {
    Write-Host "❌ Fichier .env manquant" -ForegroundColor Red
    exit 1
}

Write-Host "🐳 Demarrage des services..." -ForegroundColor Yellow

# Demarrer les services
docker-compose -f infrastructure/docker-compose.security.yml up -d


Write-Host "⏳ Attente du demarrage (40 secondes)..." -ForegroundColor Yellow
Start-Sleep -Seconds 40

Write-Host "🔍 Verification..." -ForegroundColor Yellow
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

Write-Host "`n✅ Deploiement termine!" -ForegroundColor Green
Write-Host "🌐 Keycloak: http://localhost:8080" -ForegroundColor White
Write-Host "🔧 Kong: http://localhost:8001" -ForegroundColor White
Write-Host "📊 Kong Manager: http://localhost:8002" -ForegroundColor White
