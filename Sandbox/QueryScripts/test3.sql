select dno, min(salary), max(salary), avg(salary) from employee group by dno;

select min(salary) from employee;

select *
from employee
where salary = (select min(salary) from employee)
or salary = (select max(salary) from employee);

select * from department;
select ssn from employee
where ssn in (select mgrssn from department)
or salary > 40000;