
--a)

Create login TN with Password = 'tn1'
Create login NV With Password = 'nv1'
Create login QL With Password = 'ql1'

-- gan vao AVT
Use AdventureWorks2008R2 
Create User TN for login TN;
Create User NV for login NV;
Create User QL for login QL;

--b) Phan quyen
-- chi cap quyen cho NV va QL tu choi cap quyen cho NV


Grant select, update on EmployeePayHistory to NV;
Grant select on EmplyeePayHistory to QL;
-- Truong Nhom chuyen tiep quyen cho  nhan vien
Exec sp_addrolemember 'db_datareader' , 'TN';

--
GRANT UPDATE ON HumanResources.EmployeePayHistory TO TN;
Grant Delete On HumanResources.EmployeePayHistory to NV;
Grant Select ON HumanResources.EmployeePayHistory to QL;
GRANT SELECT ON HumanResources.EmployeePayHistory TO NV;

--d)
-- Nhan vien khong the xoa 1 dong du lieu tuy y vi phai duoc cau hinh moi co the xoa duoc
--e) thu hoi quyen cua nhan vien va truong nhom
-- Thu hồi quyền của nhóm TN và NV
REVOKE SELECT, UPDATE ON HumanResources.EmployeePayHistory FROM TN;
REVOKE SELECT ON HumanResources.EmployeePayHistory FROM QL;
--cau 2 tao giao tac tang luong
BACKUP DATABASE AdventureWorks2008R2 TO DISK = 'C:\HQT CSDL\Backup\AdventureWorks2008R2_Full.bak';


Begin transaction;
-- upscale salary 10% for employee from department sales and marketing
Update HumanResources.EmployeePayHistory
Set Rate = Rate*1.1
Where BusinessEntityID in (
select E.BusinessEntityID
from HumanResources.EmployeePayHistory E
inner join HumanResources.EmployeeDepartmentHistory EDH on E.BusinessEntityID = EDH.BusinessEntityID
inner join HumanResources.Department D on EDH.DepartmentID= D.DepartmentID
Where D.Name in ('Sales','Marketing')
);
-- tang luong len 5% cho nhan vien 2 phong ban do 
Update HumanResources.EmployeePayHistory
Set Rate = Rate *1.5
Where BusinessEntityID not in (
Select E.BusinessEntityID
from HumanResources.EmployeePayHistory E
inner join HumanResources.EmployeeDepartmentHistory EDH on E.BusinessEntityID = EDH.BusinessEntityID
inner join HumanResources.Department D on EDH.DepartmentID= D.DepartmentID
Where D.Name in ('Sales','Marketing')
);
Commit transaction;

USE master;
RESTORE DATABASE AdventureWorks2008R2 FROM DISK =  'C:\HQT CSDL\Backup\AdventureWorks2008R2_Full.bak' WITH REPLACE;
--b)
Delete from [Purchasing].[PurchaseOrderDetail];

Backup database AdventureWorks2008R2 to disk ='C:\HQT CSDL\Backup\AdventureWorks2008R2_Full.bak'
WITH DIFFERENTIAL;
--c) 

use AdventureWorks2008R2
Update Person.EmailAddress
Set EmailAddress = Null 
Where BusinessEntityID = 4


BACKUP Database AdventureWorks2008R2 
TO DISK = 'C:\HQT CSDL\Backup\AdventureWorks2008R2_Full.bak'
ALTER DATABASE AdventureWorks2008R2 SET RECOVERY FULL;
 
BACKUP Log AdventureWorks2008R2 
TO DISK = 'C:\HQT CSDL\Backup\AdventureWorks2008R2_log.trn'
--d)
CREATE TRIGGER trg_ProductReview_AfterUpdate
ON [Production].[ProductReview]
AFTER UPDATE
AS
BEGIN
    -- Kiểm tra xem có tồn tại sản phẩm được cập nhật không
    IF NOT EXISTS (SELECT 1 FROM inserted i JOIN Product p ON i.ProductID = p.ProductID)
    BEGIN
        -- Nếu không tồn tại, báo lỗi và quay lui giao tác
        RAISERROR ('Không tồn tại mã sản phẩm được cập nhật.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    -- Lấy thông tin liên quan của sản phẩm
    SELECT p.ProductID, p.Color, p.StandardCost, pr.Rating, pr.Comments
    FROM Product p
    INNER JOIN inserted i ON p.ProductID = i.ProductID
    INNER JOIN ProductReview pr ON i.ProductID = pr.ProductID;
END;


UPDATE  [Production].[ProductReview]
SET Comments = 'Bình luận mới'
WHERE ProductID = 1;

select*from [Production].[Product]

-- 
-- Kiểm tra xem có kết nối nào đang sử dụng cơ sở dữ liệu AdventureWorks2008R2 không
SELECT 
    spid, 
    ecid, 
    status, 
    loginame, 
    hostname, 
    cmd
FROM 
    sys.sysprocesses 
WHERE 
    DB_NAME(dbid) = 'AdventureWorks2008R2';

-- Đóng tất cả các kết nối đang sử dụng cơ sở dữ liệu AdventureWorks2008R2
ALTER DATABASE AdventureWorks2008R2 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;


Drop database AdventureWork2008R2;