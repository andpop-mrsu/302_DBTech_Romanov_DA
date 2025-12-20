<?php
declare(strict_types=1);

$path = __DIR__ . '/data/database.sqlite';
$pdo = new PDO('sqlite:' . $path);
$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
$pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);

$schema = file_get_contents(__DIR__ . '/schema.sql');
if ($schema === false) {
    throw new RuntimeException('Не удалось прочитать schema.sql');
}

$pdo->exec($schema);
echo "Database initialized at {$path}" . PHP_EOL;

