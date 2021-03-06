﻿USE QL_COFFEE_CS414BIS_PDT
--câu lệnh add record vào bảng
-------------------
SELECT * FROM PDT_KHUVUC
-----------------
DECLARE @i INT =0
DECLARE @n INT =10

WHILE(@i <@n)
BEGIN

INSERT INTO PDT_KHUVUC(khuVucName) VALUES ('Khu ' + CAST(@i AS nvarchar(100)))


SET @i+=1
END
GO
--------------------------
INSERT INTO PDT_TABLE(tableName,tableStatus,idKhuVuc) VALUES ('Bàn 1',-1,1)
------------------------
SELECT * FROM PDT_TABLE
------------------------
SELECT * FROM PDT_CATEGORYFOOD
----------------------------
INSERT INTO PDT_CATEGORYFOOD(categoryName) VALUES (N'COFFFEE')
INSERT INTO PDT_CATEGORYFOOD(categoryName) VALUES (N'NƯỚC PHA CHẾ')
INSERT INTO PDT_CATEGORYFOOD(categoryName) VALUES (N'NƯỚC GIẢI KHÁT')
INSERT INTO PDT_CATEGORYFOOD(categoryName) VALUES (N'THUỐC LÁ')
INSERT INTO PDT_CATEGORYFOOD(categoryName) VALUES (N'ĐỒ ĂN')
----------------------------
SELECT * FROM PDT_FOOD
---------------------
SELECT * FROM PDT_FOOD WHERE idCategoryFood=1
---------------------
INSERT INTO PDT_FOOD(FoodName,donViTinh,gia,idCategoryFood) VALUES (N'Phê đen',N'Ly',10000,1)
INSERT INTO PDT_FOOD(FoodName,donViTinh,gia,idCategoryFood) VALUES (N'Phê sữa',N'Ly',12000,1)
INSERT INTO PDT_FOOD(FoodName,donViTinh,gia,idCategoryFood) VALUES (N'FĐSG',N'Ly',15000,1)
INSERT INTO PDT_FOOD(FoodName,donViTinh,gia,idCategoryFood) VALUES (N'FSSG',N'Ly',17000,1)
INSERT INTO PDT_FOOD(FoodName,donViTinh,gia,idCategoryFood) VALUES (N'CAPUCHINO',N'Ly',20000,1)


INSERT INTO PDT_FOOD(FoodName,donViTinh,gia,idCategoryFood) VALUES (N'Revai',N'Chai',17000,3)
INSERT INTO PDT_FOOD(FoodName,donViTinh,gia,idCategoryFood) VALUES (N'String dâu',N'Chai',10000,3)
INSERT INTO PDT_FOOD(FoodName,donViTinh,gia,idCategoryFood) VALUES (N'String vàng',N'Chai',10000,3)
INSERT INTO PDT_FOOD(FoodName,donViTinh,gia,idCategoryFood) VALUES (N'Bò húc',N'Chai',15000,3)
INSERT INTO PDT_FOOD(FoodName,donViTinh,gia,idCategoryFood) VALUES (N'N1',N'Chai',15000,3)
INSERT INTO PDT_FOOD(FoodName,donViTinh,gia,idCategoryFood) VALUES (N'0 Độ',N'Chai',15000,3)

INSERT INTO PDT_FOOD(FoodName,donViTinh,gia,idCategoryFood) VALUES (N'Cacao',N'Ly',17000,2)
INSERT INTO PDT_FOOD(FoodName,donViTinh,gia,idCategoryFood) VALUES (N'Nước Chanh',N'Ly',20000,2)
INSERT INTO PDT_FOOD(FoodName,donViTinh,gia,idCategoryFood) VALUES (N'B52',N'Ly',50000,2)
INSERT INTO PDT_FOOD(FoodName,donViTinh,gia,idCategoryFood) VALUES (N'Rob Roys',N'Ly',120000,2)
INSERT INTO PDT_FOOD(FoodName,donViTinh,gia,idCategoryFood) VALUES (N'Cocktail sidecar',N'Ly',90000,2)


