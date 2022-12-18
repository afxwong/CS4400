-- CS4400: Introduction to Database Systems
-- Relational Model Constraints: Domain, Key, Entity & Referential Integrity
-- Wednesday, December 23, 2020

-- [1] Create a database for our experimentation
drop database if exists small_company;
create database if not exists small_company;
use small_company;

-- [2] Create a table for the department entity type
drop table if exists department;
create table department (
	dname varchar(20),
    dnumber integer,
    manager varchar(20),
    manager_start_date date
) engine = innodb;

-- [3] Enter department data while respecting the data type and format restrictions
insert into department values ('Research', 'Four', 'Smith', '2020-01-06');
insert into department values ('Research', 4, 'Smith', 'January 6, 2020');
insert into department values ('System Implementation', 4, 'Smith', '2020-01-06');

-- [4] Enter records representing various departments (with some duplication)
insert into department values ('Research', 4, 'Smith', '2020-01-06');
insert into department values ('Integration', 8, 'Robinson', '2020-05-11');
insert into department values ('Systems', 8, 'Taylor', '2020-02-16');

-- [5] Enter an exact duplicate of one of the existing records
insert into department values ('Integration', 8, 'Robinson', '2020-05-11');

-- [6] Remove the exact duplicate record that was just entered without
-- removing the other record
delete from department where dname = 'Integration' and dnumber = 8 limit 1;
-- Even though you can remove the record, it's still poor practice to allow
-- the duplicate records to be created in the first place

-- [7] Remove all of the data from the department table and improve the structure
delete from department;

-- [8] Designate a primary key for the re-created department table
drop table if exists department;
create table department (
	dname varchar(20),
    dnumber integer,
    manager varchar(20),
    manager_start_date date,
    primary key (dnumber)
) engine = innodb;

-- [9] Re-enter the original department data set where possible while
-- respecting key constraints
insert into department values ('Research', 4, 'Smith', '2020-01-06');
insert into department values ('Integration', 8, 'Robinson', '2020-05-11');
insert into department values ('Systems', 8, 'Taylor', '2020-02-16');
insert into department values ('Integration', 8, 'Robinson', '2020-05-11');

-- [10] Re-enter the Systems Department information, but make sure they have
-- a valid and unique department number
insert into department values ('Systems', null, 'Taylor', '2020-02-16');
insert into department values ('Systems', 17, 'Taylor', '2020-02-16');

-- [11] Create a table for the project entity type with pnumber as the primary key
drop table if exists project;
create table project (
	pname varchar(100),
    pnumber integer,
    location varchar(100),
    primary key (pnumber)
) engine = innodb;

-- [12] Enter records representing various projects
insert into project values ('Project X', 100, 'Houston, TX'),
('Project Y', 110, 'Atlanta, GA'),
('Project Z', 120, 'Seattle, WA');

-- [13] Modify the project table to allow an association from a project
-- to its controlling department
alter table project add column controlling_dept integer;
-- Ideally, it would be preferable to create all of these columns, keys
-- and other structure before data is entered; however, DDL gives us the
-- capability of modifying and evolving existing structures as needed

-- [14] Enter some project data about the controlling departments
update project set controlling_dept = 8 where pnumber = 100;
update project set controlling_dept = 17 where pnumber = 110;

-- [15] Removing a parent department is not prevented, and causes a loss
-- of consistency in the database state
delete from department where dnumber = 17;

-- [16] Update the data temporarily to remove the inconsistency
update project set controlling_dept = null where pnumber = 110;

-- [17] Create a structure to prevent the loss of consistency
alter table project add constraint exec_dept foreign key (controlling_dept)
references department (dnumber);

-- [18] Modify some of the department and project data while respecting
-- the consistency between the tables

-- records that don't refer to a parent table record can be created 
insert into project values ('Project U', 130, 'Dallas, TX', null);

-- records that refer to a non-existent parent table record CAN'T be created 
insert into project values ('Project V', 140, 'Miami, FL', 17);
insert into department values ('Systems', 17, 'Taylor', '2020-02-16');
insert into project values ('Project V', 140, 'Miami, FL', 17);

-- parent records that are being referred to can't be deleted
delete from department where dnumber = 8;
delete from department where dnumber = 17;
delete from department where dnumber = 4;

-- also, parent record key field values CAN'T be updated/changed
update department set dnumber = 11 where dnumber = 17;
update department set dname = 'Systems Development' where dnumber = 17;

-- [19] Modify the foreign key structure to change what happens when records
-- in the parent table are modified
alter table project drop foreign key exec_dept;
alter table project add constraint exec_dept_loose foreign key (controlling_dept)
references department (dnumber) on update cascade on delete cascade;

-- [20] Retest some of the earlier changes to department and project data
-- while respecting the consistency between the tables
delete from department where dnumber = 8;
update department set dnumber = 11 where dnumber = 17;
