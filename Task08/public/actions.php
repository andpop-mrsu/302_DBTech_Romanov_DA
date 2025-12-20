<?php
declare(strict_types=1);

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    return;
}

$action = $_POST['action'] ?? '';

function normalizeIds(array $ids): array
{
    $clean = [];
    foreach ($ids as $id) {
        $i = (int)$id;
        if ($i > 0) {
            $clean[$i] = true;
        }
    }
    return array_keys($clean);
}

function syncEmployeeServices(PDO $pdo, int $employeeId, array $serviceIds): void
{
    $pdo->prepare('DELETE FROM EmployeeSpecialization WHERE employee_id = :id')->execute(['id' => $employeeId]);
    if (!$serviceIds) {
        return;
    }
    $stmt = $pdo->prepare('INSERT INTO EmployeeSpecialization (employee_id, service_id) VALUES (:employee_id, :service_id)');
    foreach ($serviceIds as $sid) {
        $stmt->execute(['employee_id' => $employeeId, 'service_id' => $sid]);
    }
}

if ($action === 'create_employee') {
    $serviceIds = isset($_POST['services']) && is_array($_POST['services']) ? normalizeIds($_POST['services']) : [];
    $pdo->beginTransaction();
    try {
        $stmt = $pdo->prepare('
            INSERT INTO Employee (first_name, last_name, phone, email, hire_date, dismissal_date, salary_percentage, is_active)
            VALUES (:first_name, :last_name, :phone, :email, :hire_date, :dismissal_date, :salary_percentage, :is_active)
        ');
        $stmt->execute([
            'first_name' => trim($_POST['first_name']),
            'last_name' => trim($_POST['last_name']),
            'phone' => trim($_POST['phone'] ?? ''),
            'email' => trim($_POST['email'] ?? ''),
            'hire_date' => $_POST['hire_date'],
            'dismissal_date' => $_POST['dismissal_date'] ?: null,
            'salary_percentage' => (float)$_POST['salary_percentage'],
            'is_active' => isset($_POST['is_active']) ? 1 : 0,
        ]);
        $employeeId = (int)$pdo->lastInsertId();
        syncEmployeeServices($pdo, $employeeId, $serviceIds);
        $pdo->commit();
    } catch (Throwable $e) {
        $pdo->rollBack();
        throw $e;
    }
    redirect();
}

if ($action === 'update_employee') {
    $serviceIds = isset($_POST['services']) && is_array($_POST['services']) ? normalizeIds($_POST['services']) : [];
    $pdo->beginTransaction();
    try {
        $stmt = $pdo->prepare('
            UPDATE Employee
            SET first_name = :first_name,
                last_name = :last_name,
                phone = :phone,
                email = :email,
                hire_date = :hire_date,
                dismissal_date = :dismissal_date,
                salary_percentage = :salary_percentage,
                is_active = :is_active
            WHERE id = :id
        ');
        $stmt->execute([
            'first_name' => trim($_POST['first_name']),
            'last_name' => trim($_POST['last_name']),
            'phone' => trim($_POST['phone'] ?? ''),
            'email' => trim($_POST['email'] ?? ''),
            'hire_date' => $_POST['hire_date'],
            'dismissal_date' => $_POST['dismissal_date'] ?: null,
            'salary_percentage' => (float)$_POST['salary_percentage'],
            'is_active' => isset($_POST['is_active']) ? 1 : 0,
            'id' => (int)$_POST['id'],
        ]);
        syncEmployeeServices($pdo, (int)$_POST['id'], $serviceIds);
        $pdo->commit();
    } catch (Throwable $e) {
        $pdo->rollBack();
        throw $e;
    }
    redirect();
}

if ($action === 'delete_employee') {
    $stmt = $pdo->prepare('DELETE FROM Employee WHERE id = :id');
    $stmt->execute(['id' => (int)$_POST['id']]);
    redirect();
}

if ($action === 'save_schedule') {
    $stmt = $pdo->prepare('
        INSERT INTO WorkSchedule (employee_id, weekday, start_time, end_time, note)
        VALUES (:employee_id, :weekday, :start_time, :end_time, :note)
    ');
    $stmt->execute([
        'employee_id' => (int)$_POST['employee_id'],
        'weekday' => $_POST['weekday'],
        'start_time' => $_POST['start_time'],
        'end_time' => $_POST['end_time'],
        'note' => trim($_POST['note'] ?? ''),
    ]);
    redirect(['action' => 'schedule', 'employee_id' => (int)$_POST['employee_id']]);
}

if ($action === 'update_schedule') {
    $stmt = $pdo->prepare('
        UPDATE WorkSchedule
        SET weekday = :weekday,
            start_time = :start_time,
            end_time = :end_time,
            note = :note
        WHERE id = :id
    ');
    $stmt->execute([
        'weekday' => $_POST['weekday'],
        'start_time' => $_POST['start_time'],
        'end_time' => $_POST['end_time'],
        'note' => trim($_POST['note'] ?? ''),
        'id' => (int)$_POST['id'],
    ]);
    redirect(['action' => 'schedule', 'employee_id' => (int)$_POST['employee_id']]);
}

if ($action === 'delete_schedule') {
    $stmt = $pdo->prepare('DELETE FROM WorkSchedule WHERE id = :id');
    $stmt->execute(['id' => (int)$_POST['id']]);
    redirect(['action' => 'schedule', 'employee_id' => (int)$_POST['employee_id']]);
}

if ($action === 'save_work') {
    $stmt = $pdo->prepare('
        INSERT INTO WorkRecord (appointment_id, employee_id, service_id, car_category_id, actual_duration, actual_price, work_date, start_time, end_time, notes)
        VALUES (:appointment_id, :employee_id, :service_id, :car_category_id, :actual_duration, :actual_price, :work_date, :start_time, :end_time, :notes)
    ');
    $stmt->execute([
        'appointment_id' => (int)$_POST['appointment_id'],
        'employee_id' => (int)$_POST['employee_id'],
        'service_id' => (int)$_POST['service_id'],
        'car_category_id' => (int)$_POST['car_category_id'],
        'actual_duration' => (int)$_POST['actual_duration'],
        'actual_price' => (float)$_POST['actual_price'],
        'work_date' => $_POST['work_date'],
        'start_time' => $_POST['start_time'],
        'end_time' => $_POST['end_time'],
        'notes' => trim($_POST['notes'] ?? ''),
    ]);
    redirect(['action' => 'work_records', 'employee_id' => (int)$_POST['employee_id']]);
}

if ($action === 'update_work') {
    $stmt = $pdo->prepare('
        UPDATE WorkRecord
        SET appointment_id = :appointment_id,
            service_id = :service_id,
            car_category_id = :car_category_id,
            actual_duration = :actual_duration,
            actual_price = :actual_price,
            work_date = :work_date,
            start_time = :start_time,
            end_time = :end_time,
            notes = :notes
        WHERE id = :id
    ');
    $stmt->execute([
        'appointment_id' => (int)$_POST['appointment_id'],
        'service_id' => (int)$_POST['service_id'],
        'car_category_id' => (int)$_POST['car_category_id'],
        'actual_duration' => (int)$_POST['actual_duration'],
        'actual_price' => (float)$_POST['actual_price'],
        'work_date' => $_POST['work_date'],
        'start_time' => $_POST['start_time'],
        'end_time' => $_POST['end_time'],
        'notes' => trim($_POST['notes'] ?? ''),
        'id' => (int)$_POST['id'],
    ]);
    redirect(['action' => 'work_records', 'employee_id' => (int)$_POST['employee_id']]);
}

if ($action === 'delete_work') {
    $stmt = $pdo->prepare('DELETE FROM WorkRecord WHERE id = :id');
    $stmt->execute(['id' => (int)$_POST['id']]);
    redirect(['action' => 'work_records', 'employee_id' => (int)$_POST['employee_id']]);
}

