# Ratings Service (Servicio de Calificaciones)

Microservicio para gestionar calificaciones de libros con estrellas (1-5) desarrollado con **Lumen**.

**Puerto:** `8007`  
**Complejidad:** ⭐ (Baja)

## 📋 Descripción

Este servicio permite a los usuarios calificar libros con un sistema de estrellas del 1 al 5. Maneja únicamente la calificación numérica (diferente del servicio de Reviews que maneja comentarios y texto).

## 🚀 Instalación Completa

### 1. Crear proyecto Lumen

```bash
composer create-project --prefer-dist laravel/lumen ratings-service
cd ratings-service
```

### 2. Configurar el archivo .env

```bash
cp .env.example .env
```

Editar `.env`:

```env
APP_NAME="Ratings Service"
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_TIMEZONE=UTC

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=ratings_service
DB_USERNAME=root
DB_PASSWORD=tu_password

CACHE_DRIVER=file
QUEUE_CONNECTION=sync
```

### 3. Crear la base de datos

```bash
mysql -u root -p
```

```sql
CREATE DATABASE ratings_service;
EXIT;
```

### 4. Crear la estructura de directorios

```bash
mkdir -p app/Models
mkdir -p app/Traits
```

### 5. Copiar los archivos

Copiar los siguientes archivos en su ubicación correspondiente:

```
ratings-service/
├── app/
│   ├── Models/
│   │   └── Rating.php
│   ├── Traits/
│   │   └── ApiResponser.php
│   └── Http/
│       └── Controllers/
│           └── RatingController.php
├── bootstrap/
│   └── app.php
├── database/
│   └── migrations/
│       └── xxxx_xx_xx_xxxxxx_create_ratings_table.php
├── routes/
│   └── web.php
└── .env
```

### 6. Configurar bootstrap/app.php

**IMPORTANTE:** Asegúrate de que `bootstrap/app.php` tenga habilitado Eloquent:

```php
$app->withEloquent();
```

### 7. Actualizar composer autoload

```bash
composer dump-autoload
```

### 8. Ejecutar las migraciones

```bash
php artisan migrate
```

### 9. Iniciar el servidor

```bash
php -S localhost:8007 -t public
```

El servicio estará disponible en: `http://localhost:8007`

### 10. Verificar instalación

```bash
curl http://localhost:8007
```

Deberías ver:
```json
{
  "service": "Ratings Service",
  "version": "Lumen (9.x.x)",
  "status": "running"
}
```

## 📡 Endpoints

### 1. Listar todas las calificaciones
```http
GET /ratings
```

**Ejemplo con cURL:**
```bash
curl http://localhost:8007/ratings
```

**Respuesta exitosa (200):**
```json
{
  "data": [
    {
      "id": 1,
      "rating": 5,
      "book_id": 1,
      "user_id": 1,
      "created_at": "2024-01-15T10:30:00.000000Z",
      "updated_at": "2024-01-15T10:30:00.000000Z"
    }
  ]
}
```

### 2. Obtener una calificación específica
```http
GET /ratings/{id}
```

**Ejemplo con cURL:**
```bash
curl http://localhost:8007/ratings/1
```

**Respuesta exitosa (200):**
```json
{
  "data": {
    "id": 1,
    "rating": 5,
    "book_id": 1,
    "user_id": 1,
    "created_at": "2024-01-15T10:30:00.000000Z",
    "updated_at": "2024-01-15T10:30:00.000000Z"
  }
}
```

**Error - No encontrado (404):**
```json
{
  "error": "Rating not found",
  "code": 404
}
```

### 3. Calificaciones de un libro
```http
GET /ratings/book/{book_id}
```

**Ejemplo con cURL:**
```bash
curl http://localhost:8007/ratings/book/1
```

**Respuesta exitosa (200):**
```json
{
  "data": [
    {
      "id": 1,
      "rating": 5,
      "book_id": 1,
      "user_id": 1,
      "created_at": "2024-01-15T10:30:00.000000Z",
      "updated_at": "2024-01-15T10:30:00.000000Z"
    },
    {
      "id": 2,
      "rating": 4,
      "book_id": 1,
      "user_id": 2,
      "created_at": "2024-01-15T11:00:00.000000Z",
      "updated_at": "2024-01-15T11:00:00.000000Z"
    }
  ]
}
```

