------MVP
------Q1. Are there any pay_details records lacking both a local_account_no and iban number?

SELECT 
  	pd.local_account_no,
  	pd.iban
FROM pay_details 
WHERE local_account_no IS NULL iban IS NULL ;

------MVP
------Q2. Get a table of employees first_name, last_name and country, ordered alphabetically 
------first by country and then by last_name (put any NULLs last).

SELECT
	first_name,
	last_name,
	country
FROM employees
ORDER BY country ASC NULLS LAST

------MVP
------Q3. Find the details of the top ten highest paid employees in the corporation.

SELECT *
FROM employees 
ORDER BY salary DESC NULLS LAST 
LIMIT 10

------MVP
------Q4. Find the first_name, last_name and salary of the lowest paid employee in Hungary.

SELECT
	first_name,
	last_name,
	salary
FROM employees 
WHERE country = 'Hungary'
ORDER BY salary
LIMIT 1;

------MVP
------Q5. Find all the details of any employees with a ‘yahoo’ email address?

SELECT *
FROM employees 
WHERE email LIKE '%yahoo%';

-----MVP
-----Q6. Provide a breakdown of the numbers of employees enrolled, not enrolled, and with unknown enrollment status 
-----in the corporation pension scheme.

SELECT
	pension_enrol,
	count(id) AS num_employees
FROM employees 
GROUP BY pension_enrol ;

------MVP
------Q7. What is the maximum salary among those employees in the ‘Engineering’ department who work 1.0 full-time equivalent hours (fte_hours)?

SELECT  
	max(salary) AS max_engineering_salary
FROM employees 
WHERE department = 'Engineering' AND fte_hours = 1;

------MVP
------Q8. Get a table of country, number of employees in that country, and the average salary of employees in that country 
------for any countries in which more than 30 employees are based. Order the table by average salary descending.

SELECT 
  country, 
  count(id) AS num_employees, 
  AVG(salary) AS average_salary
FROM employees
GROUP BY country
HAVING COUNT(id) > 30
ORDER BY average_salary DESC

------MVP
------Q9. Return a table containing each employees first_name, last_name, full-time equivalent hours (fte_hours), salary, 
------and a new column effective_yearly_salary which should contain fte_hours multiplied by salary.

SELECT 
  first_name,
  last_name,
  fte_hours,
  salary,
  fte_hours * salary AS effective_yearly_salary
FROM employees ;

------MVP
------Q10. Find the first name and last name of all employees who lack a local_tax_code.

SELECT
	first_name,
	last_name,
	pd.local_tax_code
FROM employees AS e LEFT JOIN pay_details AS pd
ON e.pay_detail_id = pd.id 
WHERE local_tax_code IS NULL;

------MVP
------Q11. The expected_profit of an employee is defined as (48 * 35 * charge_cost - salary) * fte_hours, 
------where charge_cost depends upon the team to which the employee belongs. Get a table showing expected_profit for each employee.

SELECT 
  *, 
  (48 * 35 * CAST(t.charge_cost AS INT) - e.salary) *e.fte_hours AS expected_profit
FROM employees AS e LEFT JOIN teams AS t
ON t.id = e.team_id ;

------MVP
------Q12. Get a list of the id, first_name, last_name, salary and fte_hours of employees in the largest department. Add two extra columns 
------showing the ratio of each employee’s salary to that department’s average salary, and each employee’s fte_hours 
------to that department’s average fte_hours.

WITH dsa(department, avg_salary, avg_fte_hours) AS (
SELECT department, avg(salary) AS avg_salary, avg(fte_hours) AS avg_fte_hours
FROM employees
GROUP BY department
) 
SELECT 
	e.id, 
	e.first_name, 
	e.last_name, 
	e.salary, 
	e.fte_hours, 
	e.department,
	e.salary/dsa.avg_salary AS salary_ratio, e.fte_hours / dsa.avg_fte_hours AS fte_ratio
FROM employees AS e left JOIN dsa ON dsa.department = e.department
WHERE e.department = 'Legal';

------EXTENSIONS
------Q1. Return a table of those employee first_names shared by more than one employee, 
------together with a count of the number of times each first_name occurs. 
------Omit employees without a stored first_name from the table. Order the table descending by count, and then alphabetically by first_name.

SELECT 
  first_name, 
  COUNT(*) AS name_count
FROM employees
WHERE first_name IS NOT NULL
GROUP BY first_name 
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC, first_name ASC ;
	