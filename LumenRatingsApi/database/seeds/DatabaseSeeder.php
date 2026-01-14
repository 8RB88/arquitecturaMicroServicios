<?php

use App\Rating;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        // Crear 30 calificaciones de ejemplo
        factory(Rating::class, 30)->create();
    }
}