### 4. Promedio de calificaciones de un libro
```http
GET /ratings/book/{book_id}/average
```

**Ejemplo con cURL:**
```bash
curl http://localhost:8007/ratings/book/1/average
```

**Respuesta exitosa (200):**
```json
{
  "book_id": 1,
  "average": 4.5,
  "total_ratings": 2
}
```

Si no hay calificaciones:
```json
{
  "book_id": 1,
  "average": 0,
  "total_ratings": 0
}
```

### 5. Crear una calificación
```http
POST /ratings
Content-Type: application/json

{
  "rating": 5,
  "book_id": 1,
  "user_id": 1
}
```

**Ejemplo con cURL:**
```bash
curl -X POST http://localhost:8007/ratings \
  -H "Content-Type: application/json" \
  -d '{
    "rating": 5,
    "book_id": 1,
    "user_id": 1
  }'
```

**Respuesta exitosa (201):**
```json
{
  "data": {
    "id": 1,
    "rating": 5,
    "book_id": 1,
    "user_id": 1,
    "created_at": "2024-01-15T10:30:00.000000Z",
    "updated_at": "2024-01-15T10:30:00.000000Z"
  }
}
```

**Error - Validación (422):**
```json
{
  "rating": [
    "The rating must be between 1 and 5."
  ]
}
```

**Error - Usuario ya calificó el libro (409):**
```json
{
  "error": "User has already rated this book. Use PUT to update the rating.",
  "code": 409
}
```

### 6. Actualizar una calificación
```http
PUT /ratings/{id}
Content-Type: application/json

{
  "rating": 4
}
```

**Ejemplo con cURL:**
```bash
curl -X PUT http://localhost:8007/ratings/1 \
  -H "Content-Type: application/json" \
  -d '{"rating": 4}'
```

**Respuesta exitosa (200):**
```json
{
  "data": {
    "id": 1,
    "rating": 4,
    "book_id": 1,
    "user_id": 1,
    "created_at": "2024-01-15T10:30:00.000000Z",
    "updated_at": "2024-01-15T12:00:00.000000Z"
  }
}
```

### 7. Eliminar una calificación
```http
DELETE /ratings/{id}
```

**Ejemplo con cURL:**
```bash
curl -X DELETE http://localhost:8007/ratings/1
```

**Respuesta exitosa (200):**
```json
{
  "message": "Rating deleted successfully"
}
```

## 🗄️ Modelo de Datos

### Tabla: `ratings`

| Campo | Tipo | Descripción | Restricciones |
|-------|------|-------------|---------------|
| `id` | BIGINT | Identificador único (PK) | AUTO_INCREMENT |
| `rating` | INTEGER | Calificación (1-5) | NOT NULL, CHECK (1-5) |
| `book_id` | BIGINT | ID del libro | NOT NULL |
| `user_id` | BIGINT | ID del usuario | NOT NULL |
| `created_at` | TIMESTAMP | Fecha de creación | NULL |
| `updated_at` | TIMESTAMP | Fecha de actualización | NULL |

**Constraints:**
- `rating` debe estar entre 1 y 5 (CHECK constraint)
- Índice único en `(book_id, user_id)` para evitar calificaciones duplicadas
- Índices en `book_id` y `user_id` para mejorar el rendimiento

## 🔗 Relaciones con otros servicios

### Servicios que consumen este:
- **Gateway**: Para enrutar peticiones
- **Recommendations Service**: Para recomendar libros mejor calificados
- **Analytics Service**: Para estadísticas y análisis

### Servicios que este consume:
- **Books Service**: Para validar que el libro existe
- **Users Service**: Para validar que el usuario existe

## 🎯 Conceptos Aprendidos

