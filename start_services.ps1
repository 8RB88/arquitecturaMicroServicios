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
        $process = Start-Process -FilePath "php" `
            -ArgumentList "-S localhost:$($service.port) -t `"$publicPath`"" `
            -WindowStyle Hidden `
            -PassThru `
            -WorkingDirectory $servicePath
        
        $processes += @{
            service = $service.name
            pid = $process.Id
            port = $service.port
            dir = $service.dir
        }
        
        Write-Host "  OK - PID: $($process.Id)" -ForegroundColor Green
    } else {
        Write-Host "  FALLO - Directorio no encontrado" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Esperando inicializacion..." -ForegroundColor Yellow
Start-Sleep -Seconds 3

# Probar cada servicio
Write-Host ""
Write-Host "================================================" -ForegroundColor Yellow
Write-Host "PROBANDO SERVICIOS" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Yellow
Write-Host ""

$passed = 0
$failed = 0

foreach ($service in $services) {
    $url = "http://localhost:$($service.port)/"
    
    Write-Host "Probando $($service.name) en puerto $($service.port)..." -ForegroundColor Cyan
    
    try {
        $response = (New-Object System.Net.WebClient).DownloadString($url)
        Write-Host "  OK - Responde correctamente" -ForegroundColor Green
        $passed++
    } catch {
        Write-Host "  FALLO - No responde" -ForegroundColor Red
        $failed++
    }
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Yellow
Write-Host "RESUMEN" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "Servicios iniciados: $($processes.Count)" -ForegroundColor Cyan
Write-Host "Servicios activos: $passed" -ForegroundColor Green
Write-Host "Servicios sin respuesta: $failed" -ForegroundColor Red
Write-Host ""
Write-Host "URLs de acceso:" -ForegroundColor Yellow
foreach ($proc in $processes) {
    Write-Host "  - $($proc.service): http://localhost:$($proc.port)" -ForegroundColor Cyan
}
Write-Host ""
Write-Host "Servicios ejecutandose en background. Presione CTRL+C para finalizar." -ForegroundColor Yellow
Write-Host ""

# Mantener el script ejecutándose
while ($true) {
    Start-Sleep -Seconds 10
}
