<section class="card">
    <h2>Редактирование интервала</h2>
    <form method="post" class="grid">
        <input type="hidden" name="action" value="update_schedule">
        <input type="hidden" name="id" value="<?= $schedule['id'] ?>">
        <input type="hidden" name="employee_id" value="<?= (int)$_GET['employee_id'] ?>">
        <label>День недели
            <input name="weekday" required value="<?= h($schedule['weekday']) ?>">
        </label>
        <label>Начало
            <input type="time" name="start_time" required value="<?= $schedule['start_time'] ?>">
        </label>
        <label>Окончание
            <input type="time" name="end_time" required value="<?= $schedule['end_time'] ?>">
        </label>
        <label>Комментарий
            <input name="note" value="<?= h((string)$schedule['note']) ?>">
        </label>
        <div class="actions">
            <button type="submit">Сохранить</button>
            <a class="btn-secondary" href="index.php?action=schedule&employee_id=<?= (int)$_GET['employee_id'] ?>">Назад</a>
        </div>
    </form>
</section>

