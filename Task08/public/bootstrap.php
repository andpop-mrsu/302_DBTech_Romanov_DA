<?php
declare(strict_types=1);

$dbPath = __DIR__ . '/../data/database.sqlite';

function getPdo(string $path): PDO
{
    $pdo = new PDO('sqlite:' . $path);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
    return $pdo;
}

function initializeDatabase(PDO $pdo): void
{
    $exists = $pdo->query("SELECT name FROM sqlite_master WHERE type='table' AND name='Employee'")->fetchColumn();
    if ($exists) {
        return;
    }

    $schema = file_get_contents(__DIR__ . '/../schema.sql');
    if ($schema === false) {
        throw new RuntimeException('Не удалось прочитать schema.sql');
    }
    $pdo->exec($schema);
}

function redirect(array $params = []): never
{
    $url = 'index.php';
    if ($params) {
        $url .= '?' . http_build_query($params);
    }
    header("Location: {$url}");
    exit;
}

function h(?string $value): string
{
    return htmlspecialchars((string)$value, ENT_QUOTES);
}

$pdo = getPdo($dbPath);
initializeDatabase($pdo);

