-- Họ và tên: Vũ Minh Phát
-- MSSV: 21127739
-- Bài tập tuần 2

-- Xóa DB QLGiaoVienThamGiaDeTai cũ từ lần chạy thứ 2
--	-> Lần chạy thứ 1 có thể báo lỗi (dòng chữ đỏ) 
--	   nhưng không ảnh hưởng đến kết quả.
--	-> Nếu gặp lỗi (hoặc chạy quá lâu) 
--	   có thể thử Refresh Databases.
USE master
GO
DROP DATABASE QLGiaoVienThamGiaDeTai
GO
------------------------------------------
-- Tạo DB QLGiaoVienThamGiaDeTai
CREATE DATABASE QLGiaoVienThamGiaDeTai
GO
USE QLGiaoVienThamGiaDeTai
GO

-- C1.
-- *** Tạo cấu trúc cho DB QLGiaoVienThamGiaDeTai ***
/*		  +----------------------------------+
		  |    Tạo bảng + thêm khóa chính    |
		  |       (+ thêm khóa ngoại)        |
		  +----------------------------------+		*/

-- Xử lý khóa vòng ở nhóm GIAOVIEN, KHOA, BOMON
-- GIAOVIEN thiếu FK_GIAOVIEN_BOMON
CREATE TABLE GIAOVIEN (
	MAGV char(5),
	HOTEN nvarchar(40),
	LUONG decimal(9, 1),
	PHAI nchar(3),
	NGSINH date,
	DIACHI nvarchar(50),
	GVQLCM char(5),-- REF GIAOVIEN.MAGV
	MABM nchar(5), -- REF BOMON
	
	CONSTRAINT PK_GIAOVIEN PRIMARY KEY (MAGV),
	CONSTRAINT FK_GIAOVIEN_GIAOVIEN FOREIGN KEY (GVQLCM) REFERENCES GIAOVIEN(MAGV)
)

-- KHOA có đủ 'khóa'
CREATE TABLE KHOA (
	MAKHOA nchar(5),
	TENKHOA nvarchar(40),
	NAMTL smallint, -- dùng smallint vì không có kiểu YEAR
	PHONG char(5), 
	DIENTHOAI char(12),
	TRUONGKHOA char(5), -- REF GIAOVIEN.MAGV
	NGAYNHANCHUC date,
	
	CONSTRAINT PK_KHOA PRIMARY KEY (MAKHOA),
	CONSTRAINT FK_KHOA_GIAOVIEN FOREIGN KEY (TRUONGKHOA) REFERENCES GIAOVIEN(MAGV)
)

-- BOMON có đủ 'khóa'
CREATE TABLE BOMON  (
	MABM nchar(5), 
	TENBM nvarchar(40),
	PHONG char(5), 
	DIENTHOAI char(12), 
	TRUONGBM char(5), -- REF GV.MAGV
	MAKHOA nchar(5),  -- REF KHOA.MAKHOA
	NGAYNHANCHUC date,
	
	CONSTRAINT PK_BOMON PRIMARY KEY (MABM),
	CONSTRAINT KF_BOMON_KHOA FOREIGN KEY (MAKHOA) REFERENCES KHOA(MAKHOA),
	CONSTRAINT KF_BOMON_GIAOVIEN FOREIGN KEY (TRUONGBM) REFERENCES GIAOVIEN(MAGV)
)

-- Bổ sung khóa ngoại cho GIAOVIEN 
ALTER TABLE GIAOVIEN
ADD CONSTRAINT FK_GIAOVIEN_BOMON
FOREIGN KEY (MABM)
REFERENCES BOMON(MABM)

-- Khi này các bảng còn lại có thể thêm khóa ngoại ngay khi tạo bảng
CREATE TABLE GV_DT  (
	MAGV char(5),
	DIENTHOAI char(12),
	
	CONSTRAINT PK_GV_DT PRIMARY KEY (MAGV, DIENTHOAI),
	CONSTRAINT FK_GV_DT_GIAOVIEN FOREIGN KEY (MAGV) REFERENCES GIAOVIEN(MAGV)
)

CREATE TABLE NGUOITHAN (
	MAGV char(5), 
	TEN nvarchar(10), 
	NGSINH datetime, 
	PHAI nchar(3),
	
	CONSTRAINT PK_NGUOITHAN PRIMARY KEY (MAGV, TEN),
	CONSTRAINT FK_NGUOITHAN_GIAOVIEN FOREIGN KEY (MAGV) REFERENCES GIAOVIEN(MAGV)
)

