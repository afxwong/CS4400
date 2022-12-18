-- CS4400: Introduction to Database Systems
-- Bank Management Project - Phase 3 (v2)
-- Generating Stored Procedures & Functions for the Use Cases
-- April 4th, 2022

-- implement these functions and stored procedures on the project database
use bank_management;
 
drop procedure if exists create_corporation;
delimiter //
create procedure create_corporation (in ip_corpID varchar(100),
    in ip_shortName varchar(100), in ip_longName varchar(100),
    in ip_resAssets integer)
begin
	-- Implement your code here
    insert into corporation values (ip_corpID, ip_shortName, ip_longName, ip_resAssets);
end //
delimiter ;

-- [2] create_bank()
-- This stored procedure creates a new bank that is owned by an existing corporation
-- The corporation must also be managed by a valid employee [being a manager doesn't leave enough time for other jobs]
drop procedure if exists create_bank;
delimiter //
create procedure create_bank (in ip_bankID varchar(100), in ip_bankName varchar(100),
	in ip_street varchar(100), in ip_city varchar(100), in ip_state char(2),
    in ip_zip char(5), in ip_resAssets integer, in ip_corpID varchar(100),
    in ip_manager varchar(100), in ip_bank_employee varchar(100))
begin
	-- Implement your code here
    if (
		(ip_bank_employee in (select perID from employee)) and
        (ip_bank_employee not in (select manager from bank)) and
        (ip_manager not in (select perID from workFor)) and
        (ip_manager not in (select manager from bank))
	) then
		insert into bank values (ip_bankID, ip_bankName, ip_street, ip_city, ip_state, ip_zip, ip_resAssets, ip_corpID, ip_manager);
		insert into workFor values (ip_bankID, ip_bank_employee);
    end if;
end //
delimiter ;

-- [3] start_employee_role()
-- If the person exists as an admin or employee then don't change the database state [not allowed to be admin along with any other person-based role]
-- If the person doesn't exist then this stored procedure creates a new employee
-- If the person exists as a customer then the employee data is added to create the joint customer-employee role
drop procedure if exists start_employee_role;
delimiter //
create procedure start_employee_role (in ip_perID varchar(100), in ip_taxID char(11),
	in ip_firstName varchar(100), in ip_lastName varchar(100), in ip_birthdate date,
    in ip_street varchar(100), in ip_city varchar(100), in ip_state char(2),
    in ip_zip char(5), in ip_dtJoined date, in ip_salary integer,
    in ip_payments integer, in ip_earned integer, in emp_password  varchar(100))
begin
	-- Implement your code here
    if ((ip_perID not in (select perID from employee)) and ip_perID not in (select perID from system_admin)) then
		if (ip_perID not in (select perID from customer)) then
			insert into person values (ip_perID, emp_password);
			insert into bank_user values (ip_perID, ip_taxID, ip_birthdate, ip_firstName, ip_lastName, ip_dtJoined, ip_street, ip_city, ip_state, ip_zip);
		end if;
        insert into employee values (ip_perID, ip_salary, ip_payments, ip_earned);
	end if;
end //
delimiter ;

-- [4] start_customer_role()
-- If the person exists as an admin or customer then don't change the database state [not allowed to be admin along with any other person-based role]
-- If the person doesn't exist then this stored procedure creates a new customer
-- If the person exists as an employee then the customer data is added to create the joint customer-employee role
drop procedure if exists start_customer_role;
delimiter //
create procedure start_customer_role (in ip_perID varchar(100), in ip_taxID char(11),
	in ip_firstName varchar(100), in ip_lastName varchar(100), in ip_birthdate date,
    in ip_street varchar(100), in ip_city varchar(100), in ip_state char(2),
    in ip_zip char(5), in ip_dtJoined date, in cust_password varchar(100))
begin
	-- Implement your code here
    if ((ip_perID not in (select perID from employee)) and ip_perID not in (select perID from system_admin)) then
		if (ip_perID not in (select perID from employee)) then
			insert into person values (ip_perID, cust_password);
			insert into bank_user values (ip_perID, ip_taxID, ip_birthdate, ip_firstName, ip_lastName, ip_dtJoined, ip_street, ip_city, ip_state, ip_zip);
		end if;
        insert into customer values (ip_perID);
    end if;
end //
delimiter ;

-- [5] stop_employee_role()
-- If the person doesn't exist as an employee then don't change the database state
-- If the employee manages a bank or is the last employee at a bank then don't change the database state [each bank must have a manager and at least one employee]
-- If the person exists in the joint customer-employee role then the employee data must be removed, but the customer information must be maintained
-- If the person exists only as an employee then all related person data must be removed
drop procedure if exists stop_employee_role;
delimiter //
create procedure stop_employee_role (in ip_perID varchar(100))
begin
	-- Implement your code here
    -- TODO: make sure count of employees is above 1
    if (
		(ip_perID in (select perID from employee)) and 
		(ip_perID not in (select manager from bank)) and 
		(1 not in (select count(*) from workFor where bankID in (select bankID from workFor where perID = ip_perID) group by bankID))
    ) then
		delete from workFor where perID = ip_perID;
        delete from employee where perID = ip_perID;
        if (ip_perID not in (select perID from customer)) then
			delete from bank_user where perID = ip_perID;
            delete from person where perID = ip_perID;
        end if;
    end if;
end //
delimiter ;

-- [6] stop_customer_role()
-- If the person doesn't exist as an customer then don't change the database state
-- If the customer is the only holder of an account then don't change the database state [each account must have at least one holder]
-- If the person exists in the joint customer-employee role then the customer data must be removed, but the employee information must be maintained
-- If the person exists only as a customer then all related person data must be removed
drop procedure if exists stop_customer_role;
delimiter //
create procedure stop_customer_role (in ip_perID varchar(100))
begin
	-- Implement your code here
    -- TODO: check that not the only holder of an account
    if (
		(ip_perID in (select perID from customer)) and 
		(1 not in (select count(*) from access where accountID in (select accountID from access where perID = ip_perID) group by accountID))
    ) then
		delete from access where perID = ip_perID;
        delete from customer_contacts where perID = ip_perID;
		delete from customer where perID = ip_perID;
        if (ip_perID not in (select perID from employee)) then
			delete from bank_user where perID = ip_perID;
            delete from person where perID = ip_perID;
        end if;
    end if;
end //
delimiter ;

-- [7] hire_worker()
-- If the person is not an employee then don't change the database state
-- If the worker is a manager then then don't change the database state [being a manager doesn't leave enough time for other jobs]
-- Otherwise, the person will now work at the assigned bank in addition to any other previous work assignments
-- Also, adjust the employee's salary appropriately
drop procedure if exists hire_worker;
delimiter //
create procedure hire_worker (in ip_perID varchar(100), in ip_bankID varchar(100),
	in ip_salary integer)
