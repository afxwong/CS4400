select dno, min(salary), avg(salary), max(salary)
from employee
group by dno
having count(*) < 4;

select dno, count(*)
from employee
where salary > 25000 and dno not in (select dnumber from department where dname = "Headquarters")
group by dno;

select dno, count(*)
from employee
where salary > 25000 and dno in 
(select dno from employee group by dno having count(*) < 4)
group by dno;

select fname, lname, address
from employee
where ssn in 
(select essn from dependent where relationship = "Daughter");

select fname, lname, address
from employee
where ssn in 
(select essn from works_on where pno in 
(select pnumber from project where plocation = "Houston"));

select distinct ssn
from employee
where salary > 25000 and ssn not in 
(select essn from works_on where pno = 20);

select fname, lname, address, dno, dnumber, dname
from employee, department;

select fname, lname, address, dname, dno
from employee, department
where dno = dnumber;

select fname, lname, address, dname, dno
from employee
join department
on dno = dnumber;

select fname, lname, address, dname, dno from employee natural join
(select dname, dnumber as dno from department) as temp;

select worker.fname as work_fname, worker.lname as work_lname, worker.address, worker.superssn, supervisor.fname, supervisor.lname
from employee as worker
left join employee as supervisor
on worker.superssn = supervisor.ssn;

select dependent_name, dependent.bdate, fname, lname
from dependent
right join employee
on essn = ssn;

select fname, lname, dname, dnumber
from employee
left join department
on ssn = mgrssn;

select fname, lname, address, pname, plocation 
from employee 
join project
on locate(plocation,address) > 0;

select worker.fname, worker.lname, worker.bdate, supervisor.fname, supervisor.lname, supervisor.bdate
from employee as worker
join employee as supervisor
on worker.bdate < supervisor.bdate
where supervisor.ssn in (select mgrssn from department);

select bdate, address from employee where fname = "John" and lname = "Smith";

select fname, lname, address from employee where dno in (select dnumber from department where dname = "Research");

select pnumber, dnum, lname, address, bdate
from project, employee, department
where plocation = "Stafford" and mgrssn = ssn and dnum = dnumber;

select fname, lname from employee
where not exists (select pnumber from project where dnum = 5
and pnumber not in (select pno from works_on where ssn = essn));

select pno from works_on
where essn in (select ssn from employee where lname = "Smith") or
essn in (select mgrssn from department where mgrssn in (select ssn from employee where lname = "Smith"));

select fname, lname
from employee
where ssn in (select essn from dependent where essn = ssn group by essn having count(*) >= 2);

select fname, lname
from employee
where ssn not in (select essn from dependent);

select fname, lname
from employee
where ssn in (select mgrssn from department) and ssn in (select essn from dependent);

select emp.fname, emp.lname, sup.fname, sup.lname
from employee as emp
left join employee as sup
on emp.superssn = sup.ssn;

select ssn from employee;

select ssn, dname from employee, department;

select fname, lname from employee where address like "%Houston%";

select fname, lname, (salary + (salary * .1)) as salary
from employee
where ssn in (select essn from works_on, project where pno = pnumber and pname = 'ProductX')
union
select fname, lname, salary
from employee
where ssn not in (select essn from works_on, project where pno = pnumber and pname = 'ProductX');

select * from employee where salary between 30000 and 40000 and dno = 5;

select dname, lname, fname, pname
from department, employee, works_on, project
where dnumber = dno and ssn = essn and pno = pnumber
order by dname, lname, fname;

select fname, lname
from employee
where ssn in (select essn from dependent where dependent_name = fname and dependent.sex = employee.sex);

select ssn
from employee
where ssn in (select essn from works_on where pno between 0 and 4);

select fname, lname
from employee
where superssn is NULL;

select dnumber, count(ssn), avg(salary)
from department, employee
where dnumber = dno
group by dnumber;

select pnumber, pname, count(distinct essn)
from project
left join works_on
on pnumber = pno
group by pname, pnumber;

select pnumber, pname, count(distinct essn)
from project
left join works_on
on pnumber = pno
group by pname, pnumber
having count(distinct essn) > 2;

select pnumber, pname, count(distinct essn)
from project
left join (select essn, pno from works_on where essn in (select ssn from employee where dno = 5)) as temp
on pnumber = pno
group by pname, pnumber;

select dno, count(ssn)
from employee
where salary > 25000 and dno in (select dno from employee group by dno having count(*) < 4)
group by dno
having count(ssn) < 4;

select fname, lname
from employee
where dno = 5 and ssn in (select essn from works_on where hours > 10 and pno = (select pnumber from project where pname = "ProductX"));

select fname, lname 
from employee
where superssn = (select ssn from employee where fname = "Franklin" and lname = "Wong");

select fname, lname from employee where dno in
(select dno from employee group by dno having max(salary) >= (select max(salary) 
from employee));

select fname, lname
from employee
where superssn in (select ssn from employee where superssn = '888665555');

select fname, lname
from employee
where salary - 10000 > (select min(salary) from employee);
