CREATE TABLE employee (
    employee_id INTEGER,
    first_name TEXT,
    last_name TEXT,
    age INTEGER CHECK (age BETWEEN 18 AND 65),
    salary NUMERIC CHECK (salary > 0)
);

INSERT INTO employee VALUES (1, 'Simon','Riley', 30, 150000.00);
INSERT INTO employee VALUES (2, 'Benjamin', 'Pointdexter', 28, 250000.00);
INSERT INTO employee VALUES (3, 'Sally','Face', 16, 100000.00);
INSERT INTO employee VALUES (4, 'Rouge', 'Noir', 33, 0.00);


CREATE TABLE products_catalog (
    product_id INTEGER,
    product_name TEXT,
    regular_price NUMERIC,
    discount_price NUMERIC,
    CONSTRAINT valid_discount CHECK (
        regular_price > 0 AND
        discount_price > 0 AND
        discount_price < regular_price
        )
);

INSERT INTO products_catalog VALUES (1, 'Voiture', 350000.00, 300000.00);
INSERT INTO products_catalog VALUES (2, 'Gateau', 15000.00, 12000.00);
INSERT INTO products_catalog VALUES (3, 'Livre', 20000.00, 300000.00);

CREATE TABLE bookings (
    booking_id INTEGER,
    check_in_date DATE,
    check_out_date DATE,
    num_guests INTEGER,
    CONSTRAINT check_guests_range CHECK (num_guests BETWEEN 1 AND 10),
    CONSTRAINT check_dates_order CHECK (check_out_date > check_in_date)
);
INSERT INTO bookings VALUES (1, '2026-06-06', '2026-06-09', 3);
INSERT INTO bookings VALUES (2, '2026-06-09', '2026-06-13', 2);
INSERT INTO bookings VALUES (3, '2026-06-10', '2026-06-05', 8);

CREATE TABLE customers (
    customer_id INTEGER NOT NULL,
    email TEXT NOT NULL,
    phone TEXT,
    registration_date DATE NOT NULL
);

CREATE TABLE inventory (
    item_id INTEGER NOT NULL,
    item_name TEXT NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity >= 0),
    unit_price NUMERIC NOT NULL CHECK (unit_price > 0),
    last_updated TIMESTAMP NOT NULL
);

INSERT INTO customers VALUES (1, 'test1@mail.com', '+77054873108', '2026-07-23');
INSERT INTO customers VALUES (2, 'test2@mail.com', '+77770990989', '2026-08-18');
INSERT INTO customers VALUES (3, NULL, '+77076777889', '2026-09-29');
INSERT INTO inventory VALUES (100,'Ichigo', '88', 2900.00, NOW());

CREATE TABLE users (
    user_id INTEGER,
    username TEXT CONSTRAINT unique_username UNIQUE,
    email TEXT CONSTRAINT unique_email UNIQUE,
    created_at TIMESTAMP
);

CREATE TABLE course_enrollment (
    enrollment_id INTEGER,
    student_id INTEGER,
    course_code TEXT,
    semester TEXT,
    CONSTRAINT unique_student_course_sem UNIQUE (student_id, course_code, semester)
);

INSERT INTO users VALUES (1,'aayareina', 'whimsy@email.com', NOW());
INSERT INTO users VALUES (2, 'aayareina', 'wisteria@email.com', NOW());

CREATE TABLE department (
    dept_id INTEGER PRIMARY KEY,
    dept_name TEXT NOT NULL,
    location TEXT
);
INSERT INTO department VALUES (1, 'IT', 'Almaty');
INSERT INTO department VALUES (2, 'HR', 'Astanchanka');
INSERT INTO department VALUES (1, 'Finance', 'Mechtaa');
INSERT INTO department VALUES (NULL, 'Legal', 'Almaty');

CREATE TABLE student_courses (
    student_id INTEGER,
    course_id INTEGER,
    enrollment_date DATE,
    grade TEXT,
    PRIMARY KEY (student_id, course_id)
);

CREATE TABLE employees_dept (
    emp_id INTEGER PRIMARY KEY,
    emp_name TEXT NOT NULL,
    dept_id INTEGER REFERENCES department(dept_id),
    hire_date DATE
);

