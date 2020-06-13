--Dropping tables, if they already exist.
DROP TABLE titles CASCADE
DROP TABLE employees CASCADE
DROP TABLE salaries CASCADE
DROP TABLE dept_manager CASCADE 
DROP TABLE departments CASCADE
DROP TABLE dept_emp CASCADE

--Staff Title Table
-- Primary Key Contraint added, based on ERD and .CSV observations
CREATE TABLE "titles" (
    "title_id" VARCHAR   NOT NULL,
    "title" VARCHAR(30)   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

--Employees Table
--Primary Key Contraint added, based on ERD and .CSV observations
CREATE TABLE "employees" (
    "emp_no" INT   NOT NULL,
    "emp_title_id" VARCHAR   NOT NULL,
    "birth_date" DATE   NOT NULL,
    "first_name" VARCHAR(30)   NOT NULL,
    "last_name" VARCHAR(30)   NOT NULL,
    "sex" VARCHAR(1)   NOT NULL,
    "hire_date" DATE   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

--Salaries Table
CREATE TABLE "salaries" (
    "emp_no" INT   NOT NULL,
    "salary" MONEY   NOT NULL
);

--Department Manager
CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR   NOT NULL,
    "emp_no" INT   NOT NULL
);

--Department Numbers
CREATE TABLE "departments" (
    "dept_no" VARCHAR   NOT NULL,
    "dept_name" VARCHAR(30)   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

--Employee vs. Department
CREATE TABLE "dept_emp" (
    "emp_no" INT   NOT NULL,
    "dept_no" VARCHAR   NOT NULL
);

--Adding Foreign Key Contraints, based on observations in ERD. 
ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title_id" FOREIGN KEY("emp_title_id")
REFERENCES "titles" ("title_id");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

--Importing CSV files data, into respective table
--Ensuring data is imported in same order as table creation
COPY titles FROM '/Users/williamforsyth/Documents/uc_davis/Homework_Repos/sql-challenge/data/titles.csv' DELIMITER ',' CSV HEADER;
COPY employees FROM '/Users/williamforsyth/Documents/uc_davis/Homework_Repos/sql-challenge/data/employees.csv' DELIMITER ',' CSV HEADER;
COPY salaries FROM '/Users/williamforsyth/Documents/uc_davis/Homework_Repos/sql-challenge/data/salaries.csv' DELIMITER ',' CSV HEADER;
COPY departments FROM '/Users/williamforsyth/Documents/uc_davis/Homework_Repos/sql-challenge/data/departments.csv' DELIMITER ',' CSV HEADER;
COPY dept_manager FROM '/Users/williamforsyth/Documents/uc_davis/Homework_Repos/sql-challenge/data/dept_manager.csv' DELIMITER ',' CSV HEADER;
COPY dept_emp FROM '/Users/williamforsyth/Documents/uc_davis/Homework_Repos/sql-challenge/data/dept_emp.csv' DELIMITER ',' CSV HEADER;

-- Query template to run 'just in case' I find incorrect data types
ALTER TABLE table_name
ALTER COLUMN column_name datatype;

--Systematicaly checking tables, following insersion of respective csv files.
SELECT * FROM titles
SELECT * FROM employees
SELECT * FROM salaries
SELECT * FROM departments
SELECT * FROM dept_manager
SELECT * FROM dept_emp

--List the following details of each employee: employee number, last name, first name, sex, and salary.
SELECT s.emp_no, e.last_name, e.first_name, e.sex, s.salary
FROM employees as e
INNER JOIN salaries as s
ON e.emp_no = s.emp_no;

--List first name, last name, and hire date for employees who were hired in 1986.
SELECT last_name, first_name, hire_date
FROM employees
WHERE
	hire_date BETWEEN '1986-01-01' AND '1986-12-31'
	
--List the manager of each department with the following information:
--department number, department name, the manager's employee number, last name, first name.
SELECT dm.dept_no, d.dept_name, dm.emp_no, last_name, first_name
FROM dept_manager as dm
JOIN employees as e
ON dm.emp_no = e.emp_no
JOIN departments as d
on d.dept_no = dm.dept_no

-- A list of the departments of each employee with the following information: employee number, last name, first name, and department name.
SELECT de.emp_no, last_name, first_name, dept_name
FROM dept_emp as de
JOIN employees as e
ON de.emp_no = e.emp_no
JOIN departments as d
ON de.dept_no = d.dept_no

--List first name, last name, and sex for employees whose first name is "Hercules" and last names begin with "B."
SELECT first_name, last_name
FROM employees
WHERE first_name = 'Hercules'
AND last_name LIKE 'B%';

--List all employees in the Sales department, including their employee number, last name, first name, and department name.
SELECT de.emp_no, last_name, first_name, dept_name
FROM dept_emp as de
JOIN employees as e
ON de.emp_no = e.emp_no
JOIN departments as d
ON de.dept_no = d.dept_no
WHERE dept_name = 'Sales'

--List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT de.emp_no, last_name, first_name, dept_name
FROM dept_emp as de
JOIN employees as e
ON de.emp_no = e.emp_no
JOIN departments as d
ON de.dept_no = d.dept_no
WHERE dept_name = 'Sales'
OR dept_name = 'Development'

--In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
SELECT last_name,
COUNT (last_name) AS "frequency_count"
FROM employees
GROUP BY last_name
ORDER BY
COUNT(last_name) DESC;

