# 🚀 Proyecto Levantado y Listo para Probar

## Estado Actual

✅ **Todos los microservicios están corriendo**

### URLs de Acceso

| Servicio | URL | Puerto |
|----------|-----|--------|
| Gateway API | http://localhost:8000 | 8000 |
| Authors API | http://localhost:8001 | 8001 |
| Books API | http://localhost:8002 | 8002 |
| Ratings API | http://localhost:8007 | 8007 |

---

## 🧪 Ejemplos de Pruebas

### 1. Gateway API (Punto de Entrada)
```powershell
Invoke-WebRequest -Uri "http://localhost:8000/" -UseBasicParsing
```

### 2. Authors API
```powershell
# Listar autores
Invoke-WebRequest -Uri "http://localhost:8001/authors" -UseBasicParsing

# Crear autor
$body = @{ name="J.K. Rowling" } | ConvertTo-Json
Invoke-WebRequest -Uri "http://localhost:8001/authors" -Method POST -Body $body -ContentType "application/json"
```

### 3. Books API
```powershell
# Listar libros
Invoke-WebRequest -Uri "http://localhost:8002/books" -UseBasicParsing

# Crear libro
$body = @{ title="Harry Potter"; author_id=1 } | ConvertTo-Json
Invoke-WebRequest -Uri "http://localhost:8002/books" -Method POST -Body $body -ContentType "application/json"
```

### 4. Ratings API
```powershell
# Listar calificaciones
Invoke-WebRequest -Uri "http://localhost:8007/ratings" -UseBasicParsing

# Crear calificación
$body = @{ rating=5; book_id=1; user_id=1 } | ConvertTo-Json
Invoke-WebRequest -Uri "http://localhost:8007/ratings" -Method POST -Body $body -ContentType "application/json"

# Promedios de calificaciones
Invoke-WebRequest -Uri "http://localhost:8007/ratings/book/1/average" -UseBasicParsing
```

---

## 🛑 Detener los Servicios

Para detener todos los microservicios de una vez:

```powershell
Get-Process php | Stop-Process -Force
```

---

## 📋 Estructura del Proyecto

- **LumenGatewayApi**: API Gateway que orquesta las solicitudes
- **LumenAuthorsApi**: Servicio para gestionar autores
- **LumenBooksApi**: Servicio para gestionar libros
- **LumenRatingsApi**: Servicio para gestionar calificaciones de libros

---

## 📚 Documentación Adicional

Para más información sobre la arquitectura del proyecto, consulta:
- [arquitectura.md](arquitectura.md)
- [guiaEstudiante.md](guiaEstudiante.md)
- [README.md](README.md)

---

**Última actualización**: 14 de enero de 2026
