------Find all the employees who work in the ‘Human Resources’ department.

SELECT *
FROM employees
WHERE department = 'Human Resources';

------Get the first_name, last_name, and country of the employees who work in the ‘Legal’ department.

SELECT
	first_name,
	last_name,
	country
FROM employees 
WHERE department = 'Legal';

------Count the number of employees based in Portugal.

SELECT 
	count(id) AS portugal_employees
FROM employees
WHERE country = 'Portugal';

------Count the number of employees based in either Portugal or Spain.

SELECT country,
	COUNT(id) AS num_employees
FROM employees
WHERE country = 'Portugal' OR country = 'Spain'
GROUP BY country;

------Count the number of pay_details records lacking a local_account_no.

SELECT
	count(id)
FROM pay_details
WHERE local_account_no IS NULL;

------Get a table with employees first_name and last_name ordered alphabetically by last_name (put any NULLs last).

SELECT 
	first_name,
	last_name
FROM employees 
ORDER BY last_name ASC NULLS LAST ;	

How many employees have a first_name beginning with ‘F’?

SELECT
	count(id)
FROM employees 
WHERE first_name LIKE 'F%';

------Count the number of pension enrolled employees not based in either France or Germany.

SELECT 
	count(id)
FROM employees
WHERE country NOT IN ('France', 'Germany') AND pension_enrol IS TRUE;

------Obtain a count by department of the employees who started work with the corporation in 2003.

SELECT
	department,
	count(id) AS starters_2003
FROM employees 
WHERE start_date BETWEEN '2003-01-01' AND '2003-12-31'
GROUP BY department;

------Obtain a table showing department, fte_hours and the number of employees in each department who work each fte_hours pattern. 
------Order the table alphabetically by department, and then in ascending order of fte_hours.

SELECT
	department, 
	fte_hours,
	count(id) AS num_employees
FROM employees 
WHERE fte_hours BETWEEN 0 AND 1
GROUP BY department, fte_hours 
ORDER BY department ASC NULLS LAST, fte_hours ASC NULLS LAST ;

------Obtain a table showing any departments in which there are two or more employees lacking a stored first name. 
------Order the table in descending order of the number of employees lacking a first name, and then in alphabetical order by department.

SELECT 
	department,
	count(id) AS num_employees_no_first_name
FROM employees 
WHERE first_name IS NULL 
GROUP BY department 
HAVING count(id) >= 2
ORDER BY count(id) DESC , department ASC NULLS LAST ;

------[Tough!] Find the proportion of employees in each department who are grade 1.

SELECT 
  department, 
  SUM(CAST(grade = '1' AS INT)) / CAST(COUNT(id) AS REAL) AS prop_grade_1 
FROM employees 
GROUP BY department

------EXTENSIONS
------Do a count by year of the start_date of all employees, ordered most recent year last.


SELECT
	start_date
FROM employees 
ORDER BY start_date ASC NULLS LAST ;