begin
	-- Implement your code here
    if ((ip_perID in (select perID from employee)) and (ip_perID not in (select manager from bank))) then
		insert into workFor values (ip_bankID, ip_perID);
        update employee set salary = ip_salary where perID = ip_perID;
    end if;
end //
delimiter ;

-- [8] replace_manager()
-- If the new person is not an employee then don't change the database state
-- If the new person is a manager or worker at any bank then don't change the database state [being a manager doesn't leave enough time for other jobs]
-- Otherwise, replace the previous manager at that bank with the new person
-- The previous manager's association as manager of that bank must be removed
-- Adjust the employee's salary appropriately
drop procedure if exists replace_manager;
delimiter //
create procedure replace_manager (in ip_perID varchar(100), in ip_bankID varchar(100),
	in ip_salary integer)
begin
	-- Implement your code here
    if ((ip_perID in (select perID from employee)) and (ip_perID not in (select manager from bank)) and (ip_perID not in (select perID from workFor))) then
		update bank set manager = ip_perID where bankID = ip_bankID;
        update employee set salary = ip_salary where perID = ip_perID;
    end if;
end //
delimiter ;

-- [9] add_account_access()
-- If the account does not exist, create a new account. If the account exists, add the customer to the account
-- When creating a new account:
    -- If the person opening the account is not an admin then don't change the database state
    -- If the intended customer (i.e. ip_customer) is not a customer then don't change the database state
    -- Otherwise, create a new account owned by the designated customer
    -- The account type will be determined by the enumerated ip_account_type variable
    -- ip_account_type in {checking, savings, market}
