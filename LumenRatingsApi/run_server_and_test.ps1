# Script para iniciar el servidor PHP y ejecutar tests

$ErrorActionPreference = "SilentlyContinue"

# Directorio base
$baseDir = "c:\Users\busta\Desktop\Universidad\arquitectura\Taller_Micreoservicios\arquitecturaMicroServicios\LumenRatingsApi"

Write-Host "========================================" -ForegroundColor Yellow
Write-Host "Ratings Service - Test Suite" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Yellow
Write-Host ""

# Cambiar al directorio
Set-Location $baseDir

# Iniciar el servidor en background
Write-Host "Iniciando servidor PHP en puerto 8007..." -ForegroundColor Cyan
$serverProcess = Start-Process -FilePath "php" -ArgumentList "-S 127.0.0.1:8007 -t public" -WindowStyle Hidden -PassThru
Start-Sleep -Seconds 3

Write-Host "Servidor iniciado (PID: $($serverProcess.Id))" -ForegroundColor Green
Write-Host ""

# Tests
$uri = "http://127.0.0.1:8007"
$testsPassed = 0
$testsFailed = 0

# Test 1: GET /ratings
Write-Host "Test 1: GET /ratings" -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri "$uri/ratings" -Method GET -ErrorAction Stop
    $content = $response.Content | ConvertFrom-Json
    Write-Host "✓ Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "Response: $(($content | ConvertTo-Json -Depth 2) | Select-Object -First 5)" -ForegroundColor Green
    $testsPassed++
} catch {
    Write-Host "✗ Error: $($_.Exception.Message)" -ForegroundColor Red
    $testsFailed++
}
Write-Host ""

# Test 2: POST /ratings (crear calificación)
Write-Host "Test 2: POST /ratings" -ForegroundColor Cyan
try {
    $body = @{
        rating = 5
        book_id = 1
        user_id = 1
    } | ConvertTo-Json
    
    $response = Invoke-WebRequest -Uri "$uri/ratings" -Method POST -Body $body -ContentType "application/json" -ErrorAction Stop
    $content = $response.Content | ConvertFrom-Json
    Write-Host "✓ Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "Response: $($content | ConvertTo-Json -Depth 2)" -ForegroundColor Green
    $testsPassed++
} catch {
    Write-Host "✗ Error: $($_.Exception.Message)" -ForegroundColor Red
    $testsFailed++
}
Write-Host ""

# Test 3: GET /ratings/1
Write-Host "Test 3: GET /ratings/1" -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri "$uri/ratings/1" -Method GET -ErrorAction Stop
    $content = $response.Content | ConvertFrom-Json
    Write-Host "✓ Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "Response: $($content | ConvertTo-Json -Depth 2)" -ForegroundColor Green
    $testsPassed++
} catch {
    Write-Host "✗ Error: $($_.Exception.Message)" -ForegroundColor Red
    $testsFailed++
}
Write-Host ""

# Test 4: PUT /ratings/1
Write-Host "Test 4: PUT /ratings/1" -ForegroundColor Cyan
try {
    $body = @{
        rating = 4
    } | ConvertTo-Json
    
    $response = Invoke-WebRequest -Uri "$uri/ratings/1" -Method PUT -Body $body -ContentType "application/json" -ErrorAction Stop
    $content = $response.Content | ConvertFrom-Json
    Write-Host "✓ Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "Response: $($content | ConvertTo-Json -Depth 2)" -ForegroundColor Green
    $testsPassed++
} catch {
    Write-Host "✗ Error: $($_.Exception.Message)" -ForegroundColor Red
    $testsFailed++
}
Write-Host ""

# Test 5: DELETE /ratings/1
Write-Host "Test 5: DELETE /ratings/1" -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri "$uri/ratings/1" -Method DELETE -ErrorAction Stop
    $content = $response.Content | ConvertFrom-Json
    Write-Host "✓ Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "Response: $($content | ConvertTo-Json -Depth 2)" -ForegroundColor Green
    $testsPassed++
} catch {
    Write-Host "✗ Error: $($_.Exception.Message)" -ForegroundColor Red
    $testsFailed++
}
Write-Host ""

# Test 6: GET /ratings/book/1
Write-Host "Test 6: GET /ratings/book/1" -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri "$uri/ratings/book/1" -Method GET -ErrorAction Stop
    $content = $response.Content | ConvertFrom-Json
    Write-Host "✓ Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "Response: $($content | ConvertTo-Json -Depth 2 | Select-Object -First 5)" -ForegroundColor Green
    $testsPassed++
} catch {
    Write-Host "✗ Error: $($_.Exception.Message)" -ForegroundColor Red
    $testsFailed++
}
Write-Host ""

# Test 7: GET /ratings/book/1/average
Write-Host "Test 7: GET /ratings/book/1/average" -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri "$uri/ratings/book/1/average" -Method GET -ErrorAction Stop
    $content = $response.Content | ConvertFrom-Json
    Write-Host "✓ Status: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "Response: $($content | ConvertTo-Json -Depth 2)" -ForegroundColor Green
    $testsPassed++
} catch {
    Write-Host "✗ Error: $($_.Exception.Message)" -ForegroundColor Red
    $testsFailed++
}
Write-Host ""

# Resumen
Write-Host "========================================" -ForegroundColor Yellow
Write-Host "Resumen de Pruebas" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Yellow
Write-Host "✓ Pruebas exitosas: $testsPassed" -ForegroundColor Green
Write-Host "✗ Pruebas fallidas: $testsFailed" -ForegroundColor Red
Write-Host "Total: $($testsPassed + $testsFailed)" -ForegroundColor Cyan
Write-Host ""

# Detener el servidor
Write-Host "Deteniendo servidor..." -ForegroundColor Yellow
Stop-Process -Id $serverProcess.Id -Force

Write-Host "¡Listo!" -ForegroundColor Green
