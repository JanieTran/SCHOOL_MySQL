-- ALTER

alter table enrolled add submitted date;

alter table enrolled change cid course varchar(20);

alter table enrolled drop grade;

alter table enrolled drop foreign key fk_enrolled_sid;

alter table enrolled add constraint fk_enrolled_sid
    foreign key (sid) references students(sid);

-- SELECT

select * from students S where S.age >= 21;

select gname, fname from students S where S.age >= 21;

select S.sid, S.gname, S.fname from students S, enrolled E
    where S.sid = E.sid and S.age >= 21;

select distinct S.sid, S.gname, S.fname from students S, enrolled E
    where S.sid = E.sid and S.age >= 21;

-- VIEW
create view older_students (given_name, age) as
    select gname, age from students S where age >= 22;

-- RENAME TABLE
rename table students to students_renamed;