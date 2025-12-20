PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS CarCategory (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS Employee (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    hire_date DATE NOT NULL,
    dismissal_date DATE NULL,
    salary_percentage DECIMAL(5,2) NOT NULL DEFAULT 25.00,
    is_active BOOLEAN NOT NULL DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CHECK (salary_percentage BETWEEN 0 AND 100),
    CHECK (dismissal_date IS NULL OR dismissal_date > hire_date)
);

CREATE TABLE IF NOT EXISTS Service (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    duration_minutes INTEGER NOT NULL DEFAULT 60,
    base_price DECIMAL(10,2) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CHECK (duration_minutes > 0),
    CHECK (base_price >= 0)
);

CREATE TABLE IF NOT EXISTS ServicePrice (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    service_id INTEGER NOT NULL,
    car_category_id INTEGER NOT NULL,
    actual_price DECIMAL(10,2) NOT NULL,
    effective_date DATE NOT NULL DEFAULT CURRENT_DATE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (service_id) REFERENCES Service(id) ON DELETE CASCADE,
    FOREIGN KEY (car_category_id) REFERENCES CarCategory(id) ON DELETE CASCADE,
    CHECK (actual_price >= 0),
    UNIQUE(service_id, car_category_id, effective_date)
);

CREATE TABLE IF NOT EXISTS EmployeeSpecialization (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    employee_id INTEGER NOT NULL,
    service_id INTEGER NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES Employee(id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES Service(id) ON DELETE CASCADE,
    UNIQUE(employee_id, service_id)
);

CREATE TABLE IF NOT EXISTS Appointment (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    employee_id INTEGER NOT NULL,
    service_id INTEGER NOT NULL,
    car_category_id INTEGER NOT NULL,
    client_name VARCHAR(100) NOT NULL,
    client_phone VARCHAR(20),
    car_model VARCHAR(100) NOT NULL,
    car_license_plate VARCHAR(20),
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'scheduled',
    scheduled_duration INTEGER NOT NULL,
    scheduled_price DECIMAL(10,2) NOT NULL,
    notes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES Employee(id),
    FOREIGN KEY (service_id) REFERENCES Service(id),
    FOREIGN KEY (car_category_id) REFERENCES CarCategory(id),
    CHECK (status IN ('scheduled', 'completed', 'cancelled', 'no_show')),
    CHECK (scheduled_duration > 0),
    CHECK (scheduled_price >= 0)
);

CREATE TABLE IF NOT EXISTS WorkRecord (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    appointment_id INTEGER NOT NULL,
    employee_id INTEGER NOT NULL,
    service_id INTEGER NOT NULL,
    car_category_id INTEGER NOT NULL,
    actual_duration INTEGER NOT NULL,
    actual_price DECIMAL(10,2) NOT NULL,
    work_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    notes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appointment_id) REFERENCES Appointment(id),
    FOREIGN KEY (employee_id) REFERENCES Employee(id),
    FOREIGN KEY (service_id) REFERENCES Service(id),
    FOREIGN KEY (car_category_id) REFERENCES CarCategory(id),
    CHECK (actual_duration > 0),
    CHECK (actual_price >= 0),
    CHECK (end_time > start_time)
);

CREATE TABLE IF NOT EXISTS WorkSchedule (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    employee_id INTEGER NOT NULL,
    weekday VARCHAR(30) NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    note TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES Employee(id) ON DELETE CASCADE,
    CHECK (end_time > start_time)
);

INSERT INTO CarCategory (name, description) VALUES
('Легковые', 'Легковые автомобили всех классов'),
('Внедорожники', 'Кроссоверы и внедорожники'),
('Коммерческие', 'Грузовики и коммерческий транспорт'),
('Мотоциклы', 'Мотоциклы и скутеры');

INSERT INTO Employee (first_name, last_name, phone, email, hire_date, salary_percentage) VALUES
('Ксения', 'Горина', '+7 (902) 333-12-43', 'ksssGorina@sto.ru', '2022-24-12', 26.00),
('Иван', 'Иванов', '+7 (321) 445-90-99', 'ivanIVANOV@mail.ru', '2023-03-13', 35.00),
('Юрий', 'Разинков', '+7 (321) 445-90-99', 'Razinkovvv13@gmail.ru', '2023-12-03', 30.00),
('Елена', 'Сидорова', '+7 (912) 345-67-90', 'ElenaSidr@mail.ru', '2023-20-02', 28.00);

INSERT INTO Employee (first_name, last_name, phone, email, hire_date, dismissal_date, salary_percentage, is_active) VALUES
('Дмитрий', 'Смирнов', '+7-912-345-67-93', 'dmitry@sto.ru', '2022-08-01', '2023-06-30', 25.00, 0);

INSERT INTO Service (name, description, duration_minutes, base_price) VALUES
('Замена масла', 'Полная замена моторного масла и фильтра', 45, 1500.00),
('Замена тормозных колодок', 'Замена передних или задних тормозных колодок', 90, 3000.00),
('Развал-схождение', 'Регулировка углов установки колес', 60, 2500.00),
('Диагностика двигателя', 'Компьютерная диагностика двигателя', 30, 1200.00),
('Замена свечей зажигания', 'Замена комплекта свечей зажигания', 40, 1800.00);

INSERT INTO ServicePrice (service_id, car_category_id, actual_price) VALUES
(1, 1, 1500.00), (1, 2, 1800.00), (1, 3, 2200.00), (1, 4, 800.00),
(2, 1, 3000.00), (2, 2, 3500.00), (2, 3, 4500.00), (2, 4, 1200.00),
(3, 1, 2500.00), (3, 2, 2800.00), (3, 3, 3200.00), (3, 4, 1500.00),
(4, 1, 1200.00), (4, 2, 1400.00), (4, 3, 1600.00), (4, 4, 900.00),
(5, 1, 1800.00), (5, 2, 2000.00), (5, 3, 2400.00), (5, 4, 1000.00);

INSERT INTO EmployeeSpecialization (employee_id, service_id) VALUES
(1, 1), (1, 2), (1, 5),
(2, 1), (2, 4), (2, 5),
(3, 2), (3, 3),
(4, 1), (4, 4), (4, 5),
(5, 1), (5, 2);

INSERT INTO Appointment (employee_id, service_id, car_category_id, client_name, client_phone, car_model, car_license_plate, appointment_date, appointment_time, scheduled_duration, scheduled_price) VALUES
(1, 1, 1, 'Андрей Симонов', '+7 (918) 132-32-33', 'LADA 2115', 'А321ВВ777', '2024-02-15', '09:00', 45, 1500.00),
(2, 4, 2, 'Иван Лоханов', '+7 (923) 433-11-54', 'RENAULT LOGAN', 'Б456ГД777', '2024-01-15', '10:00', 30, 1400.00),
(3, 2, 1, 'Китаев Евгений', '+7 (923) 143-43-35', 'HONDA INTEGRA TYPE-R', 'В789ЕЖ777', '2024-01-15', '11:00', 90, 3000.00),
(4, 5, 1, 'Рузаева Мария', '+7 (923) 321-77-11', 'LADA X-RAY', 'Г123КК777', '2024-01-16', '09:30', 40, 1800.00);

INSERT INTO WorkRecord (appointment_id, employee_id, service_id, car_category_id, actual_duration, actual_price, work_date, start_time, end_time, notes) VALUES
(1, 1, 1, 1, 40, 1500.00, '2024-01-15', '09:00', '09:40', 'Замена синтетического масла 5W-30'),
(2, 2, 4, 2, 35, 1400.00, '2024-01-15', '10:00', '10:35', 'Диагностика показала нормальные параметры'),
(3, 3, 2, 1, 85, 3000.00, '2024-01-15', '11:00', '12:25', 'Замена передних тормозных колодок');

CREATE INDEX IF NOT EXISTS idx_appointment_date ON Appointment(appointment_date, appointment_time);
CREATE INDEX IF NOT EXISTS idx_appointment_employee ON Appointment(employee_id, appointment_date);
CREATE INDEX IF NOT EXISTS idx_workrecord_date ON WorkRecord(work_date);
CREATE INDEX IF NOT EXISTS idx_workrecord_employee ON WorkRecord(employee_id, work_date);
CREATE INDEX IF NOT EXISTS idx_employee_active ON Employee(is_active);
CREATE INDEX IF NOT EXISTS idx_service_price ON ServicePrice(service_id, car_category_id);

