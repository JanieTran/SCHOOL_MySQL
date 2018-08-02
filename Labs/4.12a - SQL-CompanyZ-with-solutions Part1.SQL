-- RMIT Vietnam - School of Science and Technology - Database Concepts
-- Author: Emanuel Santos / Edouard Amouroux
-- File Created: 15/11/2017
-- File Updated: 28/06/2018

-- Company Z - SQL Queries Exercises

-- Some information and constraints about the schema:
-- - An employee may not have a supervisor (supervisor = NULL)
-- - A department may not have a director (director = NULL)
-- - An employee may have a supervisor from a different department
-- - The income value denotes the monthly income of an employee
-- - It is assumed that a director of a department works for that department

SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS history;
DROP TABLE IF EXISTS commission;
DROP TABLE IF EXISTS department;
DROP TABLE IF EXISTS employee;
DROP TABLE IF EXISTS position;
DROP VIEW IF EXISTS employee_more_positions_per_department;

-- position(code, title, income)
CREATE TABLE position (
  `code` VARCHAR(3),
  title VARCHAR(50) NOT NULL,
  income INT NOT NULL,
  --
  CONSTRAINT pk_position PRIMARY KEY(`code`)
);


-- employee(number, name, position.code position, employee.number supervisor, department.code department)
CREATE TABLE employee (
  number INT UNSIGNED,
  `name` VARCHAR(50) NOT NULL,
  position VARCHAR(3),
  department VARCHAR(3),
  supervisor INT UNSIGNED,
  --
  CONSTRAINT pk_employee PRIMARY KEY(number),
  --
  CONSTRAINT fk_employee_position FOREIGN KEY (position) REFERENCES position (`code`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  --
  CONSTRAINT fk_employee_department FOREIGN KEY (department) REFERENCES department (`code`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    --
  CONSTRAINT fk_employee_supervisor FOREIGN KEY (supervisor) REFERENCES employee (`number`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);


-- department(code, name, location, employee.number director)
CREATE TABLE department (
  `code` VARCHAR(3),
  `name` VARCHAR(150) NOT NULL,
  location VARCHAR(50) NOT NULL,
  director INT UNSIGNED,
  --
  CONSTRAINT pk_department PRIMARY KEY(code),
  --
  CONSTRAINT fk_department_director FOREIGN KEY (director) REFERENCES employee(number)
);


-- commission(employee.number employee, date, value)
CREATE TABLE commission (
  employee INT UNSIGNED,
  date DATE NOT NULL,
  value INT NOT NULL,
  --
  CONSTRAINT pk_commission PRIMARY KEY(employee, date),
  --
  CONSTRAINT fk_commission_employee FOREIGN KEY (employee) REFERENCES employee(number)
    ON DELETE CASCADE 
    ON UPDATE CASCADE
);


-- history(employee.number employee, position.code position, start_date)
CREATE TABLE history (
  employee INT UNSIGNED,
  position VARCHAR(3),
  start_date DATE,
  --
  CONSTRAINT pk_history PRIMARY KEY(employee, position, start_date),
  --
  CONSTRAINT fk_history_employee FOREIGN KEY (employee) REFERENCES employee (number)
    ON DELETE CASCADE 
    ON UPDATE CASCADE,

  --    --
  CONSTRAINT fk_history_position FOREIGN KEY (position) REFERENCES position (`code`)
    ON DELETE CASCADE 
    ON UPDATE CASCADE
);


-- inserting values
INSERT INTO position (`code`, title, income) 
  VALUES ('CS1', 'Salesman', 100);
INSERT INTO position (`code`, title, income) 
  VALUES ('CS2', 'Manager', 400);
INSERT INTO position (`code`, title, income) 
  VALUES ('CS3', 'Development director', 300);
INSERT INTO position (`code`, title, income) 
  VALUES ('CS4', 'Digital strategy manager', 600);
INSERT INTO position (`code`, title, income) 
  VALUES ('CS5', 'Director of communications', 700);


INSERT INTO employee (number, name, position, department, supervisor)
  VALUES (1, 'George Constanza', 'CS2', 'DP1', 4);
INSERT INTO employee (number, name, position, department, supervisor)
  VALUES (2, 'Anna Nguyen', 'CS5', 'DP1', NULL);
INSERT INTO employee (number, name, position, department, supervisor)
  VALUES (3, 'Peter', 'CS3', 'DP2', 3);
INSERT INTO employee (number, name, position, department, supervisor)
  VALUES (4, 'Liam', 'CS3', 'DP1', 2);
INSERT INTO employee (number, name, position, department, supervisor)
  VALUES (5, 'Mason', 'CS1', 'DP3', 8);
INSERT INTO employee (number, name, position, department, supervisor)
  VALUES (6, 'Jacob', 'CS2', 'DP3', NULL);
INSERT INTO employee (number, name, position, department, supervisor)
  VALUES (7, 'William','CS4', 'DP2', 9);
INSERT INTO employee (number, name, position, department, supervisor)
  VALUES (8, 'Ethan', 'CS5', 'DP1', NULL);
INSERT INTO employee (number, name, position, department, supervisor)
  VALUES (9, 'Liam', 'CS4', 'DP2', 10);
INSERT INTO employee (number, name, position, department, supervisor)
  VALUES (10, 'James', 'CS3', 'DP3', NULL);
INSERT INTO employee (number, name, position, department, supervisor)
  VALUES (11, 'Mary', 'CS4', 'DP2', 9);
INSERT INTO employee (number, name, position, department, supervisor)
  VALUES (12, 'John', 'CS1', 'DP1', NULL);
INSERT INTO employee (number, name, position, department, supervisor)
  VALUES (13, 'Hang', 'CS4', 'DP1', NULL);


INSERT INTO department (code, name, location, director)
  VALUES ('DP1', 'Sales Department', 'Hanoi', 2);
INSERT INTO department (code, name, location, director)
  VALUES ('DP2', 'Research Department', 'Hanoi', 3);
INSERT INTO department (code, name, location, director)
  VALUES ('DP3', 'International Department', 'HCMC', 5);


INSERT INTO commission(employee, date, value)
  VALUES (1,'2016-07-30', 50);
INSERT INTO commission(employee, date, value)
  VALUES (1,'2016-08-12', 150);
INSERT INTO commission(employee, date, value)
  VALUES (2,'2015-07-30', 550);
INSERT INTO commission(employee, date, value)
  VALUES (3,'2016-06-10', 550);
INSERT INTO commission(employee, date, value)
  VALUES (5,'2009-03-01', 300);
INSERT INTO commission(employee, date, value)
  VALUES (5,'2009-02-10', 250);
INSERT INTO commission(employee, date, value)
  VALUES (7,'2012-08-12', 100);
INSERT INTO commission(employee, date, value)
  VALUES (7,'2010-08-12', 150);


INSERT INTO history (employee, position, start_date)
  VALUES (1,'CS1', '2015-01-10');
INSERT INTO history (employee, position, start_date)
  VALUES (1,'CS4', '2017-05-07');
INSERT INTO history (employee, position, start_date)
  VALUES (1,'CS3', '2017-03-09');
INSERT INTO history (employee, position, start_date)
  VALUES (1,'CS5', '2013-04-10');
INSERT INTO history (employee, position, start_date)
  VALUES (2,'CS1', '2013-01-10');
INSERT INTO history (employee, position, start_date)
  VALUES (4,'CS3', '2014-05-07');
INSERT INTO history (employee, position, start_date)
  VALUES (7,'CS1', '2011-05-07');
INSERT INTO history (employee, position, start_date)
  VALUES (7,'CS2', '2011-05-07');
INSERT INTO history (employee, position, start_date)
  VALUES (7,'CS3', '2011-05-07');
INSERT INTO history (employee, position, start_date)
  VALUES (7,'CS5', '2014-01-01');

COMMIT;
SET FOREIGN_KEY_CHECKS=1;



-- SOLUTIONS

-- a)
SELECT e.name, d.name
FROM department d, employee e
WHERE e.department = d.code;
 
-- b) 
SELECT e.name, d.name
FROM department d, employee e
WHERE e.department = d.code
ORDER BY d.name ASC, e.name DESC;

-- c)
SELECT e.name
FROM position p, employee e
WHERE p.code = e.position AND p.income BETWEEN 350 AND 450;

