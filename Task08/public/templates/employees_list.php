<section class="card">
    <table>
        <thead>
        <tr>
            <th>Фамилия</th>
            <th>Имя</th>
            <th>Телефон</th>
            <th>Email</th>
            <th>Специализация</th>
            <th>Статус</th>
            <th></th>
        </tr>
        </thead>
        <tbody>
        <?php foreach ($employees as $employee): ?>
            <tr>
                <td><?= h($employee['last_name']) ?></td>
                <td><?= h($employee['first_name']) ?></td>
                <td><?= h((string)$employee['phone']) ?></td>
                <td><?= h((string)$employee['email']) ?></td>
                <td><?= h((string)$employee['specializations']) ?></td>
                <td><?= $employee['is_active'] ? 'Активен' : 'Не работает' ?></td>
                <td class="table-actions">
                    <a href="index.php?action=schedule&employee_id=<?= $employee['id'] ?>">График</a>
                    <a href="index.php?action=work_records&employee_id=<?= $employee['id'] ?>">Выполненные работы</a>
                    <a href="index.php?action=edit_employee&id=<?= $employee['id'] ?>">Редактировать</a>
                    <a class="danger" href="index.php?action=confirm_delete_employee&id=<?= $employee['id'] ?>">Удалить</a>
                </td>
            </tr>
        <?php endforeach; ?>
        </tbody>
    </table>
    <div class="actions">
        <a class="btn-primary" href="index.php?action=add_employee">Добавить</a>
    </div>
</section>

