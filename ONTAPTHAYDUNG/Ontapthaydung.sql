--Câu 1: Có 2 nhóm người dùng tham gia dự án với các công việc cụ thể sau:
--- Các nhân viên sửa, xóa và xem số liệu: gồm trưởng nhóm TN và nhân viên NV, chỉ được làm việc trên bảng EmployeePayHistory.
--- Quản lý xem các báo cáo thống kê: gồm quản lý QL, thuộc role db_datareader.
--Thực hiện các yêu cầu sau:
--a. Tạo các login; tạo các user khai thác CSDL AdventureWorks2008R2 cho các nhân viên và quản lý (tên login trùng tên user).
Create login NV with password ='123'
Create login QL with password ='123'
Create login TN with password ='123'
-- Tao user
Create user NV for login NV
Create user QL for login QL
Create user TN for login TN

--b. Phân quyền: -Admin: chỉ cấp quyền cần thiết cho TN và QL; từ chối cấp quyền sửa cho NV.
---Trưởng nhóm TN: chuyển tiếp tất cả các quyền mình có cho NV
Grant select,update,delete,insert on [HumanResources].[EmployeePayHistory] to TN
 with grant Option
 --cap quyen cho quan ly 
 exec sp_addrolemember [db_datareader] , QL 
 --tu choi cap quyen sua cho nhan vien
 Grant select,delete,insert on [HumanResources].[EmployeePayHistory] to NV
 --c lam o cac cua so TN, NV , QL
 --d : - phan kiem tra nhan vien co sua duoc ko o cua so nv
 select *from [Person].[Person]
 --chi co admin moi xem duoc ban person ngoai ra QL,TN,NV khong xem duoc
 --e Nhóm nhân viên (TN và NV) hoàn thành dự án, Admin hãy vô hiệu hóa các hoạt động của nhóm này trên CSDL
 revoke select,update,delete,insert on [HumanResources].[EmployeePayHistory] from TN cascade
 revoke select,delete,insert on [HumanResources].[EmployeePayHistory] to NV
-- Câu 2:
--Hãy viết các lệnh Backup tại các vị trí [...], rồi Restore cơ sở dữ liệu theo yêu cầu ở câu e.
--Lưu file backup vào thư mục T:\Backup.
--a. Tạo một giao tác tăng lương (Rate) 10% cho các nhân viên làm việc ở phòng (Department.Name) ‘Sales’ và ‘Marketing’; 
--tăng lương 5% cho các nhân viên các phòng ban khác. Ghi nhận dữ liệu đang có - Full Backup].
Begin tran;
-- tang 10% cho nhan vien lam viec o phong sales va marketing
Update [HumanResources].[EmployeePayHistory]
Set Rate=Rate*1.10
Where BusinessEntityID in (
Select E.BusinessEntityID from HumanResources.Employee E
JOIN HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
JOIN HumanResources.Department d ON edh.DepartmentID = d.DepartmentID
Where d.Name in ('Sales','Marketing')	);

Update [HumanResources].[EmployeePayHistory]
Set Rate=Rate*1.05
Where BusinessEntityID in (
Select E.BusinessEntityID from HumanResources.Employee E
JOIN HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
JOIN HumanResources.Department d ON edh.DepartmentID = d.DepartmentID
Where d.Name not in ('Sales','Marketing')	);
Commit;
-- ful backup
Backup database AdventureWorks2008R2
to disk='C:\HQT CSDL\ONTAPTHAYDUNG\Backup'
with description = 'Full Backup'

-- Kiểm tra lương của nhân viên sau khi thực hiện giao tác
SELECT e.BusinessEntityID, e.JobTitle, eph.Rate, d.Name AS DepartmentName
FROM HumanResources.EmployeePayHistory eph
JOIN HumanResources.Employee e ON eph.BusinessEntityID = e.BusinessEntityID
JOIN HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
JOIN HumanResources.Department d ON edh.DepartmentID = d.DepartmentID
ORDER BY e.BusinessEntityID;
--b. Xóa mọi bản ghi trong bảng PurchaseOrderDetail. [Ghi nhận dữ liệu đang có - Differential Backup]
  delete from [Purchasing].[PurchaseOrderDetail]

  -- viet differential backup 
  backup database [AdventureWorks2008R2]
  to disk = 'D:\backup\backup2008.bak'
  with differential , description = ' Differential Backup '

--c. Xóa địa chỉ mail (EmailAddress) của nhân viên có mã số nhân viên (BusinessEntityID) là 4. [Ghi nhận dữ liệu đang có - Log Backup]
 select * from [Person].[EmailAddress]
 where BusinessEntityID = 4
 -- xoa dia chi mail
 delete from [Person].[EmailAddress] 
 where BusinessEntityID = 4
 -- viet log backup 
 backup  log [AdventureWorks2008R2]
 to disk = 'D:\backup\backup2008.bak'
 with description = 'Log Backup'
--d. Viết after trigger trên bảng ProductReview sao cho khi cập nhật 1 bình luận (Comments) cho 1 mã sản phẩm thì liệt kê danh sách thông tin liên quan của sản phẩm gồm ProductID, Color, StandardCost, Rating, Comments; nếu mã sản phẩm không có thì báo lỗi và quay lui giao tác. Viết lệnh kích hoạt trigger cho 2 trường hợp
-- Tạo trigger trên bảng ProductReview
--e. Xóa CSDL AdventureWorks2008R2. Phục hồi CSDL về trạng thái bước c. Kiểm tra xem dữ liệu phục hồi có đạt yêu cầu không (lương có tăng, các bản ghi có bị xóa, có xóa 1 địa chỉ mail)?

drop database AdventureWorks2008R2
-- khôi phuc dư liệu  về bước c .
 

 restore database AdventureWorks2008R2
 from disk ='D:\backup\backup2008.bak'
 with file = 1 , norecovery
 
 restore database AdventureWorks2008R2
 from disk ='D:\backup\backup2008.bak'
 with file =2 , norecovery 

 restore database AdventureWorks2008R2
 from disk = 'D:\backup\backup2008.bak'
 with file = 3, recovery 

 use AdventureWorks2008R2
 -- kiem tra lai xoa mail 
  delete from [Person].[EmailAddress] 
 where BusinessEntityID = 4 -- ok 
