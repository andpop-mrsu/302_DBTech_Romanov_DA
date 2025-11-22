INSERT OR IGNORE INTO users (name, email, gender, register_date, occupation_id)
VALUES
('Романов Дмитрий Алексеевич', 'Romanov13@gmail.com', 'male', date('now'),
 (SELECT id FROM occupations ORDER BY id LIMIT 1)),
('Соснина Ирина Васильевна', 'SosninaIrishka@gmail.com', 'female', date('now'),
 (SELECT id FROM occupations ORDER BY id LIMIT 1)),
('Тиосса Максим Николаевич', 'TiossaMaks@mail.ru', 'male', date('now'),
 (SELECT id FROM occupations ORDER BY id LIMIT 1)),
('Тужин Данила Олегович', 'TyzhinDanila@gmail.com', 'male', date('now'),
 (SELECT id FROM occupations ORDER BY id LIMIT 1)),
('Учуваткин Никита Сергеевич', 'YchvatkinQWE@yandex.ru', 'male', date('now'),
 (SELECT id FROM occupations ORDER BY id LIMIT 1));



INSERT OR IGNORE INTO movies (title, year)
VALUES
('Анора (2024)', 2024),
('Переводчик (2023)', 2023),
('Бэтмен (2022)', 2022);


INSERT OR IGNORE INTO genres (name) VALUES ('Sci-Fi');
INSERT OR IGNORE INTO genres (name) VALUES ('Action');
INSERT OR IGNORE INTO genres (name) VALUES ('Crime');
INSERT OR IGNORE INTO genres (name) VALUES ('Thriller');
INSERT OR IGNORE INTO genres (name) VALUES ('Drama');

INSERT OR IGNORE INTO movie_genres (movie_id, genre_id)
SELECT m.id, g.id FROM movies m JOIN genres g ON g.name = 'Drama'
WHERE m.title = 'Анора (2024)';

INSERT OR IGNORE INTO movie_genres (movie_id, genre_id)
SELECT m.id, g.id FROM movies m JOIN genres g ON g.name = 'Thriller'
WHERE m.title = 'Переводчик (2023)';

INSERT OR IGNORE INTO movie_genres (movie_id, genre_id)
SELECT m.id, g.id FROM movies m JOIN genres g ON g.name = 'Action'
WHERE m.title = 'Бэтмен (2022)';

INSERT INTO ratings (user_id, movie_id, rating, timestamp)
SELECT u.id, m.id, 3.8, strftime('%s','now')
FROM users u JOIN movies m ON m.title = 'Анора (2024)'
WHERE u.email = 'Romanov13@gmail.com'
AND NOT EXISTS (
    SELECT 1 FROM ratings r WHERE r.user_id = u.id AND r.movie_id = m.id
);

INSERT INTO ratings (user_id, movie_id, rating, timestamp)
SELECT u.id, m.id, 5.0, strftime('%s','now')
FROM users u JOIN movies m ON m.title = 'Переводчик (2023)'
WHERE u.email = 'Romanov13@gmail.com'
AND NOT EXISTS (
    SELECT 1 FROM ratings r WHERE r.user_id = u.id AND r.movie_id = m.id
);

INSERT INTO ratings (user_id, movie_id, rating, timestamp)
SELECT u.id, m.id, 4.5, strftime('%s','now')
FROM users u JOIN movies m ON m.title = 'Бэтмен (2022)'
WHERE u.email = 'Romanov13@gmail.com'
AND NOT EXISTS (
    SELECT 1 FROM ratings r WHERE r.user_id = u.id AND r.movie_id = m.id
);