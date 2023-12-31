-- Họ và tên: Vũ Minh Phát
-- MSSV: 21127739
-- Ôn tập kiểm tra giữa kỳ - Đề 4

USE master
GO
DROP DATABASE QLTruongHoc
GO

CREATE DATABASE QLTruongHoc
GO
USE QLTruongHoc
GO

-- 1: Tạo bảng + khóa chính
CREATE TABLE LOPHOC (
	IDLopHoc char(5)
	, NamBD smallint
	, ChuNhiem char(5)
	, IDKhoa char(3)
	, SoLuong smallint

	, CONSTRAINT PK_LOPHOC PRIMARY KEY (IDLopHoc)
)

CREATE TABLE LICHDAY (
	IDLop char(5)
	, IDThuTiet char(10)
	, IDPhongHoc char(3)
	, GiaoVien char(5)
	, IDKhoa char(3)
	, ThoiLuong smallint
	, ThietBi nvarchar(20)

	, CONSTRAINT PK_LICHDAY PRIMARY KEY (IDLop, IDThuTiet, IDPhongHoc)
)

CREATE TABLE GIAOVIEN (
	IDKhoa char(3)
	, IDMaGV char(5)
	, HoTen nvarchar(30)
	, SoCMND char(10)
	, NgaySinh date
	, IDQuanLi char(5)
	
	, CONSTRAINT PK_GIAOVIEN PRIMARY KEY (IDMaGV, IDKhoa)
)

-- 2: Khóa ngoại
ALTER TABLE LOPHOC
ADD CONSTRAINT FK_LOPHOC_GIAOVIEN
FOREIGN KEY (ChuNhiem, IDKhoa)
REFERENCES GIAOVIEN(IDMaGV, IDKhoa)

ALTER TABLE LICHDAY
ADD CONSTRAINT FK_LICHDAY_GIAOVIEN
FOREIGN KEY (GiaoVien, IDKhoa)
REFERENCES GIAOVIEN(IDMaGV, IDKhoa)

ALTER TABLE LICHDAY
ADD CONSTRAINT FK_LICHDAY_LOPHOC
FOREIGN KEY (IDLop)
REFERENCES LOPHOC(IDLopHoc)

ALTER TABLE GIAOVIEN
ADD CONSTRAINT FK_GIAOVIEN_GIAOVIEN
FOREIGN KEY (IDQuanLi, IDKhoa)
REFERENCES GIAOVIEN(IDMaGV, IDKhoa)

-- 3: Nhập dữ liệu
INSERT INTO GIAOVIEN(IDKhoa, IDMaGV, HoTen, SoCMND, NgaySinh)
VALUES
	('2', '1716', N'Lê Quang Bảo', '240674063', NULL)
	, ('1', '0753', N'Hà Ngọc Thúy', '240674504', '1990-5-2') 

INSERT INTO GIAOVIEN
VALUES
	('1', '1716', N'Nguyễn Quan Tùng', '240674018', '1988-2-1', '0753')
	, ('2', '0357', N'Lưu Phi Nam', '240674027', '1980-7-20', '1716')
	, ('1', '0357', N'Trương Thị Minh', '240674405', NULL, '0753')
	, ('1', '1718', N'Ngô Thị Thủy', '240674306', NULL, '0357')
	
INSERT INTO LOPHOC(IDLopHoc, NamBD, ChuNhiem, IDKhoa)
VALUES
	('L01', 2015, '0357', '2')
	, ('L02', 2013, '1716', '1')
	
INSERT INTO LICHDAY(IDLop, IDThuTiet, IDPhongHoc, GiaoVien, IDKhoa, ThoiLuong)
VALUES
	('L01', 'T2(1-6)', '2', '1718', '1', 10)
	, ('L02', 'T2(7-12)', '1', '0753', '1', 30)
	, ('L01', 'T4(4-6)', '5', '0357', '2', 25)

-- 4: GV chủ nhiệm + tuổi của lớp có lịch dạy tiết 6
SELECT DISTINCT GV.*
	 , DATEDIFF(YYYY, GV.NgaySinh, GETDATE()) Tuoi_GV
  FROM GIAOVIEN GV
  JOIN LOPHOC LH ON LH.ChuNhiem=GV.IDMaGV AND LH.IDKhoa=GV.IDKhoa
  JOIN LICHDAY LD ON LD.IDLop = LH.IDLopHoc
 WHERE LD.IDThuTiet LIKE '%-6)'

-- 5: Tên GV + tên người QL chưa cung cấp ngày sinh
SELECT GV.HoTen TEN_GV
	 , NQL.HoTen TEN_NGUOI_QL
  FROM GIAOVIEN GV
  LEFT JOIN GIAOVIEN NQL ON NQL.IDMaGV=GV.IDQuanLi AND NQL.IDKhoa=GV.IDKhoa
 WHERE GV.NgaySinh IS NULL
 
