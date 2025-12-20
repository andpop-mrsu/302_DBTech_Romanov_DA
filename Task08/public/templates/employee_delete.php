<section class="card warning">
    <h2>Удалить мастера <?= h($employee['first_name'] . ' ' . $employee['last_name']) ?>?</h2>
    <form method="post">
        <input type="hidden" name="action" value="delete_employee">
        <input type="hidden" name="id" value="<?= $employee['id'] ?>">
        <div class="actions">
            <button type="submit">Удалить</button>
            <a class="btn-secondary" href="index.php">Отмена</a>
        </div>
    </form>
</section>