INSERT INTO PDT_FOOD(FoodName,donViTinh,gia,idCategoryFood) VALUES (N'Thuốc 3 số',N'Gói',40000,4)
INSERT INTO PDT_FOOD(FoodName,donViTinh,gia,idCategoryFood) VALUES (N'Thuốc ngựa',N'Gói',26000,4)
INSERT INTO PDT_FOOD(FoodName,donViTinh,gia,idCategoryFood) VALUES (N'Ngựa Điếu',N'Điếu',1200,4)
---------------------
USE QL_COFFEE_CS414BIS_PDT
SELECT FoodName,donViTinh,gia FROM PDT_FOOD WHERE idCategoryFood=1
--------------------------------
SELECT * FROM PDT_BILL WHERE idTable=2
--------------------------------

INSERT INTO PDT_BILL(billStatus,billDataCheckIn,billDateCheckOut,idTable) VALUES (-1,GETDATE(),GETDATE(),1)

DELETE PDT_BILL WHERE idTable=1


------------------
SELECT * FROM PDT_BILLINFO WHERE idBill=4

INSERT INTO PDT_BILLINFO(billInfoCount,idBill,idFood) VALUES (1,4,8)
-------------------------------------
SELECT * FROM PDT_BILL

INSERT INTO PDT_BILL(status,billDataCheckIn,billDateCheckOut,idTable) VALUES (-1,GETDATE(),GETDATE(),2)
--------------------------
SELECT idBill FROM PDT_BILL WHERE idTable=4
---------------------------
--Update by NguyenVanPhuc
--Date 10/02/2018

EXEC USP_INSERTBILLINFO @idBill=86 ,@idFood=1,@countBillInfo=3
SELECT COUNT(*)
FROM PDT_BILL
WHERE idBill=86
---------------------------- 
EXEC USP_DELETEBILLINFO @idBillInfo=11
-------------------------------
EXEC USP_INSERTBILL @idTable=100,@billStatus=-1 , @billTotal=0 , @billNameAccount='FD'
--------------------

DECLARE @II INT EXEC @II=USP_DELETEBILL @idTable=1
----------------------------
DECLARE @B INT =-1
SELECT @B= idBillInfo
FROM PDT_BILLINFO
WHERE idBill=0
PRINT @B
---------------------
DECLARE @BB INT =-1
SELECT @BB= COUNT(*)
FROM PDT_BILLINFO
WHERE idBill=123
PRINT @BB
--------------------------
EXEC USP_CHUYENBAN 3,1
------
SELECT * FROM PDT_TABLE WHERE tableStatus=-1
-------------
DECLARE @I INT= 3
WHILE(@I<60)
BEGIN
	INSERT INTO PDT_TABLE(tableName,tableStatus,idKhuVuc) VALUES ('Bàn '+CAST(@I AS nvarchar(10)),-1,1)
	SET @I=@I+1
END
GO
---------------
DELETE FROM PDT_TABLE WHERE idKhuVuc=3
---------------
SELECT * 
FROM PDT_FOOD
WHERE foodName LIKE 'p%' 
select * from PDT_TABLE where idKhuVuc=1

-----------------------
SELECT * FROM PDT_BILLINFO WHERE idBill=207
----------------------
SELECT COUNT(*) FROM PDT_BILLINFO WHERE idBill=207
-------------------
exec USP_CHECKBILLINFOBYIDTABLE 1
---------
declare @count int
select @count=COUNT(*)
	FROM PDT_BILLINFO
	WHERE idBill = 207

select @count

SELECT * 
FROM PDT_BILLINFO
WHERE idBill=207
----------

UPDATE PDT_BILLINFO
SET idBill=
WHERE idTable=@idTableNEW

EXEC USP_DELETEBILLINFO 87