-- When adding a customer to an account:
    -- If the person granting access is not an admin or someone with access to the account then don't change the database state
    -- If the intended customer (i.e. ip_customer) is not a customer then don't change the database state
    -- Otherwise, add the new customer to the existing account
drop procedure if exists add_account_access;
delimiter //
create procedure add_account_access (in ip_requester varchar(100), in ip_customer varchar(100),
	in ip_account_type varchar(10), in ip_bankID varchar(100),
    in ip_accountID varchar(100), in ip_balance integer, in ip_interest_rate integer,
    in ip_dtDeposit date, in ip_minBalance integer, in ip_numWithdrawals integer,
    in ip_maxWithdrawals integer, in ip_dtShareStart date)
begin
	-- Implement your code here
    if ((ip_bankID, ip_accountID) not in (select bankID, accountID from bank_account)) then
		if ((ip_requester in (select perID from system_admin)) and ip_customer in (select perID from customer)) then
			insert into bank_account values (ip_bankID, ip_accountID, ip_balance);
            insert into access values (ip_customer, ip_bankID, ip_accountID, ip_dtShareStart, ip_dtDeposit);
            if ip_account_type = "checking" then
				insert into checking values (ip_bankID, ip_accountID, null, null, null, null);
			else
				insert into interest_bearing values (ip_bankID, ip_accountID, ip_interest_rate, ip_dtDeposit);
                if ip_account_type = "savings" then
					insert into savings values (ip_bankID, ip_accountID, ip_minBalance);
                else
					insert into market values (ip_bankID, ip_accountID, ip_maxWithdrawals, ip_numWithdrawals);
                end if;
            end if;
        end if;
    else
		if ((ip_requester in (select perID from system_admin)) or (ip_requester in (select perID from access where (bankID, accountID) = (ip_bankID, ip_accountID)))) then
			insert into access values (ip_customer, ip_bankID, ip_accountID, ip_balance);
        end if;
    end if;
end //
delimiter ;

-- [10] remove_account_access()
-- Remove a customer's account access. If they are the last customer with access to the account, close the account
-- When just revoking access:
    -- If the person revoking access is not an admin or someone with access to the account then don't change the database state
    -- Otherwise, remove the designated sharer from the existing account
-- When closing the account:
    -- If the customer to be removed from the account is NOT the last remaining owner/sharer then don't close the account
    -- If the person closing the account is not an admin or someone with access to the account then don't change the database state
    -- Otherwise, the account must be closed
drop procedure if exists remove_account_access;
delimiter //
create procedure remove_account_access (in ip_requester varchar(100), in ip_sharer varchar(100),
	in ip_bankID varchar(100), in ip_accountID varchar(100))
begin
	-- Implement your code here
    if ((ip_requester in (select perID from system_admin)) or (ip_requester in (select perID from access where (bankID, accountID) = (ip_bankID, ip_accountID)))) then
		delete from access where (perID, bankID, accountID) = (ip_sharer, ip_bankID, ip_accountID);
        
        if (0 in (select count(*) from access where (bankID, accountID) = (ip_bankID, ip_accountID))) then
			-- removes market account
			delete from market where (bankID, accountID) = (ip_bankID, ip_accountID);
            
            -- changes protection account if a checking account uses it for overdraft
            update checking set protectionBank = null, protectionAccount = null where (protectionBank, protectionAccount) = (ip_bankID, ip_accountID);
            -- removes savings account
			delete from savings where (bankID, accountID) = (ip_bankID, ip_accountID);
			
            -- removes interest bearing fees
            delete from interest_bearing_fees where (bankID, accountID) = (ip_bankID, ip_accountID);
            -- removes interest bearing account
			delete from interest_bearing where (bankID, accountID) = (ip_bankID, ip_accountID);
            
            -- removes checking account
            delete from checking where (bankID, accountID) = (ip_bankID, ip_accountID);
            
            -- removes account
            delete from bank_account where (bankID, accountID) = (ip_bankID, ip_accountID);
        end if;
    end if;
