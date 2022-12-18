-- CS4400: Introduction to Database Systems (Spring 2022)
-- Phase II: Create Table & Insert Statements [v0] Monday, February 21, 2022 @ 11:00pm EDT

-- Team 91
-- Anthony Wong (awong307)
-- Austin Chemelli (achemelli3)
-- Tanay Sonthalia (tsonthalia3)
-- Harry Zhu (hzhu378)

-- Directions:
-- Please follow all instructions for Phase II as listed on Canvas.
-- Fill in the team number and names and GT usernames for all members above.
-- Create Table statements must be manually written, NOT taken from an SQL Dump file.
-- The file must run without error to receive any credit.

-- Recommendations:
-- You may arrange your create table() and insert() statements in any order.
-- Develop a "strategy" to determine the order in which you will implement the tables.
-- Then, implement each table, and ensure that you can load the data correctly before
-- beginning work on the next table.

-- ------------------------------------------------------
-- CREATE TABLE STATEMENTS AND INSERT STATEMENTS BELOW
-- ------------------------------------------------------

DROP DATABASE IF EXISTS CS4400BMS;
CREATE DATABASE IF NOT EXISTS CS4400BMS;
USE CS4400BMS;

DROP TABLE IF EXISTS person;
CREATE TABLE person (
	person_id char(15) NOT NULL,
	pass char(15) NOT NULL,
    PRIMARY KEY (person_id)
) ENGINE=InnoDB;

INSERT INTO person VALUES 
('mmoss7', 'password1'),
('tmcgee1', 'password2'),
('dscully5', 'password3'),
('fmulder8', 'password4'),
('arwhite6', 'password5'),
('ealfaro4', 'password6'),
('mmcgill4', 'password7'),
('sville19', 'password8'),
('rnairn5', 'password9'),
('smcgill17', 'password10'),
('tjtalbot4', 'password11'),
('owalter6', 'password12'),
('rsanchez', 'password13'),
('msmith', 'password14'),
('lgibbs4', 'password15'),
('ghopper9', 'password16'),
('asantiago99', 'password17'),
('rholt99', 'password18'),
('jperalta99', 'password19'),
('glinetti99', 'password20'),
('cboyle99', 'password21'),
('rdiaz99', 'password22'),
('atrebek1', 'password23'),
('kjennings66', 'password24'),
('gburdell', 'password25'),
('pbeesly17', 'password26'),
('beyonce', 'password27');

DROP TABLE IF EXISTS user_;
CREATE TABLE user_ (
	person_id char(15) NOT NULL,
	tax_id char(11) NOT NULL,
    first_name char(15),
    last_name char(15),
    birthdate date,
    street char(50),
    city char(15),
    state char(2),
    zip decimal(5, 0),
    date_joined date,
    UNIQUE(tax_id),
    PRIMARY KEY (person_id),
    CONSTRAINT fk1 FOREIGN KEY (person_id) REFERENCES person (person_id)
) ENGINE=InnoDB;

