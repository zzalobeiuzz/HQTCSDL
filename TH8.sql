﻿--1. Viết SP spTangLuong dùng để tăng lương lên 10% cho tất cả các nhân viên.
CREATE PROC spTangLuong
AS
BEGIN
    UPDATE NHANVIEN
    SET Luong = Luong * 1.1;
END
GO
--2. Thêm vào cột NgayNghiHuu (ngày nghỉ hưu) trong bảng NHANVIEN. Viết SP
--spNghiHuu dùng để cập nhật ngày nghỉ hưu là ngày hiện tại cộng thêm 100 (ngày) cho những
--nhân viên nam có tuổi từ 60 trở lên và nữ từ 55 trở lên.
CREATE PROC spNghiHuu
AS
BEGIN
    UPDATE NHANVIEN
    SET NGAYNGHIHUU = DATEADD(YEAR, 
                              CASE WHEN Phai = 'Nam' AND DATEDIFF(YEAR, NGSINH, GETDATE()) >= 60
                                   THEN 100
                                   WHEN Phai = 'Nữ' AND DATEDIFF(YEAR, NGSINH, GETDATE()) >= 55
                                   THEN 100
                                   ELSE 0
                              END, 
                              GETDATE())
END
GO

--3. Tạo SP spXemDeAn cho phép xem các đề án có địa điểm đề án được truyền vào khi
--gọi thủ tục.
CREATE PROCEDURE spXemDeAn
    @DiaDiem NVARCHAR(50)
AS
BEGIN
    SELECT *
    FROM DEAN
    WHERE DDIEM_DA = @DiaDiem
END
GO

--4. Tạo SP spCapNhatDeAn cho phép cập nhật lại địa điểm đề án với 2 tham số truyền
--vào là diadiem_cu, diadiem_moi.
CREATE PROCEDURE spCapNhatDeAn
    @DiaDiemCu NVARCHAR(50),
    @DiaDiemMoi NVARCHAR(50)
AS
BEGIN
    UPDATE DEAN
    SET DDIEM_DA = @DiaDiemMoi
    WHERE DDIEM_DA = @DiaDiemCu
END
GO

--5. Viết SP spThemDeAn để thêm dữ liệu vào bảng DEAN với các tham số vào là các
--trường của bảng DEAN.
CREATE PROCEDURE spThemDeAn
    @MaDeAn INT,
    @TenDeAn NVARCHAR(50),
    @DiaDiem NVARCHAR(50),
    @NgayBatDau DATETIME,
    @NgayKetThuc DATETIME
AS
BEGIN
    INSERT INTO DEAN(MADA, TENDA, DDIEM_DA, NGA, NgayKetThuc)
    VALUES(@MaDeAn, @TenDeAn, @DiaDiem, @NgayBatDau, @NgayKetThuc)
END
GO

--6. Cập nhật SP spThemDeAn ở câu trên để thỏa mãn ràng buộc sau: kiểm tra mã đề án có
--trùng với các mã đề án khác không. Nếu có thì thông báo lỗi “Mã đề án đã tồn tại, đề nghị chọn
--mã đề án khác”. Sau đó, tiếp tục kiểm tra mã phòng ban. Nếu mã phòng ban không tồn tại
--trong bảng PHONGBAN thì thông báo lỗi: “Mã phòng không tồn tại”. Thực thi thủ tục với 1
--trường hợp đúng và 2 trường hợp sai để kiểm chứng.
CREATE PROCEDURE spThemDeAn
    @MaDeAn INT,
    @TenDeAn NVARCHAR(50),
    @DiaDiem NVARCHAR(50),
    @phong int
AS
BEGIN
    IF EXISTS(SELECT 1 FROM DEAN WHERE MADA = @MaDeAn)
    BEGIN
        RAISERROR ('Mã đề án đã tồn tại, đề nghị chọn mã đề án khác',16,1)
        RETURN;
    END
    
    IF NOT EXISTS(SELECT 1 FROM PHONGBAN WHERE MAPHG = @phong)
BEGIN
        RAISERROR ('Mã phòng không tồn tại',16,1)
        RETURN;
    END
    
    INSERT INTO DEAN(TENDA, MADA, DDIEM_DA, PHONG)
    VALUES(@TenDeAn, @MaDeAn, @DiaDiem, @phong)