end //
delimiter ;

-- [11] create_fee()
drop procedure if exists create_fee;
delimiter //
create procedure create_fee (in ip_bankID varchar(100), in ip_accountID varchar(100),
	in ip_fee_type varchar(100))
begin
	-- Implement your code here
    insert into interest_bearing_fees values (ip_bankID, ip_accountID, ip_fee_type);
end //
delimiter ;

-- [12] start_overdraft()
drop procedure if exists start_overdraft;
delimiter //
create procedure start_overdraft (in ip_requester varchar(100),
	in ip_checking_bankID varchar(100), in ip_checking_accountID varchar(100),
    in ip_savings_bankID varchar(100), in ip_savings_accountID varchar(100))
begin
	-- Implement your code here
    if (
		(ip_requester in (select perID from system_admin)) or
        (
			(ip_requester in (select perID from access where (bankID, accountID) = (ip_checking_bankID, ip_checking_accountID))) and
            (ip_requester in (select perID from access where (bankID, accountID) = (ip_savings_bankID, ip_savings_accountID)))
		)
    ) then
		update checking set protectionBank = ip_savings_bankID, protectionAccount = ip_savings_accountID where (bankID, accountID) = (ip_checking_bankID, ip_checking_accountID);
    end if;
end //
delimiter ;

-- [13] stop_overdraft()
drop procedure if exists stop_overdraft;
delimiter //
create procedure stop_overdraft (in ip_requester varchar(100),
	in ip_checking_bankID varchar(100), in ip_checking_accountID varchar(100))
begin
	-- Implement your code here
	if (
		(ip_requester in (select perID from system_admin)) or
        (ip_requester in (select perID from access where (bankID, accountID) = (ip_checking_bankID, ip_checking_accountID)))
    ) then
		update checking set protectionBank = null, protectionAccount = null where (bankID, accountID) = (ip_checking_bankID, ip_checking_accountID);
    end if;
end //
delimiter ;

-- [14] account_deposit()
-- If the person making the deposit does not have access to the account then don't change the database state
-- Otherwise, the account balance and related info must be modified appropriately
drop procedure if exists account_deposit;
delimiter //
create procedure account_deposit (in ip_requester varchar(100), in ip_deposit_amount integer,
	in ip_bankID varchar(100), in ip_accountID varchar(100), in ip_dtAction date)
begin
	-- Implement your code here	
    if (ip_requester in (select perID from access where (bankID, accountID) = (ip_bankID, ip_accountID))) then
		update bank_account set balance = balance + ip_deposit_amount where (bankID, accountID) = (ip_bankID, ip_accountID);
        update access set dtAction = ip_dtAction where (bankID, accountID) = (ip_bankID, ip_accountID);
    end if;
end //
delimiter ;

-- [15] account_withdrawal()
-- If the person making the withdrawal does not have access to the account then don't change the database state
-- If the withdrawal amount is more than the account balance for a savings or market account then don't change the database state [the account balance must be positive]
-- If the withdrawal amount is more than the account balance + the overdraft balance (i.e., from the designated savings account) for a checking account then don't change the database state [the account balance must be positive]
-- Otherwise, the account balance and related info must be modified appropriately (amount deducted from the primary account first, and second from the overdraft account as needed)
drop procedure if exists account_withdrawal;
delimiter //
create procedure account_withdrawal (in ip_requester varchar(100), in ip_withdrawal_amount integer,
	in ip_bankID varchar(100), in ip_accountID varchar(100), in ip_dtAction date)
