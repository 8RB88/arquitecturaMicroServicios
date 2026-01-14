# Guía de Integración: Ratings Service con Gateway

## 📋 Resumen

Este documento describe cómo integrar el Ratings Service con el API Gateway. El Ratings Service es un microservicio independiente que corre en el puerto 8007 y proporciona endpoints para crear, leer, actualizar y eliminar calificaciones de libros.

## 🔧 Pasos de Integración

### 1. Agregar Configuración del Servicio en el Gateway

Editar `LumenGatewayApi/config/services.php`:

```php
<?php

return [
    'authors' => [
        'base_uri' => env('AUTHORS_SERVICE_BASE_URL'),
        'secret' => env('AUTHORS_SERVICE_SECRET'),
    ],

    'books' => [
        'base_uri' => env('BOOKS_SERVICE_BASE_URL'),
        'secret' => env('BOOKS_SERVICE_SECRET'),
    ],

    // AGREGAR ESTO:
    'ratings' => [
        'base_uri' => env('RATINGS_SERVICE_BASE_URL'),
        'secret' => env('RATINGS_SERVICE_SECRET'),
    ],
];
```

### 2. Actualizar archivo .env del Gateway

Agregar a `LumenGatewayApi/.env`:

```env
RATINGS_SERVICE_BASE_URL=http://localhost:8007
RATINGS_SERVICE_SECRET=
```

### 3. Crear RatingService en el Gateway

Crear archivo `LumenGatewayApi/app/Services/RatingService.php`:

```php
<?php

namespace App\Services;

use App\Traits\ConsumesExternalService;

class RatingService
{
    use ConsumesExternalService;

    /**
     * The base uri to be used to consume the ratings service
     * @var string
     */
    public $baseUri;

    /**
     * The secret to be used to consume the ratings service
     * @var string
     */
    public $secret;

    public function __construct()
    {
        $this->baseUri = config('services.ratings.base_uri');
        $this->secret = config('services.ratings.secret');
        
        if (empty($this->baseUri)) {
            throw new \RuntimeException('RATINGS_SERVICE_BASE_URL is not configured in .env file');
        }
    }

    /**
     * Get all ratings
     * @return array
     */
    public function obtainRatings()
    {
        return $this->performRequest('GET', '/ratings');
    }

    /**
     * Create a rating
     * @return array
     */
    public function createRating($data)
    {
        return $this->performRequest('POST', '/ratings', $data);
    }

    /**
     * Get a single rating
     * @return array
     */
    public function obtainRating($rating)
    {
        return $this->performRequest('GET', "/ratings/{$rating}");
    }

    /**
     * Edit a rating
     * @return array
     */
    public function editRating($data, $rating)
    {
        return $this->performRequest('PUT', "/ratings/{$rating}", $data);
    }

    /**
     * Delete a rating
     * @return array
     */
    public function deleteRating($rating)
    {
        return $this->performRequest('DELETE', "/ratings/{$rating}");
    }

    /**
     * Get ratings by book
     * @return array
     */
    public function obtainRatingsByBook($book_id)
    {
        return $this->performRequest('GET', "/ratings/book/{$book_id}");
    }

    /**
     * Get average rating for a book
     * @return array
     */
    public function obtainAverageRating($book_id)
    {
        return $this->performRequest('GET', "/ratings/book/{$book_id}/average");
    }
}
```

### 4. Crear RatingController en el Gateway

Crear archivo `LumenGatewayApi/app/Http/Controllers/RatingController.php`:

