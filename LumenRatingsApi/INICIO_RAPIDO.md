# Guía de Inicio Rápido - Ratings Service

## ✅ Requisitos Previos

- PHP >= 7.2.5
- Composer
- Git

## 🚀 Instalación Rápida

### 1. Navegar al directorio del servicio

```bash
cd LumenRatingsApi
```

### 2. Instalar dependencias

```bash
composer install
```

### 3. Configurar archivo .env

El archivo `.env` ya está creado con la configuración básica. Asegúrate de que contenga:

```env
APP_NAME="Ratings Service"
APP_ENV=local
APP_DEBUG=true
APP_URL=http://localhost:8007
APP_KEY=

DB_CONNECTION=sqlite
DB_DATABASE=database.sqlite

BOOKS_SERVICE_BASE_URL=http://localhost:8002
```

### 4. Generar clave de aplicación

```bash
php artisan key:generate
```

### 5. Crear base de datos SQLite

```bash
touch database/database.sqlite
```

### 6. Ejecutar migraciones

```bash
php artisan migrate
```

### 7. Iniciar el servidor

```bash
php -S localhost:8007 -t public
```

## 🧪 Pruebas Rápidas

En otra terminal, prueba los endpoints:

### Ver todas las calificaciones

```bash
curl http://localhost:8007/ratings
```

### Crear una calificación

```bash
curl -X POST http://localhost:8007/ratings \
  -H "Content-Type: application/json" \
  -d '{
    "rating": 5,
    "book_id": 1,
    "user_id": 1
  }'
```

### Ver promedio de un libro

```bash
curl http://localhost:8007/ratings/book/1/average
```

## 📚 Estructura de Archivos Clave

```
LumenRatingsApi/
├── app/Rating.php                  ← Modelo de datos
├── app/Http/Controllers/RatingController.php  ← Lógica de controlador
├── routes/web.php                  ← Definición de rutas
└── database/migrations/             ← Esquema de BD
```

## 🔧 Configuración del Gateway (Opcional)

Si deseas acceder al Ratings Service a través del Gateway (puerto 8000), sigue los pasos en [INTEGRACION_GATEWAY.md](INTEGRACION_GATEWAY.md).

## 📝 Endpoints Disponibles

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | `/ratings` | Listar todas las calificaciones |
| POST | `/ratings` | Crear una nueva calificación |
| GET | `/ratings/{id}` | Obtener una calificación específica |
| PUT | `/ratings/{id}` | Actualizar una calificación |
| DELETE | `/ratings/{id}` | Eliminar una calificación |
| GET | `/ratings/book/{book_id}` | Obtener calificaciones de un libro |
| GET | `/ratings/book/{book_id}/average` | Obtener promedio de un libro |

## ⚠️ Validaciones Importantes

- **rating**: Debe ser un número entero entre 1 y 5
- **book_id**: ID del libro (requerido)
- **user_id**: ID del usuario (requerido)
- **Unicidad**: Un usuario solo puede calificar un libro una vez

## 🐛 Solución de Problemas

### Error: "Base URI is not configured"

Asegúrate de que las variables de entorno están configuradas en `.env`:

```bash
BOOKS_SERVICE_BASE_URL=http://localhost:8002
```

### Error: "Class 'App\Rating' not found"

Ejecuta las migraciones:

```bash
php artisan migrate
```

### Error de conexión al puerto 8007

Verifica que el puerto 8007 no esté en uso:

```bash
# Windows
netstat -ano | findstr :8007

# Linux/Mac
lsof -i :8007
```

## 📖 Documentación Adicional

- [ESTRUCTURA.md](ESTRUCTURA.md) - Descripción de la estructura del proyecto
- [INTEGRACION_GATEWAY.md](INTEGRACION_GATEWAY.md) - Cómo integrar con el Gateway
- [README.md](README.md) - Documentación completa del servicio

## ✨ Próximos Pasos

1. ✅ Crear calificaciones
2. ✅ Implementar validaciones adicionales
3. ✅ Integrar con el Gateway
4. ✅ Agregar autenticación
5. ✅ Implementar caché
