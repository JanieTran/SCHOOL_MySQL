drop table if exists students, enrolled;

create table students (
  sid     integer primary key,
  gname   varchar(30) not null,
  fname   varchar(30) not null,
  age     tinyint not null,
  gpa     real not null
);

create table enrolled (
  cid     char(8),
  grade   char(1) not null,
  sid     integer,
  constraint fk_enrolled_sid
      foreign key (sid) references students(sid)
          on delete cascade on update cascade,
  constraint pk_enrolled
      primary key (cid, sid),
);

insert into students (sid, gname, fname, age, gpa) values
    (682634, 'John', 'Smith', 20, 3.0),
    (632461, 'Phu', 'Nguyen', 21, 1.0),
    (612352, 'Thong', 'Nguyen', 19, 2.7),
    (603111, 'Tam', 'Quach', 20, 0.8),
    (123456, 'Donald', 'Trump', 23, 0.1);

insert into enrolled (cid, grade, sid) values
    ('MATH2239', 'D', 123456),
    ('MATH2240', 'D', 123456),
    ('ISYS2077', 'A', 682634),
    ('ISYS2040', 'C', 632461);

-- Make sure everything is updated in database
commit