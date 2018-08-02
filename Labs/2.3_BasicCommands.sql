----------------------------------------------------------
-- Lab 2.3 - Basic SQL Commands
----------------------------------------------------------

-- DELETE TABLE
drop table if exists students;

-- CREATE TABLE
create table students (
  sid     integer,
  gname   varchar(30),
  fname   varchar(30),
  age     tinyint,
  gpa     real,
  -- CHECK command is not applicable in MySQL
  check (age >= 18)
)

-- INSERT RECORDS
  -- 1 record
insert into students (sid, gname, fname, age, gpa)
    values (101, 'Ricardo', 'Kaka', 36, 4.0);

  -- Multiple records
insert into students (sid, gname, fname, age, gpa) values
    (102, 'Novak', 'Djokovic', 31, 3.9),
    (103, 'Roger', 'Federer', 37, 3.8),
    (104, 'Cristiano', 'Ronaldo', 33, 3.7),
    (105, 'Error', 'Name', 0, 0);

  -- Record not satisfying constraints
insert into students (sid, gname, fname, age, gpa)
    values (106, 'Underage', 'Member', 10, 0);

-- SEE FULL TABLE
select * from students;

-- UPDATE TABLE
update students S set S.gpa = 3.7 where S.gpa = 3.8;

-- DELETE RECORD(S)
delete from students where gname = 'Error';