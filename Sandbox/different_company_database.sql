-- CS4400: Introduction to Database Systems
-- Different Company Database (Clean WITH Primary and Foreign Keys)
-- Wednesday, December 23, 2020

-- This version of the database is intended to work with legacy versions of MySQL
-- It does include the tables and data, which are needed to practice the queries
-- It does not include the views, stored procedures and functions from other versions

-- This version of the database is renormalized and poorly structured by design to
-- demonstrate how a poor design impacts the ability to query the database 

DROP DATABASE IF EXISTS diff_company;
CREATE DATABASE IF NOT EXISTS diff_company;
USE diff_company;

--
-- Table structure for table employee
--

DROP TABLE IF EXISTS employee;
CREATE TABLE employee (
  fname char(10) NOT NULL,
  lname char(20) NOT NULL,
  ssn decimal(9,0) NOT NULL,
  bdate date NOT NULL,
  address char(30) NOT NULL,
  sex char(1) NOT NULL,
  salary decimal(5,0) NOT NULL,
  superssn decimal(9,0) DEFAULT NULL,
  dno decimal(1,0) NOT NULL,
  depname1 char(10) DEFAULT NULL,
  depsex1 char(1) DEFAULT NULL,
  deprelationship1 char(30) DEFAULT NULL,
  depbdate1 date DEFAULT NULL,
  depname2 char(10) DEFAULT NULL,
  depsex2 char(1) DEFAULT NULL,
  deprelationship2 char(30) DEFAULT NULL,
  depbdate2 date DEFAULT NULL,
  depname3 char(10) DEFAULT NULL,
  depsex3 char(1) DEFAULT NULL,
  deprelationship3 char(30) DEFAULT NULL,
  depbdate3 date DEFAULT NULL,
  depname4 char(10) DEFAULT NULL,
  depsex4 char(1) DEFAULT NULL,
  deprelationship4 char(30) DEFAULT NULL,
  depbdate4 date DEFAULT NULL,
  PRIMARY KEY (ssn),
  KEY dno (dno),
  KEY empemp (superssn)
) ENGINE=InnoDB;

--
-- Dumping data for table employee
--