-- d)
-- We dont need table position because this table has the position code
SELECT DISTINCT e.position, d.name
FROM department d, employee e  
WHERE e.department = d.code;

-- e)
SELECT d.name, e.name
FROM department d, employee e
WHERE (d.director = e.supervisor) AND (e.department = d.code);

-- f)
SELECT d.name, ee.name
FROM department d, employee ee, employee e
WHERE (d.director = ee.number) AND (d.code = ee.department) AND (e.supervisor = ee.number);

SELECT d.name, ee.name
FROM department d, employee ee
WHERE (d.director = ee.number)
      AND (d.code = ee.department)
      AND EXISTS (SELECT *
                  FROM employee e
                  WHERE (e.supervisor = ee.number));
                  
-- g)
(SELECT d.director AS DorS
 FROM department d
 WHERE d.director IS NOT NULL)
UNION
(SELECT e.supervisor AS DorS
 FROM employee e
 WHERE e.supervisor IS NOT NULL);

-- h)
SELECT p.code
FROM position p, -- not need for this table
     history h, employee e0, department d0, 
     employee e1, department d1, employee e2
WHERE p.code = h.position
  AND h.employee = e0.number
  AND e0.department = d0.code
  AND d0.location = 'Hanoi'   
  AND p.code = e1.position
  AND e1.department = d1.code 
  AND d1.director = e2.number
  AND e2.name LIKE 'P%';

-- i)
SELECT e.name, p.income, d.name
  FROM employee e, department d,position p
 WHERE (e.department = d.code) -- e works at d
   AND (e.position = p.code) -- e position
   AND (e.number IN -- e supervize e0
         (SELECT e0.supervisor
            FROM employee e0))
   AND 'Hanoi' NOT IN 
      (SELECT d1.location
         FROM employee e1, department d1
        WHERE (e1.department = d1.code) -- e1 works in Hanoi
          AND (e1.supervisor = e.number)); -- e supervizes e1

