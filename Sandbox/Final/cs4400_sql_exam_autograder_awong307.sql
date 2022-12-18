-- CS4400: Introduction to Database Systems: Thursday, April 28, 2022
-- One-to-One SQL Assessment [AUTOGRADER (v3)]: Global Company Database
-- This version of the database is intended to work with legacy versions of MySQL

-- -------------------------------------------------
-- ENTER YOUR QUERY SOLUTIONS STARTING AT LINE 190
-- -------------------------------------------------

drop database if exists global_company;
create database if not exists global_company;
use global_company;

-- -----------------------------------------------
-- table structures
-- -----------------------------------------------

create table employee (
  fname char(10) not null,
  lname char(20) not null,
  ssn decimal(9, 0) not null,
  bdate date not null,
  address char(30) not null,
  sex char(1) not null,
  salary decimal(5, 0) not null,
  superssn decimal(9, 0) default null,
  dno decimal(1, 0) not null,
  primary key (ssn)
) engine = innodb;

create table dependent (
  essn decimal(9, 0) not null,
  dependent_name char(10) not null,
  sex char(1) not null,
  bdate date not null,
  relationship char(30) not null,
  primary key (essn, dependent_name),
  constraint fk1 foreign key (essn) references employee (ssn)
) engine = innodb;

create table department (
  dname char(20) not null,
  dnumber decimal(1, 0) not null,
  mgrssn decimal(9, 0) not null,
  mgrstartdate date not null,
  primary key (dnumber),
  unique key (dname)
) engine = innodb;

create table dept_locations (
  dnumber decimal(1, 0) not null,
  dlocation char(15) not null,
  primary key (dnumber, dlocation),
  constraint fk8 foreign key (dnumber) references department (dnumber)
) engine = innodb;

create table project (
  pname char(20) not null,
  pnumber decimal(2, 0) not null,
  plocation char(20) not null,
  dnum decimal(1, 0) not null,
  primary key (pnumber),
  unique key (pname),
  constraint fk3 foreign key (dnum) references department (dnumber)
) engine = innodb;

create table works_on (
  essn decimal(9, 0) not null,
  pno decimal(2, 0) not null,
  hours decimal(5, 1) default null,
  primary key (essn, pno),
  constraint fk5 foreign key (essn) references employee (ssn),
  constraint fk6 foreign key (pno) references project (pnumber)
) engine = innodb;

create table fund_source (
  fsid integer not null,
  remaining integer default null,
  usage_rate integer default null,
  pnumber decimal(2, 0) default null,
  primary key (fsid),
  constraint fk22 foreign key (pnumber) references project (pnumber)
) engine = innodb;

create table customer (
  cid varchar(100) not null,
  company varchar(200) default null,
  location char(20) default null,
  assets integer default null,
  fsid integer not null,
  primary key (cid),
  constraint fk10 foreign key (fsid) references fund_source (fsid)
) engine = innodb;

create table budget (
  dnumber decimal(1, 0) not null,
  bcode integer not null,
  balance integer default null,
  fsid integer default null,
  primary key (dnumber, bcode),
  constraint fk9 foreign key (dnumber) references department (dnumber),
  constraint fk11 foreign key (fsid) references fund_source (fsid)
) engine = innodb;

create table remote_access (
  ssn decimal(9, 0) not null,
  ip_address varchar(39) default null,
  user_account varchar(200) default null,
  primary key (ssn),
  unique key (ip_address),
  constraint fk12 foreign key (ssn) references employee (ssn)
) engine = innodb;

create table time_frames (
  ssn decimal(9, 0) not null,
  start_hour integer not null,
  duration integer not null,
  primary key (ssn, start_hour, duration),
  constraint fk13 foreign key (ssn) references remote_access (ssn)
) engine = innodb;

create table in_office (
  ssn decimal(9, 0) not null,
  building varchar(200) default null,
  room varchar(200) default null,
  primary key (ssn),
  constraint fk14 foreign key (ssn) references employee (ssn)
) engine = innodb;

create table analysis (
  pnumber decimal(2, 0) not null,
  title text default null,
  frequency integer default null,
  quantity integer default null,
  primary key (pnumber),
  constraint fk15 foreign key (pnumber) references project (pnumber)
) engine = innodb;

create table operations (
  pnumber decimal(2, 0) not null,
  title text default null,
  team_size integer default null,
  primary key (pnumber),
  constraint fk16 foreign key (pnumber) references project (pnumber)
) engine = innodb;

create table operation_skills (
  pnumber decimal(2, 0) not null,
  skill_name varchar(200) not null,
  primary key (pnumber, skill_name),
  constraint fk17 foreign key (pnumber) references operations (pnumber)
) engine = innodb;

create table maintenance (
  pnumber decimal(2, 0) not null,
  primary key (pnumber),
  constraint fk18 foreign key (pnumber) references project (pnumber)
) engine = innodb;

create table maintenance_types (
  pnumber decimal(2, 0) not null,
  remote_access enum('none', 'intranet', 'vpn', 'open') not null,
  frequency integer not null,
  cost integer not null,
  primary key (pnumber, remote_access, frequency, cost),
  constraint fk19 foreign key (pnumber) references maintenance (pnumber)
) engine = innodb;

create table interns_in (
  essn decimal(9, 0) not null,
  dependent_name char(10) not null,
  dnumber decimal(1, 0) not null,
  rating integer default null,
  primary key (essn, dependent_name, dnumber),
  constraint fk20 foreign key (essn, dependent_name) references dependent (essn, dependent_name),
  constraint fk21 foreign key (dnumber) references department (dnumber)  
) engine = innodb;

-- Enter your queries in the area below using this format:
-- create or replace view practiceQuery<#> as
-- <your proposed query solution>;

-- Be sure to end all queries with a semi-colon (';') and make sure that
-- the <#> value matches the query value from the practice sheet

-- -------------------------------------------------
-- view structures (student created solutions)
-- PUT ALL PROPOSED QUERY SOLUTIONS BELOW THIS LINE
-- -------------------------------------------------

create or replace view practiceQuery256 as
select cid, company, location, assets
from customer
where (not cid like "%bank%") or (not location in ("Dallas", "Houston"));

create or replace view practiceQuery664 as
select project.pnumber, pname, title
from project, analysis
where project.pnumber = analysis.pnumber and frequency * quantity > 100;

create or replace view practiceQuery366 as
select skill_name
from operation_skills
where skill_name in (select skill_name from operation_skills group by skill_name having count(*) = 1);

create or replace view practiceQuery650 as
select pname, pnumber, plocation
from project
where pnumber in (select pnumber from operations) and pnumber not in (select pno from works_on where hours < 10);

create or replace view practiceQuery361 as
select location, sum(assets) as total_assets, count(distinct fsid) as num_identifiers
from customer
group by location;

create or replace view practiceQuery717 as
select dname, dnumber, concat(fname, " ", lname) as manager_name
from department, employee
where dnumber = dno and mgrssn = ssn and dnumber in (select dnumber from interns_in group by dnumber having count(*) >= 2);