```php
<?php

namespace App\Http\Controllers;

use App\Services\BookService;
use App\Services\RatingService;
use App\Traits\ApiResponser;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

class RatingController extends Controller
{
    use ApiResponser;

    /**
     * The book service instance
     * @var BookService
     */
    public $bookService;

    /**
     * The rating service instance
     * @var RatingService
     */
    public $ratingService;

    /**
     * Create a new controller instance
     * @return void
     */
    public function __construct(BookService $bookService, RatingService $ratingService)
    {
        $this->bookService = $bookService;
        $this->ratingService = $ratingService;
    }

    /**
     * Display a listing of ratings
     * @return Illuminate\Http\Response
     */
    public function index()
    {
        return $this->successResponse($this->ratingService->obtainRatings());
    }

    /**
     * Store a newly created rating
     * @return Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        // Validar que el libro existe
        try {
            $this->bookService->obtainBook($request->book_id);
        } catch (\Exception $e) {
            return $this->errorResponse('El libro especificado no existe', Response::HTTP_NOT_FOUND);
        }

        $rating = $this->ratingService->createRating($request->all());

        return $this->successResponse($rating, Response::HTTP_CREATED);
    }

    /**
     * Display a specific rating
     * @return Illuminate\Http\Response
     */
    public function show($id)
    {
        return $this->successResponse($this->ratingService->obtainRating($id));
    }

    /**
     * Update a specific rating
     * @return Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        $rating = $this->ratingService->editRating($request->all(), $id);

        return $this->successResponse($rating);
    }

    /**
     * Delete a specific rating
     * @return Illuminate\Http\Response
     */
    public function destroy($id)
    {
        return $this->successResponse($this->ratingService->deleteRating($id));
    }

    /**
     * Get ratings by book
     * @return Illuminate\Http\Response
     */
    public function ratingsByBook($book_id)
    {
        // Validar que el libro existe
        try {
            $this->bookService->obtainBook($book_id);
        } catch (\Exception $e) {
            return $this->errorResponse('El libro especificado no existe', Response::HTTP_NOT_FOUND);
        }

        return $this->successResponse($this->ratingService->obtainRatingsByBook($book_id));
    }

    /**
     * Get average rating for a book
     * @return Illuminate\Http\Response
     */
    public function averageRating($book_id)
    {
        // Validar que el libro existe
        try {
            $this->bookService->obtainBook($book_id);
        } catch (\Exception $e) {
            return $this->errorResponse('El libro especificado no existe', Response::HTTP_NOT_FOUND);
        }

        return $this->successResponse($this->ratingService->obtainAverageRating($book_id));
    }
}
```

### 5. Agregar Rutas en el Gateway

Editar `LumenGatewayApi/routes/web.php` y agregar:

```php
// Rutas de Calificaciones
$router->get('/ratings', 'RatingController@index');
$router->post('/ratings', 'RatingController@store');
$router->get('/ratings/{rating}', 'RatingController@show');
$router->put('/ratings/{rating}', 'RatingController@update');
$router->patch('/ratings/{rating}', 'RatingController@update');
$router->delete('/ratings/{rating}', 'RatingController@destroy');
$router->get('/ratings/book/{book_id}/average', 'RatingController@averageRating');
$router->get('/ratings/book/{book_id}', 'RatingController@ratingsByBook');
```

## 🧪 Pruebas de Integración

### Crear una calificación

```bash
curl -X POST http://localhost:8000/ratings \
  -H "Content-Type: application/json" \
  -d '{
    "rating": 5,
    "book_id": 1,
    "user_id": 1
  }'
```

### Obtener promedio de un libro

```bash
curl http://localhost:8000/ratings/book/1/average
```

### Obtener todas las calificaciones

```bash
curl http://localhost:8000/ratings
```

## 📝 Notas Importantes

- El Ratings Service debe estar corriendo en el puerto 8007
- El Gateway actúa como intermediario y valida que el libro exista
- Las respuestas del servicio son encapsuladas nuevamente por el Gateway
- El índice único en la base de datos garantiza que un usuario solo califique un libro una vez

## 🚀 Próximos Pasos

1. Implementar integración con Users Service (validar que el usuario existe)
2. Agregar caché de promedios para mejorar rendimiento
3. Implementar notificaciones cuando se crea una calificación
4. Agregar estadísticas de calificaciones en Analytics Service