INSERT INTO user_ VALUES
('arwhite6', '053-87-1120', 'Amelia-Rose', 'Whitehead', '1960-06-06', '60 Nightshade Court', 'Baltimore', 'MD', '21217', '2021-12-03'),
('ealfaro4', '278-78-7676', 'Evie', 'Alfaro', '1960-06-06', '314 Five Fingers Way', 'Atlanta', 'GA', '30301', '2021-12-27'),
('mmcgill4', '623-09-0887', 'Maheen', 'McGill', '1955-06-23', '741 Pan American Trace', 'East Cobb', 'GA', '30304', '2020-09-08'),
('sville19', '354-10-6263', 'Sahar', 'Villegas', '1965-03-16', '10 Downing Road', 'East Cobb', 'GA', '30304', '2020-06-16'),
('rnairn5', '404-51-1036', 'Roxanne', 'Nairn', '1959-07-13', '2048 Transparency Road', 'Atlanta', 'GA', '30301', '2021-08-16'),
('smcgill17', '238-40-5070', 'Saqlain', 'McGill', '1954-06-02', '741 Pan American Trace', 'East Cobb', 'GA', '30304', '2020-09-11'),
('tjtalbot4', '203-46-3005', 'TJ', 'Talbot', '1978-05-10', '101 Snoopy Woodstock Circle', 'Salt Lake City', 'UT', '84108', '2020-03-25'),
('owalter6', '346-51-9139', 'Om', 'Walter', '1971-10-23', '143 Snoopy Woodstock Circle', 'Salt Lake City', 'UT', '84108', '2020-04-29'),
('rsanchez', '012-34-5678', 'Rick', 'Sanchez', '1936-08-22', '137 Puget Run', 'Seattle', 'WA', '98420', NULL),
('msmith', '246-80-1234', 'Morty', 'Smith', '1999-04-04', '137 Puget Run', 'Seattle', 'WA', '98420', '2017-08-21'),
('lgibbs4', '304-39-1098', 'Leroy', 'Gibbs', '1954-11-21', '50 Mountain Spur', 'Stillwater', 'PA', '17878', '2021-06-16'),
('ghopper9', '101-00-1111', 'Grace', 'Hopper', '1906-12-09', '1 Broadway', 'New York', 'NY', '10004', '2019-12-25'),
('asantiago99', '765-43-2109', 'Amy', 'Santiago', '1983-07-04', '1477 Park Avenue Apt. 82', 'New York', 'NY', '11217', '2018-03-09'),
('rholt99', '111-22-3333', 'Raymond', 'Holt', '1955-01-01', '123 Main Street', 'Perth Amboy', 'NJ', '08861', '2022-01-01'),
('jperalta99', '775-33-6054', 'Jake', 'Peralta', '1981-09-04', '1477 Park Avenue Apt. 82', 'New York', 'NY', '11217', '2018-03-09'),
('glinetti99', '233-76-0019', 'Gina', 'Linetti', '1986-03-20', '75 Allure Drive', 'New York', 'NY', '11220', '2019-04-04'),
('cboyle99', '433-12-1200', 'Charles', 'Boyle', '1982-09-04', '1477 Park Avenue Apt. 65', 'New York', 'NY', '11217', '2018-03-10'),
('rdiaz99', '687-54-1033', 'Rosa', 'Diaz', '1984-11-30', '3 East Park Loop', 'Yonkers', 'NY', '10112', '2020-12-24'),
('atrebek1', '000-00-0000', 'Alex', 'Trebek', '1940-07-22', '10202 West Washington Boulevard', 'Culver City', 'CA', '90232', '2014-03-22'),
('kjennings66', '004-52-2700', 'Ken', 'Jennings', '1974-05-23', '74 Champions Heights', 'Edmonds', 'WA', '98020', '2005-09-07'),
('gburdell', '404-00-0000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('pbeesly17', '664-98-7654', 'Pam', 'Beesly', NULL, NULL, NULL, NULL, NULL, '2021-06-06'),
('beyonce', '444-55-6666', 'Beyonce', NULL, '1981-09-04', '222 Star Grove', 'Houston', 'TX', '77077', '2014-02-02');

DROP TABLE IF EXISTS admin_;
CREATE TABLE admin_ (
	person_id char(15) NOT NULL,
    PRIMARY KEY (person_id),
    CONSTRAINT fk2 FOREIGN KEY (person_id) REFERENCES person (person_id)
) ENGINE=InnoDB;

INSERT INTO admin_ VALUES
('mmoss7'),
('tmcgee1'),
('dscully5'),
('fmulder8');

DROP TABLE IF EXISTS employee;
CREATE TABLE employee (
	employee_id char(15) NOT NULL,
    salary decimal(6, 0),
    tot_earned decimal(8, 0),
    num_payments decimal(3, 0),
    PRIMARY KEY (employee_id),
    CONSTRAINT fk3 FOREIGN KEY (employee_id) REFERENCES user_ (person_id)
) ENGINE=InnoDB;

INSERT INTO employee VALUES
('arwhite6', '4700', '28200', '6'),
('ealfaro4', '5600', '17100', '3'),
('mmcgill4', '9400', '29100', '3'),
('sville19', '8000', '35000', '4'),
('rnairn5', '5100', '27400', '5'),
('smcgill17', '8800', '33700', '3'),
('rsanchez', '49500', '654321', '10'),
('lgibbs4', NULL, NULL, NULL),
('ghopper9', '49500', '447999', '5'),
('rholt99', NULL, NULL, NULL),
('jperalta99', '5400', '5900', '3'),
('glinetti99', NULL, NULL, NULL),
('cboyle99', NULL, '1200', NULL),
('kjennings66', '2000', '43000', '9'),
('gburdell', NULL, NULL, NULL),
('pbeesly17', '8400', '14000', '2'),
('beyonce', '9800', '320985', '6');

DROP TABLE IF EXISTS customer;
CREATE TABLE customer (
	customer_id char(15) NOT NULL,
    PRIMARY KEY (customer_id),
    CONSTRAINT fk4 FOREIGN KEY (customer_id) REFERENCES user_ (person_id)
) ENGINE=InnoDB;

INSERT INTO customer VALUES
('arwhite6'),
('tjtalbot4'),
('owalter6'),
('rsanchez'),
('msmith'),
('asantiago99'),
('rholt99'),
('glinetti99'),
('cboyle99'),
('rdiaz99'),
('atrebek1'),
('kjennings66'),
('pbeesly17');

DROP TABLE IF EXISTS customer_contact;
CREATE TABLE customer_contact (
	customer_id char(15) NOT NULL,
    contact_type char(10) NOT NULL,
    contact_address char(30) NOT NULL,
    PRIMARY KEY (customer_id, contact_type, contact_address),
    CONSTRAINT fk5 FOREIGN KEY (customer_id) REFERENCES customer (customer_id)
) ENGINE=InnoDB;

INSERT INTO customer_contact VALUES
('arwhite6', 'mobile', '333-182-9303'),
('arwhite6', 'email', 'amelia_whitehead@me.com'),
('tjtalbot4', 'mobile', '845-101-2760'),
('tjtalbot4', 'home', '236-464-1023'),
('tjtalbot4', 'email', 'tj_forever@aol.com'),
('owalter6', 'home', '370-186-5341'),
('rsanchez', 'phone', '000-098-7654'),
('msmith', 'email', 'morty@rm.com'),
('asantiago99', 'email', 'asantiago99@nypd.org'),
('asantiago99', 'fax', '334-444-1234 x276'),
('pbeesly17', 'email', 'pb@dunder.com'),
('pbeesly17', 'email', 'jh@dunder.com'),
('msmith', 'phone', '000-098-7654');

DROP TABLE IF EXISTS corporation;
CREATE TABLE corporation (
	corporation_id char(5) NOT NULL,
    short_name char(15) NOT NULL,
    long_name char(50) NOT NULL,
    reserved_assets decimal(10, 0),
    UNIQUE(short_name),
    UNIQUE(long_name),
    PRIMARY KEY (corporation_id)
) ENGINE=InnoDB;

INSERT INTO corporation VALUES
('WF', 'Wells Fargo', 'Wells Fargo Bank National Association', '33000000'),
('BA', 'Bank of America', 'Bank of America Corporation', '51000000'),
('ST', 'Sun Trust', 'Sun Trust Banks/Truist Financial Corporation', '39000000'),
('NASA', 'NASA FCU', 'NASA Federal Credit Union', '11000000'),
('TD', 'TD Ameritrade', 'TD Ameritrade Holding Corporation', '0'),
('GS', 'Goldman Sachs', 'Goldman Sachs Group, Inc.', NULL);

DROP TABLE IF EXISTS bank;
CREATE TABLE bank (
	bank_id char(15) NOT NULL,
    bank_name char(50),
    street char(50),
    city char(15),
    state char(2),
    zip decimal(5, 0),
	reserved_assets decimal(10, 0),
    manager char(15) NOT NULL,
    corporation_id char(5) NOT NULL,
    UNIQUE(street, city, state, zip),
    UNIQUE(manager),
    PRIMARY KEY (bank_id),
    CONSTRAINT fk6 FOREIGN KEY (manager) REFERENCES employee (employee_id),
    CONSTRAINT fk7 FOREIGN KEY (corporation_id) REFERENCES corporation (corporation_id)
) ENGINE=InnoDB;

INSERT INTO bank VALUES
('WF_1', 'Wells Fargo #1 Bank', '1010 Binary Way', 'Seattle', 'WA', '98101', '127000', 'sville19', 'WF'),
('WF_2', 'Wells Fargo #2 Bank', '337 Firefly Lane', 'Seattle', 'WA', '98101', '553000', 'mmcgill4', 'WF'),
('BA_West', 'Bank of America West Region Bank', '865 Black Gold Circle', 'Dallas', 'TX', '75116', '267000', 'smcgill17', 'BA'),
('NASA_Goddard', 'NASA FCU at Goddard SFC', '8800 Greenbelt Road', 'Greenbelt', 'MD', '20771', '140000', 'rsanchez', 'NASA'),
('TD_Online', NULL, NULL, NULL, NULL, NULL, '0', 'kjennings66', 'TD'),
('TD_GT', 'TD Ameritrade Midtown Branch', '47 Tech Parkway', 'Atlanta', 'GA', '30333', NULL, 'gburdell', 'TD'),
('NASA_KSC', 'NASA FCU at Kennedy Space Center', '1 Space Commerce Way', 'Cape Canaveral', 'FL', '45678', '0', 'rholt99', 'NASA'),
('BA_South', 'Bank of America Plaza-Midtown', '600 Peachtree Street NE', 'Atlanta', 'GA', '30333', '42000', 'ghopper9', 'BA'),
('NASA_HAL', 'NASA FCU at US Space & Rocket Center', '1 Tranquility Base Suite 203', 'Huntsville', 'AL', '35805', NULL, 'pbeesly17', 'NASA');

DROP TABLE IF EXISTS account_;
CREATE TABLE account_ (
	bank_id char(15) NOT NULL,
    account_id char(20) NOT NULL,
    balance decimal(8, 0),
    PRIMARY KEY (bank_id, account_id),
    CONSTRAINT fk8 FOREIGN KEY (bank_id) REFERENCES bank (bank_id)
) ENGINE=InnoDB;

INSERT INTO account_ VALUES
('WF_2', 'checking_A', '2700'),
('BA_West', 'checking_A', '1000'),
('NASA_Goddard', 'company_checking', NULL),
('NASA_KSC', 'company_checking', '150000'),
('TD_Online', 'company_checking', '0'),
('WF_2', 'market_X', '27000'),
('TD_Online', 'Roth_IRA', '167000'),
('TD_GT', 'Roth_IRA', '15000'),
('BA_South', 'GT_investments', '16000'),
('WF_2', 'savings_A', '19400'),
('BA_West', 'savings_B', '8000'),
('NASA_Goddard', 'company_savings', '1000000'),
('TD_GT', 'savings_A', '8500'),
('BA_South', 'GT_savings', '9999');

DROP TABLE IF EXISTS interest_bearing;
CREATE TABLE interest_bearing (
	bank_id char(15) NOT NULL,
    account_id char(20) NOT NULL,
    interest_rate decimal(2, 0),
    last_deposit date,
    PRIMARY KEY (bank_id, account_id),
    CONSTRAINT fk9 FOREIGN KEY (bank_id, account_id) REFERENCES account_ (bank_id, account_id)
) ENGINE=InnoDB;

INSERT INTO interest_bearing VALUES
('WF_2', 'market_X', '20', '2021-12-23'),
('TD_Online', 'Roth_IRA', '12', '2022-01-03'),
('TD_GT', 'Roth_IRA', '8', '2021-01-01'),
('BA_South', 'GT_investments', '4', '2020-03-11'),
('WF_2', 'savings_A', '10', '2021-11-05'),
('BA_West', 'savings_B', '6', '2021-09-01'),
('NASA_Goddard', 'company_savings', NULL, NULL),
('TD_GT', 'savings_A', NULL, NULL),
('BA_South', 'GT_savings', '2', NULL);

DROP TABLE IF EXISTS interest_bearing_fees;
CREATE TABLE interest_bearing_fees (
	bank_id char(15) NOT NULL,
	account_id char(20) NOT NULL,
    fee char(15) NOT NULL,
    PRIMARY KEY (bank_id, account_id, fee),
	CONSTRAINT fk10 FOREIGN KEY (bank_id, account_id) REFERENCES interest_bearing (bank_id, account_id)
) ENGINE=InnoDB;

INSERT INTO interest_bearing_fees VALUES
('WF_2', 'savings_A', 'low balance'),
('BA_West', 'savings_B', 'low balance'),
('BA_West', 'savings_B', 'overdraft'),
('WF_2', 'market_X', 'administrative'),
('WF_2', 'market_X', 'frequency'),
('WF_2', 'market_X', 'fee'),
('TD_Online', 'Roth_IRA', 'low balance'),
('TD_Online', 'Roth_IRA', 'withdrawal'),
('NASA_Goddard', 'company_savings', 'credit union'),
('BA_South', 'GT_investments', 'withdrawal');

DROP TABLE IF EXISTS checking;
CREATE TABLE checking (
	bank_id char(15) NOT NULL,
    account_id char(20) NOT NULL,
    PRIMARY KEY (bank_id, account_id),
    CONSTRAINT fk11 FOREIGN KEY (bank_id, account_id) REFERENCES account_ (bank_id, account_id)
) ENGINE=InnoDB;

INSERT INTO checking VALUES
('WF_2', 'checking_A'),
('BA_West', 'checking_A'),
('NASA_Goddard', 'company_checking'),
('NASA_KSC', 'company_checking'),
('TD_Online', 'company_checking');

DROP TABLE IF EXISTS savings;
CREATE TABLE savings (
	bank_id char(15) NOT NULL,
	account_id char(20) NOT NULL,
	min_balance decimal(8, 0),
    overdraft_bank char(15),
    overdraft_account char(20),
    overdraft_date date,
    overdraft_amount decimal(8, 0),
    UNIQUE(overdraft_bank, overdraft_account),
    PRIMARY KEY (bank_id, account_id),
    CONSTRAINT fk12 FOREIGN KEY (bank_id, account_id) REFERENCES interest_bearing (bank_id, account_id),
    CONSTRAINT fk13 FOREIGN KEY (overdraft_bank, overdraft_account) REFERENCES checking (bank_id, account_id)
) ENGINE=InnoDB;

INSERT INTO savings VALUES
('WF_2', 'savings_A', '15000', NULL, NULL, NULL, NULL),
('BA_West', 'savings_B', '10000', 'BA_West', 'checking_A', '2021-12-08', '600'),
('NASA_Goddard', 'company_savings', NULL, 'NASA_KSC', 'company_checking', NULL, NULL),
('TD_GT', 'savings_A', '0', NULL, NULL, NULL, NULL),
('BA_South', 'GT_savings', '2000', 'TD_Online', 'company_checking', '2020-08-07', '1');

DROP TABLE IF EXISTS market;
CREATE TABLE market (
	bank_id char(15) NOT NULL,
	account_id char(20) NOT NULL,
    max_withdrawl decimal(8, 0),
    num_withdrawals decimal(6, 0),
    PRIMARY KEY (bank_id, account_id),
    CONSTRAINT fk14 FOREIGN KEY (bank_id, account_id) REFERENCES interest_bearing (bank_id, account_id)
) ENGINE=InnoDB;

INSERT INTO market VALUES
('WF_2', 'market_X', '2', '1'),
('TD_Online', 'Roth_IRA', '0', '0'),
('TD_GT', 'Roth_IRA', NULL, NULL),
('BA_South', 'GT_investments', '10', '5');

DROP TABLE IF EXISTS customer_own_account;
CREATE TABLE customer_own_account (
	customer_id char(15) NOT NULL,
	bank_id char(15) NOT NULL,
	account_id char(20) NOT NULL,
    joined_date date NOT NULL,
    last_transaction date,
    PRIMARY KEY (customer_id, bank_id, account_id),
    CONSTRAINT fk15 FOREIGN KEY (customer_id) REFERENCES customer (customer_id),
    CONSTRAINT fk16 FOREIGN KEY (bank_id, account_id) REFERENCES account_ (bank_id, account_id)
) ENGINE=InnoDB;

INSERT INTO customer_own_account VALUES
('arwhite6', 'WF_2', 'checking_A', '2021-08-10', '2022-01-26'),
('arwhite6', 'WF_2', 'savings_A', '2021-08-10', '2021-11-11'),
('tjtalbot4', 'WF_2', 'savings_A', '2021-08-17', '2022-02-03'),
('owalter6', 'BA_West', 'checking_A', '2020-09-02', NULL),
('owalter6', 'BA_West', 'savings_B', '2020-09-02', NULL),
('msmith', 'NASA_Goddard', 'company_checking', '2018-10-11', NULL),
('rsanchez', 'NASA_Goddard', 'company_checking', '2018-10-10', '2022-02-04'),
('rsanchez', 'NASA_KSC', 'company_checking', '2018-10-10', '2022-01-13'),
('tjtalbot4', 'TD_Online', 'company_checking', '2020-12-07', '2020-12-07'),
('rholt99', 'WF_2', 'market_X', '2022-02-02', '2020-02-04'),
('asantiago99', 'WF_2', 'market_X', '2020-02-02', '2020-02-04'),
('cboyle99', 'TD_Online', 'Roth_IRA', '2021-09-26', NULL),
('glinetti99', 'TD_Online', 'Roth_IRA', '2019-12-24', NULL),
('msmith', 'TD_GT', 'Roth_IRA', '2021-01-01', '2022-01-01'),
('kjennings66', 'BA_South', 'GT_investments', '2009-08-09', NULL),
('rsanchez', 'NASA_Goddard', 'company_savings', '2014-08-16', NULL),
('pbeesly17', 'TD_GT', 'savings_A', '2021-09-09', NULL),
('atrebek1', 'BA_South', 'GT_savings', '2015-12-31', '2017-03-22'),
('kjennings66', 'BA_South', 'GT_savings', '2010-08-09', '2022-02-21');

DROP TABLE IF EXISTS works_for;
CREATE TABLE works_for (
	bank_id char(15) NOT NULL,
	employee_id char(15) NOT NULL,
    PRIMARY KEY (bank_id, employee_id),
    CONSTRAINT fk17 FOREIGN KEY (bank_id) REFERENCES bank (bank_id),
    CONSTRAINT fk18 FOREIGN KEY (employee_id) REFERENCES employee (employee_id)
) ENGINE=InnoDB;

INSERT INTO works_for VALUES
('WF_2', 'arwhite6'),
('WF_1', 'ealfaro4'),
('WF_2', 'ealfaro4'),
('BA_West', 'rnairn5'),
('BA_South', 'beyonce'),
('NASA_Goddard', 'beyonce'),
('TD_Online', 'beyonce'),
('TD_GT', 'jperalta99'),
('TD_GT', 'cboyle99'),
('NASA_KSC', 'jperalta99'),
('NASA_KSC', 'cboyle99'),
('NASA_HAL', 'jperalta99'),
('BA_West', 'glinetti99'),
('TD_Online', 'glinetti99');