create or replace view practiceQuery568 as
select pname, plocation, remaining, usage_rate
from project, fund_source
where project.pnumber = fund_source.pnumber and usage_rate <= 1000 and plocation not in ("Houston"); 

create or replace view practiceQuery733 as
select pname, pnumber, plocation, dnum
from project
where pnumber in (select pnumber from maintenance_types group by pnumber having count(*) < 3);


-- -------------------------------------------------
-- PUT ALL PROPOSED QUERY SOLUTIONS ABOVE THIS LINE
-- -------------------------------------------------

-- The sole purpose of the following instruction is to minimize the impact of student-entered code
-- on the remainder of the autograding processes below
set @unused_variable_dont_care_about_value = 0;

-- -----------------------------------------------
-- table data
-- -----------------------------------------------

insert into employee values
('John', 'Smith', 123456789, '1965-01-09', '731 Fondren, Houston TX', 'M', 30000, 333445555, 5),
('Franklin', 'Wong', 333445555, '1955-12-08', '638 Voss, Houston TX', 'M', 40000, 888665555, 5),
('Joyce', 'English', 453453453, '1972-07-31', '5631 Rice, Houston TX', 'F', 25000, 333445555, 5),
('Ramesh', 'Narayan', 666884444, '1962-09-15', '975 Fire Oak, Humble TX', 'M', 38000, 333445555, 5),
('James', 'Borg', 888665555, '1937-11-10', '450 Stone, Houston TX', 'M', 55000, null, 1),
('Jennifer', 'Wallace', 987654321, '1941-06-20', '291 Berry, Bellaire TX', 'F', 43000, 888665555, 4),
('Ahmad', 'Jabbar', 987987987, '1969-03-29', '980 Dallas, Houston TX', 'M', 25000, 987654321, 4),
('Alicia', 'Zelaya', 999887777, '1968-01-19', '3321 Castle, Spring TX', 'F', 25000, 987654321, 4);

insert into dependent values
(123456789, 'Alice', 'F', '1988-12-30', 'Daughter'),
(123456789, 'Elizabeth', 'F', '1967-05-05', 'Spouse'),
(123456789, 'Michael', 'M', '1988-01-04', 'Son'),
(333445555, 'Alice', 'F', '1986-04-04', 'Daughter'),
(333445555, 'Joy', 'F', '1958-05-03', 'Spouse'),
(333445555, 'Theodore', 'M', '1983-10-25', 'Son'),
(987654321, 'Abner', 'M', '1942-02-28', 'Spouse');

insert into department values
('Headquarters', 1, 888665555, '1981-06-19'),
('Administration', 4, 987654321, '1995-01-01'),
('Research', 5, 333445555, '1988-05-22');

insert into dept_locations values
(1, 'Houston'),
(4, 'Stafford'),
(5, 'Bellaire'),
(5, 'Houston'),
(5, 'Sugarland');

insert into project values
('ProductX', 1, 'Bellaire', 5),
('ProductY', 2, 'Sugarland', 5),
('ProductZ', 3, 'Houston', 5),
('Computerization', 10, 'Stafford', 4),
('Reorganization', 20, 'Houston', 1),
('Newbenefits', 30, 'Stafford', 4);

insert into works_on values
(123456789, 1, 32.5),
(123456789, 2, 7.5),
(333445555, 2, 10.0),
(333445555, 3, 10.0),
(333445555, 10, 10.0),
(333445555, 20, 10.0),
(453453453, 1, 20.0),
(453453453, 2, 20.0),
(666884444, 3, 40.0),
(888665555, 20, null),
(987654321, 20, 15.0),
(987654321, 30, 20.0),
(987987987, 10, 35.0),
(987987987, 30, 5.0),
(999887777, 10, 10.0),
(999887777, 30, 30.0);

insert into fund_source values
(2, 10000, 1000, 1),
(3, 27000, 1000, 2),
(5, 31000, 2000, 2),
(7, 16000, 1000, 3),
(11, 6000, 1000, 10),
(13, 9000, 2000, 10),
(17, 61000, 5000, 10),
(23, 24000, 3000, 20),
(29, 21000, 1000, 30);

insert into customer values
('bank1', 'Second National Bank', 'Dallas', 350000, 2),
('bank2', 'Tempest Bank', 'Atlanta', 200000, 3),
('mgmt1', 'Power, Water & Copper', 'Dallas', null, 7),
('tech2', 'Cumulus Cloud Computing', null, 380000, 11),
('tech3', null, 'Houston', 850000, 13),
('bank3', 'Credit Union Universal', 'New York', 417000, 23),
('bank4', 'Anytime Anywhere Crypto', 'Houston', 619000, 29);

insert into budget values
(1, 10, 170000, 5),
(4, 6, 64000, null),
(5, 0, 516000, 17);

insert into remote_access values
(666884444, '403e:8f59:336e:d11b:0425:ed18:2f34:48a3', 'rnarayan3'),
(888665555, '26c8:4186:2105:cf66:7b3f:4b03:5dd7:3eb4', 'jborg1'),
(987654321, '3208:78e4:578b:034b:c7ff:1b55:6e41:8ece', 'jwallace3');

insert into time_frames values
(666884444, 13, 9),
(987654321, 11, 4),
(987654321, 23, 5),
(888665555, 15, 4);

insert into in_office values
(123456789, 'Main', '33-C'),
(333445555, 'Main', '100'),
(453453453, 'Main', '33-C'),
(987987987, 'Computing', 'Bridge'),
(999887777, 'Research', null);

insert into analysis values
(2, 'stock market prediction', 60, 2),
(30, 'cryptocurrency correlation', 30, 1);

insert into operations values
(2, 'stock ticker collection', 2),
(10, 'drone traffic control', 4),
(20, 'cloud conversion', 5),
(30, 'crypto monitoring', 2);

insert into operation_skills values
(2, 'financial analysis'),
(2, 'data storage management'),
(2, 'data visualization'),
(10, 'drone piloting'),
(10, 'real-time operating systems'),
(10, 'wireless networking'),
(20, 'cloud computing'),
(30, 'financial analysis'),
(30, 'data storage management'),
(30, 'pattern mining'),
(30, 'data visualization');

insert into maintenance values
(1),
(2),
(10);

insert into maintenance_types values
(1, 'intranet', 4, 500),
(1, 'open', 12, 100),
(2, 'none', 1, 2000),
(2, 'intranet', 10, 200),
(2, 'vpn', 30, 100),
(10, 'vpn', 4, 400),
(10, 'open', 20, 100);

insert into interns_in values
(123456789, 'Alice', 1, 7),
(123456789, 'Alice', 4, 8),
(123456789, 'Michael', 4, 6),
(123456789, 'Michael', 5, 8),
(333445555, 'Alice', 5, 10);

-- -------------------------------------------------
-- additional referential integrity constraints
-- -------------------------------------------------

