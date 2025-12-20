<section class="card">
    <h2>Редактирование записи</h2>
    <form method="post" class="grid">
        <input type="hidden" name="action" value="update_work">
        <input type="hidden" name="id" value="<?= $work['id'] ?>">
        <input type="hidden" name="employee_id" value="<?= (int)$_GET['employee_id'] ?>">
        <label>Приём
            <select name="appointment_id" required>
                <?php foreach ($appointments as $app): ?>
                    <option value="<?= $app['id'] ?>" <?= $app['id'] == $work['appointment_id'] ? 'selected' : '' ?>>
                        <?= h($app['client_name']) ?> — <?= $app['appointment_date'] ?> <?= $app['appointment_time'] ?>
                    </option>
                <?php endforeach; ?>
            </select>
        </label>
        <label>Услуга
            <select name="service_id" required>
                <?php foreach ($services as $service): ?>
                    <option value="<?= $service['id'] ?>" <?= $service['id'] == $work['service_id'] ? 'selected' : '' ?>>
                        <?= h($service['name']) ?>
                    </option>
                <?php endforeach; ?>
            </select>
        </label>
        <label>Категория авто
            <select name="car_category_id" required>
                <?php foreach ($carCategories as $cat): ?>
                    <option value="<?= $cat['id'] ?>" <?= $cat['id'] == $work['car_category_id'] ? 'selected' : '' ?>>
                        <?= h($cat['name']) ?>
                    </option>
                <?php endforeach; ?>
            </select>
        </label>
        <label>Длительность, мин
            <input type="number" name="actual_duration" min="1" required value="<?= $work['actual_duration'] ?>">
        </label>
        <label>Стоимость
            <input type="number" step="0.01" min="0" name="actual_price" required value="<?= $work['actual_price'] ?>">
        </label>
        <label>Дата
            <input type="date" name="work_date" required value="<?= $work['work_date'] ?>">
        </label>
        <label>Начало
            <input type="time" name="start_time" required value="<?= $work['start_time'] ?>">
        </label>
        <label>Конец
            <input type="time" name="end_time" required value="<?= $work['end_time'] ?>">
        </label>
        <label>Заметки
            <input name="notes" value="<?= h((string)$work['notes']) ?>">
        </label>
        <div class="actions">
            <button type="submit">Сохранить</button>
            <a class="btn-secondary" href="index.php?action=work_records&employee_id=<?= (int)$_GET['employee_id'] ?>">Назад</a>
        </div>
    </form>
</section>

