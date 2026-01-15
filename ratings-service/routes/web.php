<?php

/*
|--------------------------------------------------------------------------
| Application Routes
|--------------------------------------------------------------------------
|
| Aquí es donde puedes registrar todas las rutas para tu aplicación.
| Es muy simple. Simplemente dile a Lumen los URIs a los que debe responder
| y dale el Closure a llamar cuando se solicite ese URI.
|
*/

/** @var \Laravel\Lumen\Routing\Router $router */

$router->get('/', function () use ($router) {
    return response()->json([
        'service' => 'Ratings Service',
        'version' => $router->app->version(),
        'status' => 'running'
    ]);
});

// Rutas del servicio de Ratings
$router->group(['prefix' => 'ratings'], function () use ($router) {
    
    // GET /ratings - Listar todas las calificaciones
    $router->get('/', 'RatingController@index');
    
    // GET /ratings/book/{book_id} - Calificaciones de un libro específico
    $router->get('/book/{book_id}', 'RatingController@getBookRatings');
    
    // GET /ratings/book/{book_id}/average - Promedio de calificaciones de un libro
    $router->get('/book/{book_id}/average', 'RatingController@getBookAverageRating');
    
    // POST /ratings - Crear una nueva calificación
    $router->post('/', 'RatingController@store');
    
    // GET /ratings/{id} - Obtener una calificación específica
    $router->get('/{id}', 'RatingController@show');
    
    // PUT /ratings/{id} - Actualizar una calificación
    $router->put('/{id}', 'RatingController@update');
    
    // DELETE /ratings/{id} - Eliminar una calificación
    $router->delete('/{id}', 'RatingController@destroy');
});