select perID, count(*), salary, truncate((salary / count(*)), 0) as perbank
from (select employee.perID, bankID, salary
from employee
join workfor
on employee.perID = workfor.perID) as temp
group by perID;

select * from bank;

select bankID, sum(perbank) as deduct
from (select temp3.perID, perbank, bankID
from (select perID, count(*), salary, truncate((salary / count(*)), 0) as perbank
from (select employee.perID, bankID, salary
from employee
join workfor
on employee.perID = workfor.perID) as temp
group by perID) as temp2, workfor as temp3) as temp4
group by bankID;

update bank set resAssets = resAssets -
(select sum(perbank) as deduct
from (select temp3.perID, perbank, bankID
from (select perID, count(*), salary, truncate((salary / count(*)), 0) as perbank
from (select employee.perID, bankID, salary
from employee
join workfor
on employee.perID = workfor.perID) as temp
group by perID) as temp2, workfor as temp3) as temp4
group by bankID)
where bank.bankID = bankID;





select checking_account.balance + overdraft_account.balance
				from (
					select protectionBank, protectionAccount, balance
					from bank_account natural join checking
					where bankID = "BA_West" and accountID = "checking_A"
				) as checking_account join bank_account as overdraft_account
				on checking_account.protectionBank = overdraft_account.bankID and checking_account.protectionAccount = overdraft_account.accountID;

select checking_account.balance as "checking_balance", protectionBank, protectionAccount
				from (
					select protectionBank, protectionAccount, balance
					from bank_account natural join checking
					where bankID = "BA_West" and accountID = "checking_A"
				) as checking_account join bank_account as overdraft_account
				on checking_account.protectionBank = overdraft_account.bankID and checking_account.protectionAccount = overdraft_account.accountID;

select balance from bank_account where accountID = "checking_A" and bankID = "WF_2";
select balance from bank_account where accountID = (select protectionAccount from checking where accountID = "checking_A" and bankID = "BA_West") and bankID = "BA_West";
