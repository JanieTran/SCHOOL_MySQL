-- RMIT Vietnam - School of Science and Technology - Database Concepts
-- Author: Emanuel Santos
-- File Created: 15/11/2017
-- File Updated: 15/11/2017


-- Company Z - SQL Queries Exercises

-- Some information and constraints about the schema:
-- - An employee may not have a supervisor (supervisor = NULL)
-- - A department may not have a director (director = NULL)
-- - An employee may have a supervisor from a different department
-- - The income value denotes the monthly income of an employee
-- - It is assumed that a director of a department works for that department

-- a)
SELECT e.name, d.name
FROM department d, employee e
WHERE e.department = d.code;
 
-- b) 
SELECT e.name, d.name
FROM employee e, department d
WHERE e.department = d.code
ORDER BY d.name ASC, e.name DESC ;

-- c)
SELECT e.name
FROM employee e, position p
WHERE e.position = p.code AND p.income BETWEEN 350 AND 450;

-- d)
-- We dont need table position because this table has the position code
SELECT DISTINCT e.position, d.name
FROM department d, employee e
WHERE e.department = d.code;

-- e)
SELECT DISTINCT d.name, e.name
FROM employee e, department d
WHERE e.department = d.code AND e.supervisor = d.director;

-- f)
-- -- Basic
SELECT d.name, e1.name
FROM department d, employee e1, employee e2
WHERE e1.number = d.director AND e1.number = e2.supervisor AND d.code = e1.department;
-- -- Extra
SELECT d.name, e.name
FROM department d, employee e
WHERE e.number = d.director AND EXISTS(SELECT *
                                       FROM employee e1
                                       WHERE e.number = e1.supervisor);
-- -- Other solution
SELECT d.name, e.name
FROM department d, employee e
WHERE e.number = d.director AND e.number IN (SELECT e1.supervisor
                                             FROM employee e1);
                  
-- g)
SELECT e.number
FROM employee e
WHERE EXISTS(SELECT *
             FROM employee e1, department d
             WHERE e.number = e1.supervisor OR e.number = d.director);
-- -- Other solution
SELECT d.director AS e_number
FROM department d
WHERE d.director IS NOT NULL
UNION
SELECT e.supervisor AS e_number
FROM employee e
WHERE e.supervisor IS NOT NULL;

-- h)
SELECT DISTINCT e.position
FROM department d, employee e
WHERE e.department = d.code
      AND d.location = 'Hanoi'
      AND EXISTS(SELECT *
                 FROM employee e1
                 WHERE e1.number = d.director
                       AND e1.name LIKE 'P%');
-- -- Other solution
SELECT DISTINCT p.code
FROM position p,
     history h, employee e0, department d0,
     employee e1, department d1, employee e2
WHERE e2.name LIKE 'P%'
  AND e2.number = d1.director
  AND d1.code = e1.department
  AND e1.position = p.code
  AND d0.location = 'Hanoi'
  AND e0.department = d0.code
  AND h.employee = e0.number
  AND p.code = h.position;


-- i)
SELECT e.name, p.income, d.name AS department
FROM employee e, position p, department d
WHERE e.position = p.code
  AND e.department = d.code
  AND e.number IN (SELECT e1.supervisor
                   FROM employee e1, department d1
                   WHERE e1.department = d1.code
                     AND d1.location <> 'Hanoi');
-- -- Other solution
SELECT e.name, p.income, d.name
FROM employee e, department d,position p
WHERE e.department = d.code -- e works at d
  AND e.position = p.code -- e position
  AND e.number IN (SELECT e0.supervisor -- e supervise e0
                   FROM employee e0)
  AND 'Hanoi' NOT IN (SELECT d1.location
                      FROM employee e1, department d1
                      WHERE e1.department = d1.code -- e1 works in Hanoi
                        AND e1.supervisor = e.number); -- e supervizes e1

-- j)
SELECT d.name, COUNT(*)
FROM employee e, department d
WHERE e.department = d.code
GROUP BY d.code;

-- k)
SELECT e.position, d.name, COUNT(*)
FROM department d, employee e
WHERE e.department = d.code
GROUP BY e.position, d.code;

-- l)
SELECT e.name, p.income * 12 AS annual_income
FROM employee e, position p
WHERE e.position = p.code
  AND p.income BETWEEN (SELECT AVG(p1.income) - 50 FROM position p1, employee e1 WHERE e1.position = p1.code)
                   AND (SELECT AVG(p1.income) + 50 FROM position p1, employee e1 WHERE e1.position = p1.code);

-- -- Other solution
SELECT e.name, p.income * 12 AS annual_income
FROM position p, employee e
WHERE e.position = p.code
  AND ABS(p.income - (SELECT AVG(p1.income)
                      FROM position p1, employee e1)) <= 100;

-- TO TEST THE NEXT QUERIES WORKS WITH NULL VALUES
INSERT INTO position VALUE ('CS6', 'Intern', 100);

-- m)
SELECT p.code, COUNT(*) AS e_income_higher_avg
FROM position p LEFT OUTER JOIN employee e
         ON e.position = p.code
WHERE p.income > (SELECT AVG(p1.income)
                  FROM position p1, employee e1
                  WHERE e1.position = p1.code)
GROUP BY p.code;
 
-- n)
SELECT d.name, p.title, h.start_date, e.name
FROM department d, position p, history h, employee e
WHERE e.department = d.code
  AND p.code = h.position
  AND e.number = h.employee
  AND h.start_date = (SELECT MIN(h1.start_date)
                      FROM employee e1, history h1
                      WHERE e1.number = h1.employee
                        AND e1.department = e.department
                        AND h1.position = h.position);

-- o)
SELECT d.name, e.name, p.income
FROM department d, employee e, position p
WHERE d.code = e.department
  AND p.code = e.position
  AND p.income = (SELECT MAX(p1.income)
                  FROM department d1, employee e1, position p1
                  WHERE d1.code = e1.department
                    AND p1.code = e1.position
                  GROUP BY d.code)
GROUP BY d.code;

-- p)
SELECT e.name, e.position
  FROM employee e;

-- q)
SELECT e.name AS dname, e.name AS ename
FROM department d;

-- r)
SELECT e.name
  FROM employee e;

-- s)
SELECT d.name
  FROM department d;

