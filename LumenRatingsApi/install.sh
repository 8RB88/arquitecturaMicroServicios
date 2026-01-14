#!/bin/bash

# Script para instalar y ejecutar el Ratings Service

echo "==============================================="
echo "Instalación del Ratings Service"
echo "==============================================="

# 1. Instalar dependencias
echo -e "\n[1/5] Instalando dependencias con Composer..."
composer install
if [ $? -ne 0 ]; then
    echo "Error al instalar dependencias"
    exit 1
fi

# 2. Crear archivo .env si no existe
if [ ! -f .env ]; then
    echo -e "\n[2/5] Creando archivo .env..."
    cp .env .env.local 2>/dev/null || echo "Archivo .env ya existe"
fi

# 3. Generar clave de aplicación
echo -e "\n[3/5] Generando clave de aplicación..."
php artisan key:generate

# 4. Crear base de datos SQLite
echo -e "\n[4/5] Creando base de datos SQLite..."
if [ ! -f database/database.sqlite ]; then
    touch database/database.sqlite
fi

# 5. Ejecutar migraciones
echo -e "\n[5/5] Ejecutando migraciones..."
php artisan migrate --force

echo -e "\n==============================================="
echo "✅ Instalación completada"
echo "==============================================="
echo ""
echo "Para iniciar el servidor, ejecuta:"
echo "  php -S localhost:8007 -t public"
echo ""