-- Thứ tự tối ưu: CHUDE -> DETAI -> CONGVIEC -> THAMGIADT
CREATE TABLE CHUDE  (
	MACD nchar(5),
	TENCD nvarchar(40), 
	
	CONSTRAINT PK_CHUDE PRIMARY KEY (MACD)
)

CREATE TABLE DETAI  (
	MADT char(5), 
	TENDT nvarchar(50), 
	CAPQL nvarchar(20), 
	KINHPHI decimal(9, 1), 
	NGAYBD date, 
	NGAYKT date, 
	MACD nchar(5), 
	GVCNDT char(5),
	
	CONSTRAINT PK_DETAI PRIMARY KEY (MADT),
	CONSTRAINT FK_DETAI_GIAOVIEN FOREIGN KEY (GVCNDT) REFERENCES GIAOVIEN(MAGV),
	CONSTRAINT FK_DETAI_CHUDE FOREIGN KEY (MACD) REFERENCES CHUDE(MACD)
)

CREATE TABLE CONGVIEC (
	MADT char(5),
	SOTT char(2),
	TENCV nvarchar(40), 
	NGAYBD datetime, 
	NGAYKT datetime,

	CONSTRAINT PK_CONGVIEC PRIMARY KEY (MADT, SOTT),
	CONSTRAINT FK_CONGVIEC_DETAI FOREIGN KEY (MADT) REFERENCES DETAI(MADT)
)

CREATE TABLE THAMGIADT (
	MAGV char(5), 
	MADT char(5),
	STT char(2),
	PHUCAP decimal(3, 1), 
	KETQUA nvarchar(10),

	CONSTRAINT PK_THAMGIADT PRIMARY KEY (MAGV, MADT, STT),
	CONSTRAINT FK_THAMGIADT_GIAOVIEN FOREIGN KEY (MAGV) REFERENCES GIAOVIEN(MAGV),
	CONSTRAINT FK_THAMGIADT_CONGVIEC FOREIGN KEY (MADT, STT) REFERENCES CONGVIEC(MADT, SOTT)
)

/*	+------------------------------------+
	|    Tạo thêm 1 số ràng buộc khác    |
	+------------------------------------+	*/
-- Ràng buộc trên BOMON --
ALTER TABLE BOMON
ADD CONSTRAINT U_TENBM_BOMON
UNIQUE (TENBM)

ALTER TABLE BOMON
ADD CONSTRAINT U_PHONG_BOMON
UNIQUE (PHONG)

ALTER TABLE BOMON
ADD CONSTRAINT U_DIENTHOAI_BOMON
UNIQUE (DIENTHOAI)

-- Ràng buộc trên KHOA --
ALTER TABLE KHOA
ADD CONSTRAINT U_TENKHOA_KHOA
UNIQUE (TENKHOA)

ALTER TABLE KHOA
ADD CONSTRAINT U_PHONG_KHOA
UNIQUE (PHONG)

ALTER TABLE KHOA
ADD CONSTRAINT U_DIENTHOAI_KHOA
UNIQUE (DIENTHOAI)

-- Ràng buộc trên DETAI --
ALTER TABLE DETAI
ADD CONSTRAINT U_TENDT_DETAI
UNIQUE (TENDT)

ALTER TABLE DETAI
ADD CONSTRAINT C_NGAY_DETAI
CHECK (NGAYBD < NGAYKT)

-- Ràng buộc trên CHUDE --
ALTER TABLE CHUDE
ADD CONSTRAINT U_TENCD_CHUDE
UNIQUE (TENCD)

-- Ràng buộc trên NGUOITHAN --
ALTER TABLE NGUOITHAN
ADD CONSTRAINT C_PHAI_NGUOITHAN
CHECK (PHAI IN ('Nam', N'Nữ'))

-- Ràng buộc trên GIAOVIEN --
ALTER TABLE GIAOVIEN
ADD CONSTRAINT C_PHAI_GIAOVIEN
CHECK (PHAI IN ('Nam', N'Nữ'))

-- Ràng buộc trên CONGVIEC --
ALTER TABLE CONGVIEC
ADD CONSTRAINT C_NGAY_CONGVIEC
CHECK (NGAYBD < NGAYKT)

-- C2.
/*	+-----------------------------------------------+
	|	Nhập dữ liệu cho DB QLGiaoVienThamGiaDeTai	|
	+-----------------------------------------------+	*/
-- Nhập toàn bộ thông tin CHUDE (do nó không có khóa ngoại)
INSERT INTO CHUDE
VALUES 
	('NCPT', N'Nghiên cứu phát triển'),
	('QLGD', N'Quản lý giáo dục'),
	(N'ƯDCN', N'Ứng dụng công nghệ')

