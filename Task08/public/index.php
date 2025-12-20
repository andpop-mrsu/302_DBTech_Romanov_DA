<?php
declare(strict_types=1);

require __DIR__ . '/bootstrap.php';
require __DIR__ . '/repository.php';
require __DIR__ . '/actions.php';

$action = $_GET['action'] ?? 'list';
$employeeId = isset($_GET['employee_id']) ? (int)$_GET['employee_id'] : null;
$id = isset($_GET['id']) ? (int)$_GET['id'] : null;

$employees = fetchEmployees($pdo);
$services = fetchServices($pdo);
$carCategories = fetchCarCategories($pdo);
$appointments = fetchAppointments($pdo);
$allWorkRecords = $action === 'all_work' ? fetchAllWorkRecords($pdo) : [];

include __DIR__ . '/templates/header.php';

?>
<div class="container">
    <h1>Мастера СТО</h1>

    <?php if ($action === 'add_employee'): ?>
        <?php $mode = 'create'; $employee = null; $employeeServices = []; ?>
        <?php include __DIR__ . '/templates/employee_form.php'; ?>

<?php elseif ($action === 'edit_employee' && $id): ?>
        <?php
        $employee = fetchEmployee($pdo, $id);
        $employeeServices = $employee ? fetchEmployeeServiceIds($pdo, $id) : [];
        ?>
        <?php if ($employee): ?>
            <?php $mode = 'edit'; ?>
            <?php include __DIR__ . '/templates/employee_form.php'; ?>
        <?php endif; ?>

    <?php elseif ($action === 'confirm_delete_employee' && $id): ?>
        <?php $employee = fetchEmployee($pdo, $id); ?>
        <?php if ($employee): ?>
            <?php include __DIR__ . '/templates/employee_delete.php'; ?>
        <?php endif; ?>

    <?php elseif ($action === 'schedule' && $employeeId): ?>
        <?php $employee = fetchEmployee($pdo, $employeeId); ?>
        <?php if ($employee): ?>
            <?php ensureDefaultSchedule($pdo, $employeeId); ?>
            <?php $schedules = fetchSchedules($pdo, $employeeId); ?>
            <?php include __DIR__ . '/templates/schedule.php'; ?>
        <?php endif; ?>

    <?php elseif ($action === 'edit_schedule' && $employeeId && $id): ?>
        <?php $schedule = fetchSchedule($pdo, $id); ?>
        <?php if ($schedule): ?>
            <?php include __DIR__ . '/templates/schedule_edit.php'; ?>
        <?php endif; ?>

    <?php elseif ($action === 'work_records' && $employeeId): ?>
        <?php $employee = fetchEmployee($pdo, $employeeId); ?>
        <?php if ($employee): ?>
            <?php $workRecords = fetchWorkRecords($pdo, $employeeId); ?>
            <?php include __DIR__ . '/templates/work_records.php'; ?>
        <?php endif; ?>

    <?php elseif ($action === 'edit_work' && $employeeId && $id): ?>
        <?php $work = fetchWorkRecord($pdo, $id); ?>
        <?php if ($work): ?>
            <?php include __DIR__ . '/templates/work_edit.php'; ?>
        <?php endif; ?>

    <?php elseif ($action === 'all_work'): ?>
        <?php include __DIR__ . '/templates/work_records_all.php'; ?>

    <?php else: ?>
        <?php include __DIR__ . '/templates/employees_list.php'; ?>
    <?php endif; ?>
</div>

<?php include __DIR__ . '/templates/footer.php'; ?>

