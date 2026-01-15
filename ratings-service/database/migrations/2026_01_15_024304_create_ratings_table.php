<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateRatingsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('ratings', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->unsignedInteger('rating'); // 1-5 stars
            $table->unsignedBigInteger('book_id');
            $table->unsignedBigInteger('user_id');
            $table->timestamps();
            
            // Índice único para evitar que un usuario califique el mismo libro más de una vez
            $table->unique(['book_id', 'user_id'], 'ratings_book_user_unique');
            
            // Índices para mejorar el rendimiento de consultas
            $table->index('book_id');
            $table->index('user_id');
        });
        
        // Agregar constraint CHECK después de crear la tabla (MySQL 8.0.16+)
        DB::statement('ALTER TABLE ratings ADD CONSTRAINT ratings_rating_check CHECK (rating >= 1 AND rating <= 5)');
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('ratings');
    }
}