-- Nhập thông tin KHOA, bỏ qua TRUONGKHOA
INSERT INTO KHOA
VALUES
	('CNTT', N'Công nghệ thông tin', 1995, 'B11', '0838123456', NULL, '2005-02-20'),
	('HH', N'Hóa học', 1980, 'B41', '0838456456', NULL, '2001-10-15'),
	('SH', N'Sinh học', 1980, 'B31', '0838454545', NULL, '2000-10-11'),
	('VL', N'Vật lý', 1976, 'B21', '0838223223', NULL, '2003-09-18')

-- Nhập BOMON nhưng tạm bỏ qua TRUONGBM
INSERT INTO BOMON
VALUES
	('CNTT', N'Công nghệ tri thức', 'B15', '0838126126', NULL, 'CNTT', NULL),
	('HHC', N'Hóa hữu cơ', 'B44', '0838222222', NULL, 'HH', NULL),
	('HL', N'Hóa lý', 'B42', '0838878787', NULL, 'HH', NULL),
	('HPT', N'Hóa phân tích', 'B43', '0838777777', NULL, 'HH', '2007-10-15'),
	('HTTT', N'Hệ thống thông tin', 'B13', '0838125125', NULL, 'CNTT', '2004-09-20'),
	('MMT', N'Mạng máy tính', 'B16', '0838676767', NULL, 'CNTT', '2005-05-15'),
	('SH', N'Sinh hóa', 'B33', '0838898989', NULL, 'SH', NULL),
	(N'VLĐT', N'Vật lý điện tử', 'B23', '0838234234', NULL, 'VL', NULL),
	(N'VLƯD', N'Vật lý ứng dụng', 'B24', '0838454545', NULL, 'VL', '2006-02-18'),
	('VS', 'Vi sinh', 'B32', '0838909090', NULL, 'SH', '2007-01-01')
	
-- Nhập đầy đủ thông tin GIAOVIEN
INSERT INTO GIAOVIEN
VALUES
	('001', N'Nguyễn Hoài An', 2000.0, 'Nam', '1973-02-15', N'25/3 Lạc Long Quân, Q.10, TP HCM', NULL, 'MMT'),
	('002', N'Trần Trà Hương', 2500.0, N'Nữ', '1960-06-20', N'125 Trần Hưng Đạo, Q.1, TP HCM', NULL, 'HTTT'),
	('003', N'Nguyễn Ngọc Ánh', 2200.0, N'Nữ', '1975-05-11', N'12/21 Võ Văn Ngân Thủ Đức, TP HCM', '002', 'HTTT'),
	('004', N'Trương Nam Sơn', 2300.0, 'Nam', '1959-06-20', N'215 Lý Thường Kiệt, TP Biên Hòa', NULL, 'VS'),
	('005', N'Lý Hoàng Hà', 2500.0, 'Nam', '1954-10-23', N'22/5 Nguyễn Xí, Q.Bình Thạnh, TP HCM', NULL, N'VLĐT'),
	('006', N'Trần Bạch Tuyết', 1500.0, N'Nữ', '1980-05-20', N'127 Hùng Vương, TP Mỹ Tho', '004', 'VS'),
	('007', N'Nguyễn An Trung', 2100.0, 'Nam', '1976-06-05', N'234 3/2, TP Biên Hòa', NULL, 'HPT'),
	('008', N'Trần Trung Hiếu', 1800.0, 'Nam', '1977-08-06', N'22/11 Lý Thường Kiệt, TP Mỹ Tho', '007', 'HPT'),
	('009', N'Trần Hoàng Nam', 2000.0, 'Nam', '1975-11-22', N'234 Trần Não, An Phú, TP HCM', '001', 'MMT'),
	('010', N'Phạm Nam Thanh', 1500.0, 'Nam', '1980-12-12', N'221 Hùng Vương, Q.5, TP HCM', '007', 'HPT')

-- Cập nhật TRUONGKHOA của KHOA -> Đủ thông tin KHOA
UPDATE KHOA
SET TRUONGKHOA = '002'
WHERE MAKHOA = 'CNTT'

UPDATE KHOA
SET TRUONGKHOA = '007'
WHERE MAKHOA = 'HH'

UPDATE KHOA
SET TRUONGKHOA = '004'
WHERE MAKHOA = 'SH'

UPDATE KHOA
SET TRUONGKHOA = '005'
WHERE MAKHOA = 'VL'
	
-- Bổ sung TRUONGBM cho BOMON -> đủ thông tin cho BOMON
UPDATE BOMON
SET TRUONGBM = '007'
WHERE MABM = 'HPT'

UPDATE BOMON
SET TRUONGBM = '002'
WHERE MABM = 'HTTT'
	
