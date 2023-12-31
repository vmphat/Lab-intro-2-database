-- Mã đề: 4
-- Mã lớp: 21CLC01 (chiều T2)
-- MSSV: 21127739
-- Vị trí: cột 6 hàng 2

-- Họ và tên: Vũ Minh Phát

-- Tạo db
USE master
GO
DROP DATABASE QLThuVien
GO

CREATE DATABASE QLThuVien
GO
USE QLThuVien
GO

-- 1. Tạo bảng + Khóa chính
CREATE TABLE DOCGIA (
	MaDG char(10)
	, IDTruong char(10)
	, HoTen nvarchar(40)
	, DiaChi nvarchar(40)
	, NVCap char(5)
	, NgaySinh date
	, DocGiaPT char(10)
	
	, PRIMARY KEY (MaDG, IDTruong)
)

CREATE TABLE PHIEUMUON (
	MaSach char(5)
	, NgayMuon date
	, MaDG char(10)
	, NgayTra date
	, MaNV char(5)
	, IDTruong char(10)
	
	, PRIMARY KEY (MaSach, NgayMuon, MaDG, IDTruong)
)

CREATE TABLE THUTHU (
	MaNV char(5)
	, HoTen nvarchar(40)
	, DiaChi nvarchar(40)
	, Email char(30)
	, DienThoai char(15)
	
	, PRIMARY KEY (MaNV)
)

GO

-- 2. Khóa ngoại
ALTER TABLE DOCGIA
ADD CONSTRAINT FK_DOCGIA_DOCGIA
FOREIGN KEY (DocGiaPT, IDTruong)
REFERENCES DOCGIA(MaDG, IDTruong)

ALTER TABLE DOCGIA
ADD CONSTRAINT FK_DOCGIA_THUTHU
FOREIGN KEY (NVCap)
REFERENCES THUTHU(MaNV)

ALTER TABLE PHIEUMUON
ADD CONSTRAINT FK_PHIEUMUON_DOCGIA
FOREIGN KEY (MaDG, IDTruong)
REFERENCES DOCGIA(MaDG, IDTruong)

ALTER TABLE PHIEUMUON
ADD CONSTRAINT FK_PHIEUMUON_THUTHU
FOREIGN KEY (MaNV)
REFERENCES THUTHU(MaNV)

GO

-- 3. Nhập liệu
INSERT INTO THUTHU(MaNV, HoTen, DiaChi, Email, DienThoai)
VALUES 
	('S001', N'Trần Thị Bé', N'31 Nguyễn Xí Q.Bình Thạnh', 'Kh001@gmail.com', '02154788539') 
	, ('S002', N'Nguyễn Minh Tâm', N'2 Trần Hưng Đạo Q5', 'Nam2000@gmail.com', '09066745821') 
	, ('S003', N'Trần Văn Lí', N'30 Hà Tồn Quyền Q5', 'nmdu@gmail.com', '05832695874') 

INSERT INTO DOCGIA(MaDG, HoTen, DiaChi, NgaySinh, NVCap, IDTruong, DocGiaPT)
VALUES
	('DG002', N'Lưu Phi Nam', N'23 Bình Phú Q6', '2005-12-01', 'S001', 'KHTN', NULL)
	, ('DG001', N'Nguyễn Minh Du', NULL, '2002-03-03', 'S002', 'DHSP', NULL)
	, ('DG001', N'Nguyễn Quan Tùng', N'112 Trần Hưng Đạo Q5', '2004-02-21', 'S001', 'KHTN', 'DG002')
	, ('DG003', N'Nguyễn Văn Toàn', N'1A Ký Con Q1', '2003-02-22', 'S001', 'KHTN', 'DG001')
	
INSERT INTO PHIEUMUON(MaSach, NgayMuon, MaDG, NgayTra, MaNV, IDTruong)
VALUES
	('001', '2019-11-30', 'DG001', '2019-12-05', 'S001', 'KHTN')
	, ('002', '2020-02-12', 'DG001', '2020-02-22', 'S001', 'KHTN')
	, ('001', '2020-02-13', 'DG002', '2020-03-13', 'S002', 'KHTN')

GO

-- 4. DS DG Q5 mượn sách > 10 ngày
SELECT DISTINCT DG.*
--	 , DATEDIFF(D, PM.NgayMuon, PM.NgayTra)
  FROM DOCGIA DG
  JOIN PHIEUMUON PM ON PM.MaDG=DG.MaDG AND PM.IDTruong=DG.IDTruong
 WHERE DG.DiaChi LIKE '%Q5'
   AND DATEDIFF(D, PM.NgayMuon, PM.NgayTra) > 10
   
-- 5. Tên TT và số DG ở Q6
SELECT TT.HoTen AS TEN_TT
	 , COUNT(*) AS SO_DG_TT_CAPTHE
  FROM THUTHU TT
  LEFT JOIN DOCGIA DG ON DG.NVCap=TT.MaNV
 WHERE DG.DiaChi LIKE '%Q6'
 GROUP BY TT.MaNV, TT.HoTen

