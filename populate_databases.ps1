# Script para poblar las bases de datos directamente con SQLite

Write-Host "================================================" -ForegroundColor Yellow
Write-Host "POBLANDO BASES DE DATOS" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Yellow
Write-Host ""

$baseDir = "c:\Users\busta\Desktop\Universidad\arquitectura\Taller_Micreoservicios\arquitecturaMicroServicios"

# 1. Ratings Database
Write-Host "1. Creando tabla ratings en Ratings API..." -ForegroundColor Cyan

$ratingsDb = Join-Path $baseDir "LumenRatingsApi\database\database.sqlite"
$sql_ratings = @"
CREATE TABLE IF NOT EXISTS ratings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    rating INTEGER NOT NULL CHECK(rating >= 1 AND rating <= 5),
    book_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, book_id)
);

-- Insertar datos de ejemplo
INSERT OR IGNORE INTO ratings (rating, book_id, user_id, created_at, updated_at) VALUES
(5, 1, 1, datetime('now'), datetime('now')),
(4, 2, 2, datetime('now'), datetime('now')),
(5, 3, 3, datetime('now'), datetime('now')),
(3, 1, 4, datetime('now'), datetime('now')),
(4, 2, 5, datetime('now'), datetime('now')),
(5, 4, 6, datetime('now'), datetime('now')),
(2, 5, 7, datetime('now'), datetime('now')),
(4, 1, 8, datetime('now'), datetime('now')),
(5, 2, 9, datetime('now'), datetime('now')),
(3, 3, 10, datetime('now'), datetime('now')),
(4, 4, 1, datetime('now'), datetime('now')),
(5, 5, 2, datetime('now'), datetime('now')),
(4, 1, 3, datetime('now'), datetime('now')),
(3, 2, 4, datetime('now'), datetime('now')),
(5, 3, 5, datetime('now'), datetime('now')),
(4, 4, 6, datetime('now'), datetime('now')),
(5, 5, 7, datetime('now'), datetime('now')),
(3, 1, 9, datetime('now'), datetime('now')),
(4, 2, 10, datetime('now'), datetime('now')),
(5, 3, 1, datetime('now'), datetime('now'));
"@

try {
    $sqlite = "C:\Program Files\sqlite3\sqlite3.exe"
    if (-not (Test-Path $sqlite)) {
        $sqlite = "sqlite3"
    }
    
    # Crear archivo temporal con SQL
    $tempSql = [System.IO.Path]::GetTempFileName() + ".sql"
    Set-Content -Path $tempSql -Value $sql_ratings -Encoding UTF8
    
    # Ejecutar con sqlite3
    & $sqlite $ratingsDb < $tempSql
    
    Write-Host "   OK - 20 calificaciones insertadas" -ForegroundColor Green
    
    Remove-Item $tempSql -Force
} catch {
    Write-Host "   ERROR - No se pudo poblar ratings: $_" -ForegroundColor Red
}

# 2. Authors Database
Write-Host ""
Write-Host "2. Creando tabla authors en Authors API..." -ForegroundColor Cyan

$authorsDb = Join-Path $baseDir "LumenAuthorsApi\database\database.sqlite"
$sql_authors = @"
CREATE TABLE IF NOT EXISTS authors (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    gender TEXT,
    country TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Insertar datos de ejemplo
INSERT OR IGNORE INTO authors (name, gender, country, created_at, updated_at) VALUES
('George R. R. Martin', 'male', 'United States', datetime('now'), datetime('now')),
('J. K. Rowling', 'female', 'United Kingdom', datetime('now'), datetime('now')),
('J. R. R. Tolkien', 'male', 'United Kingdom', datetime('now'), datetime('now')),
('Stephen King', 'male', 'United States', datetime('now'), datetime('now')),
('Agatha Christie', 'female', 'United Kingdom', datetime('now'), datetime('now')),
('Isaac Asimov', 'male', 'Russia', datetime('now'), datetime('now')),
('Arthur C. Clarke', 'male', 'United Kingdom', datetime('now'), datetime('now')),
('Ray Bradbury', 'male', 'United States', datetime('now'), datetime('now')),
('Philip K. Dick', 'male', 'United States', datetime('now'), datetime('now')),
('William Gibson', 'male', 'Canada', datetime('now'), datetime('now'));
"@

try {
    $tempSql = [System.IO.Path]::GetTempFileName() + ".sql"
    Set-Content -Path $tempSql -Value $sql_authors -Encoding UTF8
    
    & $sqlite $authorsDb < $tempSql
    
    Write-Host "   OK - 10 autores insertados" -ForegroundColor Green
    
    Remove-Item $tempSql -Force
} catch {
    Write-Host "   ERROR - No se pudo poblar authors: $_" -ForegroundColor Red
}

# 3. Books Database
Write-Host ""
Write-Host "3. Creando tabla books en Books API..." -ForegroundColor Cyan

$booksDb = Join-Path $baseDir "LumenBooksApi\database\database.sqlite"
$sql_books = @"
CREATE TABLE IF NOT EXISTS books (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    author_id INTEGER,
    isbn TEXT,
    publication_year INTEGER,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Insertar datos de ejemplo
INSERT OR IGNORE INTO books (title, author_id, isbn, publication_year, created_at, updated_at) VALUES
('A Game of Thrones', 1, '978-0553103540', 1996, datetime('now'), datetime('now')),
('Harry Potter and the Philosopher Stone', 2, '978-0747532699', 1997, datetime('now'), datetime('now')),
('The Hobbit', 3, '978-0547928227', 1937, datetime('now'), datetime('now')),
('The Shining', 4, '978-0385333312', 1977, datetime('now'), datetime('now')),
('Murder on the Orient Express', 5, '978-0062073556', 1934, datetime('now'), datetime('now')),
('Foundation', 6, '978-0553293357', 1951, datetime('now'), datetime('now')),
('2001: A Space Odyssey', 7, '978-0451524935', 1968, datetime('now'), datetime('now')),
('Fahrenheit 451', 8, '978-1451673264', 1953, datetime('now'), datetime('now')),
('Do Androids Dream of Electric Sheep?', 9, '978-0345404473', 1968, datetime('now'), datetime('now')),
('Neuromancer', 10, '978-0441569595', 1984, datetime('now'), datetime('now')),
('A Clash of Kings', 1, '978-0553108033', 1998, datetime('now'), datetime('now')),
('Harry Potter and the Chamber of Secrets', 2, '978-0747538494', 1998, datetime('now'), datetime('now')),
('The Lord of the Rings', 3, '978-0544003415', 1954, datetime('now'), datetime('now')),
('It', 4, '978-1501192050', 1986, datetime('now'), datetime('now')),
('Death on the Nile', 5, '978-0062693778', 1937, datetime('now'), datetime('now'));
"@

try {
    $tempSql = [System.IO.Path]::GetTempFileName() + ".sql"
    Set-Content -Path $tempSql -Value $sql_books -Encoding UTF8
    
    & $sqlite $booksDb < $tempSql
    
    Write-Host "   OK - 15 libros insertados" -ForegroundColor Green
    
    Remove-Item $tempSql -Force
} catch {
    Write-Host "   ERROR - No se pudo poblar books: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Yellow
Write-Host "BASES DE DATOS POBLADAS EXITOSAMENTE" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "Resumen:" -ForegroundColor Cyan
Write-Host "  - Ratings: 20 registros" -ForegroundColor White
Write-Host "  - Authors: 10 registros" -ForegroundColor White
Write-Host "  - Books:   15 registros" -ForegroundColor White
Write-Host ""
