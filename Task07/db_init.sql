CREATE TABLE IF NOT EXISTS employees (
    employees_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    position TEXT NOT NULL CHECK(position IN ('мастер', 'старший мастер', 'администратор')),
    salary_percentage REAL NOT NULL CHECK(salary_percentage >= 0 AND salary_percentage <= 100),
    hire_date DATE NOT NULL DEFAULT (date('now')),
    dismissal_date DATE,
    phone TEXT,
    email TEXT,
    work_schedule TEXT,
    qualification TEXT, 
    CHECK(dismissal_date IS NULL OR dismissal_date >= hire_date)
);

CREATE TABLE IF NOT EXISTS car_categories (
    car_categories_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE IF NOT EXISTS boxes (
    boxes_id INTEGER PRIMARY KEY AUTOINCREMENT,
    number INTEGER NOT NULL UNIQUE CHECK(number > 0),
    is_active INTEGER NOT NULL DEFAULT 1 CHECK(is_active IN (0, 1)),
    box_type TEXT NOT NULL CHECK(box_type IN ('подъемник', 'смотровая яма', 'шиномонтажный', 'диагностический')),
    description TEXT
);

CREATE TABLE IF NOT EXISTS services (
    services_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    duration_minutes INTEGER NOT NULL CHECK(duration_minutes > 0),
    price REAL NOT NULL CHECK(price >= 0),
    car_category_id INTEGER NOT NULL,
    service_type TEXT NOT NULL CHECK(service_type IN ('техобслуживание', 'ремонт', 'диагностика', 'шиномонтаж')),
    required_qualification TEXT,
    description TEXT,
    FOREIGN KEY (car_category_id) REFERENCES car_categories(car_categories_id) ON DELETE RESTRICT,
    UNIQUE(name, car_category_id)
);

CREATE TABLE IF NOT EXISTS master_specializations (
    specialization_id INTEGER PRIMARY KEY AUTOINCREMENT,
    employee_id INTEGER NOT NULL,
    service_id INTEGER NOT NULL,
    certification_date DATE,
    FOREIGN KEY (employee_id) REFERENCES employees(employees_id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES services(services_id) ON DELETE CASCADE,
    UNIQUE(employee_id, service_id)
);

CREATE TABLE IF NOT EXISTS work_schedule (
    schedule_id INTEGER PRIMARY KEY AUTOINCREMENT,
    employee_id INTEGER NOT NULL,
    work_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    is_working_day INTEGER NOT NULL DEFAULT 1 CHECK(is_working_day IN (0, 1)),
    FOREIGN KEY (employee_id) REFERENCES employees(employees_id) ON DELETE CASCADE,
    UNIQUE(employee_id, work_date)
);

CREATE TABLE IF NOT EXISTS bookings (
    bookings_id INTEGER PRIMARY KEY AUTOINCREMENT,
    client_name TEXT NOT NULL,
    client_phone TEXT NOT NULL,
    vehicle_model TEXT NOT NULL,
    vehicle_year INTEGER,
    mileage INTEGER,
    box_id INTEGER NOT NULL,
    employee_id INTEGER NOT NULL,
    service_id INTEGER NOT NULL,
    booking_date DATE NOT NULL,
    booking_time TIME NOT NULL,
    status TEXT NOT NULL DEFAULT 'запланировано' 
        CHECK(status IN ('запланировано', 'в работе', 'выполнено', 'отменено')),
    created_at DATETIME NOT NULL DEFAULT (datetime('now')),
    client_notes TEXT,
    FOREIGN KEY (box_id) REFERENCES boxes(boxes_id) ON DELETE RESTRICT,
    FOREIGN KEY (employee_id) REFERENCES employees(employees_id) ON DELETE RESTRICT,
    FOREIGN KEY (service_id) REFERENCES services(services_id) ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS completed_works (
    completed_works_id INTEGER PRIMARY KEY AUTOINCREMENT,
    booking_id INTEGER,
    employee_id INTEGER NOT NULL,
    box_id INTEGER NOT NULL,
    service_id INTEGER NOT NULL,
    work_date DATE NOT NULL DEFAULT (date('now')),
    start_time TIME NOT NULL,
    actual_duration_minutes INTEGER NOT NULL CHECK(actual_duration_minutes > 0),
    actual_price REAL NOT NULL CHECK(actual_price >= 0),
    used_parts TEXT, 
    diagnostic_results TEXT,
    warranty_period_days INTEGER,
    notes TEXT,
    FOREIGN KEY (booking_id) REFERENCES bookings(bookings_id) ON DELETE SET NULL,
    FOREIGN KEY (employee_id) REFERENCES employees(employees_id) ON DELETE RESTRICT,
    FOREIGN KEY (box_id) REFERENCES boxes(boxes_id) ON DELETE RESTRICT,
    FOREIGN KEY (service_id) REFERENCES services(services_id) ON DELETE RESTRICT
);

INSERT INTO employees (name, position, salary_percentage, hire_date, dismissal_date, phone, email, work_schedule, qualification) VALUES
('Петров Алексей Владимирович', 'старший мастер', 35.0, '2022-01-15', NULL, '+7-901-234-56-78', 'petrov.av@sto.ru', 'утренняя смена', 'эксперт'),
('Смирнова Елена Игоревна', 'мастер', 28.0, '2023-03-10', NULL, '+7-902-345-67-89', 'smirnova.ei@sto.ru', 'вечерняя смена', 'специалист'),
('Козлов Дмитрий Сергеевич', 'мастер', 32.0, '2021-11-05', NULL, '+7-903-456-78-90', 'kozlov.ds@sto.ru', 'плавающий график', 'эксперт'),
('Волкова Марина Петровна', 'администратор', 0.0, '2023-02-20', NULL, '+7-904-567-89-01', 'volkova.mp@sto.ru', 'утренняя смена', NULL),
('Никитин Иван Алексеевич', 'мастер', 30.0, '2020-08-12', '2024-06-30', '+7-905-678-90-12', 'nikitin.ia@sto.ru', 'вечерняя смена', 'специалист'),
('Соколов Артем Викторович', 'мастер', 26.5, '2024-01-08', NULL, '+7-906-789-01-23', 'sokolov.av@sto.ru', 'утренняя смена', 'стажер');

INSERT INTO car_categories (name, description) VALUES
('Легковые отечественные', 'ВАЗ, ГАЗ, УАЗ'),
('Легковые иномарки', 'Иномарки до 3.5 тонн'),
('Кроссоверы и внедорожники', 'SUV 4x4'),
('Коммерческий транспорт', 'Грузовики, микроавтобусы'),
('Премиум сегмент', 'BMW, Mercedes, Audi премиум');

INSERT INTO boxes (number, is_active, box_type, description) VALUES
(1, 1, 'подъемник', '2-стоечный подъемник, до 3.5т'),
(2, 1, 'подъемник', '4-стоечный подъемник, до 5т'),
(3, 1, 'смотровая яма', 'Смотровая яма с оборудованием'),
(4, 1, 'шиномонтажный', 'Шиномонтажный бокс'),
(5, 1, 'диагностический', 'Компьютерная диагностика'),
(6, 0, 'подъемник', 'На ремонте до 25.12.2024');

INSERT INTO services (name, duration_minutes, price, car_category_id, service_type, required_qualification, description) VALUES
('Замена масла двигателя', 60, 1500.0, 1, 'техобслуживание', 'специалист', 'Замена масла и фильтра'),
('Замена тормозных колодок', 90, 3000.0, 1, 'ремонт', 'специалист', 'Замена передних/задних колодок'),
('Компьютерная диагностика', 45, 2000.0, 1, 'диагностика', 'эксперт', 'Сканирование ошибок'),
('Регулировка развала-схождения', 60, 2500.0, 1, 'техобслуживание', 'эксперт', 'На стенде'),
('Замена ремня ГРМ', 180, 8000.0, 1, 'ремонт', 'эксперт', 'С заменой роликов');

INSERT INTO services (name, duration_minutes, price, car_category_id, service_type, required_qualification, description) VALUES
('Замена масла двигателя', 60, 2200.0, 2, 'техобслуживание', 'специалист', 'Синтетическое масло'),
('Замена тормозных дисков', 120, 6500.0, 2, 'ремонт', 'эксперт', 'Диски и колодки'),
('Диагностика подвески', 75, 3500.0, 2, 'диагностика', 'эксперт', 'Полная диагностика'),
('Замена свечей зажигания', 45, 2800.0, 2, 'техобслуживание', 'специалист', 'Иридиевые свечи'),
('Заправка кондиционера', 60, 4000.0, 2, 'техобслуживание', 'специалист', 'Хладагент R134a');

INSERT INTO services (name, duration_minutes, price, car_category_id, service_type, required_qualification) VALUES
('Замена масла в КПП', 90, 4500.0, 3, 'техобслуживание', 'эксперт'),
('Диагностика полного привода', 90, 5000.0, 3, 'диагностика', 'эксперт'),
('Замена сайлентблоков', 150, 8500.0, 3, 'ремонт', 'эксперт');

INSERT INTO services (name, duration_minutes, price, car_category_id, service_type) VALUES
('Замена масла в дизеле', 120, 6000.0, 4, 'техобслуживание'),
('Регулировка тормозов', 90, 4500.0, 4, 'ремонт');

INSERT INTO services (name, duration_minutes, price, car_category_id, service_type) VALUES
('Адаптация новых аккумуляторов', 45, 3500.0, 5, 'техобслуживание'),
('Кодирование оборудования', 60, 5000.0, 5, 'диагностика');

INSERT INTO master_specializations (employee_id, service_id, certification_date) VALUES
(1, 3, '2022-03-15'),  
(1, 5, '2022-05-20'),  
(1, 8, '2022-08-10'),  
(2, 1, '2023-04-05'),  
(2, 9, '2023-06-15'),  
(3, 2, '2021-12-10'),  
(3, 7, '2022-02-18'),  
(3, 10, '2022-07-22'), 
(5, 4, '2021-09-30'),  
(5, 6, '2021-11-25'),  
(6, 1, '2024-02-15'); 

INSERT INTO work_schedule (employee_id, work_date, start_time, end_time, is_working_day) VALUES
(1, '2024-12-23', '08:00', '16:00', 1),  
(1, '2024-12-24', '08:00', '16:00', 1),  
(1, '2024-12-25', '08:00', '16:00', 1),  
(2, '2024-12-23', '14:00', '22:00', 1),  
(2, '2024-12-24', '14:00', '22:00', 1),
(2, '2024-12-25', '14:00', '22:00', 1),
(3, '2024-12-23', '10:00', '18:00', 1),  
(3, '2024-12-24', '10:00', '18:00', 1),
(3, '2024-12-25', '00:00', '00:00', 0),  
(6, '2024-12-23', '08:00', '16:00', 1);  

INSERT INTO bookings (client_name, client_phone, vehicle_model, vehicle_year, mileage, box_id, employee_id, service_id, booking_date, booking_time, status, client_notes) VALUES
('Иванов Сергей Михайлович', '+7-910-111-22-33', 'Lada Vesta', 2020, 45000, 1, 1, 3, '2024-12-23', '09:00', 'запланировано', 'Проверить двигатель, есть стуки'),
('Петрова Анна Викторовна', '+7-911-222-33-44', 'Toyota Camry', 2019, 65000, 2, 3, 7, '2024-12-23', '11:00', 'запланировано', 'Стук в передней подвеске'),
('Сидоров Андрей Николаевич', '+7-912-333-44-55', 'Ford Focus', 2018, 80000, 1, 2, 1, '2024-12-23', '14:00', 'запланировано', 'Плановое ТО'),
('Козлов Дмитрий Игоревич', '+7-913-444-55-66', 'BMW X5', 2021, 30000, 5, 1, 15, '2024-12-24', '10:00', 'запланировано', 'Кодирование после замены АКБ'),
('Морозова Ольга Сергеевна', '+7-914-555-66-77', 'Volkswagen Polo', 2022, 15000, 3, 6, 1, '2024-12-22', '13:00', 'выполнено', 'Первое ТО'),
('Никитин Алексей Петрович', '+7-915-666-77-88', 'Kia Sportage', 2020, 55000, 4, 3, 10, '2024-12-21', '15:00', 'отменено', 'Клиент перенес на январь');

INSERT INTO completed_works (booking_id, employee_id, box_id, service_id, work_date, start_time, actual_duration_minutes, actual_price, used_parts, diagnostic_results, warranty_period_days, notes) VALUES
(5, 6, 3, 1, '2024-12-22', '13:00', 65, 1500.0, 'Масло 5W-30, фильтр масляный', 'Замечаний нет, двигатель в норме', 180, 'Первый самостоятельный ТО стажера'),
(NULL, 2, 1, 9, '2024-12-20', '10:00', 50, 2800.0, 'Свечи зажигания NGK', NULL, 365, 'Замена свечей на Hyundai Solaris'),
(NULL, 3, 2, 7, '2024-12-19', '11:30', 80, 3500.0, NULL, 'Износ шаровых опор, рекомендована замена', 30, 'Диагностика Mazda CX-5'),
(NULL, 1, 5, 3, '2024-12-19', '14:00', 50, 2000.0, NULL, 'Ошибка P0301 - пропуски зажигания 1 цилиндр', 14, 'Диагностика Lada Granta'),
(NULL, 5, 1, 4, '2024-06-15', '09:00', 70, 2500.0, NULL, 'Углы выставлены в норму', 90, 'Развал-схождение ВАЗ 2114 - последняя работа мастера'),
(NULL, 5, 2, 6, '2024-06-10', '13:00', 65, 2200.0, 'Масло 0W-20, фильтр', NULL, 180, 'ТО Toyota Corolla'),
(NULL, 3, 1, 2, '2024-12-18', '16:00', 100, 3000.0, 'Колодки тормозные передние', NULL, 365, 'Замена тормозов на Lada Largus'),
(NULL, 1, 2, 5, '2024-12-17', '10:00', 190, 8000.0, 'Ремень ГРМ, ролики, помпа', 'Ремень сильно изношен, своевременная замена', 365, 'Замена ГРМ на ВАЗ 2110'),
(NULL, 2, 3, 1, '2024-12-16', '14:30', 60, 1500.0, 'Масло 10W-40', NULL, 180, 'Плановое ТО'),
(NULL, 3, 4, 11, '2024-12-16', '11:00', 100, 4500.0, 'Масло ATF, прокладка', NULL, 180, 'Замена масла в АКПП Kia Sorento');