# Script de pruebas para Windows PowerShell
# Guarda este archivo como: test_ratings.ps1
# Ejecución: PowerShell -File test_ratings.ps1

$BASE_URL = "http://localhost:8007"

Write-Host "==============================================="
Write-Host "Pruebas del Ratings Service"
Write-Host "==============================================="

Write-Host ""
Write-Host "[TEST 1] GET /ratings - Listar todas las calificaciones" -ForegroundColor Cyan
Invoke-WebRequest -Uri "$BASE_URL/ratings" -Method Get -Headers @{"Accept" = "application/json"} | Select-Object -ExpandProperty Content | ConvertFrom-Json | ConvertTo-Json

Write-Host ""
Write-Host "[TEST 2] POST /ratings - Crear una calificación" -ForegroundColor Cyan
$body = @{
    rating = 5
    book_id = 1
    user_id = 1
} | ConvertTo-Json

try {
    Invoke-WebRequest -Uri "$BASE_URL/ratings" `
        -Method Post `
        -Headers @{"Content-Type" = "application/json"} `
        -Body $body | Select-Object -ExpandProperty Content | ConvertFrom-Json | ConvertTo-Json
} catch {
    Write-Host "Error: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "[TEST 3] GET /ratings/book/1 - Obtener calificaciones de un libro" -ForegroundColor Cyan
Invoke-WebRequest -Uri "$BASE_URL/ratings/book/1" -Method Get -Headers @{"Accept" = "application/json"} | Select-Object -ExpandProperty Content | ConvertFrom-Json | ConvertTo-Json

Write-Host ""
Write-Host "[TEST 4] GET /ratings/book/1/average - Obtener promedio de un libro" -ForegroundColor Cyan
Invoke-WebRequest -Uri "$BASE_URL/ratings/book/1/average" -Method Get -Headers @{"Accept" = "application/json"} | Select-Object -ExpandProperty Content | ConvertFrom-Json | ConvertTo-Json

Write-Host ""
Write-Host "[TEST 5] GET /ratings/1 - Obtener una calificación específica" -ForegroundColor Cyan
try {
    Invoke-WebRequest -Uri "$BASE_URL/ratings/1" -Method Get -Headers @{"Accept" = "application/json"} | Select-Object -ExpandProperty Content | ConvertFrom-Json | ConvertTo-Json
} catch {
    Write-Host "Error: La calificación no existe" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "[TEST 6] PUT /ratings/1 - Actualizar una calificación" -ForegroundColor Cyan
$updateBody = @{
    rating = 4
} | ConvertTo-Json

try {
    Invoke-WebRequest -Uri "$BASE_URL/ratings/1" `
        -Method Put `
        -Headers @{"Content-Type" = "application/json"} `
        -Body $updateBody | Select-Object -ExpandProperty Content | ConvertFrom-Json | ConvertTo-Json
} catch {
    Write-Host "Error: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "[TEST 7] Intentar crear una calificación duplicada (debe fallar)" -ForegroundColor Cyan
$duplicateBody = @{
    rating = 3
    book_id = 1
    user_id = 1
} | ConvertTo-Json

try {
    Invoke-WebRequest -Uri "$BASE_URL/ratings" `
        -Method Post `
        -Headers @{"Content-Type" = "application/json"} `
        -Body $duplicateBody | Select-Object -ExpandProperty Content | ConvertFrom-Json | ConvertTo-Json
} catch {
    Write-Host "Esperado: Error de validación (usuario ya calificó este libro)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "==============================================="
Write-Host "✅ Pruebas completadas" -ForegroundColor Green
Write-Host "==============================================="
Write-Host ""
