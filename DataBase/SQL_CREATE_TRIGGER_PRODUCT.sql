﻿--Create by NguyenVanPhuc
--Date: 09/02/2018


--CREATE TRIGGER UTG_UPDATEBILLINFO
--ON PDT_BILLINFO FOR INSERT, UPDATE
--AS
--BEGIN
--	DECLARE @IDBILL INT
--	SELECT @IDBILL=idBill FROM INSERTED
--	DECLARE @IDTABLE INT
--	SELECT @IDTABLE=idTable FROM PDT_BILL WHERE idBill=@IDBILL AND status =-1
--	UPDATE PDT_TABLE SET tableStatus=1 WHERE idTable=@IDTABLE
--END
--GO
-------------------
CREATE TRIGGER UTG_UPDATEBILL
ON PDT_BILL FOR INSERT,UPDATE,DELETE
AS
BEGIN
	DECLARE @IDTABLE INT
	SELECT @IDTABLE=idTable FROM INSERTED
	UPDATE PDT_TABLE SET tableStatus=1 WHERE idTable=@IDTABLE
END
GO
--Update by NguyenVanPhuc
--Date 12/02/2018
--------------------
CREATE TRIGGER UTG_UPDATEBILLDELETE
ON PDT_BILL FOR INSERT,UPDATE,DELETE
AS
BEGIN
	DECLARE @IDTABLE INT
	SELECT @IDTABLE=idTable FROM DELETED
	UPDATE PDT_TABLE SET tableStatus=-1 WHERE idTable=@IDTABLE
END
GO
--Update by NguyenVanPhuc
--Date 12/02/2018
--------------------------
--Update by NguyenVanPhuc
--Date 10/02/2018

CREATE PROC USP_INSERTBILLINFO
@idBill INT, @idFood INT ,@countBillInfo INT
AS
BEGIN

	--UPDATE 10/02/2018
	--CHẶN LỖI
	DECLARE @countExitBill int =-1

	SELECT @countExitBill=COUNT(*)
	FROM PDT_BILL
	WHERE idBill=@idBill

	IF(@countExitBill<1)
	BEGIN
		PRINT N'bàn chưa được mở, không thể thêm món! '
		RETURN
	END
	-----------------
	DECLARE @isExitFood INT
	DECLARE @countFood INT =0

	SELECT @isExitFood =idFood,@countFood=billInfoCount 
	FROM PDT_BILLINFO
	WHERE idBill=@idBill AND idFood=@idFood

	--UPDATE 07/03/2018
	--Ràng buộc số lượng
	IF(@countFood+@countBillInfo<=0)
	BEGIN
		PRINT N'Số lượng món ăn không thể nhỏ hơn không'
		RETURN
	END

	IF(@isExitFood>0)
	BEGIN
		UPDATE PDT_BILLINFO 
		SET billInfoCount =@countBillInfo+@countFood
		WHERE idBill=@idBill AND idFood=@idFood
	END

	ELSE
	BEGIN
		INSERT INTO PDT_BILLINFO(idBill,idFood,billInfoCount)
		VALUES (@idBill,@idFood,@countBillInfo)
	END

END
GO
----------------------------
CREATE PROC USP_DELETEBILLINFO
@idBillInfo INT
AS
BEGIN
	DELETE PDT_BILLINFO
	WHERE idBillInfo=@idBillInfo
END
GO
-------------------
CREATE PROC USP_INSERTBILL
@idTable INT,@billStatus INT , @billTotal FLOAT , @billNameAccount NVARCHAR(50)
AS
BEGIN
	DECLARE @isExitBillStatus INT =1
	SELECT @isExitBillStatus=billStatus
	FROM PDT_BILL
	WHERE idTable=@idTable

	IF(@isExitBillStatus=1)
	BEGIN
		INSERT INTO PDT_BILL(idTable,billDataCheckIn,billStatus,billTotal,billNameAccount)
		VALUES(@idTable,GETDATE(),@billStatus, @billTotal, @billNameAccounT)
		PRINT N'Thêm dữ liệu thành công'
	END
	ELSE
	BEGIN
		PRINT N'Bàn này đã có bill'
	END
END
GO
----------------------
CREATE PROC USP_DELETEBILL
@idTable INT
AS
BEGIN
	DECLARE @countExitBillInfo INT =-1
	DECLARE @IDBILL INT=-1

	--Tìm id bill của table này
	SELECT @IDBILL=idBill
	FROM PDT_BILL
	WHERE idTable=@idTable

	--Đếm xem có bao nhiêu recode có idBill như vậy
	SELECT @countExitBillInfo=COUNT(*)
	FROM PDT_BILLINFO
	WHERE idBill=@IDBILL

	--Tiến hành xóa các billInfo có idBill là dưới
	IF(@countExitBillInfo>0)
	BEGIN
		DELETE PDT_BILLINFO
		WHERE idBill=@IDBILL
	END

	--Sau khi bill đã không còn ràng buộc khóa ngoại, tiến hành xóa nó
	DELETE PDT_BILL
	WHERE idTable= @idTable
