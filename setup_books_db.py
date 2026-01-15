import sqlite3
import os

# Ruta de la BD de Books
db_path = "LumenBooksApi/database/database.sqlite"

# Conectar a la base de datos SQLite
conn = sqlite3.connect(db_path)
cursor = conn.cursor()

try:
    # Crear tabla books
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS books (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            price INTEGER NOT NULL,
            author_id INTEGER NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    """)
    
    print("✅ Tabla 'books' creada exitosamente")
    
    # Crear tabla migrations
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS migrations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            migration TEXT NOT NULL,
            batch INTEGER NOT NULL
        )
    """)
    
    print("✅ Tabla 'migrations' creada exitosamente")
    
    # Registrar que la migración se ejecutó
    cursor.execute("""
        INSERT OR IGNORE INTO migrations (migration, batch) 
        VALUES ('2020_11_24_165911_create_books_table', 1)
    """)
    
    # Insertar libros de ejemplo
    books = [
        ('Clean Code', 'A Handbook of Agile Software Craftsmanship', 5000, 1),
        ('Design Patterns', 'Elements of Reusable Object-Oriented Software', 4500, 2),
        ('The Pragmatic Programmer', 'Your Journey to Mastery', 4800, 3),
        ('Code Complete', 'A Practical Handbook of Software Construction', 5200, 4),
        ('Refactoring', 'Improving the Design of Existing Code', 4700, 5),
        ('The Mythical Man-Month', 'Essays on Software Engineering', 3800, 6),
        ('Effective Java', 'Programming Language Guide', 4600, 7),
        ('You Dont Know JS', 'Up & Going', 2500, 8),
    ]
    
    for title, description, price, author_id in books:
        cursor.execute("""
            INSERT OR IGNORE INTO books (title, description, price, author_id) 
            VALUES (?, ?, ?, ?)
        """, (title, description, price, author_id))
    
    conn.commit()
    print(f"✅ {len(books)} libros insertados exitosamente")
    
    # Verificar datos
    cursor.execute("SELECT COUNT(*) as count FROM books")
    count = cursor.fetchone()[0]
    print(f"\n📚 Total de libros en la BD: {count}")
    
    cursor.execute("SELECT id, title FROM books")
    books_list = cursor.fetchall()
    print("\n📖 Libros disponibles:")
    for book_id, title in books_list:
        print(f"  [{book_id}] {title}")
    
    # Obtener tamaño de la BD
    size = os.path.getsize(db_path)
    print(f"\n💾 Tamaño de la BD: {size} bytes")
    
    print("\n✅ ¡Base de datos de Books configurada!")
    
except Exception as e:
    print(f"❌ Error: {e}")
    exit(1)
finally:
    conn.close()
