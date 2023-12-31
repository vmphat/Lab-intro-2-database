-- Họ và tên: Vũ Minh Phát
-- MSSV: 21127739
-- Ôn tập GK - Đề 1

USE master
GO
DROP DATABASE QLCongViec
GO

CREATE DATABASE QLCongViec
GO
USE QLCongViec
GO

-- 1. Tạo bảng + khóa chính
CREATE TABLE DOI (
	IDDoi char(3)
	, TenDoi nvarchar(20)
	, DoiTruong char(3)
	, SoLuong smallint

	, CONSTRAINT PK_DOI PRIMARY KEY (IDDoi)
)

CREATE TABLE BOTRI (
	IDDoi char(3)
	, IDThanhVien char(3)
	, DiaChi nvarchar(30)
	, NhiemVu nvarchar(30)
	, QuanLi char(3)
	
	, CONSTRAINT PK_BOTRI PRIMARY KEY (IDDoi, IDThanhVien)
	, UNIQUE (IDThanhVien)
)

CREATE TABLE THANHVIEN (
	IDThanhVien char(3)
	, HoTen nvarchar(30)
	, SoCMND char(10)
	, DiaChi nvarchar(20)
	, NgaySinh date
	
	, CONSTRAINT PK_THANHVIEN PRIMARY KEY (IDThanhVien)
)

-- 2. Khóa ngoại
ALTER TABLE DOI
ADD CONSTRAINT FK_DOI_BOTRI
FOREIGN KEY (IDDoi, DoiTruong)
REFERENCES BOTRI(IDDoi, IDThanhVien)

ALTER TABLE BOTRI
ADD CONSTRAINT FK_BOTRI_DOI
FOREIGN KEY (IDDoi)
REFERENCES DOI(IDDoi)

ALTER TABLE BOTRI
ADD FOREIGN KEY (IDThanhVien)
REFERENCES THANHVIEN(IDThanhVien)

ALTER TABLE BOTRI
ADD FOREIGN KEY (IDDoi, QuanLi)
REFERENCES BOTRI(IDDoi, IDThanhVien)

-- 3. Nhập dữ liệu
INSERT INTO THANHVIEN
VALUES
	('1', N'Nguyễn Quan Tùng', '240674018', 'TPHCM', '2000-1-30')
	, ('2', N'Lưu Phi Nam', '240674027', N'Quảng Nam', '2001-3-12')
	, ('3', N'Lê Quang Bảo', '240674063', N'Quảng Ngãi', '1999-5-14')
	, ('4', N'Hà Ngọc Thúy', '240674504', 'TPHCM', '1998-7-26')
	, ('5', N'Trương Thị Minh', '240674405', N'Hà Nội', NULL)
	, ('6', N'Ngô Thị Thủy', '240674306', NULL, '2000-9-18')

INSERT INTO DOI(IDDoi, TenDoi, DoiTruong)
VALUES
	('2', N'Đội Tân Phú', NULL)
	, ('7', N'Đội Bình Phú', NULL)

INSERT INTO BOTRI
VALUES
	('2', '1', N'45 Phú Thọ Hòa Tân Phú', N'Theo dõi hoạt động', '1')
	, ('2', '2', N'123 Vườn Lài Tân Phú', N'Trực khu vực vòng xoay 1', '1')
	, ('7', '5', N'1Bis Trần Đình Xu Q1', NULL, NULL)
	, ('7', '3', N'11 Chợ lớn Bình Phú', NULL, '5')
	, ('7', '4', N'2 Bis Nguyễn Văn Cừ Q5', NULL, '3')

UPDATE DOI
SET DoiTruong = '1'
WHERE IDDoi = '2'

UPDATE DOI
SET DoiTruong = '5'
WHERE IDDoi = '7'

-- 4. Tên đội, tên đội trưởng của tv t/hiện nv tại Tân Phú
SELECT DISTINCT D.TenDoi
	 , TV.HoTen TenDoiTruong
  FROM BOTRI BT 
  JOIN DOI D ON D.IDDoi = BT.IDDoi
  JOIN THANHVIEN TV ON TV.IDThanhVien = D.DoiTruong
 WHERE BT.DiaChi LIKE '% Tân Phú'

-- 5. Tên QL và slg tv có cung cấp ngày sinh
SELECT QL.HoTen TenQL
	 , COUNT(BT.IDThanhVien) SL_TV_CoCungCap_NgaySinh
  FROM THANHVIEN QL
  JOIN BOTRI BT ON BT.QuanLi = QL.IDThanhVien
  JOIN THANHVIEN TV ON TV.IDThanhVien = BT.IDThanhVien
 WHERE TV.NgaySinh IS NOT NULL
 GROUP BY QL.HoTen

