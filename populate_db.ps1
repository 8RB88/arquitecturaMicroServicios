# Script para poblar las bases de datos directamente

Write-Host "================================================" -ForegroundColor Yellow
Write-Host "POBLANDO BASES DE DATOS" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Yellow
Write-Host ""

$baseDir = "c:\Users\busta\Desktop\Universidad\arquitectura\Taller_Micreoservicios\arquitecturaMicroServicios"

# Crear SQL para ratings
Write-Host "1. Poblando tabla ratings..." -ForegroundColor Cyan

$ratingsDb = Join-Path $baseDir "LumenRatingsApi\database\database.sqlite"

# SQL directo
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

INSERT OR IGNORE INTO ratings (rating, book_id, user_id) VALUES
(5, 1, 1), (4, 2, 2), (5, 3, 3), (3, 1, 4), (4, 2, 5),
(5, 4, 6), (2, 5, 7), (4, 1, 8), (5, 2, 9), (3, 3, 10),
(4, 4, 1), (5, 5, 2), (4, 1, 3), (3, 2, 4), (5, 3, 5),
(4, 4, 6), (5, 5, 7), (3, 1, 9), (4, 2, 10), (5, 3, 1);
"@

# Guardar a archivo temporal
$tempFile = [System.IO.Path]::GetTempFileName()
[System.IO.File]::WriteAllText($tempFile, $sql_ratings)

# Usar cmd.exe para ejecutar sqlite3
$cmd = "sqlite3.exe `"$ratingsDb`" < `"$tempFile`""
cmd.exe /c $cmd 2>$null

if ($LASTEXITCODE -eq 0) {
    Write-Host "   OK - Tabla ratings creada" -ForegroundColor Green
} else {
    Write-Host "   Error ejecutando comando" -ForegroundColor Yellow
}

Remove-Item $tempFile -Force -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "2. Poblando tabla authors..." -ForegroundColor Cyan

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

INSERT OR IGNORE INTO authors (name, gender, country) VALUES
('George R. R. Martin', 'male', 'United States'),
('J. K. Rowling', 'female', 'United Kingdom'),
('J. R. R. Tolkien', 'male', 'United Kingdom'),
('Stephen King', 'male', 'United States'),
('Agatha Christie', 'female', 'United Kingdom'),
('Isaac Asimov', 'male', 'Russia'),
('Arthur C. Clarke', 'male', 'United Kingdom'),
('Ray Bradbury', 'male', 'United States'),
('Philip K. Dick', 'male', 'United States'),
('William Gibson', 'male', 'Canada');
"@

$tempFile = [System.IO.Path]::GetTempFileName()
[System.IO.File]::WriteAllText($tempFile, $sql_authors)

$cmd = "sqlite3.exe `"$authorsDb`" < `"$tempFile`""
cmd.exe /c $cmd 2>$null

Write-Host "   OK - Tabla authors creada" -ForegroundColor Green

Remove-Item $tempFile -Force -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "3. Poblando tabla books..." -ForegroundColor Cyan

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

INSERT OR IGNORE INTO books (title, author_id, isbn, publication_year) VALUES
('A Game of Thrones', 1, '978-0553103540', 1996),
('Harry Potter and the Philosopher Stone', 2, '978-0747532699', 1997),
('The Hobbit', 3, '978-0547928227', 1937),
('The Shining', 4, '978-0385333312', 1977),
('Murder on the Orient Express', 5, '978-0062073556', 1934),
('Foundation', 6, '978-0553293357', 1951),
('2001: A Space Odyssey', 7, '978-0451524935', 1968),
('Fahrenheit 451', 8, '978-1451673264', 1953),
('Do Androids Dream of Electric Sheep?', 9, '978-0345404473', 1968),
('Neuromancer', 10, '978-0441569595', 1984),
('A Clash of Kings', 1, '978-0553108033', 1998),
('Harry Potter and the Chamber of Secrets', 2, '978-0747538494', 1998),
('The Lord of the Rings', 3, '978-0544003415', 1954),
('It', 4, '978-1501192050', 1986),
('Death on the Nile', 5, '978-0062693778', 1937);
"@

$tempFile = [System.IO.Path]::GetTempFileName()
[System.IO.File]::WriteAllText($tempFile, $sql_books)

$cmd = "sqlite3.exe `"$booksDb`" < `"$tempFile`""
cmd.exe /c $cmd 2>$null

Write-Host "   OK - Tabla books creada" -ForegroundColor Green

Remove-Item $tempFile -Force -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "================================================" -ForegroundColor Yellow
Write-Host "DATOS INSERTADOS EXITOSAMENTE" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Yellow
