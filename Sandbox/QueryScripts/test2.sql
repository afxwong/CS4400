select concat(fname, " ", lname) as "Whole Name", address from employee;
select fname, lname, address, bdate from employee where bdate > "1968-1-1";