END
GO

--7. Tạo SP spXoaDeAn cho phép xóa các đề án với tham số truyền vào là Mã đề án. Lưu ý
--trước khi xóa cần kiểm tra mã đề án có tồn tại trong bảng PHANCONG hay không, nếu có thì
--viết ra thông báo và không thực hiện việc xóa dữ liệu.
CREATE PROCEDURE spXoaDeAn
    @MaDeAn INT
AS
BEGIN
    IF EXISTS(SELECT 1 FROM PHANCONG WHERE MADA = @MaDeAn)
    BEGIN
        RAISERROR ('Mã đề án đã tồn tại trong bảng PHANCONG',16,1)
        RETURN;
    END
    
    DELETE FROM DEAN WHERE MADA = @MaDeAn
END
GO

--8. Cập nhật SP spXoaDeAn cho phép xóa các đề án với tham số truyền vào là Mã đề án.
--Lưu ý trước khi xóa cần kiểm tra mã đề án có tồn tại trong bảng PHANCONG hay không, nếu
--có thì thực hiện xóa tất cả các dữ liệu trong bảng PHANCONG có liên quan đến mã đề án cần
--xóa, sau đó tiến hành xóa dữ liệu trong bảng DEAN.
CREATE PROCEDURE spXoaDeAn
    @MaDeAn INT
AS
BEGIN
    DELETE FROM PHANCONG WHERE MADA = @MaDeAn
    DELETE FROM DEAN WHERE MADA = @MaDeAn
END
GO

--9. Tạo SP spTongGioLamViec có tham số truyền vào là MaNV, tham số ra là tổng thời
--gian (tính bằng giờ) làm việc ở tất cả các dự án của nhân viên đó.
CREATE PROCEDURE spTongGioLamViec
@MaNV INT,
@TongThoiGian INT OUT
AS
BEGIN
SELECT @TongThoiGian = SUM(ThoiGian)
FROM PHANCONG
WHERE MA_NVIEN= @MaNV
END
GO

--10. Viết SP spTongTien để in ra màn hình tổng tiền phải trả cho nhân viên với tham số
--truyền vào là mã nhân viên. (Tổng tiền phải trả cho nhân viên = lương + lương đề án; lương đề
--án = 100000 đ x thời gian). Kết quả của thủ tục là dòng chữ: “Tổng tiền phải trả cho nhân viên
--‘333’ là 1200000 đồng.
CREATE PROCEDURE spTongTien
@MaNV INT
AS
BEGIN
DECLARE @TongTien INT
DECLARE @Luong INT
SELECT @Luong = Luong 
FROM NHANVIEN 
WHERE MaNV = @MaNV

SELECT @TongTien = @Luong + (100000 * SUM(ThoiGian))
FROM PHANCONG 
WHERE MA_NVIEN = @MaNV

PRINT 'Tổng tiền phải trả cho nhân viên ''' + CONVERT(VARCHAR, @MaNV) + ''' là ' + CONVERT(VARCHAR, @TongTien) + ' đồng.'
END
GO

--11. Viết SP spThemPhanCong để thêm dữ liệu vào bảng PHANCONG thỏa mãn yêu cầu
--sau: ThoiGian phải là một số dương, MaDA phải tồn tại ở bảng DEAN và MaNV phải tồn tại
--trong bảng NHANVIEN. Nếu không thỏa mãn phải thông báo lỗi tương ứng và không được
--phép thêm dữ liệu.
CREATE PROCEDURE spThemPhanCong
@MaNV INT,
@MaDA INT,
@ThoiGian INT
AS
BEGIN
IF @ThoiGian <= 0
BEGIN
PRINT 'Thời gian phải là một số dương.'
RETURN
END
IF NOT EXISTS (SELECT * FROM DEAN WHERE MADA = @MaDA)
BEGIN
    PRINT 'Mã đề án không tồn tại trong bảng DEAN.'
    RETURN
END

IF NOT EXISTS (SELECT * FROM NHANVIEN WHERE MaNV = @MaNV)
BEGIN
    PRINT 'Mã nhân viên không tồn tại trong bảng NHANVIEN.'
    RETURN
END

INSERT INTO PHANCONG (MA_NVIEN, MADA, ThoiGian)
VALUES (@MaNV, @MaDA, @ThoiGian)
END