END
GO
----------------------
--Mở bàn nếu bàn chưa được mở mà vẫn thêm món ăn vào bàn
CREATE PROC USP_INSERTBILLINFO_INSERTBILL
@idBill INT, @idFood INT ,@countBillInfo INT,
--parameter Insert Bill
@idTable INT,@billStatus INT , @billTotal FLOAT , @billNameAccount NVARCHAR(50)
AS
BEGIN
	--Kiểm tra xem bàn có mở chưa
	DECLARE @countExitBill int =-1

	SELECT @countExitBill=COUNT(*)
	FROM PDT_BILL
	WHERE idBill=@idBill

	--Mở bàn nếu bàn chưa mở
	IF(@countExitBill<1)
	BEGIN
		EXEC USP_INSERTBILL @idTable,@billStatus,@billTotal,@billNameAccount
	END
	-----------------
	DECLARE @isExitFood INT
	DECLARE @countFood INT =0

	SELECT @isExitFood =idFood,@countFood=billInfoCount 
	FROM PDT_BILLINFO
	WHERE idBill=@idBill AND idFood=@idFood

	IF(@isExitFood>0)
	BEGIN
		UPDATE PDT_BILLINFO 
		SET billInfoCount =@countBillInfo+@countFood
		WHERE idBill=@idBill AND idFood=@idFood
	END

	ELSE
	BEGIN
		INSERT INTO PDT_BILLINFO(idBill,idFood,billInfoCount)
		VALUES (@idBill,@idFood,@countBillInfo)
	END

END
GO
-----------------------------------
--UPDATE BY NGUYENVANPHUC 
--DATE: 12/02/2018
CREATE PROC USP_CHUYENBAN
@idTableOld INT,@idTableNew INT
AS
BEGIN
	--Kiểm tra bàn cũ có tồn tại?
	DECLARE @countExitTableOll INT=-1

	SELECT @countExitTableOll=COUNT(*) 
	FROM PDT_TABLE
	WHERE idTable=@idTableOld

	--Kiểm tra bàn mới có tồn tại?
	DECLARE @countExitTablenNew INT=-1

	SELECT @countExitTablenNew=COUNT(*) 
	FROM PDT_TABLE
	WHERE idTable=@idTableNew

	--Nếu bạn không tồn tại thì nothing
	IF(@countExitTablenNew<1 OR @countExitTableOll<1)
	BEGIN
		PRINT N'Bàn không tồn tại'
		RETURN
	END

	UPDATE PDT_BILL
	SET idTable=@idTableNew
	WHERE idTable=@idTableOld
END
GO

---------------
--UPDATE BY NGUYENVANPHUC 
--DATE: 06/03/2018

CREATE PROC USP_SEARCHFOOD
@FOODNAME NVARCHAR(100)
AS
BEGIN
	SELECT *
	FROM PDT_FOOD
	WHERE foodName like @FOODNAME + '%'
END
GO
----------------
--UPDATE BY NGUYENVANPHUC 
--DATE: 11/03/2018

--THỦ TỤC KIỂM TRA BÀN ĐÃ MỞ CÓ MÓN ĂN NÀO KHÔNG
CREATE PROC USP_CHECKBILLINFOBYIDTABLE
@idTable INT
AS

BEGIN
	DECLARE @idBillL INT=-1

	SELECT @idBillL=idBill
	FROM PDT_BILL
	WHERE idTable=@idTable
	--

	DECLARE @count INT =-1

	SELECT @count=COUNT(*)
	FROM PDT_BILLINFO
	WHERE idBill = @idBillL
	--RETURN
	SELECT @count
END
GO

----------------
--UPDATE BY NGUYENVANPHUC 
--DATE: 12/03/2018

--Thủ tục gộp bàn
use QL_COFFEE_CS414BIS_PDT
CREATE PROC USP_GOPBAN
@idTableOld INT, @idTableNew INT
AS
BEGIN
	--Kiểm tra bàn cũ có tồn tại?
	DECLARE @countExitTableOll INT=-1

	SELECT @countExitTableOll=COUNT(*) 
	FROM PDT_TABLE
	WHERE idTable=@idTableOld

	--Kiểm tra bàn mới có tồn tại?
	DECLARE @countExitTablenNew INT=-1

	SELECT @countExitTablenNew=COUNT(*) 
	FROM PDT_TABLE
	WHERE idTable=@idTableNew

	--Nếu bạn không tồn tại thì nothing
	IF(@countExitTablenNew<1 OR @countExitTableOll<1)
	BEGIN
		PRINT N'Bàn không tồn tại'
		RETURN
	END

	--LẤY IDBILL CỦA BÀN MỚI
	DECLARE @idBillNew INT=-1
	SELECT @idBillNew=idBill
	FROM PDT_BILL
	WHERE idTable=@idTableNew

	--LẤY IDBILL CỦA BÀN cũ
	DECLARE @idBillOld INT=-1
	SELECT @idBillOld=idBill
	FROM PDT_BILL
	WHERE idTable=@idTableOld

	--Bắt đầu gộp bàn
	UPDATE PDT_BILLINFO
	SET idBill =@idBillNew
	WHERE idBill=@idBillOld
	--xóa bàn cũ đi
	DELETE PDT_BILL
	WHERE idTable=@idTableOld
END