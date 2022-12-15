---------------------------CÂU 1-------------------------
CREATE DATABASE QLDIEM


CREATE TABLE MonHoc(
	MaMon VARCHAR(4) PRIMARY KEY,
	TenMon NVARCHAR(30),
	SoTC INT
	)

CREATE TABLE SinhVien(
	MaSV VARCHAR(4) PRIMARY KEY,
	HoTen NVARCHAR(30),
	NgaySinh DATE
	)

CREATE TABLE Diem(
	MaSV VARCHAR(4),
	MaMon VARCHAR(4),
	DiemThi FLOAT,
	CONSTRAINT FK_MaSV FOREIGN KEY (MaSV) REFERENCES SinhVien(MaSV),
	CONSTRAINT FK_MaMon FOREIGN KEY (MaMon) REFERENCES MonHoc(MaMon),
	CONSTRAINT PK_MaSV_MaMon PRIMARY KEY(MaSV,MaMon)
	)
GO
-------Nhập dữ liệu----
INSERT MonHoc VALUES
('01',N'TOÁN',3),
('02',N'VĂN',2),
('03',N'NGOẠI NGỮ',3)
GO

INSERT SinhVien VALUES
('SV01',N'PHẠM TRỌNG HUYNH','04/02/1990'),
('SV02',N'TRẦN VĂN DŨNG','05/10/1992'),
('SV03',N'NGUYỄN THANH THIỆN','11/11/1992')
GO

INSERT Diem VALUES
('SV01','01',0.1),
('SV01','02',0),
('SV01','03',3),
('SV03','02',5),
('SV02','01',2)
GO

---------Xem dữ liệu 3 bảng-----------
SELECT *FROM MonHoc
GO
SELECT *FROM Diem
GO
SELECT *FROM SinhVien
GO

--DROP TABLE Diem
--DROP TABLE SinhVien
--DROP TABLE MonHoc
---------------------CÂU 2---------------------
create function thongke (@tmh nvarchar(20))
returns int
as
begin
 declare @dem int
 set @dem = (select count(@tmh) from Diem join MonHoc on MonHoc.MaMon = Diem.MaMon where Diem.DiemThi<5)
 return @dem
end
GO
select dbo.thongke('Toán')
GO
----------------CÂU 3---------------------
create procedure NhapDiem(@MaSV char(5),@MaMon char(5), @DiemThi float)
as
insert into Diem(MaSV,MaMon,Diemthi) values(@MaSV,@MaMon,@DiemThi)
go
nhapDiem 'SV05','03',5
go

--------------CÂU 4---------------------
create trigger them_sua
on Diem
FOR  INSERT, UPDATE
AS
if(select DiemThi From inserted)>10 and (select DiemThi From inserted)<0
begin
print
'khong cho phep'
rollback transaction
end
insert into Diem
values ('SV05','03',5)