begin
	-- Implement your code here
    if (
		(ip_requester in (select perID from system_admin)) or 
        (ip_requester in (select perID from access where (bankID, accountID) = (ip_bankID, ip_accountID)))
	) then
		if (ip_withdrawal_amount <= (select balance from bank_account where (bankID, accountID) = (ip_bankID, ip_accountID))) then
			update bank_account set balance = balance - ip_withdrawal_amount where (bankID, accountID) = (ip_bankID, ip_accountID);
            update access set dtAction = ip_dtAction where (perID, bankID, accountID) = (ip_requester, ip_bankID, ip_accountID);
            
            if ((ip_bankID, ip_accountID) in (select bankID, accountID from market)) then
				update market set numWithdrawals = numWithdrawals + 1 where (bankID, accountID) = (ip_bankID, ip_accountID);
            end if;
        elseif (
			((ip_bankID, ip_accountID) in (select bankID, accountID from checking)) and
            (ip_withdrawal_amount <= (select checking_balance + overdraft_balance from display_overdraft_info where (checking_bankID, checking_accountID) = (ip_bankID, ip_accountID)))
		) then
			update bank_account, display_overdraft_info
            set balance = balance - ip_withdrawal_amount + checking_balance
            where
				(bankID, accountID) = (overdraft_bankID, overdraft_accountID) and 
                (checking_bankID, checking_accountID) = (ip_bankID, ip_accountID);
                
			update checking, access, display_overdraft_info
            set amount = ip_withdrawal_amount - checking_balance, dtOverdraft = ip_dtAction
            where
				(checking.bankID, checking.accountID) = (ip_bankID, ip_accountID) and
                (checking.bankID, checking.accountID) = (checking_bankID, checking_accountID);
			
            update bank_account set balance = 0 where (bankID, accountID) = (ip_bankID, ip_accountID);
            
            update access, display_overdraft_info
            set dtAction = ip_dtAction
            where
				(perID, access.bankID, access.accountID) = (ip_requester, ip_bankID, ip_accountID) or
                (perID, access.bankID, access.accountID) = (ip_requester, overdraft_bankID, overdraft_accountID);
        end if;
	end if;
end //
delimiter ;

-- [16] account_transfer()
-- If the person making the transfer does not have access to both accounts then don't change the database state
-- If the withdrawal amount is more than the account balance for a savings or market account then don't change the database state [the account balance must be positive]
-- If the withdrawal amount is more than the account balance + the overdraft balance (i.e., from the designated savings account) for a checking account then don't change the database state [the account balance must be positive]
-- Otherwise, the account balance and related info must be modified appropriately (amount deducted from the withdrawal account first, and second from the overdraft account as needed, and then added to the deposit account)
drop procedure if exists account_transfer;
delimiter //
create procedure account_transfer (in ip_requester varchar(100), in ip_transfer_amount integer,
	in ip_from_bankID varchar(100), in ip_from_accountID varchar(100),
    in ip_to_bankID varchar(100), in ip_to_accountID varchar(100), in ip_dtAction date)
begin
	-- Implement your code here
    if (
		(ip_requester in (select perID from system_admin)) or 
        (
			(ip_requester in (select perID from access where (bankID, accountID) = (ip_from_bankID, ip_from_accountID))) and
            (ip_requester in (select perID from access where (bankID, accountID) = (ip_to_bankID, ip_to_accountID)))
		)
	) then
		if (ip_transfer_amount <= (select balance from bank_account where (bankID, accountID) = (ip_from_bankID, ip_from_accountID))) then
			update bank_account set balance = balance - ip_transfer_amount where (bankID, accountID) = (ip_from_bankID, ip_from_accountID);
            update bank_account set balance = ifnull(balance, 0) + ip_transfer_amount where (bankID, accountID) = (ip_to_bankID, ip_to_accountID);
                        
            update access
            set dtAction = ip_dtAction
            where
				(perID, access.bankID, access.accountID) = (ip_requester, ip_from_bankID, ip_from_accountID) or
                (perID, access.bankID, access.accountID) = (ip_requester, ip_to_bankID, ip_to_accountID);
            
            if ((ip_from_bankID, ip_from_accountID) in (select bankID, accountID from market)) then
				update market set numWithdrawals = numWithdrawals + 1 where (bankID, accountID) = (ip_from_bankID, ip_from_accountID);
            end if;
        elseif (
			((ip_from_bankID, ip_from_accountID) in (select bankID, accountID from checking)) and
            (ip_transfer_amount <= (select checking_balance + overdraft_balance from display_overdraft_info where (checking_bankID, checking_accountID) = (ip_from_bankID, ip_from_accountID)))
		) then
			update bank_account, display_overdraft_info
            set balance = balance - ip_transfer_amount + checking_balance
            where
				(bankID, accountID) = (overdraft_bankID, overdraft_accountID) and 
                (checking_bankID, checking_accountID) = (ip_from_bankID, ip_from_accountID);
                
			update checking, access, display_overdraft_info
            set amount = ip_transfer_amount - checking_balance, dtOverdraft = ip_dtAction
            where
				(checking.bankID, checking.accountID) = (ip_from_bankID, ip_from_accountID) and
                (checking.bankID, checking.accountID) = (checking_bankID, checking_accountID);
			
            update bank_account set balance = 0 where (bankID, accountID) = (ip_from_bankID, ip_from_accountID);
            update bank_account set balance = ifnull(balance, 0) + ip_transfer_amount where (bankID, accountID) = (ip_to_bankID, ip_to_accountID);
            
            update access, display_overdraft_info
            set dtAction = ip_dtAction
            where
				(perID, access.bankID, access.accountID) = (ip_requester, ip_from_bankID, ip_from_accountID) or
                (perID, access.bankID, access.accountID) = (ip_requester, ip_to_bankID, ip_to_accountID) or
                (perID, access.bankID, access.accountID) = (ip_requester, overdraft_bankID, overdraft_accountID);
        end if;
	end if;
