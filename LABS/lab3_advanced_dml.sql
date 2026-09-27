DROP TABLE IF EXISTS projects CASCADE;
DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS departments CASCADE;
DROP TABLE IF EXISTS employee_archive CASCADE;

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(50) DEFAULT 'Unassigned',
    salary INT,
    hire_date DATE,
    status VARCHAR(20) DEFAULT 'Active'

);

CREATE TABLE departments (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(50),
    budget INT,
    manager_id INT

);

CREATE TABLE projects (
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR(100),
    dept_id INT,
    start_date DATE,
    end_date DATE,
    budget INT
);

INSERT INTO departments (dept_name, budget, manager_id) VALUES
   ('IT',120000, 1),
    ('Sales',80000, 2),
    ('HR', 40000, 3);

INSERT INTO employees (first_name, last_name, department, salary, hire_date, status) VALUES
('Joel', 'Miller', 'IT', 75000, '2019-05-12', 'Active'),
('Leon', 'Kennedy', 'Sales', 45000, '2021-02-10', 'Active'),
('Ada', 'Wong', 'IT', 85000, '2018-11-01', 'Active'),
('Claire', 'Redfield', 'HR', 35000, '2023-04-15', 'Inactive'),
('Albert', 'Wesker', 'Sales', 65000, '2019-08-20', 'Terminated');

INSERT INTO projects (project_name, dept_id, start_date, end_date, budget) VALUES
 ('T-Virus Containment', 1, '2022-01-01', '2022-12-31', 60000),
 ('Firefly Logistics', 1, '2023-01-01', '2024-06-30', 90000);


INSERT INTO employees (emp_id, first_name, last_name, department)
VALUES (DEFAULT, 'Chris', 'Redfield', 'Managment');

INSERT INTO employees (first_name, last_name, department, salary, status)
VALUES ('Ellie', 'Williams', 'Reception', DEFAULT, DEFAULT);

INSERT INTO departments (dept_name, budget, manager_id) VALUES
('Marketing', 50000, 4),
('Finance', 90000, 5),
('Logistics', 45000, 6);

INSERT INTO employees (first_name, last_name, department, salary, hire_date)
VALUES ('Jill', 'Valentine', 'Sales', CAST(50000 * 1.1 AS INT), CURRENT_DATE);

CREATE TEMP TABLE temp_employees AS
    SELECT * FROM employees WHERE department = 'IT';

UPDATE employees
SET salary = CAST(salary * 1.10 AS INT);


UPDATE employees
SET status = 'Senior'
WHERE salary > 60000 AND hire_date < '2020-01-01';


UPDATE employees
SET department = CASE
    WHEN salary > 80000 THEN 'Management'
    WHEN salary BETWEEN 50000 AND 80000 THEN 'Senior'
    ELSE 'Junior'
END;


UPDATE employees
SET department = DEFAULT
WHERE status = 'Inactive';


UPDATE departments d
SET budget = CAST((
    SELECT AVG(e.salary) * 1.20
    FROM employees e
    WHERE e.department = d.dept_name
) AS INT)
WHERE EXISTS (
    SELECT 1 FROM employees e WHERE e.department = d.dept_name
);

UPDATE employees
SET salary = CAST(salary * 1.15 AS INT),
    status = 'Promoted'
WHERE department = 'Sales';

DELETE FROM employees
WHERE status = 'Terminated';


DELETE FROM employees
WHERE salary < 40000
  AND hire_date > '2023-01-01'
  AND department IS NULL;


DELETE FROM departments
WHERE dept_name NOT IN (
    SELECT DISTINCT department
    FROM employees
    WHERE department IS NOT NULL
);

DELETE FROM projects
WHERE end_date < '2023-01-01'
RETURNING *;

INSERT INTO employees (first_name, last_name, department, salary, hire_date)
VALUES ('Ghost', 'User', NULL, NULL, '2024-01-01');


UPDATE employees
SET department = 'Unassigned'
WHERE department IS NULL;

DELETE FROM employees
WHERE salary IS NULL OR department IS NULL;

INSERT INTO employees (first_name, last_name, department, salary, hire_date)
VALUES ('Abby', 'Anderson', 'Sales', 70000, CURRENT_DATE)
RETURNING emp_id, (first_name || ' ' || last_name) AS full_name;

WITH old_values AS (
    SELECT emp_id, salary AS old_salary FROM employees WHERE department = 'IT'
)
UPDATE employees e
SET salary = e.salary + 5000
FROM old_values ov
WHERE e.emp_id = ov.emp_id
RETURNING e.emp_id, ov.old_salary, e.salary AS new_salary;


DELETE FROM employees
WHERE hire_date < '2020-01-01'
RETURNING *;

INSERT INTO employees (first_name, last_name, department, salary, hire_date)
SELECT 'Ethan', 'Winters', 'Sales', 60000, CURRENT_DATE
WHERE NOT EXISTS (
    SELECT 1 FROM employees WHERE first_name = 'Ethan' AND last_name = 'Winters'
);

UPDATE employees e
SET salary = CAST(
    salary * CASE
        WHEN (
            SELECT budget
            FROM departments d
            WHERE d.dept_name = e.department
            LIMIT 1
        ) > 100000 THEN 1.10
        ELSE 1.05
    END AS INT
);

WITH inserted_employees AS (
    INSERT INTO employees (first_name, last_name, department, salary, hire_date) VALUES
    ('Tommy', 'Miller', 'IT', 50000, CURRENT_DATE),
    ('Dina', 'Hashem', 'IT', 52000, CURRENT_DATE),
    ('Carlos', 'Oliveira', 'Sales', 48000, CURRENT_DATE),
    ('Sherry', 'Birkin', 'HR', 45000, CURRENT_DATE),
    ('Rebecca','Chambers', 'Finance',55000, CURRENT_DATE)
    RETURNING emp_id
)
UPDATE employees
SET salary = CAST(salary * 1.10 AS INT)

WHERE emp_id IN (SELECT emp_id FROM inserted_employees);

CREATE TABLE IF NOT EXISTS employee_archive (LIKE employees INCLUDING ALL);

WITH moved_rows AS (
    DELETE FROM employees
    WHERE status = 'Inactive'
    RETURNING *
)
INSERT INTO employee_archive
SELECT * FROM moved_rows;


UPDATE projects
SET end_date = end_date + INTERVAL '30 days'
WHERE budget > 50000
  AND dept_id IN (
      SELECT d.dept_id
      FROM departments d
      JOIN employees e ON d.dept_name = e.department
      GROUP BY d.dept_id
      HAVING COUNT(e.emp_id) > 3
  );