alter table employee add constraint fk2 foreign key (dno) references department (dnumber);
alter table employee add constraint fk7 foreign key (superssn) references employee (ssn);
alter table department add constraint fk4 foreign key (mgrssn) references employee (ssn);

-- -------------------------------------------------
-- autograding system
-- -------------------------------------------------
set @thisDatabase = 'global_company';

-- This is required to support some of the arbitrary SQL commands that might be used in the testing process.
set SQL_SAFE_UPDATES = 0;

-- This SQL MODE is used to deliberately allow for queries that do not follow the "ONLY_FULL_GROUP_BY" protocol.
-- Though it does permit queries that are arguably poorly-structured, this is permitted by the most recent SQL standards.
set session SQL_MODE = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- The magic44_data_capture table is used to store the data created by the student's queries
-- The table is populated by the magic44_evaluate_queries stored procedure
-- The data in the table is used to populate the magic44_test_results table for analysis

drop table if exists magic44_data_capture;
create table magic44_data_capture (
	stepID integer, queryID integer,
    columnDump0 varchar(1000), columnDump1 varchar(1000), columnDump2 varchar(1000), columnDump3 varchar(1000), columnDump4 varchar(1000),
    columnDump5 varchar(1000), columnDump6 varchar(1000), columnDump7 varchar(1000), columnDump8 varchar(1000), columnDump9 varchar(1000),
	columnDump10 varchar(1000), columnDump11 varchar(1000), columnDump12 varchar(1000), columnDump13 varchar(1000), columnDump14 varchar(1000)
);

-- The magic44_column_listing table is used to help prepare the insert statements for the magic44_data_capture
-- table for the student's queries which may have variable numbers of columns (the table is prepopulated)

drop table if exists magic44_column_listing;
create table magic44_column_listing (
	columnPosition integer,
    simpleColumnName varchar(50),
    nullColumnName varchar(50)
);

insert into magic44_column_listing (columnPosition, simpleColumnName) values
(0, 'columnDump0'), (1, 'columnDump1'), (2, 'columnDump2'), (3, 'columnDump3'), (4, 'columnDump4'),
(5, 'columnDump5'), (6, 'columnDump6'), (7, 'columnDump7'), (8, 'columnDump8'), (9, 'columnDump9'),
(10, 'columnDump10'), (11, 'columnDump11'), (12, 'columnDump12'), (13, 'columnDump13'), (14, 'columnDump14');

drop function if exists magic44_gen_simple_template;
delimiter //
create function magic44_gen_simple_template(numberOfColumns integer)
	returns varchar(1000) deterministic
begin
return (select group_concat(simpleColumnName separator ", ") from magic44_column_listing
	where columnPosition < numberOfColumns);
end //
delimiter ;

-- Create a variable to effectively act as a program counter for the testing process/steps
set @stepCounter = 0;

-- The magic44_magic44_query_capture function is used to construct the instruction
-- that can be used to execute and store the results of a query
drop function if exists magic44_query_capture;
delimiter //
create function magic44_query_capture(thisQuery integer)
	returns varchar(1000) deterministic
begin
	set @numberOfColumns = (select count(*) from information_schema.columns
		where table_schema = @thisDatabase
        and table_name = concat('practiceQuery', thisQuery));

	set @buildQuery = "insert into magic44_data_capture (stepID, queryID, ";
    set @buildQuery = concat(@buildQuery, magic44_gen_simple_template(@numberOfColumns));
    set @buildQuery = concat(@buildQuery, ") select ");
    set @buildQuery = concat(@buildQuery, @stepCounter, ", ");
    set @buildQuery = concat(@buildQuery, thisQuery, ", practiceQuery");
    set @buildQuery = concat(@buildQuery, thisQuery, ".* from practiceQuery");
    set @buildQuery = concat(@buildQuery, thisQuery, ";");
    
return @buildQuery;
end //
delimiter ;

-- The magic44_testing_steps table is used to change the state of the database to test the queries more fully
-- This table is used by the magic44_evaluate_queries stored procedure
-- The table is prepopulated and contains both SQL commands and non-SQL special commands that drive the testing process
-- The SQL commands are used to change the state of the database to facilitate more thorough testing
-- The non-SQL special commands are used to support execution of otherwise complex commands (e.g., stored procedures)

drop table if exists magic44_testing_steps;
create table magic44_testing_steps (
	stepID integer,
    changeInstruction varchar(2000),
    primary key (stepID)
);

-- In many cases, we will use a "compensating transaction" policy to change a table, and then change it's contents
-- back to the original state to minimize any effects from propagting errors
-- For more advanced testing, however, multiple sequential changes to the tables will be executed

