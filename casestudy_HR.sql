-- Create 'departments' table
CREATE TABLE departments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    manager_id INT
);

-- Create 'employees' table
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    hire_date DATE,
    job_title VARCHAR(50),
    department_id INT REFERENCES departments(id)
);
-- Create 'projects' table
CREATE TABLE projects (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    start_date DATE,
    end_date DATE,
    department_id INT REFERENCES departments(id)
);
-- Insert data into 'departments'
INSERT INTO departments (name, manager_id)
VALUES ('HR', 1), ('IT', 2), ('Sales', 3);

-- Insert data into 'employees'
INSERT INTO employees (name, hire_date, job_title, department_id)
VALUES ('John Doe', '2018-06-20', 'HR Manager', 1),
       ('Jane Smith', '2019-07-15', 'IT Manager', 2),
       ('Alice Johnson', '2020-01-10', 'Sales Manager', 3),
       ('Bob Miller', '2021-04-30', 'HR Associate', 1),
       ('Charlie Brown', '2022-10-01', 'IT Associate', 2),
       ('Dave Davis', '2023-03-15', 'Sales Associate', 3);
       
-- Insert data into 'projects'
INSERT INTO projects (name, start_date, end_date, department_id)
VALUES ('HR Project 1', '2023-01-01', '2023-06-30', 1),
       ('IT Project 1', '2023-02-01', '2023-07-31', 2),
       ('Sales Project 1', '2023-03-01', '2023-08-31', 3)
 ;
 
 -- SQL Challenge questions
 
 
 -- 1: Find the longest ongoing project for each department.
SELECT 
    p.id,
    d.name AS department,
    p.start_date AS project_start_day,
    p.end_date AS project_end_day,
    DATEDIFF(p.end_date, p.start_date) AS project_duration
FROM
    projects AS p
        LEFT JOIN
    departments AS d ON p.id = d.id;
    
-- 2: Find all employees who are not managers.
SELECT 
    name, job_title
FROM
    employees
WHERE
    job_title NOT LIKE '%Manager';
    
/* 3: Find all employees who have been hired after 
the start of a project in their department */

SELECT 
    name, job_title, hire_date 
FROM
    employees
WHERE
    hire_date > '2023-01-01';

/* 4. Rank employees within each department based 
on their hire date (earliest hire gets the highest rank)*/

SELECT name, hire_date, department_id,
RANK() OVER (PARTITION BY department_id ORDER BY hire_date) AS employee_rank
FROM employees
;

/* 5. Find the duration between the hire date of each employee 
and the hire date of the next employee hired in the same department.*/

SELECT 
    e1.id,
    e1.name,
    e1.hire_date,
    e1.department_id,
    MIN(e2.name) AS next_employee,
    MIN(e2.hire_date) AS next_hire_date,
    DATEDIFF(MIN(e2.hire_date), e1.hire_date) AS duration
FROM
    employees AS e1
        LEFT JOIN
    employees AS e2 ON e1.department_id = e2.department_id
        AND e1.hire_date < e2.hire_date
GROUP BY e1.id , e1.name , e1.hire_date , e1.department_id;
