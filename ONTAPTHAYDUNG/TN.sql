 --TN tăng lương (Rate) 10% cho các nhân viên có Rate<=10
use AdventureWorks2008R2
 Update [HumanResources].[EmployeePayHistory]
 set Rate= Rate*1.10
 where Rate <=10;

 SELECT * FROM HumanResources.EmployeePayHistory
WHERE Rate <= 11;  -- Xem các bản ghi có Rate <= 11 để xác nhận việc tăng lương
GO