UPDATE BOMON
SET TRUONGBM = '001'
WHERE MABM = 'MMT'

UPDATE BOMON
SET TRUONGBM = '005'
WHERE MABM = N'VLƯD'

UPDATE BOMON
SET TRUONGBM = '004'
WHERE MABM = 'VS'

-- Nhập thông tin cho GV_DT và NGUOITHAN
INSERT INTO GV_DT
VALUES
	('001', '0838912112'),
	('001', '0909123123'),
	('002', '0913454545'),
	('003', '0838121212'),
	('003', '0903656565'),
	('003', '0937125125'),
	('006', '0937888888'),
	('008', '0653717171'),
	('008', '0913232323')

INSERT INTO NGUOITHAN
VALUES 
	('001', N'Hùng', '1990-01-14', 'Nam'),
	('001', N'Thủy', '1994-12-08', N'Nữ'),
	('003', N'Hà', '1998-09-03', N'Nữ'),
	('003', N'Thu', '1998-09-03', N'Nữ'),
	('007', 'Mai', '2003-03-26', N'Nữ'),
	('007', 'Vy', '2000-02-14', N'Nữ'),
	('008', 'Nam', '1991-05-06', 'Nam'),
	('009', 'An', '1996-08-19', 'Nam'),
	('010', N'Nguyệt', '2006-01-14', N'Nữ')

-- Nhập đầy đủ thông tin DETAI
INSERT INTO DETAI
VALUES 
	('001', N'HTTT quản lý các trường ĐH', N'ĐHQG', 20.0, '2007-10-20', '2008-10-20', 'QLGD', '002'),
	('002', N'HTTT quản lý giáo vụ cho một Khoa', N'Trường', 20.0, '2000-10-12', '2001-10-12', 'QLGD', '002'),
	('003', N'Nghiên cứu chế tạo sợi Nanô Platin', N'ĐHQG', 300.0, '2008-05-15', '2010-05-15', 'NCPT', '005'),
	('004', N'Tạo vật liệu sinh học bằng màng ối người', N'Nhà nước', 100.0, '2007-01-01', '2009-12-31', 'NCPT', '004'),
	('005', N'Ứng dụng hóa học xanh', N'Trường', 200.0, '2003-10-10', '2004-12-10', N'ƯDCN', '007'),
	('006', N'Nghiên cứu tế bào gốc', N'Nhà nước', 4000.0, '2006-10-20', '2009-10-20', 'NCPT', '004'),
	('007', N'HTTT quản lý thư viện ở các trường ĐH', N'Trường', 20.0, '2009-05-10', '2010-05-10', 'QLGD', '001')

-- Nhập đầy đủ thông tin CONGVIEC
INSERT INTO CONGVIEC
VALUES 
	('001', '1', N'Khởi tạo và Lập kế hoạch', '2007-10-20', '2007-12-20'),
	('001', '2', N'Xác định yêu cầu', '2007-12-21', '2008-03-21'),
	('001', '3', N'Phân tích hệ thống', '2008-03-22', '2008-05-22'),
	('001', '4', N'Thiết kế hệ thống', '2008-05-23', '2008-06-23'),
	('001', '5', N'Cài đặt thử nghiệm', '2008-06-24', '2008-10-20'),
	('002', '1', N'Khởi tạo và Lập kế hoạch', '2009-05-10', '2009-07-10'),
	('002', '2', N'Xác định yêu cầu', '2009-07-11', '2009-10-11'),
	('002', '3', N'Phân tích hệ thống', '2009-10-12', '2009-12-20'),
	('002', '4', N'Thiết kế hệ thống', '2009-12-21', '2010-03-22'),
	('002', '5', N'Cài đặt thử nghiệm', '2010-03-23', '2010-05-10'),
	('006', '1', N'Lấy mẫu', '2006-10-20', '2007-02-20'),
	('006', '2', N'Nuôi cấy', '2007-02-21', '2008-08-21')

-- Nhập đầy đủ thông tin THAMGIADT
INSERT INTO THAMGIADT
VALUES
	('001', '002', '1', 0.0, NULL),
	('001', '002', '2', 2.0, NULL),
	('002', '001', '4', 2.0, N'Đạt'),
	('003', '001', '1', 1.0, N'Đạt'),
	('003', '001', '2', 0.0, N'Đạt'),
	('003', '001', '4', 1.0, N'Đạt'),
	('003', '002', '2', 0.0, NULL),
	('004', '006', '1', 0.0, N'Đạt'),
	('004', '006', '2', 1.0, N'Đạt'),
	('006', '006', '2', 1.5, N'Đạt'),
	('009', '002', '3', 0.5, NULL),
	('009', '002', '4', 1.5, NULL)

