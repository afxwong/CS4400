select * 
from employee, dependent
where ssn = essn;

select *
from employee
left outer join dependent
on ssn = essn;

select * 
from department
join dept_locations
on department.dnumber = dept_locations.dnumber;

select count(*) from employee join dept_locations on dno = dnumber;