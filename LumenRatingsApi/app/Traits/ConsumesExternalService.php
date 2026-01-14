<?php

namespace App\Traits;

use GuzzleHttp\Client;
use GuzzleHttp\Exception\ClientException;
use GuzzleHttp\Exception\ConnectException;

trait ConsumesExternalService
{
    /**
     * Realiza una petición HTTP a un servicio externo
     * 
     * @param string $method HTTP method (GET, POST, PUT, DELETE, PATCH)
     * @param string $requestUrl URL relativa del endpoint
     * @param array $formParams Parámetros de la petición
     * @param array $headers Headers HTTP adicionales
     * @return array|string Respuesta decodificada
     * @throws \Exception Si falla la conexión o hay error en la respuesta
     */
    public function performRequest($method, $requestUrl, $formParams = [], $headers = [])
    {
        // Validar que baseUri está configurado
        if (empty($this->baseUri)) {
            throw new \RuntimeException(
                'Base URI no está configurado. Por favor verifica tu archivo .env'
            );
        }

        $client = new Client([
            'base_uri' => $this->baseUri,
            'timeout' => 10.0,
            'connect_timeout' => 5.0,
        ]);

        // Agregar autenticación si existe
        if (isset($this->secret) && !empty($this->secret)) {
            $headers['Authorization'] = 'Bearer ' . $this->secret;
        }

        $options = ['headers' => $headers];

        // Configurar los parámetros según el método HTTP
        if (!empty($formParams)) {
            if (in_array(strtoupper($method), ['GET', 'DELETE'])) {
                $options['query'] = $formParams;
            } else {
                $options['json'] = $formParams;
            }
        }

        try {
            $response = $client->request($method, $requestUrl, $options);

            $body = $response->getBody()->getContents();
            $decoded = json_decode($body, true);

            // Si la respuesta es JSON válido
            if (json_last_error() === JSON_ERROR_NONE) {
                // Si la respuesta tiene estructura 'data', extraerla
                if (isset($decoded['data']) && is_array($decoded) && count($decoded) === 1) {
                    return $decoded['data'];
                }
                return $decoded;
            }

            // Si no es JSON válido, retornar el body sin procesar
            return $body;

        } catch (ConnectException $e) {
            // Error de conexión
            throw new \Exception(
                'No se pudo conectar con el servicio. Verifique que el servicio esté disponible.',
                503,
                $e
            );
        } catch (ClientException $e) {
            // Error HTTP (4xx, 5xx)
            $response = $e->getResponse();
            $statusCode = $response->getStatusCode();
            $body = $response->getBody()->getContents();
            $decoded = json_decode($body, true);

            $message = isset($decoded['error']) ? $decoded['error'] : $body;

            throw new \Exception(
                $message,
                $statusCode,
                $e
            );
        } catch (\Exception $e) {
            // Error genérico
            throw $e;
        }
    }
}
