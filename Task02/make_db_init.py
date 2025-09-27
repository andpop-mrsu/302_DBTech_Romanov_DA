import csv
import os
import re
import sqlite3


def extract_year_from_title(title):
    match = re.search(r'\((\d{4})\)', title)
    return int(match.group(1)) if match else None


def clean_title(title):
    return re.sub(r'\s*\(\d{4}\)', '', title).strip()


def escape_sql_string(value):
    if value is None:
        return 'NULL'
    return "'" + str(value).replace("'", "''") + "'"


def generate_sql_script():
    sql_script = []
    
    sql_script.append("PRAGMA foreign_keys = OFF;")
    sql_script.append("")
    
    sql_script.append("DROP TABLE IF EXISTS tags;")
    sql_script.append("DROP TABLE IF EXISTS ratings;")
    sql_script.append("DROP TABLE IF EXISTS movies;")
    sql_script.append("DROP TABLE IF EXISTS users;")
    sql_script.append("")
    
    sql_script.append("CREATE TABLE movies (")
    sql_script.append("    id INTEGER PRIMARY KEY,")
    sql_script.append("    title TEXT NOT NULL,")
    sql_script.append("    year INTEGER,")
    sql_script.append("    genres TEXT")
    sql_script.append(");")
    sql_script.append("")
    
    sql_script.append("CREATE TABLE users (")
    sql_script.append("    id INTEGER PRIMARY KEY,")
    sql_script.append("    name TEXT NOT NULL,")
    sql_script.append("    email TEXT NOT NULL,")
    sql_script.append("    gender TEXT NOT NULL,")
    sql_script.append("    register_date TEXT NOT NULL,")
    sql_script.append("    occupation TEXT NOT NULL")
    sql_script.append(");")
    sql_script.append("")
    
    sql_script.append("CREATE TABLE ratings (")
    sql_script.append("    id INTEGER PRIMARY KEY AUTOINCREMENT,")
    sql_script.append("    user_id INTEGER NOT NULL,")
    sql_script.append("    movie_id INTEGER NOT NULL,")
    sql_script.append("    rating REAL NOT NULL,")
    sql_script.append("    timestamp INTEGER NOT NULL,")
    sql_script.append("    FOREIGN KEY (user_id) REFERENCES users(id),")
    sql_script.append("    FOREIGN KEY (movie_id) REFERENCES movies(id)")
    sql_script.append(");")
    sql_script.append("")
    
    sql_script.append("CREATE TABLE tags (")
    sql_script.append("    id INTEGER PRIMARY KEY AUTOINCREMENT,")
    sql_script.append("    user_id INTEGER NOT NULL,")
    sql_script.append("    movie_id INTEGER NOT NULL,")
    sql_script.append("    tag TEXT NOT NULL,")
    sql_script.append("    timestamp INTEGER NOT NULL,")
    sql_script.append("    FOREIGN KEY (user_id) REFERENCES users(id),")
    sql_script.append("    FOREIGN KEY (movie_id) REFERENCES movies(id)")
    sql_script.append(");")
    sql_script.append("")
    
    with open('movies.csv', 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            movie_id = int(row['movieId'])
            title = clean_title(row['title'])
            year = extract_year_from_title(row['title'])
            genres = row['genres']
            
            sql_script.append(f"INSERT INTO movies (id, title, year, genres) VALUES ({movie_id}, {escape_sql_string(title)}, {year if year else 'NULL'}, {escape_sql_string(genres)});")
    
    sql_script.append("")
    
    with open('users.txt', 'r', encoding='utf-8') as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            parts = line.split('|')
            if len(parts) >= 6:
                user_id = int(parts[0])
                name = parts[1]
                email = parts[2]
                gender = parts[3]
                register_date = parts[4]
                occupation = parts[5]
                
                sql_script.append(f"INSERT INTO users (id, name, email, gender, register_date, occupation) VALUES ({user_id}, {escape_sql_string(name)}, {escape_sql_string(email)}, {escape_sql_string(gender)}, {escape_sql_string(register_date)}, {escape_sql_string(occupation)});")
    
    sql_script.append("")
    
    with open('ratings.csv', 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            user_id = int(row['userId'])
            movie_id = int(row['movieId'])
            rating = float(row['rating'])
            timestamp = int(row['timestamp'])
            
            sql_script.append(f"INSERT INTO ratings (user_id, movie_id, rating, timestamp) VALUES ({user_id}, {movie_id}, {rating}, {timestamp});")
    
    sql_script.append("")
    
    with open('tags.csv', 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            user_id = int(row['userId'])
            movie_id = int(row['movieId'])
            tag = row['tag']
            timestamp = int(row['timestamp'])
            
            sql_script.append(f"INSERT INTO tags (user_id, movie_id, tag, timestamp) VALUES ({user_id}, {movie_id}, {escape_sql_string(tag)}, {timestamp});")
    
    sql_script.append("")
    sql_script.append("CREATE INDEX idx_ratings_user_id ON ratings(user_id);")
    sql_script.append("CREATE INDEX idx_ratings_movie_id ON ratings(movie_id);")
    sql_script.append("CREATE INDEX idx_tags_user_id ON tags(user_id);")
    sql_script.append("CREATE INDEX idx_tags_movie_id ON tags(movie_id);")
    sql_script.append("CREATE INDEX idx_movies_year ON movies(year);")
    
    return '\n'.join(sql_script)


def main():
    print("Создание базы данных movies_rating.db...")
    
    required_files = ['movies.csv', 'users.txt', 'ratings.csv', 'tags.csv']
    for file in required_files:
        if not os.path.exists(file):
            print(f"Ошибка: файл {file} не найден!")
            return 1
    
    try:
        sql_content = generate_sql_script()
        
        with open('db_init.sql', 'w', encoding='utf-8', newline='\n') as f:
            f.write(sql_content)
        
        if os.path.exists('movies_rating.db'):
            os.remove('movies_rating.db')
        
        conn = sqlite3.connect('movies_rating.db')
        cursor = conn.cursor()
        cursor.executescript(sql_content)
        conn.commit()
        conn.close()
        
        print("База данных movies_rating.db успешно создана!")
        
        return 0
        
    except Exception as e:
        print(f"Ошибка: {e}")
        return 1


if __name__ == "__main__":
    exit(main())