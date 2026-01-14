# Script para levantar todos los microservicios

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

# Probar cada servicio
Write-Host ""
Write-Host "================================================" -ForegroundColor Yellow
Write-Host "PROBANDO SERVICIOS" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Yellow
Write-Host ""

$passed = 0
$failed = 0

foreach ($service in $services) {
    $url = "http://localhost:$($service.port)/ratings"
    
    # Ajustar URL según el servicio
    if ($service.name -eq "Authors API") { $url = "http://localhost:$($service.port)/authors" }
    if ($service.name -eq "Books API") { $url = "http://localhost:$($service.port)/books" }
    if ($service.name -eq "Gateway API") { $url = "http://localhost:$($service.port)/status" }
    
    Write-Host "Probando $($service.name)..." -ForegroundColor Cyan
    
    try {
        $response = (New-Object System.Net.WebClient).DownloadString($url)
        Write-Host "  ✓ Status: 200 OK" -ForegroundColor Green
        Write-Host "  Response: $($response.Substring(0, [Math]::Min(80, $response.Length)))..." -ForegroundColor Gray
        $passed++
    }
    catch {
        Write-Host "  ✗ Error: No responde en puerto $($service.port)" -ForegroundColor Red
        $failed++
    }
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Yellow
Write-Host "RESUMEN" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "Servicios iniciados: $($processes.Count)" -ForegroundColor Cyan
Write-Host "Servicios respondiendo: $passed" -ForegroundColor Green
Write-Host "Servicios sin respuesta: $failed" -ForegroundColor Red
Write-Host ""
Write-Host "URLs de acceso:" -ForegroundColor Yellow
foreach ($proc in $processes) {
    Write-Host "  - $($proc.service): http://localhost:$($proc.port)" -ForegroundColor Cyan
}
Write-Host ""
Write-Host "Para detener los servicios, ejecute: Stop-Process -Id <PID> -Force" -ForegroundColor Yellow
Write-Host ""
Write-Host "Presione CTRL+C para finalizar este script (servicios seguirán corriendo)" -ForegroundColor Gray
Write-Host ""

# Mantener el script ejecutándose
Write-Host "ESTADO EN VIVO:" -ForegroundColor Yellow
while ($true) {
    Clear-Host
    
    Write-Host "================================================" -ForegroundColor Yellow
    Write-Host "ESTADO DE SERVICIOS - $(Get-Date -Format 'HH:mm:ss')" -ForegroundColor Green
    Write-Host "================================================" -ForegroundColor Yellow
    Write-Host ""
    
    foreach ($proc in $processes) {
        $ps = Get-Process -Id $proc.pid -ErrorAction SilentlyContinue
        
        if ($ps) {
            try {
                $url = "http://localhost:$($proc.port)/"
                $response = (New-Object System.Net.WebClient).DownloadString($url)
                Write-Host "✓ $($proc.service) (PID: $($proc.pid)) - Puerto $($proc.port) - ACTIVO" -ForegroundColor Green
            }
            catch {
                Write-Host "⚠ $($proc.service) (PID: $($proc.pid)) - Puerto $($proc.port) - NO RESPONDE" -ForegroundColor Yellow
            }
        } else {
            Write-Host "✗ $($proc.service) - DETENIDO" -ForegroundColor Red
        }
    }
    
    Write-Host ""
    Write-Host "URLs:" -ForegroundColor Cyan
    Write-Host "  Gateway:  http://localhost:8000" -ForegroundColor Cyan
    Write-Host "  Authors:  http://localhost:8001" -ForegroundColor Cyan
    Write-Host "  Books:    http://localhost:8002" -ForegroundColor Cyan
    Write-Host "  Ratings:  http://localhost:8007" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Presione CTRL+C para salir... (Última actualización: $(Get-Date -Format 'HH:mm:ss'))" -ForegroundColor Gray
    
    Start-Sleep -Seconds 5
}
