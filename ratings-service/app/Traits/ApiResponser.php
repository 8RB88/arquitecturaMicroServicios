<?php

namespace App\Traits;

use Illuminate\Http\JsonResponse;

trait ApiResponser
{
    /**
     * Build success response
     *
     * @param mixed $data
     * @param int $code
     * @return JsonResponse
     */
    protected function successResponse($data, $code = 200)
    {
        return response()->json($data, $code);
    }

    /**
     * Build error response
     *
     * @param string $message
     * @param int $code
     * @return JsonResponse
     */
    protected function errorResponse($message, $code)
    {
        return response()->json([
            'error' => $message,
            'code' => $code
        ], $code);
    }

    /**
     * Show all records
     *
     * @param mixed $collection
     * @param int $code
     * @return JsonResponse
     */
    protected function showAll($collection, $code = 200)
    {
        return $this->successResponse(['data' => $collection], $code);
    }

    /**
     * Show one record
     *
     * @param mixed $instance
     * @param int $code
     * @return JsonResponse
     */
    protected function showOne($instance, $code = 200)
    {
        return $this->successResponse(['data' => $instance], $code);
    }

    /**
     * Show message
     *
     * @param string $message
     * @param int $code
     * @return JsonResponse
     */
    protected function showMessage($message, $code = 200)
    {
        return $this->successResponse(['message' => $message], $code);
    }
}