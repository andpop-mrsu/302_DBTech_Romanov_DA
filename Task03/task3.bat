#!/bin/bash
chcp 65001

D:\SQLite\sqlite3.exe movies_rating.db < db_init.sql

echo "1. Составить список фильмов, имеющих хотя бы одну оценку. Список фильмов отсортировать по году выпуска и по названиям. В списке оставить первые 10 фильмов."
echo "--------------------------------------------------"
sqlite3 movies_rating.db -box -echo "SELECT DISTINCT m.title, m.year FROM movies m JOIN ratings r ON m.id = r.movie_id ORDER BY m.year, m.title LIMIT 10;"
echo ""

echo "2. Вывести список всех пользователей, фамилии (не имена!) которых начинаются на букву 'A'. Полученный список отсортировать по дате регистрации. В списке оставить первых 5 пользователей."
echo "--------------------------------------------------"
sqlite3.exe movies_rating.db -box -echo "SELECT id, name, email, gender, register_date, occupation FROM users WHERE name GLOB '* A*' ORDER BY register_date LIMIT 5;"
echo ""


echo "3. Запрос, возвращающий информацию о рейтингах в более читаемом формате: имя и фамилия эксперта, название фильма, год выпуска, оценка и дата оценки в формате ГГГГ-ММ-ДД. Отсортировать по имени эксперта, названию фильма и оценке. В списке оставить первые 50 записей."
echo "--------------------------------------------------"
sqlite3 movies_rating.db -box -echo "SELECT u.name AS expert_name, m.title AS movie_title, m.year AS release_year, r.rating, datetime(r.timestamp, 'unixepoch') AS rating_date FROM ratings r JOIN users u ON u.id = r.user_id JOIN movies m ON m.id = r.movie_id ORDER BY u.name, m.title, r.rating LIMIT 50;"
echo ""

echo "4. Вывести список фильмов с указанием тегов, присвоенных пользователями. Сортировать по году, названию и тегу. В списке оставить первые 40 записей."
echo "--------------------------------------------------"
sqlite3 movies_rating.db -box -echo "SELECT m.title, m.year, t.tag FROM movies m JOIN tags t ON m.id = t.movie_id ORDER BY m.year, m.title, t.tag LIMIT 40;"
echo ""

echo "5. Вывести список самых свежих фильмов (последнего года выпуска). Год должен определяться автоматически."
echo "--------------------------------------------------"
sqlite3 movies_rating.db -box -echo "SELECT title, year FROM movies WHERE year = (SELECT MAX(year) FROM movies) ORDER BY title;"
echo ""

echo "6. Найти все драмы, выпущенные после 2005 года, которые понравились женщинам (оценка >= 4.5). Вывести название, год и количество таких оценок. Отсортировать по году и названию."
echo "--------------------------------------------------"
sqlite3.exe movies_rating.db -box -echo "SELECT m.title, m.year, COUNT(*) as high_ratings_count FROM movies m JOIN ratings r ON m.id = r.movie_id JOIN users u ON r.user_id = u.id WHERE ('|' || m.genres || '|') GLOB '*|Drama|*' AND m.year > 2005 AND u.gender = 'female' AND r.rating >= 4.5 GROUP BY m.id, m.title, m.year ORDER BY m.year, m.title;"
echo ""

echo "7. Анализ востребованности ресурса — количество пользователей, зарегистрировавшихся по годам, и определение лет с наибольшим и наименьшим количеством регистраций."
echo "--------------------------------------------------"
sqlite3 movies_rating.db -box -echo "SELECT SUBSTR(register_date, 1, 4) AS reg_year, COUNT(*) AS user_count FROM users GROUP BY reg_year ORDER BY reg_year;"
echo ""
echo "Годы с наибольшим и наименьшим количеством регистраций:"
sqlite3 movies_rating.db -box -echo "WITH yearly_counts AS (SELECT SUBSTR(register_date, 1, 4) AS reg_year, COUNT(*) AS user_count FROM users GROUP BY reg_year) SELECT reg_year, user_count FROM yearly_counts WHERE user_count = (SELECT MAX(user_count) FROM yearly_counts) OR user_count = (SELECT MIN(user_count) FROM yearly_counts) ORDER BY user_count DESC;"
echo ""