<?php

// Enrutador para Ratings Service con validación de Books API
// Este archivo maneja todas las solicitudes HTTP

header('Content-Type: application/json');

// Variable para almacenar las calificaciones en memoria (demo)
$ratings = [
    (object)['id' => 1, 'rating' => 5, 'book_id' => 1, 'user_id' => 1, 'created_at' => '2024-01-14T16:10:00', 'updated_at' => '2024-01-14T16:10:00'],
    (object)['id' => 2, 'rating' => 4, 'book_id' => 2, 'user_id' => 2, 'created_at' => '2024-01-14T16:11:00', 'updated_at' => '2024-01-14T16:11:00'],
];

$nextId = 3;

/**
 * Consume el servicio de Books para validar que un libro existe
 * 
 * @param int $bookId ID del libro a validar
 * @return bool|array Retorna true si el libro existe, false si no existe
 */
function validateBookExists($bookId) {
    $booksUrl = 'http://localhost:8002/books/' . $bookId;
    
    try {
        $context = stream_context_create([
            'http' => [
                'method' => 'GET',
                'timeout' => 5,
            ]
        ]);
        
        $response = @file_get_contents($booksUrl, false, $context);
        
        if ($response === false) {
            return false;
        }
        
        $decoded = json_decode($response, true);
        return isset($decoded['data']) ? true : false;
        
    } catch (Exception $e) {
        return false;
    }
}

// Obtener la ruta solicitada
$request_uri = $_SERVER['REQUEST_URI'] ?? '/';
$request_method = $_SERVER['REQUEST_METHOD'] ?? 'GET';

// Remover parámetros de consulta
$path = parse_url($request_uri, PHP_URL_PATH);

// Remover /public del path si está presente
$path = str_replace('/public', '', $path);

$response = [];
$httpCode = 200;

// GET /ratings - Listar todas las calificaciones
if ($request_method === 'GET' && $path === '/ratings') {
    $httpCode = 200;
    $response = ['data' => array_values((array)$ratings)];
}

// POST /ratings - Crear una calificación
elseif ($request_method === 'POST' && $path === '/ratings') {
    $input = json_decode(file_get_contents('php://input'), true);
    
    // Validar campos requeridos
    if (!isset($input['rating']) || !isset($input['book_id']) || !isset($input['user_id'])) {
        $httpCode = 422;
        $response = [
            'error' => 'Campos requeridos: rating, book_id, user_id',
            'code' => 422
        ];
    }
    // Validar rango del rating
    elseif ($input['rating'] < 1 || $input['rating'] > 5) {
        $httpCode = 422;
        $response = [
            'error' => 'El rating debe estar entre 1 y 5',
            'code' => 422
        ];
    }
    // VALIDAR QUE EL LIBRO EXISTE ✅ NUEVA FUNCIONALIDAD
    elseif (!validateBookExists($input['book_id'])) {
        $httpCode = 404;
        $response = [
            'error' => 'El libro especificado no existe',
            'code' => 404
        ];
    }
    // Validar unicidad: un usuario solo puede calificar un libro una vez
    else {
        $duplicate = false;
        foreach ($ratings as $rating) {
            if ($rating->book_id == $input['book_id'] && $rating->user_id == $input['user_id']) {
                $duplicate = true;
                break;
            }
        }
        
        if ($duplicate) {
            $httpCode = 422;
            $response = [
                'error' => 'El usuario ya ha calificado este libro',
                'code' => 422
            ];
        } else {
            // Crear la calificación
            $newRating = (object)[
                'id' => $nextId++,
                'rating' => (int)$input['rating'],
                'book_id' => (int)$input['book_id'],
                'user_id' => (int)$input['user_id'],
                'created_at' => date('Y-m-d\TH:i:s'),
                'updated_at' => date('Y-m-d\TH:i:s')
            ];
            $ratings[] = $newRating;
            
            $httpCode = 201;
            $response = ['data' => $newRating];
        }
    }
}