INSERT INTO employee VALUES ('John','Smith',123456789,'1965-01-09','731 Fondren, Houston TX','M',30000,333445555,5,'Alice','F','Daughter','1988-12-30','Elizabeth','F','Spouse','1967-05-05','Michael','M','Son','1988-01-04',NULL,NULL,NULL,NULL),('Franklin','Wong',333445555,'1955-12-08','638 Voss, Dallas TX','M',40000,888665555,5,'Alice','F','Daughter','1986-04-04','Joy','F','Spouse','1958-05-03','Theodore','M','Son','1983-10-25',NULL,NULL,NULL,NULL),('Joyce','English',453453453,'1972-07-31','5631 Rice, Dallas TX','F',25000,333445555,5,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('Ramesh','Narayan',666884444,'1962-09-15','975 Fire Oak, Humble TX','M',38000,333445555,5,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('James','Borg',888665555,'1937-11-10','450 Stone, Houston TX','M',55000,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('Jennifer','Wallace',987654321,'1941-06-20','291 Berry, Bellaire TX','F',43000,888665555,4,'Abner','M','Spouse','1942-02-28',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('Ahmad','Jabbar',987987987,'1969-03-29','980 Dallas, Houston TX','M',25000,987654321,4,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('Alicia','Zelaya',999887777,'1968-01-19','3321 Castle, Spring TX','F',25000,987654321,4,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);

--
-- Table structure for table department
--

DROP TABLE IF EXISTS department;
CREATE TABLE department (
  dname char(20) NOT NULL,
  dnumber decimal(1,0) NOT NULL,
  mgrssn decimal(9,0) NOT NULL,
  mgrstartdate date NOT NULL,
  dlocations char(90) DEFAULT NULL,
  PRIMARY KEY (dnumber),
  UNIQUE KEY dname (dname),
  KEY depemp (mgrssn),
  CONSTRAINT depemp FOREIGN KEY (mgrssn) REFERENCES employee (ssn)
) ENGINE=InnoDB;

--
-- Dumping data for table department
--

INSERT INTO department VALUES ('Headquarters',1,888665555,'1981-06-19','Houston'),('Administration',4,987654321,'1995-01-01','Stafford'),('Research',5,333445555,'1988-05-22','Bellaire, Sugarland, Houston');

--
-- Table structure for table emp_dept
--

DROP TABLE IF EXISTS emp_dept;
CREATE TABLE emp_dept (
  ename varchar(32) DEFAULT NULL,
  ssn decimal(9,0) NOT NULL,
  bdate date NOT NULL,
  address char(30) NOT NULL,
  dnumber decimal(1,0) NOT NULL,
  dname char(20) NOT NULL,
  dmgr_ssn decimal(9,0) NOT NULL
) ENGINE=InnoDB;

--
-- Dumping data for table emp_dept
--

INSERT INTO emp_dept VALUES ('James Borg',888665555,'1937-11-10','450 Stone, Houston TX',1,'Headquarters',888665555),('Jennifer Wallace',987654321,'1941-06-20','291 Berry, Bellaire TX',4,'Administration',987654321),('Ahmad Jabbar',987987987,'1969-03-29','980 Dallas, Houston TX',4,'Administration',987654321),('Alicia Zelaya',999887777,'1968-01-19','3321 Castle, Spring TX',4,'Administration',987654321),('John Smith',123456789,'1965-01-09','731 Fondren, Houston TX',5,'Research',333445555),('Franklin Wong',333445555,'1965-12-08','638 Voss, Houston TX',5,'Research',333445555),('Joyce English',453453453,'1972-07-31','5631 Rice, Houston TX',5,'Research',333445555),('Ramesh Narayan',666884444,'1962-09-15','975 Fire Oak, Humble TX',5,'Research',333445555);

--
-- Table structure for table emp_proj
--

DROP TABLE IF EXISTS emp_proj;
CREATE TABLE emp_proj (
  ssn decimal(9,0) NOT NULL,
  pnumber decimal(2,0) NOT NULL,
  hours decimal(5,1) DEFAULT NULL,
  ename varchar(32) DEFAULT NULL,
  pname char(20) NOT NULL,
  plocation char(20) NOT NULL
) ENGINE=InnoDB;

--
-- Dumping data for table emp_proj
--

INSERT INTO emp_proj VALUES (123456789,1,32.5,'Smith, John','ProductX','Bellaire'),(453453453,1,20.0,'English, Joyce','ProductX','Bellaire'),(123456789,2,7.5,'Smith, John','ProductY','Sugarland'),(333445555,2,10.0,'Wong, Franklin','ProductY','Sugarland'),(453453453,2,20.0,'English, Joyce','ProductY','Sugarland'),(333445555,3,10.0,'Wong, Franklin','ProductZ','Houston'),(666884444,3,40.0,'Narayan, Ramesh','ProductZ','Houston'),(987987987,10,35.0,'Jabbar, Ahmad','Computerization','Stafford'),(999887777,10,10.0,'Zelaya, Alicia','Computerization','Stafford'),(888665555,20,NULL,'Borg, James','Reorganization','Houston'),(987654321,30,20.0,'Wallace, Jennifer','Newbenefits','Stafford'),(987987987,30,5.0,'Jabbar, Ahmad','Newbenefits','Stafford'),(999887777,30,30.0,'Zelaya, Alicia','Newbenefits','Stafford');

--
-- Table structure for table project
--

DROP TABLE IF EXISTS project;
CREATE TABLE project (
  pname char(20) NOT NULL,
  pnumber decimal(2,0) NOT NULL,
  plocation char(20) NOT NULL,
  dnum decimal(1,0) NOT NULL,
  PRIMARY KEY (pnumber),
  UNIQUE KEY pname (pname),
  KEY dnum (dnum),
  CONSTRAINT project_ibfk_1 FOREIGN KEY (dnum) REFERENCES department (dnumber)
) ENGINE=InnoDB;

--
-- Dumping data for table project
--

INSERT INTO project VALUES ('ProductX',1,'Bellaire',5),('ProductY',2,'Sugarland',5),('ProductZ',3,'Houston',5),('Computerization',10,'Stafford',4),('Reorganization',20,'Houston',1),('Newbenefits',30,'Stafford',4);

ALTER TABLE employee ADD CONSTRAINT empemp FOREIGN KEY (superssn) REFERENCES employee (ssn);
ALTER TABLE employee ADD CONSTRAINT employee_ibfk_1 FOREIGN KEY (dno) REFERENCES department (dnumber);
