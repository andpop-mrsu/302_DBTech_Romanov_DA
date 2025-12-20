<?php
declare(strict_types=1);

function fetchEmployees(PDO $pdo): array
{
    $sql = "
        SELECT e.*, GROUP_CONCAT(s.name, ', ') AS specializations
        FROM Employee e
        LEFT JOIN EmployeeSpecialization es ON es.employee_id = e.id
        LEFT JOIN Service s ON s.id = es.service_id
        GROUP BY e.id
        ORDER BY e.last_name COLLATE NOCASE, e.first_name COLLATE NOCASE
    ";
    return $pdo->query($sql)->fetchAll();
}

function fetchEmployee(PDO $pdo, int $id): ?array
{
    $stmt = $pdo->prepare('SELECT * FROM Employee WHERE id = :id');
    $stmt->execute(['id' => $id]);
    $row = $stmt->fetch();
    return $row ?: null;
}

function fetchEmployeeServiceIds(PDO $pdo, int $employeeId): array
{
    $stmt = $pdo->prepare('SELECT service_id FROM EmployeeSpecialization WHERE employee_id = :id');
    $stmt->execute(['id' => $employeeId]);
    return array_map('intval', array_column($stmt->fetchAll(), 'service_id'));
}

function fetchServices(PDO $pdo): array
{
    return $pdo->query('SELECT id, name FROM Service ORDER BY name')->fetchAll();
}

function fetchCarCategories(PDO $pdo): array
{
    return $pdo->query('SELECT id, name FROM CarCategory ORDER BY name')->fetchAll();
}

function fetchAppointments(PDO $pdo): array
{
    $sql = "SELECT id, client_name, appointment_date, appointment_time FROM Appointment ORDER BY appointment_date DESC, appointment_time DESC";
    return $pdo->query($sql)->fetchAll();
}

function fetchSchedules(PDO $pdo, int $employeeId): array
{
    $sql = "
        SELECT *,
               CASE weekday
                   WHEN 'Понедельник' THEN 1
                   WHEN 'Вторник' THEN 2
                   WHEN 'Среда' THEN 3
                   WHEN 'Четверг' THEN 4
                   WHEN 'Пятница' THEN 5
                   WHEN 'Суббота' THEN 6
                   WHEN 'Воскресенье' THEN 7
                   ELSE 8
               END AS weekday_order
        FROM WorkSchedule
        WHERE employee_id = :id
        ORDER BY weekday_order, start_time
    ";
    $stmt = $pdo->prepare($sql);
    $stmt->execute(['id' => $employeeId]);
    return $stmt->fetchAll();
}

function fetchSchedule(PDO $pdo, int $id): ?array
{
    $stmt = $pdo->prepare('SELECT * FROM WorkSchedule WHERE id = :id');
    $stmt->execute(['id' => $id]);
    $row = $stmt->fetch();
    return $row ?: null;
}

function ensureDefaultSchedule(PDO $pdo, int $employeeId): void
{
    $stmt = $pdo->prepare('SELECT COUNT(*) FROM WorkSchedule WHERE employee_id = :id');
    $stmt->execute(['id' => $employeeId]);
    $count = (int)$stmt->fetchColumn();
    if ($count > 0) {
        return;
    }

    $defaults = [
        ['Понедельник', '09:00', '18:00'],
        ['Вторник', '09:00', '18:00'],
        ['Среда', '09:00', '18:00'],
        ['Четверг', '09:00', '18:00'],
        ['Пятница', '09:00', '18:00'],
    ];
    $insert = $pdo->prepare('
        INSERT INTO WorkSchedule (employee_id, weekday, start_time, end_time, note)
        VALUES (:employee_id, :weekday, :start_time, :end_time, :note)
    ');
    foreach ($defaults as [$day, $start, $end]) {
        $insert->execute([
            'employee_id' => $employeeId,
            'weekday' => $day,
            'start_time' => $start,
            'end_time' => $end,
            'note' => '',
        ]);
    }
}

function fetchWorkRecords(PDO $pdo, int $employeeId): array
{
    $sql = "
        SELECT wr.*, s.name AS service_name, c.name AS category_name
        FROM WorkRecord wr
        LEFT JOIN Service s ON s.id = wr.service_id
        LEFT JOIN CarCategory c ON c.id = wr.car_category_id
        WHERE wr.employee_id = :id
        ORDER BY wr.work_date DESC, wr.start_time DESC
    ";
    $stmt = $pdo->prepare($sql);
    $stmt->execute(['id' => $employeeId]);
    return $stmt->fetchAll();
}

function fetchWorkRecord(PDO $pdo, int $id): ?array
{
    $stmt = $pdo->prepare('SELECT * FROM WorkRecord WHERE id = :id');
    $stmt->execute(['id' => $id]);
    $row = $stmt->fetch();
    return $row ?: null;
}

function fetchAllWorkRecords(PDO $pdo): array
{
    $sql = "
        SELECT
            wr.*,
            e.first_name AS employee_first,
            e.last_name AS employee_last,
            s.name AS service_name,
            c.name AS category_name,
            a.client_name,
            a.client_phone,
            a.car_model,
            a.car_license_plate
        FROM WorkRecord wr
        LEFT JOIN Employee e ON e.id = wr.employee_id
        LEFT JOIN Service s ON s.id = wr.service_id
        LEFT JOIN CarCategory c ON c.id = wr.car_category_id
        LEFT JOIN Appointment a ON a.id = wr.appointment_id
        ORDER BY wr.work_date DESC, wr.start_time DESC
    ";
    return $pdo->query($sql)->fetchAll();
}

