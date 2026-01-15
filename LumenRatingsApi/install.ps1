# Script de instalación para Windows PowerShell
# Guarda este archivo como: install.ps1
# Ejecución: PowerShell -ExecutionPolicy Bypass -File install.ps1

Write-Host "==============================================="
Write-Host "Instalación del Ratings Service"
Write-Host "==============================================="

# Verificar que estamos en el directorio correcto
if (-not (Test-Path "composer.json")) {
    Write-Host "Error: No se encontró composer.json. Asegúrate de estar en el directorio LumenRatingsApi" -ForegroundColor Red
    Exit 1
}

# 1. Instalar dependencias
Write-Host ""
Write-Host "[1/5] Instalando dependencias con Composer..." -ForegroundColor Cyan
composer install
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error al instalar dependencias" -ForegroundColor Red
    Exit 1
}

# 2. Crear archivo .env si no existe
if (-not (Test-Path ".env")) {
    Write-Host ""
    Write-Host "[2/5] Creando archivo .env..." -ForegroundColor Cyan
    Copy-Item ".env" -Destination ".env.local" -ErrorAction SilentlyContinue
}

# 3. Generar clave de aplicación
Write-Host ""
Write-Host "[3/5] Generando clave de aplicación..." -ForegroundColor Cyan
php artisan key:generate

# 4. Crear base de datos SQLite
Write-Host ""
Write-Host "[4/5] Creando base de datos SQLite..." -ForegroundColor Cyan
if (-not (Test-Path "database/database.sqlite")) {
    New-Item -Path "database/database.sqlite" -ItemType File -Force | Out-Null
}

# 5. Ejecutar migraciones
Write-Host ""
Write-Host "[5/5] Ejecutando migraciones..." -ForegroundColor Cyan
php artisan migrate --force

Write-Host ""
Write-Host "==============================================="
Write-Host "✅ Instalación completada" -ForegroundColor Green
Write-Host "==============================================="
Write-Host ""
Write-Host "Para iniciar el servidor, ejecuta:" -ForegroundColor Yellow
Write-Host "  php -S localhost:8007 -t public"
Write-Host ""
