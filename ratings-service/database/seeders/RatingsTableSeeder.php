<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class RatingsTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        // Limpiar la tabla primero
        DB::table('ratings')->truncate();

        $now = Carbon::now();

        // Datos de prueba
        $ratings = [
            // Libro 1 - El Quijote (promedio: 4.0)
            ['rating' => 5, 'book_id' => 1, 'user_id' => 1, 'created_at' => $now, 'updated_at' => $now],
            ['rating' => 4, 'book_id' => 1, 'user_id' => 2, 'created_at' => $now, 'updated_at' => $now],
            ['rating' => 3, 'book_id' => 1, 'user_id' => 3, 'created_at' => $now, 'updated_at' => $now],
            ['rating' => 4, 'book_id' => 1, 'user_id' => 4, 'created_at' => $now, 'updated_at' => $now],
            
            // Libro 2 - Cien años de soledad (promedio: 4.5)
            ['rating' => 5, 'book_id' => 2, 'user_id' => 1, 'created_at' => $now, 'updated_at' => $now],
            ['rating' => 5, 'book_id' => 2, 'user_id' => 2, 'created_at' => $now, 'updated_at' => $now],
            ['rating' => 4, 'book_id' => 2, 'user_id' => 5, 'created_at' => $now, 'updated_at' => $now],
            ['rating' => 4, 'book_id' => 2, 'user_id' => 6, 'created_at' => $now, 'updated_at' => $now],
            
            // Libro 3 - 1984 (promedio: 4.67)
            ['rating' => 5, 'book_id' => 3, 'user_id' => 1, 'created_at' => $now, 'updated_at' => $now],
            ['rating' => 5, 'book_id' => 3, 'user_id' => 3, 'created_at' => $now, 'updated_at' => $now],
            ['rating' => 4, 'book_id' => 3, 'user_id' => 4, 'created_at' => $now, 'updated_at' => $now],
            
            // Libro 4 - El principito (promedio: 3.5)
            ['rating' => 4, 'book_id' => 4, 'user_id' => 2, 'created_at' => $now, 'updated_at' => $now],
            ['rating' => 3, 'book_id' => 4, 'user_id' => 5, 'created_at' => $now, 'updated_at' => $now],
            ['rating' => 3, 'book_id' => 4, 'user_id' => 6, 'created_at' => $now, 'updated_at' => $now],
            ['rating' => 4, 'book_id' => 4, 'user_id' => 7, 'created_at' => $now, 'updated_at' => $now],
            
            // Libro 5 - Harry Potter (promedio: 4.8)
            ['rating' => 5, 'book_id' => 5, 'user_id' => 1, 'created_at' => $now, 'updated_at' => $now],
            ['rating' => 5, 'book_id' => 5, 'user_id' => 2, 'created_at' => $now, 'updated_at' => $now],
            ['rating' => 5, 'book_id' => 5, 'user_id' => 3, 'created_at' => $now, 'updated_at' => $now],
            ['rating' => 4, 'book_id' => 5, 'user_id' => 4, 'created_at' => $now, 'updated_at' => $now],
            ['rating' => 5, 'book_id' => 5, 'user_id' => 5, 'created_at' => $now, 'updated_at' => $now],
            
            // Libro 6 - El señor de los anillos (promedio: 4.25)
            ['rating' => 5, 'book_id' => 6, 'user_id' => 1, 'created_at' => $now, 'updated_at' => $now],
            ['rating' => 4, 'book_id' => 6, 'user_id' => 6, 'created_at' => $now, 'updated_at' => $now],
            ['rating' => 4, 'book_id' => 6, 'user_id' => 7, 'created_at' => $now, 'updated_at' => $now],
            ['rating' => 4, 'book_id' => 6, 'user_id' => 8, 'created_at' => $now, 'updated_at' => $now],
            
            // Libro 7 - Libro con baja calificación (promedio: 2.0)
            ['rating' => 2, 'book_id' => 7, 'user_id' => 2, 'created_at' => $now, 'updated_at' => $now],
            ['rating' => 2, 'book_id' => 7, 'user_id' => 3, 'created_at' => $now, 'updated_at' => $now],
            ['rating' => 2, 'book_id' => 7, 'user_id' => 9, 'created_at' => $now, 'updated_at' => $now],
            
            // Libro 8 - Libro sin muchas calificaciones (promedio: 5.0)
            ['rating' => 5, 'book_id' => 8, 'user_id' => 1, 'created_at' => $now, 'updated_at' => $now],
            
            // Libro 9 - Libro con calificaciones variadas (promedio: 3.0)
            ['rating' => 1, 'book_id' => 9, 'user_id' => 4, 'created_at' => $now, 'updated_at' => $now],
            ['rating' => 3, 'book_id' => 9, 'user_id' => 5, 'created_at' => $now, 'updated_at' => $now],
            ['rating' => 5, 'book_id' => 9, 'user_id' => 6, 'created_at' => $now, 'updated_at' => $now],
            
            // Libro 10 - Libro popular (promedio: 4.4)
            ['rating' => 5, 'book_id' => 10, 'user_id' => 1, 'created_at' => $now, 'updated_at' => $now],
            ['rating' => 4, 'book_id' => 10, 'user_id' => 2, 'created_at' => $now, 'updated_at' => $now],
            ['rating' => 5, 'book_id' => 10, 'user_id' => 3, 'created_at' => $now, 'updated_at' => $now],
            ['rating' => 4, 'book_id' => 10, 'user_id' => 7, 'created_at' => $now, 'updated_at' => $now],
            ['rating' => 4, 'book_id' => 10, 'user_id' => 8, 'created_at' => $now, 'updated_at' => $now],
        ];

        // Insertar los datos
        DB::table('ratings')->insert($ratings);

        echo "✅ Se insertaron " . count($ratings) . " calificaciones de prueba\n";
    }
}