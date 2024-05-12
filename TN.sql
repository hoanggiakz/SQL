
Use AdventureWorks2008R2
-- TN tăng lương 10% cho các nhân viên có Rate <= 10
UPDATE[HumanResources].[EmployeePayHistory] SET Rate = Rate * 1.1 WHERE Rate <= 10;
select *from HumanResources.EmployeePayHistory 
where Rate <=10