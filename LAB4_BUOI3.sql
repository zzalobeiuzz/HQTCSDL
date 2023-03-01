--1. Liệt kê danh sách tất cả các nhân viên
SELECT * FROM NHANVIEN
GO

--2. Tìm các nhân viên làm việc ở phòng số 5
SELECT * FROM NHANVIEN
WHERE PHG = 5
GO

--3. Liệt kê họ tên và phòng làm việc các nhân viên có mức lương trên 6.000.000 đồng
SELECT HONV+' '+TENLOT+' '+TENNV AS 'HỌ VÀ TÊN' FROM NHANVIEN
WHERE LUONG>=6000000
GO

--4. Tìm các nhân viên có mức lương trên 6.500.000 ở phòng 1 hoặc các nhân viên có mức lương trên 5.000.000 ở phòng 4
SELECT * FROM NHANVIEN 
WHERE PHG = 1 AND LUONG > 6500000 OR PHG = 4 AND LUONG > 5000000
GO

--5. Cho biết họ tên đầy đủ của các nhân viên ở TP Quảng Ngãi
SELECT HONV+' '+TENLOT+' '+TENNV AS 'HỌ VÀ TÊN' FROM NHANVIEN
WHERE DCHI LIKE N'%TP QUẢNG NGÃI'
GO

--6. Cho biết họ tên đầy đủ của các nhân viên có họ bắt đầu bằng ký tự 'N';
SELECT HONV+' '+TENLOT+' '+TENNV AS 'HỌ VÀ TÊN' FROM NHANVIEN
WHERE HONV LIKE N'N%'
GO

--7. Cho biết ngày sinh và địa chỉ của nhân viên Cao Thanh Huyền
SELECT NGSINH, DCHI FROM NHANVIEN
WHERE HONV = N'CAO' AND TENLOT = N'THANH' AND TENNV = N'HUYỀN'
GO

--8. Cho biết các nhân viên có năm sinh trong khoảng 1955 đến 1975
SELECT * FROM NHANVIEN
WHERE YEAR(NGSINH) BETWEEN 1955 AND 1975 
GO

--9. Cho biết các nhân viên và năm sinh của nhân viên
SELECT HONV+' '+TENLOT+' '+TENNV AS 'HỌ VÀ TÊN', YEAR(NGSINH) AS 'NĂM SINH' FROM NHANVIEN 
GO

--10. Cho biết họ tên và tuổi của tất cả các nhân viên
SELECT HONV+' '+TENLOT+' '+TENNV AS 'HỌ VÀ TÊN', YEAR(GETDATE) - YEAR(NGSINH) AS 'TUỔI' FROM NHANVIEN
GO

--11. Tìm tên những người trưởng phòng của từng phòng ban
SELECT HONV+ ' ' +TENLOT+ ' ' +TENNV AS 'Họ Và Tên Trưởng Phòng' FROM PHONGBAN, NHANVIEN
WHERE MANV = TRPHG
GO

--12. Tìm tên và địa chỉ của tất cả các nhân viên của phòng "Điều hành"
SELECT HONV+' '+TENLOT+' '+TENNV AS 'HỌ VÀ TÊN', DCHI AS 'ĐỊA CHỈ' 
FROM NHANVIEN,PHONGBAN
WHERE PHG = MAPHG AND TENPHONG LIKE N'Điều hành'
GO

--13. Với mỗi đề án ở Tp Quảng Ngãi, cho biết tên đề án, tên phòng ban, họ tên và ngày nhận chức của trưởng phòng của phòng ban chủ trì đề án đó.
go
	select TENDEAN,TENPHG,HONV,TENNV
	from NHANVIEN,PHONGBAN,DEAN
	where NHANVIEN.MANV = PHONGBAN.TRPHG and PHONGBAN.MAPHG = DEAN.PHONG and DEAN.DDIEM_DA like N'Quảng Ngãi'

	select*
	from phongban
	select*
	from DEAN
go
--14. Tìm tên những nữ nhân viên và tên người thân của họ
go
	select TENNV,TENTN
	from NHANVIEN,THANNHAN
	where NHANVIEN.MANV = THANNHAN.MA_NVIEN and NHANVIEN.PHAI like N'Nữ'
go
--15. Với mỗi nhân viên, cho biết họ tên của nhân viên, họ tên trưởng phòng của phòng ban mà nhân viên đó đang làm việc.
go
	select nv.HONV+ ' ' +nv.TENLOT+ ' ' +nv.TENNV as 'Họ Và Tên nv', tp.HONV+ ' ' +tp.TENLOT+ ' ' +tp.TENNV as 'Họ Và Tên Trưởng Phòng'
	from NHANVIEN nv,NHANVIEN tp , PHONGBAN pb
	where tp.MANV= pb.TRPHG and pb.MAPHG=nv.PHG

go
--16. Tên những nhân viên phòng Nghiên cứu có tham gia vào đề án "Xây dựng nhà máy chế biến thủy sản".

--17. Cho biết tên các đề án mà nhân viên Trần Thanh Tâm đã tham gia.
go
	select DEAN.TENDA
	from NHANVIEN,PHANCONG,DEAN
	where NHANVIEN.MANV = PHANCONG.MA_NVIEN and PHANCONG.MADA= DEAN.MADA and HONV = N'Trần' and TENLOT=N'Thanh' and TENNV=N'Tâm'
go