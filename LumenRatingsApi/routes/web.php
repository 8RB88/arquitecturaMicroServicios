<?php

/*
|--------------------------------------------------------------------------
| Application Routes
|--------------------------------------------------------------------------
|
| Here is where you can register all of the routes for an application.
| It is a breeze. Simply tell Lumen the URIs it should respond to
| and give it the Closure to call when that URI is requested.
|
*/

$router->get('/ratings', 'RatingController@index');
$router->post('/ratings', 'RatingController@store');
$router->get('/ratings/{rating}', 'RatingController@show');
$router->put('/ratings/{rating}', 'RatingController@update');
$router->patch('/ratings/{rating}', 'RatingController@update');
$router->delete('/ratings/{rating}', 'RatingController@destroy');

// Rutas especiales para promedios
$router->get('/ratings/book/{book_id}/average', 'RatingController@averageRating');
$router->get('/ratings/book/{book_id}', 'RatingController@ratingsByBook');
