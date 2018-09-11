-- ====================================
-- MUSIC COPYRIGHT DATABASE
-- ====================================

create table Publishers (
  pcode   integer,
  name    varchar(50) not null,
  address varchar(100) not null,
  primary key (pcode)
);

create table Writers (
  wno       integer,
  firstname varchar(20) not null,
  lastname  varchar(20),
  address   varchar(100),
  pcode     integer,
  primary key (wno),
  foreign key (pcode) references Publishers (pcode)
);

create table Work (
  title     varchar(100),
  duration  time not null,
  descr     text,
  primary key (title)
);

create table WrittenWork (
  wno         integer,
  title       varchar(100),
  percentage  smallint not null,
  primary key (wno, title),
  foreign key (wno) references Writers (wno),
  foreign key (title) references Work(title)

  -- TEXTUAL RESTRICTIONS
  -- percentage in 1..100
  -- at lest 1 writer per work
);

create table Concerts (
  venue   varchar(100),
  date    date,
  primary key (venue, date)
);

create table Performance (
  title   varchar(100),
  venue   varchar(100),
  date    date,
  act     text not null,
  primary key (title, venue, date),
  foreign key (title) references Work(title),
  foreign key (venue, date) references Concerts (venue, date)
  -- order of multiple FKs is important
);

-- ====================================
-- COLLEGE DATABASE
-- ====================================

create table Students (
  sno     integer,
  name    varchar(50),
  address varchar(100),
  primary key (sno)
);

create table Lecturers (
  eno     integer,
  name    varchar(50),
  office  integer,
  rank    integer,
  phone   varchar(10),
  primary key (eno)
);

create table Courses (
  code    integer,
  name    varchar(50),
  credit  smallint,
  primary key (code)
);

create table TaughtCourses (
  sno       integer,
  code      integer,
  eno       integer,
  year      integer,
  semester  tinyint,
  grade     real,
  primary key (sno, code, eno, year, semester),
  foreign key (sno) references Students(sno),
  foreign key (code) references Courses(code),
  foreign key (eno) references Lecturers(eno)
);

create table StudentAdvisors (
  eno   integer,
  primary key (eno),
  foreign key (eno) references Lecturers(eno)
);

-- ====================================
-- BANK DATABASE
-- ====================================

create table Customers (
  id      integer,
  name    varchar(50),
  address varchar(100),
  phone   varchar(10),
  primary key (id)
);

create table Accounts (
  number    integer,
  type      varchar(10),
  balance   real,
  cid       integer not null,
  primary key (number),
  foreign key (cid) references Customers(id)
);

create table Transactions (
  id      integer,
  code    varchar(10),
  amount  real,
  date    date,
  time    time,
  descr   varchar(100),
  accnum  integer not null,
  primary key (id),
  foreign key (accnum) references Accounts(number)
);

-- ====================================
-- APARTMENT DATABASE
-- ====================================

create table Buildings (
  address   varchar(100),
  primary key (address)
);

create table Apartments (
  number        integer,
  address       varchar(100),
  asking_rent   real,
  avail_date    date not null,
  ssn           integer,
  actual_rent   real,
  end_of_lease  date not null,
  primary key (number, address),
  foreign key (address) references Buildings(address)
    on delete cascade,
  foreign key (ssn) references Tenants(ssn),
  constraint check (avail_date >= end_of_lease)
);

create table Tenants (
  ssn       integer,
  firstname varchar(50) not null,
  lastname  varchar(50) not null,
  homephone varchar(20),
  workphone varchar(20),
  employer  varchar(100),
  primary key (ssn)
);

-- ====================================
-- BRIDGE COMPANY DATABASE
-- ====================================

create table Departments (
  id        integer,
  name      varchar(50) not null,
  work_type varchar(50) not null,
  primary key (id)
);

create table Level (
  code    integer,
  primary key (code)
);

