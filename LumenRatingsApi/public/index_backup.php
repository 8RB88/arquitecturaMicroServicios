<?php

// Enrutador simple para Ratings Service
// Este archivo maneja todas las solicitudes HTTP

header('Content-Type: application/json');

// Obtener la ruta solicitada
$request_uri = $_SERVER['REQUEST_URI'] ?? '/';
$request_method = $_SERVER['REQUEST_METHOD'] ?? 'GET';

// Remover parámetros de consulta
$path = parse_url($request_uri, PHP_URL_PATH);

// Remover /public del path si está presente
$path = str_replace('/public', '', $path);

// Respuestas de ejemplo para las pruebas
$response = [];

if ($request_method === 'GET' && $path === '/ratings') {
    // GET /ratings - Listar todas las calificaciones
    http_response_code(200);
    $response = [
        'data' => [
            [
                'id' => 1,
                'rating' => 5,
                'book_id' => 1,
                'user_id' => 1,
                'created_at' => '2024-01-14T16:10:00',
                'updated_at' => '2024-01-14T16:10:00'
            ],
            [
                'id' => 2,
                'rating' => 4,
                'book_id' => 2,
                'user_id' => 2,
                'created_at' => '2024-01-14T16:11:00',
                'updated_at' => '2024-01-14T16:11:00'
            ]
        ]
    ];
} 
elseif ($request_method === 'POST' && $path === '/ratings') {
    // POST /ratings - Crear una calificación
    $input = json_decode(file_get_contents('php://input'), true);
    
    if (!isset($input['rating']) || !isset($input['book_id']) || !isset($input['user_id'])) {
        http_response_code(422);
        $response = [
            'error' => 'Campos requeridos: rating, book_id, user_id',
            'code' => 422
        ];
    } elseif ($input['rating'] < 1 || $input['rating'] > 5) {
        http_response_code(422);
        $response = [
            'error' => 'El rating debe estar entre 1 y 5',
            'code' => 422
        ];
    } else {
        http_response_code(201);
        $response = [
            'data' => [
                'id' => 3,
                'rating' => $input['rating'],
                'book_id' => $input['book_id'],
                'user_id' => $input['user_id'],
                'created_at' => date('Y-m-d\TH:i:s'),
                'updated_at' => date('Y-m-d\TH:i:s')
            ]
        ];
    }
}
elseif (preg_match('/^\/ratings\/(\d+)$/', $path, $matches)) {
    $id = $matches[1];
    
    if ($request_method === 'GET') {
        // GET /ratings/{id} - Obtener una calificación
        http_response_code(200);
        $response = [
            'data' => [
                'id' => $id,
                'rating' => 5,
                'book_id' => 1,
                'user_id' => 1,
                'created_at' => '2024-01-14T16:10:00',
                'updated_at' => '2024-01-14T16:10:00'
            ]
        ];
    }
    elseif ($request_method === 'PUT') {
        // PUT /ratings/{id} - Actualizar
        $input = json_decode(file_get_contents('php://input'), true);
        http_response_code(200);
        $response = [
            'data' => [
                'id' => $id,
                'rating' => $input['rating'] ?? 5,
                'book_id' => 1,
                'user_id' => 1,
                'created_at' => '2024-01-14T16:10:00',
                'updated_at' => date('Y-m-d\TH:i:s')
            ]
        ];
    }
    elseif ($request_method === 'DELETE') {
        // DELETE /ratings/{id} - Eliminar
        http_response_code(200);
        $response = [
            'data' => [
                'id' => $id,
                'rating' => 5,
                'book_id' => 1,
                'user_id' => 1,
                'created_at' => '2024-01-14T16:10:00',
                'updated_at' => '2024-01-14T16:10:00'
            ]
        ];
    }
}
elseif (preg_match('/^\/ratings\/book\/(\d+)$/', $path, $matches)) {
    // GET /ratings/book/{book_id} - Obtener calificaciones de un libro
    $book_id = $matches[1];
    http_response_code(200);
    $response = [
        'data' => [
            [
                'id' => 1,
                'rating' => 5,
                'book_id' => $book_id,
                'user_id' => 1,
                'created_at' => '2024-01-14T16:10:00',
                'updated_at' => '2024-01-14T16:10:00'
            ],
            [
                'id' => 2,
                'rating' => 4,
                'book_id' => $book_id,
                'user_id' => 2,
                'created_at' => '2024-01-14T16:11:00',
                'updated_at' => '2024-01-14T16:11:00'
            ]
        ]
    ];
}
elseif (preg_match('/^\/ratings\/book\/(\d+)\/average$/', $path, $matches)) {
    // GET /ratings/book/{book_id}/average - Promedio de calificaciones
    $book_id = $matches[1];
    http_response_code(200);
    $response = [
        'data' => [
            'book_id' => $book_id,
            'average' => 4.5,
            'count' => 2
        ]
    ];
}
else {
    // Ruta no encontrada
    http_response_code(404);
    $response = [
        'error' => 'Endpoint no encontrado: ' . $path,
        'code' => 404
    ];
}

echo json_encode($response, JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT);
exit;
