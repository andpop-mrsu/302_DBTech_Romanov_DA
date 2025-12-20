<section class="card">
    <h2><?= $mode === 'create' ? 'Новый мастер' : 'Редактирование мастера' ?></h2>
    <form method="post">
        <input type="hidden" name="action" value="<?= $mode === 'create' ? 'create_employee' : 'update_employee' ?>">
        <?php if ($mode === 'edit' && $employee): ?>
            <input type="hidden" name="id" value="<?= $employee['id'] ?>">
        <?php endif; ?>
        <div class="grid">
            <label>Имя
                <input name="first_name" required value="<?= h($employee['first_name'] ?? '') ?>">
            </label>
            <label>Фамилия
                <input name="last_name" required value="<?= h($employee['last_name'] ?? '') ?>">
            </label>
            <label>Телефон
                <input name="phone" value="<?= h($employee['phone'] ?? '') ?>">
            </label>
            <label>Email
                <input type="email" name="email" value="<?= h($employee['email'] ?? '') ?>">
            </label>
            <label>Дата найма
                <input type="date" name="hire_date" required value="<?= $employee['hire_date'] ?? '' ?>">
            </label>
            <label>Дата увольнения
                <input type="date" name="dismissal_date" value="<?= $employee['dismissal_date'] ?? '' ?>">
            </label>
            <label>Процент зарплаты
                <input type="number" step="0.01" min="0" max="100" name="salary_percentage" value="<?= $employee['salary_percentage'] ?? '25' ?>">
            </label>
            <label class="checkbox">
                <input type="checkbox" name="is_active" <?= !isset($employee['is_active']) || $employee['is_active'] ? 'checked' : '' ?>> Активен
            </label>
        </div>
        <div class="specializations">
            <div class="spec-title">Специализации</div>
            <div class="spec-list">
                <?php foreach ($services as $service): ?>
                    <?php $checked = in_array((int)$service['id'], $employeeServices ?? [], true) ? 'checked' : ''; ?>
                    <label class="spec-item">
                        <input type="checkbox" name="services[]" value="<?= $service['id'] ?>" <?= $checked ?>>
                        <span><?= h($service['name']) ?></span>
                    </label>
                <?php endforeach; ?>
            </div>
        </div>
        <div class="actions">
            <button type="submit">Сохранить</button>
            <a class="btn-secondary" href="index.php">Отмена</a>
        </div>
    </form>
</section>