create table Employees (
  ssn       integer,
  name      varchar(50) not null,
  phone     varchar(10) not null,
  address   varchar(100) not null,
  did       integer not null,
  lcode     integer not null,
  income    real not null,
  primary key (ssn),
  foreign key (did) references Departments(id),
  foreign key (lcode) references Level(code)
);

create table Coordinators (
  ssn       integer,
  did       integer not null,
  primary key (ssn),
  foreign key (ssn) references Employees(ssn)
);

create table Non_Coordinators (
  ssn       integer,
  primary key (ssn),
  foreign key (ssn) references Employees(ssn)
);

create table Technicians (
  ssn     integer,
  primary key (ssn),
  foreign key (ssn) references Non_Coordinators(ssn)
);

create table Assistants (
  ssn           integer,
  qualification varchar(50),
  primary key (ssn),
  foreign key (ssn) references Non_Coordinators(ssn)
);

create table Coordinate (
  co_ssn    integer,
  nc_ssn    integer,
  primary key (co_ssn, nc_ssn),
  foreign key (co_ssn) references Coordinators(ssn),
  foreign key (nc_ssn) references Non_Coordinators(ssn)
);

create table Machines (
  serial_num  integer,
  purpose     varchar(200),
  primary key (serial_num)
);

create table Maintain (
  assistant   integer,
  machine     integer,
  primary key (assistant, machine),
  foreign key (assistant) references Assistants(ssn),
  foreign key (machine) references Machines(serial_num)
);

create table Skills (
  id    integer,
  primary key (id)
);

create table Projects (
  title       varchar(50),
  start_date  date,
  end_date    date,
  tech_salary real,
  primary key (title)
);

create table TechnicianSkill (
  technician  integer,
  skill       integer,
  primary key (technician, skill),
  foreign key (technician) references Technicians(ssn),
  foreign key (skill) references Skills(id)
);

create table ProjectSkill (
  project   varchar(50),
  skill     integer,
  primary key (project, skill),
  foreign key (project) references Projects(title),
  foreign key (skill) references Skills(id)
);

create table ProjectTechnician (
  technician  integer,
  tech_skill  integer,
  project     varchar(50),
  pj_skill    integer,
  primary key (technician, project),
  foreign key (technician, tech_skill) references TechnicianSkill(technician, skill),
  foreign key (project, pj_skill) references ProjectSkill(project, skill),
  constraint check (tech_skill = pj_skill)
);

-- ====================================
-- COLLEGE DATABASE
-- ====================================

create table Programs (
  code    integer,
  credits integer not null,
  name    varchar(100) not null,
  primary key (code)
);

create table Students (
  number    integer,
  name      varchar(100) not null,
  address   varchar(100) not null,
  program   integer not null,
  primary key (number),
  foreign key (program) references Programs(code)
);

create table Courses (
  code    integer,
  credits integer not null,
  name    varchar(100) not null,
  primary key (code)
);

create table CourseEnrollment (
  student   integer,
  course    integer,
  grade     real not null,
  primary key (student, course),
  foreign key (student) references Students(number),
  foreign key (course) references Courses(code)
);

create table Companies (
  name    integer,
  email   varchar(100),
  phone   varchar(20),
  primary key (name)
);

create table CompanySupervisors (
  ssn     integer,
  company integer not null,
  primary key (ssn),
  foreign key (company) references Companies(name)
);

create table Internships (
  code        integer,
  domain      varchar(100),
  theme       varchar(100),
  SST_sv      varchar(100),
  company_sv  integer not null,
  primary key (code),
  foreign key (company_sv) references CompanySupervisors(ssn)
);

create table InternshipEnrollment (
  student     integer,
  internship  integer,
  primary key (student, internship),
  foreign key (student) references Students(number),
  foreign key (internship) references Internships(code)
);

create table InternshipApplication (
  student     integer,
  internship  integer,
  order       varchar(100),
  primary key (student, internship),
  foreign key (student) references Students(number),
  foreign key (internship) references Internships(code)
)

