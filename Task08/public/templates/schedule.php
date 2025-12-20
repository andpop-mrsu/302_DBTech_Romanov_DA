<section class="card">
    <h2>График работы: <?= h($employee['first_name'] . ' ' . $employee['last_name']) ?></h2>
    <div class="subnav">
        <a class="active" href="index.php?action=schedule&employee_id=<?= $employee['id'] ?>">График</a>
        <a href="index.php?action=work_records&employee_id=<?= $employee['id'] ?>">Выполненные работы</a>
    </div>
    <table>
        <thead>
        <tr>
            <th>День</th>
            <th>Начало</th>
            <th>Окончание</th>
            <th>Комментарий</th>
            <th></th>
        </tr>
        </thead>
        <tbody>
        <?php if (!$schedules): ?>
            <tr>
                <td colspan="5" style="text-align: center; color: var(--muted);">График не задан</td>
            </tr>
        <?php else: ?>
            <?php foreach ($schedules as $row): ?>
                <tr>
                    <td><?= h($row['weekday']) ?></td>
                    <td><?= $row['start_time'] ?></td>
                    <td><?= $row['end_time'] ?></td>
                    <td><?= h((string)$row['note']) ?></td>
                    <td class="table-actions">
                        <a href="index.php?action=edit_schedule&id=<?= $row['id'] ?>&employee_id=<?= $employee['id'] ?>">Редактировать</a>
                        <form method="post" onsubmit="return confirm('Удалить запись?');">
                            <input type="hidden" name="action" value="delete_schedule">
                            <input type="hidden" name="id" value="<?= $row['id'] ?>">
                            <input type="hidden" name="employee_id" value="<?= $employee['id'] ?>">
                            <button type="submit">Удалить</button>
                        </form>
                    </td>
                </tr>
            <?php endforeach; ?>
        <?php endif; ?>
        </tbody>
    </table>

    <h3>Добавить интервал</h3>
    <form method="post" class="grid">
        <input type="hidden" name="action" value="save_schedule">
        <input type="hidden" name="employee_id" value="<?= $employee['id'] ?>">
        <label>День недели
            <input name="weekday" placeholder="Например, Понедельник" required>
        </label>
        <label>Начало
            <input type="time" name="start_time" required>
        </label>
        <label>Окончание
            <input type="time" name="end_time" required>
        </label>
        <label>Комментарий
            <input name="note">
        </label>
        <div class="actions">
            <button type="submit">Сохранить</button>
            <a class="btn-secondary" href="index.php">К списку мастеров</a>
        </div>
    </form>
</section>