end //
delimiter ;

-- [17] pay_employees()
-- Increase each employee's pay earned so far by the monthly salary
-- Deduct the employee's pay from the banks reserved assets
-- If an employee works at more than one bank, then deduct the (evenly divided) monthly pay from each of the affected bank's reserved assets
-- Truncate any fractional results to an integer before further calculations
drop procedure if exists pay_employees;
delimiter //
create procedure pay_employees ()
begin
    -- Implement your code here
    update employee
    set earned = earned + salary, payments = payments + 1
    where payments is not null;
    
    update employee
    set payments = 1
    where payments is null;
    
    update bank
    set resAssets = 0
    where resAssets is null;
    
    update bank, (
		select bankID, sum(per_bank) as "deduction" from workFor natural join (
			select *, truncate(salary/num_banks, 0) as "per_bank"
			from employee natural join (
				select perID, count(*) as "num_banks"
				from workFor natural join employee
				group by perID
			) as num_banks
		) as deductions
		group by bankID
    ) as deduction_per_bank
    set resAssets = resAssets - deduction_per_bank.deduction
    where bank.bankID = deduction_per_bank.bankID;
end //
delimiter ;

-- [18] penalize_accounts()
-- For each savings account that is below the minimum balance, deduct the smaller of $100 or 10% of the current balance from the account
-- For each market account that has exceeded the maximum number of withdrawals, deduct the smaller of $500 per excess withdrawal or 20% of the current balance from the account
-- Add all deducted amounts to the reserved assets of the bank that owns the account
-- Truncate any fractional results to an integer before further calculations
drop procedure if exists penalize_accounts;
delimiter //
create procedure penalize_accounts ()
begin
	-- Implement your code here
    update bank
    set resAssets = 0
    where resAssets is null;
    
    -- drop table if exists penalized_savings;
--     create temporary table penalized_savings
--     select bankID, accountID, balance, truncate(least(100, 0.1 * balance), 0) as "changed_amount"
-- 	from bank_account
-- 	where (bankID, accountID) in (select bankID, accountID from savings where balance < minBalance);
--     
--     drop table if exists penalized_market;
--     create temporary table penalized_market
--     select bankID, accountID, balance, truncate(least(500, 0.2 * balance), 0) as "changed_amount"
-- 	from bank_account
--     where (bankID, accountID) in (select bankID, accountID from market where numWithdrawals > maxWithdrawals);
    
    update bank_account, penalized_savings
    set bank_account.balance = penalized_savings.balance - penalized_savings.changed_amount
    where (bank_account.bankID, bank_account.accountID) = (penalized_savings.bankID, penalized_savings.accountID);
    
    update bank_account, penalized_market
    set bank_account.balance = penalized_market.balance - penalized_market.changed_amount
    where (bank_account.bankID, bank_account.accountID) = (penalized_market.bankID, penalized_market.accountID);
    
    update bank, (select sum(changed_amount) as "total_changed", bankID from penalized_savings group by bankID) as penalized_savings_by_bank
    set resAssets = resAssets + penalized_savings_by_bank.total_changed
    where bank.bankID = penalized_savings_by_bank.bankID;
    
    update bank, (select sum(changed_amount) as "total_changed", bankID from penalized_market group by bankID) as penalized_savings_by_bank
    set resAssets = resAssets + penalized_savings_by_bank.total_changed
    where bank.bankID = penalized_savings_by_bank.bankID;
