
CREATE DATABASE Sales
 ON
 PRIMARY
 (
	NAME = tuan1_data,
	FILENAME = 'C:\Nam_3\Hệ quản trị cơ sở dữ liệu\THUC_HANH\BUOI 1\tuan1_data.mdf&#39',
	SIZE = 10MB,
	MAXSIZE = 20MB,
	FILEGROWTH = 20%
 )
 LOG ON
 (
	NAME = tuan1_log,
	FILENAME = 'C:\Nam_3\Hệ quản trị cơ sở dữ liệu\THUC_HANH\BUOI 1\tuan1_log.ldf&#39',
	SIZE = 10MB,
	MAXSIZE = 20MB,
 FILEGROWTH = 20%
)

--1. Tạo các kiểu dữliêụ người dùng sau:
USE Sales

EXEC sp_addtype 'Mota', 'nvarchar(40)' 
EXEC sp_addtype 'IDKH', 'char(10)', 'Not null'
EXEC sp_addtype 'DT' , 'char(12)'

--2. Taọ các bảng theo cấu trúc sau:

CREATE TABLE SANPHAM(
	MASP CHAR(6) NOT NULL PRIMARY KEY,
	TENSP VARCHAR(20),
	NGAYNHAP DATE,
	DVT CHAR(10),
	SOLUONGTON INT,
	DONGIANHAP MONEY
	)

CREATE TABLE HOADON(
	MAHD CHAR(10) NOT NULL PRIMARY KEY,
	NGAYLAP DATE,
	NGAYGIAO DATE,
	MAKH IDKH,
	DIENGIAI Mota
	)

CREATE TABLE KHACHHANG(
	MAKH IDKH PRIMARY KEY,
	TENKH NVARCHAR(30),
	DIACHI NVARCHAR(40),
	DIENTHOAI DT
	)

CREATE TABLE CHITIETHD(
	MAHD CHAR(10) NOT NULL PRIMARY KEY,
	MASP CHAR(6),
	SOLUONG INT
	)

--3. Trong Table HoaDon, sửa cột DienGiai thành nvarchar(100).
ALTER TABLE HOADON
ALTER COLUMN DIENGIAI NVARCHAR(100)

--4. Thêm vào bảng SanPham cột TyLeHoaHong float
ALTER TABLE SANPHAM
ADD TYLEHOAHONG FLOAT

--5. Xóa cột NgayNhap trong bảng SanPham
ALTER TABLE SANPHAM
DROP COLUMN NGAYNHAP

--6. Tạo các ràng buộc khóa chính và khóa ngoại cho các bảng trên	
ALTER TABLE HOADON
ADD
CONSTRAINT fk_khachhang_hoadon FOREIGN KEY(MAKH) REFERENCES KHACHHANG(MAKH)

ALTER TABLE CHITIETHD
ADD
CONSTRAINT fk_hoadon_chitiethd FOREIGN KEY(MAHD) REFERENCES HoaDon(MAHD)

ALTER TABLE CHITIETHD
ADD
CONSTRAINT fk_sanpham_chitiethd FOREIGN KEY(MASP) REFERENCES SANPHAM(MASP)


--7. Thêm vào bảng HoaDon các ràng buộc sau:
-- NgayGiao >= NgayLap
-- MaHD gồm 6 ký tự, 2 ký tự đầu là chữ, các ký tự còn lại là số
-- Giá trị mặc định ban đầu cho cột NgayLap luôn luôn là ngày hiện hành

ALTER TABLE HOADON
ADD CONSTRAINT CHECK_NGAYGIAO CHECK (NGAYGIAO> = NGAYLAP);

ALTER TABLE HOADON
ADD CONSTRAINT CHECK_KITU CHECK ( MAHD LIKE '[A-Z][A-Z][0-9][0-9][0-9][0-9]')

ALTER TABLE HoaDon
ADD CONSTRAINT df_ngaylap DEFAULT GETDATE() FOR NGAYLAP

--8.Thêm vào bảng Sản phẩm các ràng buộc
ALTER TABLE SANPHAM
ADD CHECK (SOLUONGTON > 0 and SOLUONGTON < 50)

ALTER TABLE SANPHAM
ADD CHECK (DONGIANHAP > 0)

ALTER TABLE SANPHAM
ADD CONSTRAINT df_ngaynhap DEFAULT GETDATE() FOR NGAYNHAP

ALTER TABLE SANPHAM
ADD CHECK (DVT = N'KG' OR DVT = N'Thùng' OR DVT = N'Hộp' OR DVT = N'Cái')

--9. Dùng lệnh T-SQL nhập dữ liệu vào 4 table trên, dữ liệu tùy ý, chú ý các ràng buộc của mỗi Table
INSERT  INTO SANPHAM 
VALUES ('SP01','BIA TIGER',N'Thùng',42,'310000','7.0'), 
		('SP02','BÁNH BAO',N'Hộp',21,'50000','1.0'),
		('SP03','KẸO DỪA',N'Hộp',5,'20000','3.0'),
		('SP04','GẠO',N'KG',30,'600000','3.2')
