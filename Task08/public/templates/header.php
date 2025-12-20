<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>СТО — мастера</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
<div class="topbar">
    <div class="topbar-title">СТО</div>
    <div class="topbar-nav">
        <a href="index.php" class="<?= ($_GET['action'] ?? 'list') === 'list' ? 'active' : '' ?>">Мастера</a>
        <a href="index.php?action=all_work" class="<?= ($_GET['action'] ?? 'list') === 'all_work' ? 'active' : '' ?>">Выполненные работы</a>
    </div>
</div>

