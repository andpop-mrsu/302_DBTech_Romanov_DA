#!/bin/bash

chcp 65001

sqlite3 movies_rating.db < db_init.sql

echo 1. Найти все пары пользователей, оценивших один и тот же фильм. Устранить дубликаты, проверить отсутствие пар с самим собой. Для каждой пары должны быть указаны имена пользователей и название фильма, который они ценили. В списке оставить первые 100 записей.
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT DISTINCT u1.name AS 'Пользователь 1', u2.name AS 'Пользователь 2', m.title AS 'Название Фильма' FROM ratings r1 JOIN ratings r2 ON r1.movie_id = r2.movie_id AND r1.user_id < r2.user_id JOIN users u1 ON r1.user_id = u1.id JOIN users u2 ON r2.user_id = u2.id JOIN movies m ON r1.movie_id = m.id LIMIT 100"

echo ""
echo 2. Найти 10 самых старых оценок от разных пользователей, вывести названия фильмов, имена пользователей, оценку, дату отзыва в формате ГГГГ-ММ-ДД.
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT m.title AS movie_title, u.name AS user_name, r.rating, date(datetime(r.timestamp, 'unixepoch')) AS review_date FROM ratings r JOIN movies m ON r.movie_id = m.id JOIN users u ON r.user_id = u.id ORDER BY r.timestamp ASC LIMIT 10;"

echo ""
echo 3. Вывести в одном списке все фильмы с максимальным средним рейтингом и все фильмы с минимальным средним рейтингом. Общий список отсортировать по году выпуска и названию фильма. В зависимости от рейтинга в колонке "Рекомендуем" для фильмов должно быть написано "Да" или "Нет".
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "WITH MovieRatings AS (SELECT m.id, m.title, m.year, AVG(r.rating) AS avg_rating FROM movies m JOIN ratings r ON m.id = r.movie_id GROUP BY m.id, m.title, m.year), MaxMinRatings AS (SELECT MAX(avg_rating) AS max_rating, MIN(avg_rating) AS min_rating FROM MovieRatings) SELECT mr.title AS 'Название фильма', mr.year AS 'Год', ROUND(mr.avg_rating, 2) AS 'Средний рейтинг', CASE WHEN mr.avg_rating = (SELECT max_rating FROM MaxMinRatings) THEN 'Да' ELSE 'Нет' END AS 'Рекомендуем' FROM MovieRatings mr WHERE mr.avg_rating = (SELECT max_rating FROM MaxMinRatings) OR mr.avg_rating = (SELECT min_rating FROM MaxMinRatings) ORDER BY mr.year, mr.title;"

echo ""
echo 4. Вычислить количество оценок и среднюю оценку, которую дали фильмам пользователи-мужчины в период с 2011 по 2014 год.
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT COUNT(*) as 'Количество оценок', AVG(r.rating) as 'Cредняя оценка' FROM ratings r JOIN users u ON r.user_id = u.id WHERE u.gender = 'male' AND strftime('%%Y', datetime(r.timestamp, 'unixepoch')) BETWEEN '2011' AND '2014'"
echo " "

echo 5. Составить список фильмов с указанием средней оценки и количества пользователей, которые их оценили. Полученный список отсортировать по году выпуска и названиям фильмов. В списке оставить первые 20 записей.
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT m.title AS 'Название фильма', m.year AS 'Год', ROUND(AVG(r.rating), 2) AS 'Средняя оценка', COUNT(DISTINCT r.user_id) AS 'Количество оценок' FROM movies m JOIN ratings r ON m.id = r.movie_id GROUP BY m.id, m.title, m.year ORDER BY m.year, m.title LIMIT 20;"

echo ""
echo 6. Определить самый распространенный жанр фильма и количество фильмов в этом жанре. Отдельную таблицу для жанров не использовать, жанры нужно извлекать из таблицы movies.
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "WITH RECURSIVE split(genre, rest) AS (SELECT CASE WHEN instr(genres, '|') > 0 THEN substr(genres, 1, instr(genres, '|') - 1) ELSE genres END, CASE WHEN instr(genres, '|') > 0 THEN substr(genres, instr(genres, '|') + 1) ELSE '' END FROM movies WHERE genres != '(no genres listed)' UNION ALL SELECT CASE WHEN instr(rest, '|') > 0 THEN substr(rest, 1, instr(rest, '|') - 1) ELSE rest END, CASE WHEN instr(rest, '|') > 0 THEN substr(rest, instr(rest, '|') + 1) ELSE '' END FROM split WHERE rest != ''), GenreCounts AS (SELECT genre, COUNT(*) AS count FROM split WHERE genre != '' GROUP BY genre ORDER BY count DESC LIMIT 1) SELECT genre AS 'Самый распространенный жанр', count AS 'Количество фильмов' FROM GenreCounts;"

echo ""
echo 7. Вывести список из 10 последних зарегистрированных пользователей в формате "Фамилия Имя|Дата регистрации" (сначала фамилия, потом имя).
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "WITH LastUsers AS (SELECT name, register_date FROM users ORDER BY register_date DESC LIMIT 10) SELECT substr(name, instr(name, ' ') + 1) || ' ' || substr(name, 1, instr(name, ' ') - 1) || '|' || register_date AS 'Фамилия Имя|Дата регистрации' FROM LastUsers;"

echo ""
echo 8. С помощью рекурсивного CTE определить, на какие дни недели приходился ваш день рождения в каждом году.
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "WITH RECURSIVE BirthdayYears(year_num) AS (VALUES(2005) UNION ALL SELECT year_num + 1 FROM BirthdayYears WHERE year_num < 2024) SELECT year_num as year, case strftime('%%w', year_num || '-10-05') when '0' then 'Воскресенье' when '1' then 'Понедельник' when '2' then 'Вторник' when '3' then 'Среда' when '4' then 'Четверг' when '5' then 'Пятница' when '6' then 'Суббота' end as day_of_week FROM BirthdayYears ORDER BY year_num;"
echo ""`