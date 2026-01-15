<?php

namespace App\Http\Controllers;

use App\Models\Rating;
use App\Traits\ApiResponser;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;


class RatingController extends Controller
{
    use ApiResponser;

    /**
     * Display a listing of all ratings.
     *
     * @return JsonResponse
     */
    public function index()
    {
        $ratings = Rating::all();
        return $this->showAll($ratings);
    }

    /**
     * Get all ratings for a specific book.
     *
     * @param int $bookId
     * @return JsonResponse
     */
    public function getBookRatings($bookId)
    {
        $ratings = Rating::where('book_id', $bookId)->get();
        return $this->showAll($ratings);
    }

    /**
     * Get average rating for a specific book.
     *
     * @param int $bookId
     * @return JsonResponse
     */
    public function getBookAverageRating($bookId)
    {
        $ratings = Rating::where('book_id', $bookId)->get();
        
        if ($ratings->isEmpty()) {
            return $this->successResponse([
                'book_id' => (int)$bookId,
                'average' => 0,
                'total_ratings' => 0
            ]);
        }

        $average = round($ratings->avg('rating'), 2);
        $totalRatings = $ratings->count();

        return $this->successResponse([
            'book_id' => (int)$bookId,
            'average' => (float)$average,
            'total_ratings' => $totalRatings
        ]);
    }

    /**
     * Store a newly created rating.
     *
     * @param Request $request
     * @return JsonResponse
     */
    public function store(Request $request)
    {
        // Validación
        $this->validate($request, [
            'rating' => 'required|integer|min:1|max:5',
            'book_id' => 'required|integer|min:1',
            'user_id' => 'required|integer|min:1',
        ]);

        try {
            // Verificar si ya existe una calificación del mismo usuario para el mismo libro
            $existingRating = Rating::where('book_id', $request->input('book_id'))
                ->where('user_id', $request->input('user_id'))
                ->first();

            if ($existingRating) {
                return $this->errorResponse(
                    'User has already rated this book. Use PUT to update the rating.',
                    409
                );
            }

            $rating = Rating::create([
                'rating' => $request->input('rating'),
                'book_id' => $request->input('book_id'),
                'user_id' => $request->input('user_id'),
            ]);

            return $this->showOne($rating, 201);

        } catch (\Exception $e) {
            return $this->errorResponse('Error creating rating: ' . $e->getMessage(), 500);
        }
    }

    /**
     * Display the specified rating.
     *
     * @param int $id
     * @return JsonResponse
     */
    public function show($id)
    {
        $rating = Rating::find($id);

        if (!$rating) {
            return $this->errorResponse('Rating not found', 404);
        }

        return $this->showOne($rating);
    }

    /**
     * Update the specified rating.
     *
     * @param Request $request
     * @param int $id
     * @return JsonResponse
     */
    public function update(Request $request, $id)
    {
        $rating = Rating::find($id);

        if (!$rating) {
            return $this->errorResponse('Rating not found', 404);
        }

        // Validación
        $this->validate($request, [
            'rating' => 'required|integer|min:1|max:5',
        ]);

        try {
            $rating->rating = $request->input('rating');
            $rating->save();

            return $this->showOne($rating);

        } catch (\Exception $e) {
            return $this->errorResponse('Error updating rating: ' . $e->getMessage(), 500);
        }
    }

    /**
     * Remove the specified rating.
     *
     * @param int $id
     * @return JsonResponse
     */
    public function destroy($id)
    {
        $rating = Rating::find($id);

        if (!$rating) {
            return $this->errorResponse('Rating not found', 404);
        }

        try {
            $rating->delete();
            return $this->showMessage('Rating deleted successfully');

        } catch (\Exception $e) {
            return $this->errorResponse('Error deleting rating: ' . $e->getMessage(), 500);
        }
    }
}