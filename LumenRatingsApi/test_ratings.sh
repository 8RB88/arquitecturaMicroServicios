#!/bin/bash

# Script para probar el Ratings Service

echo "==============================================="
echo "Pruebas del Ratings Service"
echo "==============================================="

BASE_URL="http://localhost:8007"

echo -e "\n[TEST 1] GET /ratings - Listar todas las calificaciones"
curl -X GET "$BASE_URL/ratings" \
  -H "Accept: application/json" \
  -s | jq . || echo "Error en la solicitud"

echo -e "\n\n[TEST 2] POST /ratings - Crear una calificación"
curl -X POST "$BASE_URL/ratings" \
  -H "Content-Type: application/json" \
  -d '{
    "rating": 5,
    "book_id": 1,
    "user_id": 1
  }' \
  -s | jq . || echo "Error en la solicitud"

echo -e "\n\n[TEST 3] GET /ratings/book/1 - Obtener calificaciones de un libro"
curl -X GET "$BASE_URL/ratings/book/1" \
  -H "Accept: application/json" \
  -s | jq . || echo "Error en la solicitud"

echo -e "\n\n[TEST 4] GET /ratings/book/1/average - Obtener promedio de un libro"
curl -X GET "$BASE_URL/ratings/book/1/average" \
  -H "Accept: application/json" \
  -s | jq . || echo "Error en la solicitud"

echo -e "\n\n[TEST 5] GET /ratings/1 - Obtener una calificación específica"
curl -X GET "$BASE_URL/ratings/1" \
  -H "Accept: application/json" \
  -s | jq . || echo "Error en la solicitud"

echo -e "\n\n[TEST 6] PUT /ratings/1 - Actualizar una calificación"
curl -X PUT "$BASE_URL/ratings/1" \
  -H "Content-Type: application/json" \
  -d '{
    "rating": 4
  }' \
  -s | jq . || echo "Error en la solicitud"

echo -e "\n\n[TEST 7] Intentar crear una calificación duplicada (debe fallar)"
curl -X POST "$BASE_URL/ratings" \
  -H "Content-Type: application/json" \
  -d '{
    "rating": 3,
    "book_id": 1,
    "user_id": 1
  }' \
  -s | jq . || echo "Error en la solicitud"

echo -e "\n\n==============================================="
echo "✅ Pruebas completadas"
echo "===============================================\n"