1. **Configuración de Lumen**: Habilitar Eloquent, configurar rutas
2. **Cálculos agregados**: Implementación de promedios con `avg()`
3. **Validación de unicidad**: Restricción única compuesta `(book_id, user_id)`
4. **Operaciones matemáticas**: Cálculo de promedios y redondeo con `round()`
5. **Validación de rangos**: Rating debe estar entre 1 y 5
6. **Manejo de errores específicos**: Códigos HTTP apropiados (404, 409, 422, 500)
7. **Trait para respuestas**: Estandarización de respuestas JSON

## 🧪 Pruebas Completas con cURL

### Caso 1: Crear varias calificaciones
```bash
# Usuario 1 califica libro 1 con 5 estrellas
curl -X POST http://localhost:8007/ratings \
  -H "Content-Type: application/json" \
  -d '{"rating": 5, "book_id": 1, "user_id": 1}'

# Usuario 2 califica libro 1 con 4 estrellas
curl -X POST http://localhost:8007/ratings \
  -H "Content-Type: application/json" \
  -d '{"rating": 4, "book_id": 1, "user_id": 2}'

# Usuario 3 califica libro 1 con 3 estrellas
curl -X POST http://localhost:8007/ratings \
  -H "Content-Type: application/json" \
  -d '{"rating": 3, "book_id": 1, "user_id": 3}'
```

### Caso 2: Ver promedio del libro
```bash
curl http://localhost:8007/ratings/book/1/average
# Resultado esperado: {"book_id":1,"average":4,"total_ratings":3}
```

### Caso 3: Intentar calificación duplicada (debe fallar)
```bash
curl -X POST http://localhost:8007/ratings \
  -H "Content-Type: application/json" \
  -d '{"rating": 5, "book_id": 1, "user_id": 1}'
# Resultado esperado: Error 409
```

### Caso 4: Actualizar una calificación
```bash
# Primero obtener el ID de la calificación
curl http://localhost:8007/ratings/book/1

# Actualizar la calificación (usar el ID obtenido)
curl -X PUT http://localhost:8007/ratings/1 \
  -H "Content-Type: application/json" \
  -d '{"rating": 5}'
```

### Caso 5: Validación de rango (debe fallar)
```bash
# Rating fuera de rango
curl -X POST http://localhost:8007/ratings \
  -H "Content-Type: application/json" \
  -d '{"rating": 10, "book_id": 1, "user_id": 10}'
# Resultado esperado: Error 422
```

## 📝 Notas Importantes para Lumen

1. **Eloquent debe estar habilitado**: En `bootstrap/app.php` debe haber `$app->withEloquent();`

2. **Validación en Lumen**: Se usa `$this->validate()` en el controlador, no `$request->validate()`

3. **Rutas en Lumen**: Se definen con `$router->get()`, `$router->post()`, etc.

4. **Tipado en Lumen**: Los parámetros de ruta llegan como strings, convertir a int cuando sea necesario

5. **Un usuario solo puede calificar un libro una vez**: Constraint único lo garantiza

6. **El promedio se calcula en tiempo real**: No se almacena en BD

## 🚨 Validaciones Implementadas

- `rating`: Requerido, entero, entre 1 y 5
- `book_id`: Requerido, entero positivo (mínimo 1)
- `user_id`: Requerido, entero positivo (mínimo 1)
- Unicidad: `(book_id, user_id)` debe ser única (manejado por índice único)

## 📊 Códigos de Estado HTTP

- `200`: Operación exitosa (GET, PUT, DELETE)
- `201`: Calificación creada exitosamente (POST)
- `404`: Calificación no encontrada
- `409`: Conflicto - Usuario ya calificó este libro
- `422`: Error de validación (datos inválidos)
- `500`: Error interno del servidor

## ⚠️ Troubleshooting

### Error: "Class 'App\Models\Rating' not found"
```bash
composer dump-autoload
```

### Error: "SQLSTATE[42S02]: Base table or view not found"
```bash
php artisan migrate
```

### Error: "Call to undefined method"
Asegúrate de que `bootstrap/app.php` tenga:
```php
$app->withEloquent();
```

### El servidor no inicia en el puerto 8007
```bash
# Verificar si el puerto está en uso
lsof -i :8007

# O usar otro puerto
php -S localhost:8008 -t public
```