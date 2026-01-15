<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Rating extends Model
{
    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'ratings';

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'rating',
        'book_id',
        'user_id',
    ];

    /**
     * The attributes that should be cast to native types.
     *
     * @var array
     */
    protected $casts = [
        'rating' => 'integer',
        'book_id' => 'integer',
        'user_id' => 'integer',
    ];

    /**
     * The attributes that should be mutated to dates.
     *
     * @var array
     */
    protected $dates = [
        'created_at',
        'updated_at',
    ];

    /**
     * Boot method para validaciones personalizadas
     */
    protected static function boot()
    {
        parent::boot();

        // Validar antes de guardar
        static::saving(function ($rating) {
            if ($rating->rating < 1 || $rating->rating > 5) {
                throw new \InvalidArgumentException('Rating must be between 1 and 5');
            }
        });
    }
}