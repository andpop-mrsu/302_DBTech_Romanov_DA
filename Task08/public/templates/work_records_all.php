<section class="card">
    <h2>Все выполненные работы</h2>
    <table>
        <thead>
        <tr>
            <th>Дата</th>
            <th>Время</th>
            <th>Мастер</th>
            <th>Клиент</th>
            <th>Телефон</th>
            <th>Услуга</th>
            <th>Категория</th>
            <th>Авто</th>
            <th>Стоимость</th>
            <th>Заметки</th>
        </tr>
        </thead>
        <tbody>
        <?php foreach ($allWorkRecords as $row): ?>
            <tr>
                <td><?= $row['work_date'] ?></td>
                <td><?= $row['start_time'] ?> - <?= $row['end_time'] ?></td>
                <td><?= h(trim(($row['employee_last'] ?? '') . ' ' . ($row['employee_first'] ?? ''))) ?></td>
                <td><?= h($row['client_name']) ?></td>
                <td><?= h((string)$row['client_phone']) ?></td>
                <td><?= h((string)$row['service_name']) ?></td>
                <td><?= h((string)$row['category_name']) ?></td>
                <td><?= h(trim(($row['car_model'] ?? '') . ' ' . ($row['car_license_plate'] ?? ''))) ?></td>
                <td><?= number_format((float)$row['actual_price'], 2, '.', ' ') ?></td>
                <td><?= h((string)$row['notes']) ?></td>
            </tr>
        <?php endforeach; ?>
        </tbody>
    </table>
</section>

