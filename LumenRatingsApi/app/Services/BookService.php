<?php

namespace App\Services;

use App\Traits\ConsumesExternalService;

/**
 * Servicio para consumir la API de Libros
 * Valida que los libros existen antes de crear/actualizar calificaciones
 */
class BookService
{
    use ConsumesExternalService;

    /**
     * URL base del servicio de libros
     * @var string
     */
    public $baseUri;

    /**
     * Token secreto para autenticación (si es necesario)
     * @var string
     */
    public $secret;

    /**
     * Constructor - Inicializa la URL base del servicio
     * 
     * @throws \RuntimeException Si BOOKS_SERVICE_BASE_URL no está configurado
     */
    public function __construct()
    {
        $this->baseUri = env('BOOKS_SERVICE_BASE_URL');
        $this->secret = env('BOOKS_SERVICE_SECRET');

        // Validar que la URL del servicio esté configurada
        if (empty($this->baseUri)) {
            throw new \RuntimeException(
                'BOOKS_SERVICE_BASE_URL no está configurado en el archivo .env. ' .
                'Por favor, agrega: BOOKS_SERVICE_BASE_URL=http://localhost:8002'
            );
        }
    }

    /**
     * Obtiene un libro específico del servicio de libros
     * Usado para validar que un libro existe antes de crear una calificación
     * 
     * @param int $bookId ID del libro a validar
     * @return array Datos del libro
     * @throws \Exception Si el libro no existe o hay error en la conexión
     */
    public function obtainBook($bookId)
    {
        return $this->performRequest('GET', "/books/{$bookId}");
    }

    /**
     * Obtiene todos los libros
     * 
     * @return array Lista de libros
     * @throws \Exception Si hay error en la conexión
     */
    public function obtainBooks()
    {
        return $this->performRequest('GET', '/books');
    }
}
