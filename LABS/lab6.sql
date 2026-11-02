DROP TABLE IF EXISTS projects CASCADE;
DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS departments CASCADE;

CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50),
    location VARCHAR(50)
);

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    dept_id INT,
    salary DECIMAL (10, 2)
);

CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(50),
    dept_id INT,
    budget DECIMAL (10, 2)
);
INSERT INTO departments (dept_id, dept_name, location) VALUES
(101, 'IT', 'Building A'),
(102, 'HR', 'Building B'),
(103, 'Finance', 'Building C'),
(104, 'Marketing', 'Building D');

INSERT INTO employees (emp_id, emp_name, dept_id, salary) VALUES
(1, 'John Smith', 101, 50000),
(2, 'Jane Doe', 102, 60000),
(3, 'Mike Johnson', 101, 55000),
(4, 'Sarah Williams', 103, 65000),
(5, 'Tom Brown', NULL, 45000);

INSERT INTO projects (project_id, project_name, dept_id, budget) VALUES
(1, 'Website Redesign', 101, 100000),
(2, 'Employee Training', 102, 50000),
(3, 'Budget Analysis', 103, 75000),
(4, 'Cloud Migration', 101, 150000),
(5, 'AI Research', NULL, 200000);

--Exercise 2.1: Basic Cross JOIN
SELECT e.emp_name, d.dept_name
FROM employees e CROSS JOIN departments d;
--Answer: 20 (N-5 M-4)

--Exercise 2.2: Alternative CROSS JOIN syntax
--a)
SELECT e.emp_name, d.dept_name
FROM employees e, departments d;
--b)
SELECT e.emp_name, d.dept_name
FROM employees e
INNER JOIN departments d ON TRUE;

--Exercise 2.3: Practical CROSS JOIN
SELECT e.emp_name, p.project_name
FROM employees e
CROSS JOIN projects p;

--Exercise 3.1: Basic INNER JOIN with ON
SELECT e.emp_name, d.dept_name
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id;
--Answer: 4 rows returned.For Tom brown, the department name value is NULL.

--Exercise 3.2:INNER JOIN with USING
SELECT e.emp_name, d.dept_name, dept_id
FROM employees e
INNER JOIN departments d USING (dept_id);
--Answer: Using collapses identical columns into a single, shared column.

--Exercise 3.3: NATURAL INNER JOIN
SELECT e.emp_name, d.dept_name, p.project_name
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id
INNER JOIN projects p ON d.dept_id = p.dept_id;

--Exercise 3.4: Multi-table INNER JOIN
SELECT e.emp_name, d.dept_name, p.project_name, p.budget
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id
INNER JOIN projects p ON d.dept_id = p.dept_id
WHERE p.budget > 50000;

--Exercise 4.1: Basic LEFT JOIN
SELECT e.emp_name, d.dept_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id;
--Answer: Tom belongs to the left-hand table, 'employees', and because the query is performed using a "LEFT JOIN" Tom does not disappear from the list.

--Exercise 4.2: LEFT JOIN with USING
SELECT e.emp_name, d.dept_name, dept_id
FROM employees e
LEFT JOIN departments d USING (dept_id);

--Exercise 4.3: Find Unmatched Records
SELECT e.emp_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
WHERE d.dept_id IS NULL;

--Exercise 4.4: LEFT JOIN with Aggregation
SELECT d.dept_name, COUNT(e.emp_id) AS employee_count
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name
ORDER BY employee_count DESC;

--Exercise 5.1: Basic RIGHT JOIN
SELECT e.emp_name, d.dept_name
FROM employees e
RIGHT JOIN departments d ON e.dept_id = d.dept_id;

--Exercise 5.2: Convert to LEFT JOIN
SELECT e.emp_name, d.dept_name
FROM departments d
LEFT JOIN employees e ON e.dept_id = d.dept_id;

