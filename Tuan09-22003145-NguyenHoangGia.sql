Use master;
Go
-- Crate login user2
Create login User2
With password = '123',
	Default_Database = Master,
	Check_policy = Off;
-- Create login User3
Create login User3
With PASSWORD= '1234',
	DEFAULT_Database = Master,
	Check_policy= off;


Use AdventureWorks2008R2;
Create USER user2 FOR LOGIN User2;
Create User user3 FOR LOGIN User3;
-- Gan quyen Select cho user tren bang EmployeeU;
 Grant Select on[HumanResources].[Employee] to User2;
-- kiem tra quyen select cua user2 tren bang employee
select *from HumanResources.Employee


-- Xoa quyen
Revoke select on [HumanResources].[Employee] from user2;


-- Create database role on Advanterword2018
Create role Employee_role;
Go
-- Gan quyen select, update, delete for Employee_role
Grant Select, Update, Delete on[HumanResources].[Employee]to Employee_role;
Go

-- them user2 vao user3 vao Employee_role
Use AdventureWorks2008R2;
Go
Alter ROLE Employee_role add member User2 ;
Alter ROLE Employee_role add member User3 ; 
Go