// GET /ratings/{id} - Obtener una calificación específica
elseif (preg_match('/^\/ratings\/(\d+)$/', $path, $matches)) {
    $id = (int)$matches[1];
    
    if ($request_method === 'GET') {
        $found = false;
        foreach ($ratings as $rating) {
            if ($rating->id == $id) {
                $httpCode = 200;
                $response = ['data' => $rating];
                $found = true;
                break;
            }
        }
        
        if (!$found) {
            $httpCode = 404;
            $response = [
                'error' => 'Calificación no encontrada',
                'code' => 404
            ];
        }
    }
    elseif ($request_method === 'PUT') {
        $input = json_decode(file_get_contents('php://input'), true);
        
        $found = false;
        foreach ($ratings as $rating) {
            if ($rating->id == $id) {
                // Validar rating si se proporciona
                if (isset($input['rating']) && ($input['rating'] < 1 || $input['rating'] > 5)) {
                    $httpCode = 422;
                    $response = [
                        'error' => 'El rating debe estar entre 1 y 5',
                        'code' => 422
                    ];
                    $found = true;
                    break;
                }
                
                // Actualizar el rating
                if (isset($input['rating'])) {
                    $rating->rating = (int)$input['rating'];
                }
                if (isset($input['book_id'])) {
                    // VALIDAR QUE EL NUEVO LIBRO EXISTE ✅ NUEVA FUNCIONALIDAD
                    if (!validateBookExists($input['book_id'])) {
                        $httpCode = 404;
                        $response = [
                            'error' => 'El libro especificado no existe',
                            'code' => 404
                        ];
                        $found = true;
                        break;
                    }
                    $rating->book_id = (int)$input['book_id'];
                }
                
                $rating->updated_at = date('Y-m-d\TH:i:s');
                
                $httpCode = 200;
                $response = ['data' => $rating];
                $found = true;
                break;
            }
        }
        
        if (!$found) {
            $httpCode = 404;
            $response = [
                'error' => 'Calificación no encontrada',
                'code' => 404
            ];
        }
    }
    elseif ($request_method === 'DELETE') {
        $found = false;
        foreach ($ratings as $key => $rating) {
            if ($rating->id == $id) {
                $deleted = $rating;
                unset($ratings[$key]);
                
                $httpCode = 200;
                $response = ['data' => $deleted];
                $found = true;
                break;
            }
        }
        
        if (!$found) {
            $httpCode = 404;
            $response = [
                'error' => 'Calificación no encontrada',
                'code' => 404
            ];
        }
    }
}

// GET /ratings/book/{book_id} - Obtener calificaciones de un libro
elseif (preg_match('/^\/ratings\/book\/(\d+)$/', $path, $matches)) {
    $bookId = (int)$matches[1];
    $bookRatings = [];
    
    foreach ($ratings as $rating) {
        if ($rating->book_id == $bookId) {
            $bookRatings[] = $rating;
        }
    }
    
    $httpCode = 200;
    $response = ['data' => $bookRatings];
}

// GET /ratings/book/{book_id}/average - Promedio de calificaciones
elseif (preg_match('/^\/ratings\/book\/(\d+)\/average$/', $path, $matches)) {
    $bookId = (int)$matches[1];
    $bookRatings = [];
    
    foreach ($ratings as $rating) {
        if ($rating->book_id == $bookId) {
            $bookRatings[] = (int)$rating->rating;
        }
    }
    
    $average = count($bookRatings) > 0 ? array_sum($bookRatings) / count($bookRatings) : 0;
    $average = round($average, 2);
    
    $httpCode = 200;
    $response = [
        'data' => [
            'book_id' => $bookId,
            'average' => $average,
            'count' => count($bookRatings)
        ]
    ];
}

// Ruta no encontrada
else {
    $httpCode = 404;
    $response = [
        'error' => 'Endpoint no encontrado: ' . $path,
        'code' => 404
    ];
}

// Enviar respuesta
http_response_code($httpCode);
echo json_encode($response, JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT);
exit;

