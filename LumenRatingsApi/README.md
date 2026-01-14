# Ratings Service (Servicio de Calificaciones)

Microservicio para gestionar calificaciones de libros (1-5 estrellas).

## 📋 Descripción

Este servicio permite a los usuarios calificar libros con estrellas de 1 a 5. Diferente del Reviews Service, este servicio solo maneja la calificación numérica sin comentarios.

## 🎯 Características

- ✅ Crear, leer, actualizar y eliminar calificaciones
- ✅ Un usuario solo puede calificar un libro una vez (validación de unicidad)
- ✅ Calcular promedio de calificaciones por libro
- ✅ Listar todas las calificaciones de un libro específico

## 🔌 Endpoints

### Listar todas las calificaciones
```
GET /ratings
```

### Obtener una calificación específica
```
GET /ratings/{id}
```

### Crear una nueva calificación
```
POST /ratings
Content-Type: application/json

{
    "rating": 4,
    "book_id": 1,
    "user_id": 1
}
```

### Actualizar una calificación
```
PUT /ratings/{id}
Content-Type: application/json

{
    "rating": 5
}
```

### Eliminar una calificación
```
DELETE /ratings/{id}
```

### Obtener todas las calificaciones de un libro
```
GET /ratings/book/{book_id}
```

### Obtener promedio de calificaciones de un libro
```
GET /ratings/book/{book_id}/average
```

Respuesta:
```json
{
    "data": {
        "book_id": 1,
        "average": 4.5,
        "count": 10
    }
}
```

## 🗃️ Base de Datos

Tabla `ratings`:
- `id` (integer, PK)
- `rating` (integer, 1-5)
- `book_id` (integer)
- `user_id` (integer)
- `created_at` (timestamp)
- `updated_at` (timestamp)
- Índice único: (user_id, book_id)

## ✅ Validaciones

- Rating debe estar entre 1 y 5
- Un usuario solo puede calificar un libro una vez
- book_id y user_id son requeridos

## 🚀 Puerto

**Puerto sugerido**: `8007`

## 📝 Instalación

### 1. Instalar dependencias
```bash
cd LumenRatingsApi
composer install
```

### 2. Configurar archivo .env
```bash
cp .env.example .env
```

### 3. Generar clave de aplicación
```bash
php artisan key:generate
```

### 4. Ejecutar migraciones
```bash
php artisan migrate
```

### 5. Iniciar el servidor
```bash
php -S localhost:8007 -t public
```

## 🧪 Prueba rápida

```bash
# Crear una calificación
curl -X POST http://localhost:8007/ratings \
  -H "Content-Type: application/json" \
  -d '{"rating": 5, "book_id": 1, "user_id": 1}'

# Obtener todas las calificaciones
curl http://localhost:8007/ratings

# Obtener promedio de un libro
curl http://localhost:8007/ratings/book/1/average
```

## 📚 Conceptos Aprendidos

- CRUD básico con Lumen
- Validación de datos y unicidad
- Cálculos agregados (promedio)
- Índices únicos en base de datos
- Respuestas estandarizadas
- Integración con microservicios