INSERT INTO employees_dept VALUES (101, 'Till', 1, '2026-05-05');
INSERT INTO employees_dept VALUES (999, 'Lindeman', 666, '2026-05-05');
INSERT INTO employees_dept VALUES (999, 'Bonham', 1, '2026-05-05');

CREATE TABLE authors (
    author_id INTEGER PRIMARY KEY,
    author_name TEXT NOT NULL,
    country TEXT
);

CREATE TABLE publishers (
    publisher_id INTEGER PRIMARY KEY,
    publisher_name TEXT NOT NULL,
    city TEXT
);

CREATE TABLE books (
    book_id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    author_id INTEGER REFERENCES authors(author_id),
    publisher_id INTEGER REFERENCES publishers(publisher_id),
    publication_year INTEGER,
    isbn TEXT UNIQUE
);

INSERT INTO authors VALUES (1, 'Tim Burton', 'USA');
INSERT INTO publishers VALUES (1, 'Ghibli', 'Tokyo');
INSERT INTO books VALUES (1, 'Lucky number slevin', 1,1, 2006, 8-2-10-7-7-10);

CREATE TABLE categories (
    category_id INTEGER PRIMARY KEY,
    category_name TEXT NOT NULL
);

CREATE TABLE products_fk (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT NOT NULL,
    category_id INTEGER REFERENCES categories(category_id) ON DELETE RESTRICT
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    order_date DATE NOT NULL
);

CREATE TABLE order_items (
    item_id INTEGER PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id INTEGER REFERENCES products_fk(product_id),
    quantity INTEGER CHECK (quantity > 0)
);

INSERT INTO categories VALUES (1, 'L');
INSERT INTO products_fk VALUES (1, 'K', 1);

INSERT INTO orders VALUES (500, '2026-12-12');
INSERT INTO order_items VALUES (1, 666, 1, 3);


CREATE TABLE ec_customers (
    customer_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    phone TEXT,
    registration_date DATE NOT NULL
);

CREATE TABLE ec_products (
    product_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    price NUMERIC NOT NULL CHECK (price >= 0),
    stock_quantity INTEGER NOT NULL CHECK (stock_quantity >= 0)
);
CREATE TABLE ec_orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES ec_customers(customer_id) ON DELETE RESTRICT,
    order_date DATE NOT NULL,
    total_amount NUMERIC NOT NULL CHECK (total_amount >= 0),
    status TEXT NOT NULL CHECK (status IN ('pending', 'processing', 'shipped', 'delivered', 'cancelled'))
);

CREATE TABLE ec_order_details (
    order_detail_id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES ec_orders(order_id) ON DELETE CASCADE,
    product_id INTEGER NOT NULL REFERENCES ec_products(product_id) ON DELETE RESTRICT,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC NOT NULL CHECK (unit_price >= 0)
);

INSERT INTO ec_customers VALUES
(1, 'Айгерим', 'aigerim@mail.com', '+77011112233', '2026-01-10'),
(2, 'Тимур', 'timur@mail.com', '+77022223344', '2026-02-12'),
(3, 'Мадина', 'madina@mail.com', '+77033334455', '2026-03-15'),
(4, 'Амир', 'amir@mail.com', '+77044445566', '2026-04-20'),
(5, 'Дильназ', 'dilnaz@mail.com', '+77055556677', '2026-05-01');

INSERT INTO ec_products VALUES
(1, 'Смартфон', 'Мобильный телефон', 250000.00, 15),
(2, 'Наушники', 'Беспроводные наушники', 45000.00, 30),
(3, 'Клавиатура', 'Механическая клавиатура', 35000.00, 20),
(4, 'Мышь', 'Игровая мышь', 20000.00, 25),
(5, 'Монитор', '27-дюймовый монитор', 120000.00, 10);

INSERT INTO ec_orders VALUES
(101, 1, '2026-09-10', 295000.00, 'delivered'),
(102, 2, '2026-09-12', 35000.00, 'shipped'),
(103, 3, '2026-09-15', 120000.00, 'processing'),
(104, 4, '2026-09-20', 20000.00, 'pending'),
(105, 5, '2026-09-22', 45000.00, 'cancelled');

INSERT INTO ec_order_details VALUES
(1, 101, 1, 1, 250000.00),
(2, 101, 2, 1, 45000.00),
(3, 102, 3, 1, 35000.00),
(4, 103, 5, 1, 120000.00),
(5, 104, 4, 1, 20000.00);



