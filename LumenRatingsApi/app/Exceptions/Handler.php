<?php

namespace App\Exceptions;

use App\Traits\ApiResponser;
use Illuminate\Auth\Access\AuthorizationException;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Validation\ValidationException;
use Illuminate\Http\Response;
use Laravel\Lumen\Exceptions\Handler as ExceptionHandler;
use Symfony\Component\HttpKernel\Exception\HttpException;
use GuzzleHttp\Exception\ClientException;
use GuzzleHttp\Exception\ConnectException;
use Throwable;

class Handler extends ExceptionHandler
{
    use ApiResponser;

    /**
     * A list of the exception types that should not be reported.
     *
     * @var array
     */
    protected $dontReport = [
        AuthorizationException::class,
        HttpException::class,
        ModelNotFoundException::class,
        ValidationException::class,
    ];

    /**
     * Report or log an exception.
     *
     * @param  \Throwable  $exception
     * @return void
     *
     * @throws \Exception
     */
    public function report(Throwable $exception)
    {
        parent::report($exception);
    }

    /**
     * Render an exception into an HTTP response.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Throwable  $exception
     * @return \Illuminate\Http\Response|\Illuminate\Http\JsonResponse
     */
    public function render($request, Throwable $exception)
    {
        // Manejo de HttpException
        if ($exception instanceof HttpException) {
            $code = $exception->getStatusCode();
            $message = Response::$statusTexts[$code] ?? 'Unknown error';
            return $this->errorResponse($message, $code);
        }

        // Manejo de ModelNotFoundException
        if ($exception instanceof ModelNotFoundException) {
            $model = strtolower(class_basename($exception->getModel()));
            return $this->errorResponse(
                "No existe instancia de {$model} con el ID proporcionado",
                Response::HTTP_NOT_FOUND
            );
        }

        // Manejo de ValidationException
        if ($exception instanceof ValidationException) {
            $errors = $exception->validator->errors()->getMessages();
            return $this->errorResponse(
                'Errores de validación',
                Response::HTTP_UNPROCESSABLE_ENTITY
            );
        }

        // Manejo de ClientException (errores HTTP de servicios externos)
        if ($exception instanceof ClientException) {
            $response = $exception->getResponse();
            $code = $response->getStatusCode();
            $body = $response->getBody()->getContents();
            $decoded = json_decode($body, true);

            $message = isset($decoded['error']) ? $decoded['error'] : $body;
            return $this->errorResponse($message, $code);
        }

        // Manejo de ConnectException (errores de conexión a servicios)
        if ($exception instanceof ConnectException) {
            return $this->errorResponse(
                'No se pudo conectar con el servicio solicitado. Por favor, intenta más tarde.',
                Response::HTTP_SERVICE_UNAVAILABLE
            );
        }

        // Manejo de excepciones genéricas de servicios externos
        if (strpos(get_class($exception), 'GuzzleHttp') !== false) {
            return $this->errorResponse(
                'Error al comunicarse con el servicio externo',
                Response::HTTP_SERVICE_UNAVAILABLE
            );
        }

        // Manejo de RuntimeException (configuración faltante)
        if ($exception instanceof \RuntimeException) {
            return $this->errorResponse(
                $exception->getMessage(),
                Response::HTTP_INTERNAL_SERVER_ERROR
            );
        }

        // Para desarrollo, mostrar el error completo
        if (env('APP_DEBUG', false)) {
            return parent::render($request, $exception);
        }

        // Para producción, retornar error genérico
        return $this->errorResponse(
            'Error interno del servidor. Por favor, intenta más tarde.',
            Response::HTTP_INTERNAL_SERVER_ERROR
        );
    }
}
