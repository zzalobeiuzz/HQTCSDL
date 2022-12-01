---------------------------------------------- Câu 1 ----------------------------------------------
--------------Ràng buộc khi thêm mới nhân viên thì mức lương phải lớn hơn 15000, nếu vi phạm thì xuất thông báo “luong phải >15000’----------------------------
CREATE TRIGGER THEMNV ON NHANVIEN FOR INSERT 
AS 
IF (SELECT LUONG FROM INSERTED )<15000
BEGIN 
PRINT 'LƯƠNG PHẢI >15000'
ROLLBACK TRANSACTION 
END
GO

INSERT INTO NHANVIEN VALUES (N'TRẦN',N'QUỐC',N'HUY','080',CAST('1967-10-20' AS DATE),N'230 LÊ VĂN SỸ,TP HCM','NAM',30000,'001	',4)
GO



-------------------------  Ràng buộc khi thêm mới nhân viên thì độ tuổi phải nằm trong khoảng 18 <= tuổi <=65.----------------------------------
CREATE TRIGGER CHECK_THEMNV ON NHANVIEN FOR INSERT AS 
DECLARE @TUOI INT
SET @TUOI=YEAR(GETDATE()) - (SELECT YEAR(NGSINH) FROM INSERTED)
IF (@TUOI < 18 OR @TUOI > 65 )
BEGIN
PRINT'YÊU CẦU NHẬP TUỔI TỪ 18 ĐẾN 65'
ROLLBACK TRANSACTION 
END
GO

INSERT INTO NHANVIEN VALUES (N'LÊ',N'AN',N'SƠN','011',CAST('1970-10-20' AS DATE),N'200 LÊ VĂN SỸ,TP HCM','NAM',300000,'011',4)
GO



--------------------------------------- Ràng buộc khi cập nhật nhân viên thì không được cập nhật những nhân viên ở TP HCM-----------------------
CREATE TRIGGER UPDATE_NV ON NHANVIEN FOR UPDATE AS
IF (SELECT DCHI FROM INSERTED ) LIKE '%TP HCM%'
BEGIN
PRINT'KHÔNG THỂ CẬP NHẬT'
ROLLBACK TRANSACTION
END
UPDATE NHANVIEN SET TENNV='NHƯ' WHERE MANV ='001'
GO


---------------------------------------------- Câu 2 ----------------------------------------------
----------------------------Hiển thị tổng số lượng nhân viên nữ, tổng số lượng nhân viên nam mỗi khi có hành động thêm mới nhân viên.----------------
CREATE TRIGGER TRG_TONGNV
   ON NHANVIEN
   AFTER INSERT
AS
   DECLARE @MALE INT, @FEMALE INT;
   SELECT @FEMALE = COUNT(MANV) FROM NHANVIEN WHERE PHAI = N'NỮ';
   SELECT @MALE = COUNT(MANV) FROM NHANVIEN WHERE PHAI = N'NAM';
   PRINT N'TỔNG SỐ NHÂN VIÊN LÀ NỮ: ' + CAST(@FEMALE AS VARCHAR);
   PRINT N'TỔNG SỐ NHÂN VIÊN LÀ NAM: ' + CAST(@MALE AS VARCHAR);

INSERT INTO NHANVIEN VALUES ('LÊ','XUÂN','HIỆP','033','7-12-1999','TP HCM','NAM',60000,'003',1)
GO


 --------------------Hiển thị tổng số lượng nhân viên nữ, tổng số lượng nhân viên nam mỗi khi có hành động cập nhật phần giới tính nhân viên--------------
CREATE TRIGGER TRG_TONGNVSAUUPDATE
   ON NHANVIEN
   AFTER UPDATE
AS
   IF (SELECT TOP 1 PHAI FROM DELETED) != (SELECT TOP 1 PHAI FROM INSERTED)
   BEGIN
      DECLARE @MALE INT, @FEMALE INT;
      SELECT @FEMALE = COUNT(MANV) FROM NHANVIEN WHERE PHAI = N'NỮ';
      SELECT @MALE = COUNT(MANV) FROM NHANVIEN WHERE PHAI = N'NAM';
      PRINT N'TỔNG SỐ NHÂN VIÊN LÀ NỮ: ' + CAST(@FEMALE AS VARCHAR);
      PRINT N'TỔNG SỐ NHÂN VIÊN LÀ NAM: ' + CAST(@MALE AS VARCHAR);
   END;
UPDATE NHANVIEN
   SET HONV = 'LÊ',PHAI = N'NỮ'
 WHERE  MANV = '010'

GO


---------------------Hiển thị tổng số lượng đề án mà mỗi nhân viên đã làm khi có hành động xóa trên bảng DEAN-------------------
CREATE TRIGGER TRG_TONGNVSAUXOA ON DEAN
AFTER DELETE
AS
BEGIN
   SELECT MA_NVIEN, COUNT(MADA) AS 'SỐ ĐỀ ÁN ĐÃ THAM GIA' FROM PHANCONG
      GROUP BY MA_NVIEN
	  END
	  SELECT * FROM DEAN
INSERT INTO DEAN VALUES ('SQL', 50, 'HH', 4)
DELETE FROM DEAN WHERE MADA=50
GO


---------------------------------------------- Câu 3 ----------------------------------------------
-----------------Xóa các thân nhân trong bảng thân nhân có liên quan khi thực hiện hành động xóa nhân viên trong bảng nhân viên.-----------------
CREATE TRIGGER DELETE_THANNHAN ON NHANVIEN
INSTEAD OF DELETE
AS
BEGIN
DELETE FROM THANNHAN WHERE MA_NVIEN IN(SELECT MANV FROM DELETED)
DELETE FROM NHANVIEN WHERE MANV IN(SELECT MANV FROM DELETED)
END
INSERT INTO THANNHAN VALUES ('031', 'KHANG', 'NAM', '03-10-2017', 'CON')
DELETE NHANVIEN WHERE MANV='031'
GO



--------------=----Khi thêm một nhân viên mới thì tự động phân công cho nhân viên làm đề án có MADAlà 1.----------------
CREATE TRIGGER NHANVIEN3 ON NHANVIEN
AFTER INSERT 
AS
BEGIN
INSERT INTO PHANCONG VALUES ((SELECT MANV FROM INSERTED), 1,2,20)
END
INSERT INTO NHANVIEN VALUES ('LÊ','XUÂN','HIỆP','031','7-12-1999','HÀ NỘI','NAM',60000,'003',1)
