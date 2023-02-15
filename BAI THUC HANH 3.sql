CREATE DATABASE MarkManagement

CREATE TABLE Students(
	StudentID Nvarchar(12) PRIMARY KEY,
	StudentName Nvarchar(25) NOT NULL,
	DateofBirth Datetime NOT NULL,
	Email Nvarchar(40),
	Phone Nvarchar(12),
	Class Nvarchar(10)
	)

CREATE TABLE Subjects(
	SubjectID Nvarchar(10) PRIMARY KEY,
	SubjectName Nvarchar(25) NOT NULL
	)

CREATE TABLE Mark(
	StudentID Nvarchar(12),
	SubjectID Nvarchar(10),
	Date Datetime ,
	Theory Tinyint,
	Practical Tinyint
	PRIMARY KEY (StudentID, SubjectID)
	)

INSERT INTO Students 
VALUES ('AV0807005', N'Mail Trung Hiếu', '11/10/1989', 'trunghieu@yahoo.com', '0904115116', 'AV1'),
		('AV0807006', N'Nguyễn Quý Hùng', '2/12/1988', 'quyhung@yahoo.com', '0955667787', 'AV2'),
		('AV0807007', N'Đỗ Đắc Huỳnh', '2/1/1990', 'dachuynh@yahoo.com', '0988574747', 'AV2'),
		('AV0807009', N'An Đăng Khuê', '6/3/1986', 'dangkhue@yahoo.com', '0986757463', 'AV1'),
		('AV0807010', N'Nguyễn T. Tuyết Lan', '12/7/1989', 'tuyetlan@gmail.com', '0983310342', 'AV2'),
		('AV0807011', N'Đinh Phụng Long', '2/12/1990', 'phunglong@yahoo.com', NULL, 'AV1'),
		('AV0807012', N'Nguyễn Tuấn Nam', '2/3/1990', 'tuannam@yahoo.com', NULL, 'AV1');

INSERT INTO Subjects 
VALUES ('S001', 'SQL'),
		('S002', 'Java Simplefield'),
		('S003', 'Active Server Page');

INSERT INTO Mark 
VALUES ('AV0807005', 'S001', '6/5/2008', 8, 25),
		('AV0807006', 'S002', '6/5/2008', 16, 30),
		('AV0807007', 'S001','6/5/2008', 10, 25),
		('AV0807010', 'S003', '6/5/2008', 9, 16),
		('AV0807011', 'S002', '6/5/2008', 8, 30),
		('AV0807012', 'S001', '6/5/2008', 7, 31),
		('AV0807005', 'S002', '6/6/2008', 12, 11),
		('AV0807009', 'S003', '6/6/2008', 11, 20),
		('AV0807010', 'S001', '6/6/2008', 7, 6);

--1. Hiển thị nội dung bảng Students
SELECT * FROM Students

--2. Hiển thị nội dung danh sách sinh viên lớp AV1
SELECT * FROM Students WHERE Class = 'AV1'

--3. Sử dụng lệnh UPDATE để chuyển sinh viên có mã AV0807012 sang lớp AV2
UPDATE Students
	SET Class = 'AV2'
	WHERE StudentID= 'AV0807012'

--4. Tính tổng số sinh viên của từng lớp
SELECT Class AS LỚP,COUNT(*)AS 'SỐ LƯỢNG SV' FROM Students GROUP BY Class

-- 5. Hiển thị danh sách sinh viên lớp AV2 được sắp xếp tăng dần theo StudentName
SELECT * FROM Students WHERE Class = 'AV2' ORDER BY StudentName ASC;

--6. Hiển thị danh sách sinh viên không đạt lý thuyết môn S001 (theory <10) thi ngày 6/5/2008
SELECT StudentName 
FROM Students	S INNER JOIN Mark M 
ON S.StudentID = M.StudentID 
WHERE M.SubjectID = 'S001' AND  M.theory < 10 AND M.Date = '2008/5/6'
ORDER BY StudentName ASC;

--7. Hiển thị tổng số sinh viên không đạt lý thuyết môn S001. (theory <10)
SELECT COUNT(*) AS 'SỐ LƯỢNG SINH VIÊN KHÔNG ĐẠT'
FROM Students S INNER JOIN Mark M
ON S.StudentID = M.StudentID
WHERE M.SubjectID = 'S001' AND  M.theory < 10 

--8. Hiển thị Danh sách sinh viên học lớp AV1 và sinh sau ngày 1/1/1980
SELECT * 
FROM Students 
WHERE Class = 'AV1' AND DateofBirth > '1980/1/1';

--9. Xoá sinh viên có mã AV0807011
DELETE 
FROM Students 
WHERE StudentID = 'AV0807011';

--10.Hiển thị danh sách sinh viên dự thi môn có mã S001 ngày 6/5/2008 bao gồm các trường sau: StudentID, StudentName, SubjectName, Theory, Practical, Date
SELECT Students.StudentID, StudentName, SubjectName, Theory, Practical, Date 
FROM Mark 
INNER JOIN Subjects ON Mark.SubjectID = Subjects.SubjectID 
INNER JOIN Students ON Mark.StudentID = Students.StudentID 
WHERE Subjects.SubjectID = 'S001' AND Date = '2008/05/06';