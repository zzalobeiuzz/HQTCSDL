------------------------------------Bài 1------------------------------------------
-------------------Nhập vào MaNV cho biết tuổi của nhân viên này.------------------
CREATE FUNCTION MANV_TUOI(@MaNV varchar(4))
RETURNS INT
AS
	BEGIN
		RETURN (SELECT YEAR(GETDATE())-YEAR(NGSINH)
		FROM NHANVIEN
		WHERE MANV = @MaNV)
	END
GO
PRINT DBO.MANV_TUOI('001')
GO


-----------------Nhập vào Manv cho biết số lượng đề án nhân viên này đã tham gia-------------
CREATE FUNCTION MANV_DEAN(@MaNV varchar(4))
RETURNS INT
AS
	BEGIN
		RETURN (SELECT COUNT(*)
		FROM PHANCONG
		WHERE MA_NVIEN = @MaNV
		)
	END
GO

PRINT DBO.MANV_DEAN('001')
GO

------------------- Truyền tham số vào phái nam hoặc nữ, xuất số lượng nhân viên theo phái------------------
CREATE FUNCTION  SL_NV_PHAI(@Phai nvarchar(3))
RETURNS INT 
AS 
	BEGIN
		RETURN(SELECT COUNT (*)
		FROM NHANVIEN
		WHERE PHAI LIKE @Phai)
	END
GO

PRINT DBO.SL_NV_PHAI(N'NỮ')
GO

---------------------------Truyền tham số đầu vào là tên phòng, tính mức lương trung bình của phòng đó, Cho biết
-------------------------họ tên nhân viên (HONV, TENLOT, TENNV) có mức lương trên mức lương trung bình của phòng đó.
create function Luong_NhanVien_PB(@TenPhongBan nvarchar(20))
returns @tbLuongNV table(FULLNAME nvarchar (50) , LUONG float)
as 
	begin
		declare @LuongTB float
		select @LuongTB = AVG(LUONG) from NHANVIEN
		inner join PHONGBAN on PHONGBAN.MAPHG = NHANVIEN.PHG
		where TENPHG = @TenPhongBan
		insert into @tbLuongNV
			select HONV+' '+TENLOT+' '+TENNV, LUONG from NHANVIEN
			where LUONG > @LuongTB
		return
	end
GO

SELECT*FROM dbo.Luong_NhanVien_PB('CNTT')
GO
-------------Tryền tham số đầu vào là Mã Phòng, cho biết tên phòng ban, họ tên người trưởng phòng và số lượng đề án mà phòng ban đó chủ trì.------
if object_id('fn_soLuongDeAnTheoPB') is not null
	drop function fn_soLuongDeAnTheoPB
	go
CREATE FUNCTION fn_soLuongDeAnTheoPB(@MaPB int)
returns @tbListPB table(TenPB nvarchar(20), MATP nvarchar(10), TenTP nvarchar(50), soLuong int)
as 
begin
	insert into @tbListPB
	SELECT TENPHG, TRPHG, HONV + ' ' + TENLOT + ' ' + TENNV as 'Ten truong phong', 
	COUNT(MADA) as 'SOLUONGDEAN' FROM PHONGBAN
		INNER JOIN DEAN ON DEAN.PHONG = PHONGBAN.MAPHG
		INNER JOIN NHANVIEN ON NHANVIEN.MANV = PHONGBAN.TRPHG
		WHERE PHONGBAN.MAPHG = @MaPB
		GROUP BY TENPHG, TRPHG, TENNV, HONV, TENLOT
	return
end

select * from dbo.fn_soLuongDeAnTheoPB(1)

---------------------------------------Bài 2--------------------------
----------------Hiển thị thông tin HoNV,TenNV,TenPHG, DiaDiemPhg.----------------
select HONV,TENPHG,DIADIEM from PHONGBAN
inner join DIADIEM_PHG on DIADIEM_PHG.MAPHG = PHONGBAN.MAPHG
inner join NHANVIEN on NHANVIEN.PHG = PHONGBAN.MAPHG

create view v_DD_PhongBan
as
select HONV,TENPHG,DIADIEM from PHONGBAN
inner join DIADIEM_PHG on DIADIEM_PHG.MAPHG = PHONGBAN.MAPHG
inner join NHANVIEN on NHANVIEN.PHG = PHONGBAN.MAPHG

select * from v_DD_PhongBan

---------------------------Hiển thị thông tin TenNv, Lương, Tuổi.-------------------------
select TENNV,LUONG,YEAR(GETDATE())-YEAR(NGSINH)as 'Tuoi' from NHANVIEN

create view v_TuoiNV
as
select TENNV,LUONG,YEAR(GETDATE())-YEAR(NGSINH)as 'Tuoi' from NHANVIEN

select * from v_TuoiNV

------------------------------Hiển thị tên phòng ban và họ tên trưởng phòng của phòng ban có đông nhân viên nhất----------------------
select top(1) TENPHG,TRPHG,B.HONV+' '+B.TENLOT+' '+B.TENNV as 'TenTP',COUNT(A.MANV)as 'SoLuongNV' from NHANVIEN A
inner join PHONGBAN on PHONGBAN.MAPHG = A.PHG
inner join NHANVIEN B on B.MANV = PHONGBAN.TRPHG
group by TENPHG,TRPHG,B.TENNV,B.HONV,B.TENLOT
order by SoLuongNV desc

create view v_TopSoLuongNV_PB
as
select top(1) TENPHG,TRPHG,B.HONV+' '+B.TENLOT+' '+B.TENNV as 'TenTP',COUNT(A.MANV)as 'SoLuongNV' 
from NHANVIEN A
inner join PHONGBAN on PHONGBAN.MAPHG = A.PHG
inner join NHANVIEN B on B.MANV = PHONGBAN.TRPHG
group by TENPHG,TRPHG,B.TENNV,B.HONV,B.TENLOT
order by SoLuongNV desc

select * from v_TopSoLuongNV_PB
