# Script para ejecutar migraciones y seeders en todos los servicios

Write-Host "================================================" -ForegroundColor Yellow
Write-Host "EJECUTANDO MIGRACIONES Y SEEDERS" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Yellow
Write-Host ""

$baseDir = "c:\Users\busta\Desktop\Universidad\arquitectura\Taller_Micreoservicios\arquitecturaMicroServicios"
$services = @(
    @{name="LumenAuthorsApi"; port=8001},
    @{name="LumenBooksApi"; port=8002},
    @{name="LumenRatingsApi"; port=8007}
)

foreach ($service in $services) {
    $servicePath = Join-Path $baseDir $service.name
    
    Write-Host ""
    Write-Host ">>> Procesando $($service.name)..." -ForegroundColor Cyan
    
    if (Test-Path $servicePath) {
        Set-Location $servicePath
        
        Write-Host "    Ejecutando migraciones..." -ForegroundColor Gray
        php artisan migrate --force 2>&1 | Select-String "Migrated|migrated|error|failed" -Context 0,1
        
        Write-Host "    Ejecutando seeders..." -ForegroundColor Gray
        php artisan db:seed 2>&1 | Select-String "Seeded|seeded|error|failed" -Context 0,1
        
        Write-Host "    OK" -ForegroundColor Green
    } else {
        Write-Host "    ERROR - Directorio no encontrado" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Yellow
Write-Host "COMPLETADO" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Yellow
Write-Host ""
