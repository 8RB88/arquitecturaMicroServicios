# Script simple para levantar todos los microservicios

Write-Host "================================================" -ForegroundColor Yellow
Write-Host "INICIANDO TODOS LOS MICROSERVICIOS" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Yellow
Write-Host ""

$baseDir = "c:\Users\busta\Desktop\Universidad\arquitectura\Taller_Micreoservicios\arquitecturaMicroServicios"
$services = @(
    @{name="Gateway API"; dir="LumenGatewayApi"; port=8000},
    @{name="Authors API"; dir="LumenAuthorsApi"; port=8001},
    @{name="Books API"; dir="LumenBooksApi"; port=8002},
    @{name="Ratings API"; dir="LumenRatingsApi"; port=8007}
)

$processes = @()

# Iniciar cada servicio
foreach ($service in $services) {
    $servicePath = Join-Path $baseDir $service.dir
    $publicPath = Join-Path $servicePath "public"
    
    Write-Host "Iniciando $($service.name) en puerto $($service.port)..." -ForegroundColor Cyan
    
    if (Test-Path $publicPath) {
        $arguments = "-S localhost:$($service.port) -t $publicPath"
        $process = Start-Process -FilePath "php" -ArgumentList $arguments -WindowStyle Hidden -PassThru -WorkingDirectory $servicePath
        
        $processes += @{
            service = $service.name
            pid = $process.Id
            port = $service.port
            dir = $service.dir
        }
        
        Write-Host "  ✓ PID: $($process.Id)" -ForegroundColor Green
    } else {
        Write-Host "  ✗ Directorio no encontrado: $publicPath" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Esperando que los servidores se inicien..." -ForegroundColor Yellow
Start-Sleep -Seconds 3

Write-Host ""
Write-Host "================================================" -ForegroundColor Yellow
Write-Host "SERVICIOS INICIADOS" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Yellow
Write-Host ""

foreach ($proc in $processes) {
    Write-Host "✓ $($proc.service): http://localhost:$($proc.port)" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "Gateway URL: http://localhost:8000" -ForegroundColor Green
Write-Host ""
Write-Host "NOTA: Los servicios están corriendo en segundo plano." -ForegroundColor Yellow
Write-Host "Para detener todos, ejecute: Get-Process php | Stop-Process -Force" -ForegroundColor Gray
