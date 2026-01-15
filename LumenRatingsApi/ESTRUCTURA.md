# Ratings Service - Estructura del Proyecto

```
LumenRatingsApi/
├── app/
│   ├── Rating.php                          # Modelo Eloquent para ratings
│   ├── Exceptions/
│   │   └── Handler.php                    # Manejador de excepciones
│   ├── Http/
│   │   └── Controllers/
│   │       ├── Controller.php             # Controlador base
│   │       └── RatingController.php       # Controlador de ratings
│   ├── Providers/
│   │   └── AppServiceProvider.php         # Proveedor de servicios
│   ├── Console/
│   │   └── Kernel.php                     # Kernel de consola
│   └── Traits/
│       └── ApiResponser.php               # Trait para respuestas JSON
│
├── bootstrap/
│   └── app.php                            # Bootstrap de la aplicación
│
├── config/
│   ├── database.php                       # Configuración de base de datos
│   └── services.php                       # Configuración de servicios externos
│
├── database/
│   └── migrations/
│       ├── 2019_08_19_000000_create_failed_jobs_table.php
│       └── 2024_01_14_000000_create_ratings_table.php
│
├── public/
│   └── index.php                          # Punto de entrada de la aplicación
│
├── routes/
│   └── web.php                            # Definición de rutas
│
├── storage/
│   ├── app/
│   ├── framework/
│   │   └── cache/
│   └── logs/
│
├── tests/
│   ├── TestCase.php                       # Clase base para tests
│   └── ExampleTest.php                    # Test de ejemplo
│
├── .env                                   # Variables de entorno
├── .gitignore                             # Archivos ignorados por git
├── artisan                                # CLI de Laravel
├── composer.json                          # Dependencias del proyecto
├── phpunit.xml                            # Configuración de tests
└── README.md                              # Documentación del servicio
```

## 📝 Notas

- **Modelo**: `Rating.php` define la estructura de datos
- **Controlador**: `RatingController.php` contiene la lógica CRUD
- **Rutas**: `routes/web.php` define los endpoints disponibles
- **BD**: `database/migrations/` contiene el esquema de la base de datos
- **Respuestas**: `ApiResponser.php` estandariza las respuestas JSON
