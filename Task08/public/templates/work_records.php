<section class="card">
    <h2>Выполненные работы: <?= h($employee['first_name'] . ' ' . $employee['last_name']) ?></h2>
    <div class="subnav">
        <a href="index.php?action=schedule&employee_id=<?= $employee['id'] ?>">График</a>
        <a class="active" href="index.php?action=work_records&employee_id=<?= $employee['id'] ?>">Выполненные работы</a>
    </div>
    <table>
        <thead>
        <tr>
            <th>Дата</th>
            <th>Время</th>
            <th>Услуга</th>
            <th>Категория авто</th>
            <th>Длительность (мин)</th>
            <th>Стоимость</th>
            <th>Заметки</th>
            <th></th>
        </tr>
        </thead>
        <tbody>
        <?php if (!$workRecords): ?>
            <tr>
                <td colspan="8" style="text-align: center; color: var(--muted);">Нет выполненных работ</td>
            </tr>
        <?php else: ?>
            <?php foreach ($workRecords as $row): ?>
                <tr>
                    <td><?= $row['work_date'] ?></td>
                    <td><?= $row['start_time'] ?> - <?= $row['end_time'] ?></td>
                    <td><?= h((string)$row['service_name']) ?></td>
                    <td><?= h((string)$row['category_name']) ?></td>
                    <td><?= $row['actual_duration'] ?></td>
                    <td><?= number_format((float)$row['actual_price'], 2, '.', ' ') ?></td>
                    <td><?= h((string)$row['notes']) ?></td>
                    <td class="table-actions">
                        <a href="index.php?action=edit_work&id=<?= $row['id'] ?>&employee_id=<?= $employee['id'] ?>">Редактировать</a>
                        <form method="post" onsubmit="return confirm('Удалить запись?');">
                            <input type="hidden" name="action" value="delete_work">
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

    <h3>Добавить запись</h3>
    <form method="post" class="grid">
        <input type="hidden" name="action" value="save_work">
        <input type="hidden" name="employee_id" value="<?= $employee['id'] ?>">
        <label>Приём
            <select name="appointment_id" required>
                <option value="" disabled selected>Выберите приём</option>
                <?php foreach ($appointments as $app): ?>
                    <option value="<?= $app['id'] ?>">
                        <?= h($app['client_name']) ?> — <?= $app['appointment_date'] ?> <?= $app['appointment_time'] ?>
                    </option>
                <?php endforeach; ?>
            </select>
        </label>
        <label>Услуга
            <select name="service_id" required>
                <option value="" disabled selected>Выберите услугу</option>
                <?php foreach ($services as $service): ?>
                    <option value="<?= $service['id'] ?>"><?= h($service['name']) ?></option>
                <?php endforeach; ?>
            </select>
        </label>
        <label>Категория авто
            <select name="car_category_id" required>
                <option value="" disabled selected>Выберите категорию</option>
                <?php foreach ($carCategories as $cat): ?>
                    <option value="<?= $cat['id'] ?>"><?= h($cat['name']) ?></option>
                <?php endforeach; ?>
            </select>
        </label>
        <label>Длительность, мин
            <input type="number" name="actual_duration" min="1" required placeholder="Например, 60">
        </label>
        <label>Стоимость
            <input type="number" step="0.01" min="0" name="actual_price" required placeholder="Например, 2500">
        </label>
        <label>Дата
            <input type="date" name="work_date" required>
        </label>
        <label>Начало
            <input type="time" name="start_time" required>
        </label>
        <label>Конец
            <input type="time" name="end_time" required>
        </label>
        <label>Заметки
            <input name="notes" placeholder="Комментарий (необязательно)">
        </label>
        <div class="actions">
            <button type="submit">Сохранить</button>
            <a class="btn-secondary" href="index.php">К списку мастеров</a>
        </div>
    </form>
</section>