end //
delimiter ;

-- [19] accrue_interest()
-- For each interest-bearing account that is "in good standing", increase the balance based on the designated interest rate
-- A savings account is "in good standing" if the current balance is equal to or above the designated minimum balance
-- A market account is "in good standing" if the current number of withdrawals is less than or equal to the maximum number of allowed withdrawals
-- Subtract all paid amounts from the reserved assets of the bank that owns the account                                                                       
-- Truncate any fractional results to an integer before further calculations
drop procedure if exists accrue_interest;
delimiter //
create procedure accrue_interest ()
begin
	-- Implement your code here
    -- TODO: get interest rate
    update bank
    set resAssets = 0
    where resAssets is null;
    
    drop table if exists good_accounts;
    create temporary table good_accounts
    select bankID, accountID, balance, changed_amount
	from (
		select bankID, accountID, balance, truncate(balance * (interest_rate/100), 0) as changed_amount
		from interest_bearing natural join (
			select * from bank_account natural join savings
			where balance >= minBalance
		) as good_savings_accounts
		union all
		select bankID, accountID, balance, truncate(balance * (interest_rate/100), 0) as changed_amount
		from interest_bearing natural join (
			select * from bank_account natural join market
			where numWithdrawals <= maxWithdrawals or maxWithdrawals is null
		) as good_market_accounts
	) as temp_good_accounts;
    
    update bank_account, good_accounts
    set bank_account.balance = bank_account.balance + ifnull(good_accounts.changed_amount, 0)
    where (bank_account.bankID, bank_account.accountID) = (good_accounts.bankID, good_accounts.accountID);
    
    update bank, (
		select bankID, sum(ifnull(changed_amount, 0)) as "total_changed" from good_accounts group by bankID
	) as total_changed_per_bank
	set resAssets = resAssets - ifnull(total_changed_per_bank.total_changed, 0)
	where bank.bankID = total_changed_per_bank.bankID;
end //
delimiter ;

-- [20] display_account_stats()
-- Display the simple and derived attributes for each account, along with the owning bank
create or replace view display_account_stats as
    -- Uncomment above line and implement your code here
    select bankName as "name_of_bank", accountID as "account_identifier", balance as "account_assets", number_of_owners
	from bank natural join (
		select *
		from bank_account natural join (
			select bankID, accountID, count(*) as "number_of_owners"
			from access group by bankID, accountID
		) as owners_per_account
	) as account_wo_bank_name;

-- [21] display_bank_stats()
-- Display the simple and derived attributes for each bank, along with the owning corporation
create or replace view display_bank_stats as
    -- Uncomment above line and implement your code here
	select bankID as "bank_identifier", shortName as "name_of_corporation", bankName as "name_of_bank", street, city, state, zip, number_of_accounts, bank_assets, total_assets
	from corporation join (
		select bank.bankID, bankName, street, city, state, zip, number_of_accounts, resAssets as "bank_assets", ifnull(resAssets, 0) + ifnull(account_assets, 0) as "total_assets", corpID
		from bank left join (
			select bankID, count(*) as "number_of_accounts", sum(balance) as "account_assets"
			from bank_account
			group by bankID
		) as accounts_per_bank
		on bank.bankID = accounts_per_bank.bankID
	) as bank_w_corpID
	on corporation.corpID = bank_w_corpID.corpID;
    
