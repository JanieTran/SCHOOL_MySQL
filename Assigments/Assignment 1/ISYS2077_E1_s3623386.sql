-- --------------------------------------
-- ISYS2077 - Database Concepts
-- Student Name: Tran Thi Hong Phuong
-- Student ID: s3623386
-- Date: 22nd July, 2018
-- --------------------------------------

drop table if exists position, department, deliverables, projects, employee;

-- ---------- CREATE TABLES ---------- --

create table position (
  code      varchar(3),
  title     varchar(20) NOT NULL ,
  income    integer unsigned,
  constraint pk_position primary key (code)
);

create table employee (
  number            smallint unsigned,
  name              varchar(30) not null,
  position          varchar(3) not null,
  department_code   varchar(3) not null,
  constraint pk_employee primary key (number)
);

create table department (
  code              varchar(3),
  name              varchar(30) not null,
  location          varchar(100) not null,
  director_number   smallint unsigned,
  constraint pk_department primary key (code)
);

create table projects (
  code          smallint unsigned,
  name          varchar(40) not null,
  client_name   varchar(30) not null,
  description   varchar(200),
  constraint pk_projects primary key (code)
);

create table deliverables (
  employee_number   smallint unsigned,
  name              varchar(20),
  date              date,
  project_code      smallint unsigned,
  constraint pk_deliverables primary key (employee_number, name, date, project_code)
);

-- ---------- INSERT DATA ---------- --

insert into position (code, title, income) values
  ('CA1', 'CEO', 10000),
  ('CB1', 'Engineering Director', 6000),
  ('CC1', 'Software Developer', 2000),
  ('CD1', 'CFO', 20000);

insert into department (code, name, location, director_number) values
  ('DE1', 'Sales HCMC', '12, Nguyen Hue, Ho Chi Minh City', 1231),
  ('DE3', 'Software Development', '42, Nguyen Van Linh, Da Nang', 3458),
  ('DE2', 'Finance', '702 Nguyen Van Linh, Ho Chi Minh City', 2204),
  ('DE4', 'R&D', '42 Ngo Duc Ke, Ha Noi', 1901);

insert into employee (number, name, position, department_code) values
  (1231, 'Dora Lee', 'CA1', 'DE1'),
  (3458, 'Anna Nguyen', 'CC1', 'DE2'),
  (2204, 'Boris Bayes', 'CB1', 'DE4'),
  (1901, 'Jane Johnson', 'CD1', 'DE3');

-- ---------- FOREIGN KEYS ---------- --

alter table employee add
  constraint fk_employee_position foreign key (position) references `position`(code)
  on delete cascade on update cascade;

alter table employee add
  constraint fk_employee_department foreign key (department_code) references department(code)
  on delete cascade on update cascade;

alter table department add
  constraint fk_department_employee foreign key (director_number) references employee(number)
  on delete cascade on update cascade;

alter table deliverables add
  constraint fk_deliverables_employee foreign key (employee_number) references employee(number)
  on delete cascade on update cascade;

-- ---------- INSERT DATA (CONT) ---------- --

insert into projects (code, name, client_name, description) values
  (4512, 'The Sims go to University', 'Edward Nguyen', 'This game transcribes the worldly acclaimed Sims game to the university environment. You can attend classes, do you assignments and pass exams.'),
  (2510, 'Uber', 'Travis Kalanick', 'Peer-to-peer ridesharing app'),
  (1905, 'Instagram', 'Mike Krieger', 'Photo and video sharing network'),
  (9003, 'Chrome', 'Sundar Pichai', 'Web browser');

insert into deliverables (employee_number, name, date, project_code) values
  (1231, 'patch 1.26', '2016-07-30', 4512),
  (3458, 'Holiday DLC', '2016-08-12', 4512),
  (2204, 'fix 0.2', '2016-12-30', 2510),
  (1901,'manifest', '2017-01-19', 9003);