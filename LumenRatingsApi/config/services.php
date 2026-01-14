<?php

return [

    /*
    |--------------------------------------------------------------------------
    | Application Services
    |--------------------------------------------------------------------------
    |
    | This array contains the services that should be configured for the
    | application and used when communicating with external services.
    |
    */

    'books' => [
        'base_uri' => env('BOOKS_SERVICE_BASE_URL'),
        'secret' => env('BOOKS_SERVICE_SECRET'),
    ],

];
