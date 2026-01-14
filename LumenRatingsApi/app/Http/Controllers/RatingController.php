<?php

namespace App\Http\Controllers;

use App\Rating;
use App\Services\BookService;
use App\Traits\ApiResponser;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

class RatingController extends Controller
{
    use ApiResponser;

    /**
     * El servicio para consumir la API de libros
     * @var BookService
     */
    public $bookService;

    /**
     * Create a new controller instance.
     *
     * @param BookService $bookService
     * @return void
     */
    public function __construct(BookService $bookService)
    {
        $this->bookService = $bookService;
    }

    /**
     * Retorna lista de Calificaciones.
     * @return Illuminate\Http\Response
     */
    public function index()
    {
        $ratings = Rating::all();
        return $this->successResponse($ratings);
    }

    /**
     * Crea una instancia de una Calificación.
     * @return Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $rules = [
            'rating' => 'required|integer|min:1|max:5',
            'book_id' => 'required|integer|min:1',
            'user_id' => 'required|integer|min:1',
        ];

        $this->validate($request, $rules);

        // Validar que el libro existe en el servicio de Books
        try {
            $this->bookService->obtainBook($request->book_id);
        } catch (\Exception $e) {
            return $this->errorResponse(
                'El libro especificado no existe',
                Response::HTTP_NOT_FOUND
            );
        }

        // Validar unicidad: un usuario solo puede calificar un libro una vez
        $existingRating = Rating::where('book_id', $request->book_id)
            ->where('user_id', $request->user_id)
            ->first();

        if ($existingRating) {
            return $this->errorResponse(
                'El usuario ya ha calificado este libro',
                Response::HTTP_UNPROCESSABLE_ENTITY
            );
        }

        $rating = Rating::create($request->all());

        return $this->successResponse($rating, Response::HTTP_CREATED);
    }

    /**
     * Retornar una Calificación Específica.
     * @return Illuminate\Http\Response
     */
    public function show($id)
    {
        $rating = Rating::findOrFail($id);

        return $this->successResponse($rating);
    }

    /**
     * Actualizar información de la Calificación.
     * @return Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        $rules = [
            'rating' => 'integer|min:1|max:5',
            'book_id' => 'integer|min:1',
        ];

        $this->validate($request, $rules);

        // Si se actualiza el book_id, validar que el nuevo libro existe
        if ($request->has('book_id')) {
            try {
                $this->bookService->obtainBook($request->book_id);
            } catch (\Exception $e) {
                return $this->errorResponse(
                    'El libro especificado no existe',
                    Response::HTTP_NOT_FOUND
                );
            }
        }

        $rating = Rating::findOrFail($id);

        $rating->fill($request->all());

        if ($rating->isClean()) {
            return $this->errorResponse(
                'Al menos un atributo debe modificar',
                Response::HTTP_UNPROCESSABLE_ENTITY
            );
        }

        $rating->save();

        return $this->successResponse($rating);
    }

    /**
     * Eliminar una Calificación.
     * @return Illuminate\Http\Response
     */
    public function destroy($id)
    {
        $rating = Rating::findOrFail($id);

        $rating->delete();

        return $this->successResponse($rating);
    }

    /**
     * Obtener todas las calificaciones de un libro específico.
     * @return Illuminate\Http\Response
     */
    public function ratingsByBook($book_id)
    {
        $ratings = Rating::where('book_id', $book_id)->get();

        return $this->successResponse($ratings);
    }

    /**
     * Obtener el promedio de calificaciones de un libro.
     * @return Illuminate\Http\Response
     */
    public function averageRating($book_id)
    {
        $average = Rating::where('book_id', $book_id)->avg('rating');

        $count = Rating::where('book_id', $book_id)->count();

        $data = [
            'book_id' => $book_id,
            'average' => $average ? round($average, 2) : 0,
            'count' => $count,
        ];

        return $this->successResponse($data);
    }
}
