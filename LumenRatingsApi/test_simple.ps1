# Script simple para probar los endpoints

$baseDir = "c:\Users\busta\Desktop\Universidad\arquitectura\Taller_Micreoservicios\arquitecturaMicroServicios\LumenRatingsApi"
Set-Location $baseDir

# Iniciar servidor en background
Write-Host "Iniciando servidor..." -ForegroundColor Cyan
$serverProcess = Start-Process -FilePath "php" -ArgumentList "-S 127.0.0.1:8007 -t public" -WindowStyle Hidden -PassThru
Start-Sleep -Seconds 3

$uri = "http://127.0.0.1:8007"
$passed = 0
$failed = 0

Write-Host "`n=== TEST 1: GET /ratings ===" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$uri/ratings" -Method GET
    Write-Host "Status: $($response.StatusCode)" -ForegroundColor Green
    $response.Content | ConvertFrom-Json | ConvertTo-Json -Depth 2
    $passed++
} catch {
    Write-Host "ERROR: $_" -ForegroundColor Red
    $failed++
}

Write-Host "`n=== TEST 2: POST /ratings ===" -ForegroundColor Yellow
try {
    $body = @{rating=5; book_id=1; user_id=1} | ConvertTo-Json
    $response = Invoke-WebRequest -Uri "$uri/ratings" -Method POST -Body $body -ContentType "application/json"
    Write-Host "Status: $($response.StatusCode)" -ForegroundColor Green
    $response.Content | ConvertFrom-Json | ConvertTo-Json -Depth 2
    $passed++
} catch {
    Write-Host "ERROR: $_" -ForegroundColor Red
    $failed++
}

Write-Host "`n=== TEST 3: GET /ratings/1 ===" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$uri/ratings/1" -Method GET
    Write-Host "Status: $($response.StatusCode)" -ForegroundColor Green
    $response.Content | ConvertFrom-Json | ConvertTo-Json -Depth 2
    $passed++
} catch {
    Write-Host "ERROR: $_" -ForegroundColor Red
    $failed++
}

Write-Host "`n=== TEST 4: PUT /ratings/1 ===" -ForegroundColor Yellow
try {
    $body = @{rating=4} | ConvertTo-Json
    $response = Invoke-WebRequest -Uri "$uri/ratings/1" -Method PUT -Body $body -ContentType "application/json"
    Write-Host "Status: $($response.StatusCode)" -ForegroundColor Green
    $response.Content | ConvertFrom-Json | ConvertTo-Json -Depth 2
    $passed++
} catch {
    Write-Host "ERROR: $_" -ForegroundColor Red
    $failed++
}

Write-Host "`n=== TEST 5: DELETE /ratings/1 ===" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$uri/ratings/1" -Method DELETE
    Write-Host "Status: $($response.StatusCode)" -ForegroundColor Green
    $response.Content | ConvertFrom-Json | ConvertTo-Json -Depth 2
    $passed++
} catch {
    Write-Host "ERROR: $_" -ForegroundColor Red
    $failed++
}

Write-Host "`n=== TEST 6: GET /ratings/book/1 ===" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$uri/ratings/book/1" -Method GET
    Write-Host "Status: $($response.StatusCode)" -ForegroundColor Green
    $response.Content | ConvertFrom-Json | ConvertTo-Json -Depth 2
    $passed++
} catch {
    Write-Host "ERROR: $_" -ForegroundColor Red
    $failed++
}

Write-Host "`n=== TEST 7: GET /ratings/book/1/average ===" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$uri/ratings/book/1/average" -Method GET
    Write-Host "Status: $($response.StatusCode)" -ForegroundColor Green
    $response.Content | ConvertFrom-Json | ConvertTo-Json -Depth 2
    $passed++
} catch {
    Write-Host "ERROR: $_" -ForegroundColor Red
    $failed++
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Resumen: $passed pasadas, $failed fallidas" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan

Stop-Process -Id $serverProcess.Id -Force
