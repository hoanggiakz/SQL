--NV xóa dữ liệu của nhân viên có BusinessEntityID=3.
use AdventureWorks2008R2 
Delete from HumanResources.EmployeePayHistory
where BusinessEntityID=3


-- kiem tra 
select BusinessEntityID from HumanResources.EmployeePayHistory EPH
-- Nhan vien sua 1 dong du lieu tuy y 
Update HumanResources.EmployeePayHistory
set BusinessEntityID=4
-- nhan vien khong the xoa duoc vi khong co quyen 