--Exercise 5.3: Find Departments Without Employees
SELECT d.dept_name, d.location
FROM employees e
RIGHT JOIN departments d ON e.dept_id = d.dept_id
WHERE e.emp_id IS NULL;

--Exercise 6.1: Basic FULL JOIN
SELECT e.emp_name, e.dept_id AS emp_dept, d.dept_id AS dept_dept, d.dept_name
FROM employees e
FULL JOIN departments d ON e.dept_id = d.dept_id;
--Answer:
--On the left side emp_name and emp_dept have 'NULL' values, and the same applies to dept_dept and dept_name on the right side
--This is because an employee is missing on the left, while on the right, an employee exists but has no corresponding department.

--Exercise 6.2: FULL JOIN with Projects
SELECT d.dept_name, p.project_name, p.budget
FROM departments d
FULL JOIN projects p ON d.dept_id = p.dept_id;

--Exercise 6.3: Find Orphaned Records
SELECT
    CASE
        WHEN e.emp_id IS NULL THEN 'Department without employees'
        WHEN d.dept_id IS NULL THEN 'Employee without department'
        ELSE 'Matched'
    END AS record_status,
    e.emp_name,
    d.dept_name
FROM employees e
FULL JOIN departments d on e.dept_id = d.dept_id
WHERE e.emp_id IS NULL OR d.dept_id IS NULL;

--Exercise 7.1: Filtering in ON Clause
SELECT e.emp_name, d.dept_name, e.salary
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id AND
d.location = 'Building A';

--Exercise 7.2: Filtering in WHERE Clause
SELECT e.emp_name, d.dept_name, e.salary
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
WHERE d.location = 'Building A';

--Query 1:Retains all employees from the employees table.
-- The filter only determines whether a department is attached to an employee or if 'NULL' is assigned instead.
--Query 2:Filters the resulting rows after the join.
--It removes employees from other buildings as well as those without an assigned department, effectively turning the 'LEFT JOIN' into an 'INNER JOIN'.

--Exercise 7.3 ON vs WHERE with INNER JOIN
--No, there will be no difference in the results.
-- The results of both queries using INNER JOIN will be exactly the same.

--Exercise 8.1: Multiple Joins with different types
SELECT
d.dept_name,
e.emp_name,
e.salary,
p.project_name,
p.budget
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
LEFT JOIN projects p ON d.dept_id = p.dept_id
ORDER BY d.dept_name, e.emp_name;

--Exercise 8.2: Self Join
ALTER TABLE employees ADD COLUMN manager_id INT;
UPDATE employees SET manager_id = 3 WHERE emp_id = 1;
UPDATE employees SET manager_id = 3 WHERE emp_id = 2;
UPDATE employees SET manager_id = NULL WHERE emp_id = 3;
UPDATE employees SET manager_id = 3 WHERE emp_id = 4;
UPDATE employees SET manager_id = 3 WHERE emp_id = 5;

SELECT
e.emp_name AS employee,
m.emp_name AS manager
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.emp_id;

--Exercise 8.3: Join with subquery
SELECT d.dept_name, AVG(e.salary) AS avg_salary
FROM departments d
INNER JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name
HAVING AVG(e.salary) > 50000;

--LAB QUESTIONS
--1) INNER JOIN returns only matching rows; LEFT JOIN returns all rows from the left table and matched rows from the right (with NULL for unmatched).
--2)To generate all possible combinations (Cartesian product) between two sets, such as sizing matrices or calendar grids.
--3)In outer joins, ON filters before joining (preserving unmatched rows as NULL), while WHERE filters the final result (turning it into an inner join). For inner joins, both act restrictively.
--4)50 (5 rows × 10 rows).
--5)By automatically matching all columns that share the exact same name in both tables.
--6)Schema changes (like adding a column with a matching name) can silently break or alter the query logic without syntax errors.
--7)SELECT * FROM B RIGHT JOIN A ON A.id = B.id
--8)When you need to retain all records from both tables simultaneously, including unmatched rows on either side.