-- [22] display_corporation_stats()
-- Display the simple and derived attributes for each corporation
create or replace view display_corporation_stats as
    -- Uncomment above line and implement your code here
	select
		corporation.corpID as "corporation_identifier",
		shortName as "short_name",
		longName as "formal_name",
		number_of_banks,
		corporation.resAssets as "corporation_assets",
		corporation.resAssets + ifNull(total_assets, 0) as "total_assets"
	from corporation left join (
		select * from (
			select *, count(*) as "number_of_banks"
			from bank group by corpID
		) as num_banks natural left join (
			select corpID, sum(ifnull(resAssets, 0) + ifnull(account_assets, 0)) as "total_assets"
				from bank natural left join (
					select bankID, count(*) as "number_of_accounts", sum(ifnull(balance, 0)) as "account_assets"
					from bank_account
					group by bankID
				) as account_assets_per_bank
				group by corpID
		) as total_assets_per_bank
	) as bank_info
	on corporation.corpID = bank_info.corpID;

-- [23] display_customer_stats()
-- Display the simple and derived attributes for each customer
create or replace view display_customer_stats as
    -- Uncomment above line and implement your code here
    select 
		perID as "person_identifier",
		taxID as "tax_identifier",
		concat(firstName, " ", lastName) as "customer_name",
		birthdate as "date_of_birth",
		dtJoined as "joined_system",
		street,
		city,
		state,
		zip,
		number_of_accounts,
		ifnull(customer_assets, 0) as "customer_assets"
	from (
		select *
		from customer natural join bank_user
	) as customer_info natural left join (
		select *, sum(balance) as "customer_assets", count(*) as "number_of_accounts"
		from access natural join bank_account
		group by perID
	) as assets_and_accounts;

-- [24] display_employee_stats()
-- Display the simple and derived attributes for each employee
create or replace view display_employee_stats as
    -- Uncomment above line and implement your code here
    select
		perID as "person_identifier",
		taxID as "tax_identifier",
		concat(firstName, " ", lastName) as "employee_name",
		birthdate as "date_of_birth",
		dtJoined as "joined_system",
		street,
		city,
		state,
		zip,
		number_of_banks,
		bank_assets
	from bank_user natural join (
		select * from employee natural left join (
			select perID, sum(ifNull(total_assets, 0)) as "bank_assets", count(*) as "number_of_banks" from workFor natural join (
				select bank.bankID, ifnull(resAssets, 0) + ifnull(account_assets, 0) as "total_assets"
				from bank left join (
					select bankID, count(*) as "number_of_accounts", sum(balance) as "account_assets"
					from bank_account
					group by bankID
				) as accounts_per_bank
				on bank.bankID = accounts_per_bank.bankID
			) as bank_assets_table
			group by perID
		) as person_assets_banks_table
	) as employee_assets_banks_table;
    
-- HELPER VIEWS
create or replace view penalized_savings as
	select bankID, accountID, balance, truncate(least(100, 0.1 * balance), 0) as "changed_amount"
	from bank_account
	where (bankID, accountID) in (select bankID, accountID from savings where balance < minBalance);

create or replace view penalized_market as
	select bankID, accountID, balance, truncate(least(500, 0.2 * balance), 0) as "changed_amount"
	from bank_account
    where (bankID, accountID) in (select bankID, accountID from market where numWithdrawals > maxWithdrawals);
    
create or replace view display_overdraft_info as
	select
		ifNull(balance, 0) as "checking_balance",
		ifNull(overdraft_balance, 0) as "overdraft_balance",
		checking_bankID,
		checking_accountID,
		overdraft_bankID,
		overdraft_accountID
	from bank_account join (
		select
			checking.bankID as "checking_bankID",
			checking.accountID as "checking_accountID",
			protectionBank as "overdraft_bankID",
			protectionAccount as "overdraft_accountID",
			balance as "overdraft_balance"
		from checking join bank_account
		on (protectionBank, protectionAccount) = (bank_account.bankID, bank_account.accountID)
	) as checking_balance
	on (bank_account.bankID, bank_account.accountID) = (checking_balance.checking_bankID, checking_balance.checking_accountID);
