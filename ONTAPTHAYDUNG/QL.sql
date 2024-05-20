 --QL xem lại kết quả TN và NV đã làm.
 use AdventureWorks2008R2
-- Kiểm tra các thay đổi của TN (tăng lương)
SELECT * FROM HumanResources.EmployeePayHistory
WHERE Rate <= 11;  -- Xem các bản ghi có Rate <= 11 để xác nhận việc tăng lương
GO
-- kiem tra thay doi cua NV(xoa )
Select *from HumanResources.EmployeePayHistory
where BusinessEntityID=3
-- khong thay du lieu => da bi xoa 