insert into magic44_testing_steps values
(0, '&non_sql&evaluate_all_queries'),
-- (1, 'insert into employee values'),
(2, 'insert into dependent values
(999887777, "xxxxAurora", "F", "2010-01-01", "Daughter");'),
-- (3, 'insert into department values'),
-- (4, 'insert into dept_locations values'),
(5, 'insert into project values
("xxxxSpecial", 41, "Stafford", 4),
("xxxxWrongPlace", 55, "Bellaire", 4),
("xxxxWrongDept", 66, "Amarillo", 1),
("xxxxCommunity", 43, "Amarillo", 5);'),
(6, 'insert into works_on values
(987654321, 41, 99.0),
(333445555, 41, 99.0),
(123456789, 41, 99.0),
(333445555, 43, 99.0);'),
(7, 'insert into fund_source values
(31, 6999, 500, 1),
(37, 7000, 500, 1),
(41, 7000, 500, 1),
(43, 23400, 1500, 3);'),
(8, 'insert into customer values
("ebank1xxxx", "Fourth National Bank", "Miami", 600000, 2),
("xxxx2", "Third National Bank", "Dallas", 500000, 2);'),
(9, 'insert into budget values
(4, 99, 164000, 43);'),
(10, 'update remote_access
set ip_address = "3208:78e4:578b:034b:c7ee:1b55:6e41:8ecf"
where ssn = 987654321;'),
(11, 'insert into time_frames values
(987654321, 6, 3);'),
-- (12, 'insert into in_office values'),
-- (13, 'insert into analysis values'),
(14, 'insert into operations values
(1, "foreign language translation", 31);'),
(15, 'insert into operation_skills values
(2, "xxxx relational database"),
(2, "xxxx automated data correlation"),
(2, "xxxx astronomical data"),
(20, "xxxx quantum computing"),
(20, "xxxx virtual reality"),
(2, "cloud computing");'),
(16, 'insert into maintenance values
(30);'),
(17, 'insert into maintenance_types values
(10, "intranet", 4, 50);'),
(18, 'insert into interns_in values
(999887777, "xxxxAurora", 4, 9);'),
(19, '&non_sql&evaluate_all_queries'),
(20, 'delete from interns_in where dependent_name like "%xxxx%";'),
(21, 'delete from maintenance_types where cost < 100;'),
(22, 'delete from maintenance where pnumber > 10;'),
(23, 'delete from operation_skills
where (pnumber = 2 and skill_name = "cloud computing")
or skill_name like "%xxxx%";'),
(24, 'delete from operations where pnumber < 2;'),
-- (25, 'delete from analysis where ___;'),
-- (26, 'delete from in_office where ___;'),
(27, 'delete from time_frames where start_hour < 11;'),
(28, 'update remote_access
set ip_address = "3208:78e4:578b:034b:c7ff:1b55:6e41:8ece"
where ssn = 987654321;'),
(29, 'delete from budget where bcode > 10;'),
(30, 'delete from customer where cid like "%xxxx%";'),
(31, 'delete from fund_source where fsid > 29;'),
(32, 'delete from works_on where pno > 30;'),
(33, 'delete from project where pname like "%xxxx%";'),
-- (34, 'delete from dept_locations where ___;'),
-- (35, 'delete from department where ___;'),
(36, 'delete from dependent where dependent_name like "%xxxx%";'),
(37, 'delete from employee where false;');

drop function if exists magic44_query_exists;
delimiter //
create function magic44_query_exists(thisQuery integer)
	returns integer deterministic
begin
	return (select exists (select * from information_schema.views
		where table_schema = @thisDatabase
        and table_name like concat('practiceQuery', thisQuery)));
end //
delimiter ;

drop function if exists magic44_test_step_exists;
delimiter //
create function magic44_test_step_exists()
	returns integer deterministic
begin
	return (select exists (select * from magic44_testing_steps where stepID = @stepCounter));
end //
delimiter ;

-- Exception checking has been implemented to prevent (as much as reasonably possible) errors
-- in the queries being evaluated from interrupting the testing process
-- The magic44_log_query_errors table capture these errors for later review

drop table if exists magic44_log_query_errors;
create table magic44_log_query_errors (
	step_id integer,
    query_id integer,
    error_code char(5),
    error_message text	
);

drop procedure if exists magic44_query_check_and_run;
delimiter //
create procedure magic44_query_check_and_run(in thisQuery integer)
begin
	declare err_code char(5) default '00000';
    declare err_msg text;
    
	declare continue handler for SQLEXCEPTION
    begin
		get diagnostics condition 1
			err_code = RETURNED_SQLSTATE, err_msg = MESSAGE_TEXT;
	end;

	if magic44_query_exists(thisQuery) then
		set @sql_text = magic44_query_capture(thisQuery);
		prepare statement from @sql_text;
        execute statement;
        if err_code <> '00000' then
			insert into magic44_log_query_errors values (@stepCounter, thisQuery, err_code, err_msg);
		end if;
        deallocate prepare statement;
	end if;
end //
delimiter ;

drop procedure if exists magic44_test_step_check_and_run;
delimiter //
create procedure magic44_test_step_check_and_run()
begin
	if magic44_test_step_exists() then
		set @sql_text = (select changeInstruction from magic44_testing_steps where stepID = @stepCounter);
        if @sql_text = '&non_sql&evaluate_all_queries' then
			call magic44_evaluate_queries();
        else
			prepare statement from @sql_text;
			execute statement;
			deallocate prepare statement;
		end if;
	end if;
end //
delimiter ;

drop procedure if exists magic44_evaluate_queries;
delimiter //
create procedure magic44_evaluate_queries()
sp_main: begin
	set @startingQuery = 0, @endingQuery = 1000;
    set @queryCounter = @startingQuery;
    
	all_queries: while @queryCounter <= @endingQuery do
		call magic44_query_check_and_run(@queryCounter);
		set @queryCounter = @queryCounter + 1;
	end while;
end //
delimiter ;

drop procedure if exists magic44_evaluate_testing_steps;
delimiter //
create procedure magic44_evaluate_testing_steps()
sp_main: begin
	set @startingStep = 0;    
    if not exists (select max(stepID) from magic44_testing_steps) then leave sp_main; end if;
    set @endingStep = (select max(stepID) from magic44_testing_steps);
	set @stepCounter = @startingStep;

    all_steps: repeat		
        call magic44_test_step_check_and_run();
        set @stepCounter = @stepCounter + 1;
	until (@stepCounter > @endingStep)
    end repeat;
end //
delimiter ;

-- These tables are used to store the answers and test results.  The answers are generated by executing
-- the test script against our reference solution.  The test results are collected by running the test
-- script against your submission in order to compare the results.

-- the results from magic44_data_capture the are transferred into the magic44_test_results table
drop table if exists magic44_test_results;
create table magic44_test_results (
	step_id integer not null,
    query_id integer,
	row_hash varchar(2000) not null
);

call magic44_evaluate_testing_steps();
insert into magic44_test_results
select stepID, queryID, concat_ws('#', ifnull(columndump0, ''), ifnull(columndump1, ''), ifnull(columndump2, ''), ifnull(columndump3, ''),
ifnull(columndump4, ''), ifnull(columndump5, ''), ifnull(columndump6, ''), ifnull(columndump7, ''), ifnull(columndump8, ''), ifnull(columndump9, ''),
ifnull(columndump10, ''), ifnull(columndump11, ''), ifnull(columndump12, ''), ifnull(columndump13, ''), ifnull(columndump14, ''))
from magic44_data_capture;

-- the answers generated from the reference solution are loaded below
drop table if exists magic44_expected_results;
create table magic44_expected_results (
	step_id integer not null,
    query_id integer,
	row_hash varchar(2000) not null
);

insert into magic44_expected_results values
(0,200,'2#datastoragemanagement#############'),
(0,200,'2#datavisualization#############'),
(0,200,'30#datastoragemanagement#############'),
(0,200,'30#datavisualization#############'),
(0,209,'anytimeanywherecrypto#houston#619000############'),
(0,209,'#houston#850000############'),
(0,227,'2#datastoragemanagement#############'),
(0,227,'2#datavisualization#############'),
(0,227,'30#datastoragemanagement#############'),
(0,227,'30#datavisualization#############'),
(0,256,'bank2#tempestbank#atlanta#200000###########'),
(0,256,'bank3#creditunionuniversal#newyork#417000###########'),
(0,256,'mgmt1#power,water&copper#dallas############'),
(0,256,'tech2#cumuluscloudcomputing##380000###########'),
(0,256,'tech3##houston#850000###########'),
(0,263,'computerization#10#stafford#4###########'),
(0,263,'newbenefits#30#stafford#4###########'),
(0,263,'productz#3#houston#5###########'),
(0,290,'anytimeanywherecrypto#houston#619000############'),
(0,290,'power,water&copper#dallas#############'),
(0,290,'#houston#850000############'),
(0,291,'666884444#403e:8f59:336e:d11b:0425:ed18:2f34:48a3#rnarayan3############'),
(0,291,'888665555#26c8:4186:2105:cf66:7b3f:4b03:5dd7:3eb4#jborg1############'),
(0,301,'11#6000#1000############'),
(0,301,'13#9000#2000############'),
(0,301,'23#24000#3000############'),
(0,310,'11#6000#1000############'),
(0,350,'1#intranet#2000############'),
(0,350,'1#open#1200############'),
(0,350,'2#none#2000############'),
(0,350,'2#intranet#2000############'),
(0,350,'2#vpn#3000############'),
(0,350,'10#vpn#1600############'),
(0,350,'10#open#2000############'),
(0,353,'123456789#3#1988-12-30############'),
(0,353,'333445555#3#1986-04-04############'),
(0,353,'987654321#1#1942-02-28############'),
(0,355,'123456789#3#1967-05-05############'),
(0,355,'333445555#3#1958-05-03############'),
(0,361,'#380000#1############'),
(0,361,'atlanta#200000#1############'),
(0,361,'dallas#350000#2############'),
(0,361,'houston#1469000#2############'),
(0,361,'newyork#417000#1############'),
(0,366,'dronepiloting##############'),
(0,366,'real-timeoperatingsystems##############'),
(0,366,'wirelessnetworking##############'),
(0,366,'cloudcomputing##############'),
(0,366,'patternmining##############'),
(0,409,'1#52.5#2############'),
(0,409,'3#50.0#2############'),
(0,414,'123456789#alice#7#1###########'),
(0,414,'123456789#michael#6#2###########'),
(0,414,'333445555#alice#10#0###########'),
(0,419,'2#3#37.5############'),
(0,419,'10#3#55.0############'),
(0,419,'20#3#25.0############'),
(0,419,'30#3#55.0############'),
(0,441,'123456789#alice#8#15###########'),
(0,441,'123456789#michael#8#14###########'),
(0,441,'333445555#alice#10#20###########'),
(0,500,'administration#6#64000############'),
(0,500,'headquarters#10#170000#31000#2000##########'),
(0,500,'research#0#516000#61000#5000##########'),
(0,515,'john#smith#123456789#michael#731fondren,houstontx#m#########'),
(0,515,'franklin#wong#333445555#theodore#638voss,houstontx#m#########'),
(0,541,'productx#10000#1000############'),
(0,541,'producty#27000#1000############'),
(0,541,'producty#31000#2000############'),
(0,541,'productz#16000#1000############'),
(0,541,'computerization#6000#1000############'),
(0,541,'computerization#9000#2000############'),
(0,541,'computerization#61000#5000############'),
(0,541,'reorganization#24000#3000############'),
(0,541,'newbenefits#21000#1000############'),
(0,544,'johnsmith#main#33-c############'),
(0,544,'franklinwong#main#100############'),
(0,544,'joyceenglish#main#33-c############'),
(0,544,'ahmadjabbar#computing#bridge############'),
(0,544,'aliciazelaya#research#############'),
(0,547,'producty#31000#2000############'),
(0,547,'computerization#9000#2000############'),
(0,547,'reorganization#24000#3000############'),
(0,568,'productx#bellaire#10000#1000###########'),
(0,568,'producty#sugarland#27000#1000###########'),
(0,568,'computerization#stafford#6000#1000###########'),
(0,568,'newbenefits#stafford#21000#1000###########'),
(0,574,'computerization#stafford#dronetrafficcontrol############'),
(0,574,'reorganization#houston#cloudconversion############'),
(0,605,'administration#4#############'),
(0,616,'james#borg#26c8:4186:2105:cf66:7b3f:4b03:5dd7:3eb4#jborg1#15##########'),
(0,616,'jennifer#wallace#3208:78e4:578b:034b:c7ff:1b55:6e41:8ece#jwallace3#11##########'),
(0,616,'jennifer#wallace#3208:78e4:578b:034b:c7ff:1b55:6e41:8ece#jwallace3#23##########'),
(0,622,'3#27000#1000############'),
(0,622,'5#31000#2000#1#10#170000#########'),
(0,622,'17#61000#5000#5#0#516000#########'),
(0,622,'23#24000#3000############'),
(0,622,'29#21000#1000############'),
(0,646,'ramesh#narayan#403e:8f59:336e:d11b:0425:ed18:2f34:48a3#rnarayan3#9##########'),
(0,646,'james#borg#26c8:4186:2105:cf66:7b3f:4b03:5dd7:3eb4#jborg1#4##########'),
(0,646,'jennifer#wallace#3208:78e4:578b:034b:c7ff:1b55:6e41:8ece#jwallace3#4##########'),
(0,647,'reorganization##############'),
(0,647,'computerization#vpn#4#400###########'),
(0,647,'computerization#open#20#100###########'),
(0,647,'newbenefits##############'),
(0,650,'computerization#10#stafford############'),
(0,650,'reorganization#20#houston############'),
(0,664,'2#producty#stockmarketprediction############'),
(0,676,'producty#2#sugarland#5###########'),
(0,676,'computerization#10#stafford#4###########'),
(0,676,'newbenefits#30#stafford#4###########'),
(0,683,'rameshnarayan#rnarayan3#403e:8f59:336e:d11b:0425:ed18:2f34:48a3############'),
(0,683,'jamesborg#jborg1#26c8:4186:2105:cf66:7b3f:4b03:5dd7:3eb4############'),
(0,683,'jenniferwallace#jwallace3#3208:78e4:578b:034b:c7ff:1b55:6e41:8ece############'),
(0,689,'bank1#secondnationalbank#350000############'),
(0,689,'tech2#cumuluscloudcomputing#380000############'),
(0,689,'tech3##850000############'),
(0,689,'bank3#creditunionuniversal#417000############'),
(0,701,'2#producty#sugarland############'),
(0,701,'10#computerization#stafford############'),
(0,701,'20#reorganization#houston############'),
(0,701,'30#newbenefits#stafford############'),
(0,710,'headquarters#1#888665555############'),
(0,710,'research#5#333445555############'),
(0,717,'administration#4#jenniferwallace############'),
(0,717,'research#5#franklinwong############'),
(0,733,'productx#1#bellaire#5###########'),
(0,733,'computerization#10#stafford#4###########'),
(0,738,'productz#3#houston############'),
(0,758,'producty#2#sugarland############'),
(0,758,'computerization#10#stafford############'),
(0,771,'2#stockmarketprediction#############'),
(0,771,'10#dronetrafficcontrol#############'),
(0,771,'20#cloudconversion#############'),
(0,783,'productx#1#bellaire#5###########'),
(0,783,'computerization#10#stafford#4###########'),
(0,800,'none#1#1############'),
(0,800,'intranet#14#2############'),
(0,800,'vpn#34#2############'),
(0,800,'open#32#2############'),
(0,805,'1#borg,james#############'),
(0,813,'123456789#alice#f#1988-12-30###########'),
(0,813,'123456789#michael#m#1988-01-04###########'),
(0,813,'987654321#jennifer#f#1941-06-20###########'),
(0,813,'987987987#ahmad#m#1969-03-29###########'),
(0,813,'999887777#alicia#f#1968-01-19###########'),
(0,816,'research#5#############'),
(0,826,'10#computerization#6000#1000#380000##########'),
(0,826,'10#computerization#9000#2000#850000##########'),
(0,826,'10#computerization#61000#5000#516000##########'),
(0,826,'3#productz#16000#1000###########'),
(0,826,'20#reorganization#24000#3000#417000##########'),
(0,833,'1#1#500############'),
(0,833,'2#2#2200############'),
(0,833,'10#1#400############'),
(0,857,'3#productz#houston#research###########'),
(0,861,'1#productx#bellaire############'),
(0,861,'3#productz#houston############'),
(0,861,'20#reorganization#houston############'),
(0,861,'30#newbenefits#stafford############'),
(19,200,'2#datastoragemanagement#############'),
(19,200,'2#datavisualization#############'),
(19,200,'2#xxxxastronomicaldata#############'),
(19,200,'30#datastoragemanagement#############'),
(19,200,'30#datavisualization#############'),
(19,209,'anytimeanywherecrypto#houston#619000############'),
(19,209,'#houston#850000############'),
(19,227,'2#datastoragemanagement#############'),
(19,227,'2#datavisualization#############'),
(19,227,'2#xxxxastronomicaldata#############'),
(19,227,'2#xxxxautomateddatacorrelation#############'),
(19,227,'30#datastoragemanagement#############'),
(19,227,'30#datavisualization#############'),
(19,256,'bank2#tempestbank#atlanta#200000###########'),
(19,256,'bank3#creditunionuniversal#newyork#417000###########'),
(19,256,'ebank1xxxx#fourthnationalbank#miami#600000###########'),
(19,256,'mgmt1#power,water&copper#dallas############'),
(19,256,'tech2#cumuluscloudcomputing##380000###########'),
(19,256,'tech3##houston#850000###########'),
(19,256,'xxxx2#thirdnationalbank#dallas#500000###########'),
(19,263,'productz#3#houston#5###########'),
(19,263,'computerization#10#stafford#4###########'),
(19,263,'newbenefits#30#stafford#4###########'),
(19,263,'xxxxspecial#41#stafford#4###########'),
(19,263,'xxxxcommunity#43#amarillo#5###########'),
(19,290,'anytimeanywherecrypto#houston#619000############'),
(19,290,'power,water&copper#dallas#############'),
(19,290,'#houston#850000############'),
(19,290,'thirdnationalbank#dallas#500000############'),
(19,291,'666884444#403e:8f59:336e:d11b:0425:ed18:2f34:48a3#rnarayan3############'),
(19,291,'888665555#26c8:4186:2105:cf66:7b3f:4b03:5dd7:3eb4#jborg1############'),
(19,291,'987654321#3208:78e4:578b:034b:c7ee:1b55:6e41:8ecf#jwallace3############'),
(19,301,'11#6000#1000############'),
(19,301,'13#9000#2000############'),
(19,301,'23#24000#3000############'),
(19,301,'31#6999#500############'),
(19,310,'11#6000#1000############'),
(19,310,'31#6999#500############'),
(19,350,'1#intranet#2000############'),
(19,350,'1#open#1200############'),
(19,350,'2#none#2000############'),
(19,350,'2#intranet#2000############'),
(19,350,'2#vpn#3000############'),
(19,350,'10#intranet#200############'),
(19,350,'10#vpn#1600############'),
(19,350,'10#open#2000############'),
(19,353,'123456789#3#1988-12-30############'),
(19,353,'333445555#3#1986-04-04############'),
(19,353,'987654321#1#1942-02-28############'),
(19,353,'999887777#1#2010-01-01############'),
(19,355,'123456789#3#1967-05-05############'),
(19,355,'333445555#3#1958-05-03############'),
(19,361,'#380000#1############'),
(19,361,'atlanta#200000#1############'),
(19,361,'dallas#850000#2############'),
(19,361,'houston#1469000#2############'),
(19,361,'miami#600000#1############'),
(19,361,'newyork#417000#1############'),
(19,366,'xxxxastronomicaldata##############'),
(19,366,'xxxxautomateddatacorrelation##############'),
(19,366,'xxxxrelationaldatabase##############'),
(19,366,'dronepiloting##############'),
(19,366,'real-timeoperatingsystems##############'),
(19,366,'wirelessnetworking##############'),
(19,366,'xxxxquantumcomputing##############'),
(19,366,'xxxxvirtualreality##############'),
(19,366,'patternmining##############'),
(19,409,'1#52.5#2############'),
(19,409,'3#50.0#2############'),
(19,409,'43#99.0#1############'),
(19,414,'123456789#alice#7#1###########'),
(19,414,'123456789#michael#6#2###########'),
(19,414,'333445555#alice#10#0###########'),
(19,414,'999887777#xxxxaurora#9#0###########'),
(19,419,'2#3#37.5############'),
(19,419,'10#3#55.0############'),
(19,419,'20#3#25.0############'),
(19,419,'30#3#55.0############'),
(19,419,'41#3#297.0############'),
(19,441,'123456789#alice#8#15###########'),
(19,441,'123456789#michael#8#14###########'),
(19,441,'333445555#alice#10#20###########'),
(19,441,'999887777#xxxxaurora#9#18###########'),
(19,500,'administration#6#64000############'),
(19,500,'administration#99#164000#23400#1500##########'),
(19,500,'headquarters#10#170000#31000#2000##########'),
(19,500,'research#0#516000#61000#5000##########'),
(19,515,'john#smith#123456789#michael#731fondren,houstontx#m#########'),
(19,515,'franklin#wong#333445555#theodore#638voss,houstontx#m#########'),
(19,515,'alicia#zelaya#999887777#xxxxaurora#3321castle,springtx#f#########'),
(19,541,'productx#10000#1000############'),
(19,541,'producty#27000#1000############'),
(19,541,'producty#31000#2000############'),
(19,541,'productz#16000#1000############'),
(19,541,'computerization#6000#1000############'),
(19,541,'computerization#9000#2000############'),
(19,541,'computerization#61000#5000############'),
(19,541,'reorganization#24000#3000############'),
(19,541,'newbenefits#21000#1000############'),
(19,541,'productz#23400#1500############'),
(19,544,'johnsmith#main#33-c############'),
(19,544,'franklinwong#main#100############'),
(19,544,'joyceenglish#main#33-c############'),
(19,544,'ahmadjabbar#computing#bridge############'),
(19,544,'aliciazelaya#research#############'),
(19,547,'producty#31000#2000############'),
(19,547,'computerization#9000#2000############'),
(19,547,'reorganization#24000#3000############'),
(19,547,'productz#23400#1500############'),
(19,568,'productx#bellaire#10000#1000###########'),
(19,568,'producty#sugarland#27000#1000###########'),
(19,568,'computerization#stafford#6000#1000###########'),
(19,568,'newbenefits#stafford#21000#1000###########'),
(19,568,'productx#bellaire#6999#500###########'),
(19,568,'productx#bellaire#7000#500###########'),
(19,568,'productx#bellaire#7000#500###########'),
(19,574,'productx#bellaire#foreignlanguagetranslation############'),
(19,574,'computerization#stafford#dronetrafficcontrol############'),
(19,574,'reorganization#houston#cloudconversion############'),
(19,605,'administration#4#############'),
(19,616,'james#borg#26c8:4186:2105:cf66:7b3f:4b03:5dd7:3eb4#jborg1#15##########'),
(19,616,'jennifer#wallace#3208:78e4:578b:034b:c7ee:1b55:6e41:8ecf#jwallace3#6##########'),
(19,616,'jennifer#wallace#3208:78e4:578b:034b:c7ee:1b55:6e41:8ecf#jwallace3#11##########'),
(19,616,'jennifer#wallace#3208:78e4:578b:034b:c7ee:1b55:6e41:8ecf#jwallace3#23##########'),
(19,622,'3#27000#1000############'),
(19,622,'5#31000#2000#1#10#170000#########'),
(19,622,'17#61000#5000#5#0#516000#########'),
(19,622,'23#24000#3000############'),
(19,622,'29#21000#1000############'),
(19,622,'43#23400#1500#4#99#164000#########'),
(19,646,'ramesh#narayan#403e:8f59:336e:d11b:0425:ed18:2f34:48a3#rnarayan3#9##########'),
(19,646,'james#borg#26c8:4186:2105:cf66:7b3f:4b03:5dd7:3eb4#jborg1#4##########'),
(19,646,'jennifer#wallace#3208:78e4:578b:034b:c7ee:1b55:6e41:8ecf#jwallace3#3##########'),
(19,646,'jennifer#wallace#3208:78e4:578b:034b:c7ee:1b55:6e41:8ecf#jwallace3#4##########'),
(19,647,'reorganization##############'),
(19,647,'xxxxwrongdept##############'),
(19,647,'computerization#intranet#4#50###########'),
(19,647,'computerization#vpn#4#400###########'),
(19,647,'computerization#open#20#100###########'),
(19,647,'newbenefits##############'),
(19,647,'xxxxspecial##############'),
(19,647,'xxxxwrongplace##############'),
(19,650,'productx#1#bellaire############'),
(19,650,'computerization#10#stafford############'),
(19,650,'reorganization#20#houston############'),
(19,664,'2#producty#stockmarketprediction############'),
(19,676,'producty#2#sugarland#5###########'),
(19,676,'computerization#10#stafford#4###########'),
(19,676,'reorganization#20#houston#1###########'),
(19,676,'newbenefits#30#stafford#4###########'),
(19,683,'rameshnarayan#rnarayan3#403e:8f59:336e:d11b:0425:ed18:2f34:48a3############'),
(19,683,'jamesborg#jborg1#26c8:4186:2105:cf66:7b3f:4b03:5dd7:3eb4############'),
(19,683,'jenniferwallace#jwallace3#3208:78e4:578b:034b:c7ee:1b55:6e41:8ecf############'),
(19,689,'bank1#secondnationalbank#350000############'),
(19,689,'ebank1xxxx#fourthnationalbank#600000############'),
(19,689,'xxxx2#thirdnationalbank#500000############'),
(19,689,'tech2#cumuluscloudcomputing#380000############'),
(19,689,'tech3##850000############'),
(19,689,'bank3#creditunionuniversal#417000############'),
(19,701,'1#productx#bellaire############'),
(19,701,'2#producty#sugarland############'),
(19,701,'10#computerization#stafford############'),
(19,701,'20#reorganization#houston############'),
(19,701,'30#newbenefits#stafford############'),
(19,710,'headquarters#1#888665555############'),
(19,710,'administration#4#987654321############'),
(19,710,'research#5#333445555############'),
(19,717,'administration#4#jenniferwallace############'),
(19,717,'research#5#franklinwong############'),
(19,733,'productx#1#bellaire#5###########'),
(19,738,'productz#3#houston############'),
(19,738,'xxxxspecial#41#stafford############'),
(19,738,'xxxxcommunity#43#amarillo############'),
(19,738,'xxxxwrongplace#55#bellaire############'),
(19,738,'xxxxwrongdept#66#amarillo############'),
(19,758,'productx#1#bellaire############'),
(19,758,'producty#2#sugarland############'),
(19,758,'computerization#10#stafford############'),
(19,758,'newbenefits#30#stafford############'),
(19,771,'2#stockmarketprediction#############'),
(19,771,'1#foreignlanguagetranslation#############'),
(19,771,'10#dronetrafficcontrol#############'),
(19,771,'20#cloudconversion#############'),
(19,783,'productx#1#bellaire#5###########'),
(19,783,'computerization#10#stafford#4###########'),
(19,800,'none#1#1############'),
(19,800,'intranet#18#3############'),
(19,800,'vpn#34#2############'),
(19,800,'open#32#2############'),
(19,805,'1#borg,james#############'),
(19,813,'123456789#alice#f#1988-12-30###########'),
(19,813,'123456789#michael#m#1988-01-04###########'),
(19,813,'999887777#xxxxaurora#f#2010-01-01###########'),
(19,813,'987654321#jennifer#f#1941-06-20###########'),
(19,813,'987987987#ahmad#m#1969-03-29###########'),
(19,813,'999887777#alicia#f#1968-01-19###########'),
(19,816,'research#5#############'),
(19,826,'3#productz#16000#1000###########'),
(19,826,'3#productz#23400#1500#164000##########'),
(19,826,'10#computerization#6000#1000#380000##########'),
(19,826,'10#computerization#9000#2000#850000##########'),
(19,826,'10#computerization#61000#5000#516000##########'),
(19,826,'20#reorganization#24000#3000#417000##########'),
(19,833,'1#2#600############'),
(19,833,'2#3#2300############'),
(19,833,'10#2#500############'),
(19,857,'41#xxxxspecial#stafford#administration###########'),
(19,857,'55#xxxxwrongplace#bellaire#administration###########'),
(19,857,'66#xxxxwrongdept#amarillo#headquarters###########'),
(19,857,'3#productz#houston#research###########'),
(19,857,'43#xxxxcommunity#amarillo#research###########'),
(19,861,'20#reorganization#houston############'),
(19,861,'30#newbenefits#stafford############');

-- Delete the unneeded rows from the answers table to simplify later analysis
delete from magic44_expected_results where not magic44_query_exists(query_id);

-- Modify the row hash results for the results table to eliminate spaces and convert all characters to lowercase
update magic44_test_results set row_hash = lower(replace(row_hash, ' ', ''));

-- The magic44_count_differences view displays the differences between the number of rows contained in the answers
-- and the test results.  the value null in the answer_total and result_total columns represents zero (0) rows for
-- that query result.

drop view if exists magic44_count_answers;
create view magic44_count_answers as
select step_id, query_id, count(*) as answer_total
from magic44_expected_results group by step_id, query_id;

drop view if exists magic44_count_test_results;
create view magic44_count_test_results as
select step_id, query_id, count(*) as result_total
from magic44_test_results group by step_id, query_id;

drop view if exists magic44_count_differences;
create view magic44_count_differences as
select magic44_count_answers.query_id, magic44_count_answers.step_id, answer_total, result_total
from magic44_count_answers left outer join magic44_count_test_results
	on magic44_count_answers.step_id = magic44_count_test_results.step_id
	and magic44_count_answers.query_id = magic44_count_test_results.query_id
where answer_total <> result_total or result_total is null
union
select magic44_count_test_results.query_id, magic44_count_test_results.step_id, answer_total, result_total
from magic44_count_test_results left outer join magic44_count_answers
	on magic44_count_test_results.step_id = magic44_count_answers.step_id
	and magic44_count_test_results.query_id = magic44_count_answers.query_id
where result_total <> answer_total or answer_total is null
order by query_id, step_id;

-- The magic44_content_differences view displays the differences between the answers and test results
-- in terms of the row attributes and values.  the error_category column contains missing for rows that
-- are not included in the test results but should be, while extra represents the rows that should not
-- be included in the test results.  the row_hash column contains the values of the row in a single
-- string with the attribute values separated by a selected delimeter (i.e., the pound sign/#).

drop view if exists magic44_content_differences;
create view magic44_content_differences as
select query_id, step_id, 'missing' as category, row_hash
from magic44_expected_results where concat(step_id, '@', query_id, '@',row_hash) not in
	(select concat(step_id, '@', query_id, '@', row_hash) from magic44_test_results)
union
select query_id, step_id, 'extra' as category, row_hash
from magic44_test_results where concat(step_id, '@', query_id, '@', row_hash) not in
	(select concat(step_id, '@', query_id, '@', row_hash) from magic44_expected_results)
order by query_id, step_id, row_hash;

drop view if exists magic44_result_set_size_errors;
create view magic44_result_set_size_errors as
select step_id, query_id, 'result_set_size' as err_category from magic44_count_differences
group by step_id, query_id;

drop view if exists magic44_attribute_value_errors;
create view magic44_attribute_value_errors as
select step_id, query_id, 'attribute_values' as err_category from magic44_content_differences
where concat(step_id, '@', query_id) not in (select concat(step_id, '@', query_id) from magic44_count_differences)
group by step_id, query_id;

drop view if exists magic44_errors_assembled;
create view magic44_errors_assembled as
select * from magic44_result_set_size_errors
union    
select * from magic44_attribute_value_errors;

drop table if exists magic44_row_count_errors;
create table magic44_row_count_errors (
	query_id integer,
    step_id integer,
    expected_row_count integer,
    actual_row_count integer
);

insert into magic44_row_count_errors
select * from magic44_count_differences
order by query_id, step_id;

drop table if exists magic44_column_errors;
create table magic44_column_errors (
	query_id integer,
    step_id integer,
    extra_or_missing char(20),
    condensed_row_contents varchar(15000)
);

insert into magic44_column_errors
select * from magic44_content_differences
order by query_id, step_id, row_hash;

-- Evaluate potential query errors against the original state and the modified state
drop view if exists magic44_result_errs_original;
create view magic44_result_errs_original as
select distinct 'row_count_errors_initial_state' as title, query_id
from magic44_row_count_errors where step_id = 0;

drop view if exists magic44_result_errs_modified;
create view magic44_result_errs_modified as
select distinct 'row_count_errors_modified_state' as title, query_id
from magic44_row_count_errors
where query_id not in (select query_id from magic44_result_errs_original)
union
select * from magic44_result_errs_original;

drop view if exists magic44_attribute_errs_original;
create view magic44_attribute_errs_original as
select distinct 'column_errors_initial_state' as title, query_id
from magic44_column_errors where step_id = 0
and query_id not in (select query_id from magic44_result_errs_modified)
union
select * from magic44_result_errs_modified;

drop view if exists magic44_attribute_errs_modified;
create view magic44_attribute_errs_modified as
select distinct 'column_errors_modified_state' as title, query_id
from magic44_column_errors
where query_id not in (select query_id from magic44_attribute_errs_original)
union
select * from magic44_attribute_errs_original;

drop view if exists magic44_correct_remainders;
create view magic44_correct_remainders as
select distinct 'fully_correct' as title, query_id
from magic44_test_results
where query_id not in (select query_id from magic44_attribute_errs_modified)
union
select * from magic44_attribute_errs_modified;

drop view if exists magic44_grading_rollups;
create view magic44_grading_rollups as
select title, count(*) as number_affected, group_concat(query_id order by query_id asc) as queries_affected
from magic44_correct_remainders
group by title;

drop table if exists magic44_autograding_results;
create table magic44_autograding_results (
	query_status varchar(1000),
    number_affected integer,
    queries_affected varchar(2000)
);

drop table if exists magic44_autograding_directory;
create table magic44_autograding_directory (query_status_category varchar(1000));
insert into magic44_autograding_directory values ('column_errors_initial_state'),
('column_errors_modified_state'), ('fully_correct'), ('row_count_errors_initial_state'),
('row_count_errors_modified_state');

insert into magic44_autograding_results
select query_status_category, number_affected, queries_affected
from magic44_autograding_directory left outer join magic44_grading_rollups
on query_status_category = title;

create or replace view magic44_autograding_quick_scoring as
select query_status, sum(number_affected * (case query_status when 'fully_correct' then 2
	when 'row_count_errors_initial_state' then 0.25 when 'row_count_errors_modified_state' then 0.5
    when 'column_errors_initial_state' then 0.33 when 'column_errors_modified_state' then 0.67 end)) as approx_score,
    number_affected, queries_affected
from magic44_autograding_results
group by query_status with rollup;

create view magic44_row_count_differences as
select *, if(count_initial = count_modified, "check", "") as repairs from
(select query_id, count(*) as count_initial
from magic44_test_results
where step_id = (select min(step_id) from magic44_test_results)
group by step_id, query_id) as results_initial
natural join
(select query_id, count(*) as count_modified
from magic44_test_results
where step_id = (select max(step_id) from magic44_test_results)
group by step_id, query_id) as results_modified;

-- Remove all unneeded tables, views, stored procedures and functions
-- Keep only those structures needed to provide student feedback
drop table if exists magic44_autograding_directory;
drop view if exists magic44_grading_rollups;
drop view if exists magic44_correct_remainders;
drop view if exists magic44_attribute_errs_modified;
drop view if exists magic44_attribute_errs_original;
drop view if exists magic44_result_errs_modified;
drop view if exists magic44_result_errs_original;
drop view if exists magic44_errors_assembled;
drop view if exists magic44_attribute_value_errors;
drop view if exists magic44_result_set_size_errors;
drop view if exists magic44_content_differences;
drop view if exists magic44_count_differences;
drop view if exists magic44_count_test_results;
drop view if exists magic44_count_answers;
drop procedure if exists magic44_evaluate_testing_steps;
drop procedure if exists magic44_evaluate_queries;
drop procedure if exists magic44_test_step_check_and_run;
drop procedure if exists magic44_query_check_and_run;
drop function if exists magic44_test_step_exists;
drop function if exists magic44_query_exists;
drop function if exists magic44_query_capture;
drop function if exists magic44_gen_simple_template;
drop table if exists magic44_column_listing;
drop table if exists magic44_data_capture;
