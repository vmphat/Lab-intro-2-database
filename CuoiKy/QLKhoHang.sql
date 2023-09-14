--use master
--go
--DROP DATABASE QLKHOHANG
--GO
CREATE DATABASE QLKHOHANG
GO
USE QLKHOHANG
GO

CREATE TABLE ChungLoai (
	MaCL		nchar(8),
	TenCL		nvarchar(20),
	SoTHieu		int,
	TSLNhap		int,
	TSLXuat		int,
	PRIMARY KEY (MaCL)
)

CREATE TABLE HangHoa (
	MaHangHoa	nchar(8),
	TenHangHoa	nvarchar(50),
	ThuongHieu	nvarchar(20),
	ChungLoai	nchar(8),
	NgayKiemKe	datetime,
	TongSoLuong	int,
	PRIMARY KEY (MaHangHoa),
	FOREIGN KEY (ChungLoai) REFERENCES ChungLoai(MaCL)
)

CREATE TABLE NhanVien (
	MaNhanVien	nchar(8),
	TenNhanVien	nvarchar(30),
	TSLNhap		int,
	TSLXuat		int,
	PRIMARY KEY (MaNhanVien)
)

CREATE TABLE PhieuBienNhan (
	MaBienNhan	nchar(8),
	LoaiPhieu	nchar(8),
	NgayGioXuatPhieu	datetime,
	MaNhanVien	nchar(8),
	TongSoLuong	int,
	PRIMARY KEY (MaBienNhan),
	FOREIGN KEY (MaNhanVien) REFERENCES NhanVien
)

CREATE TABLE ChiTietBienNhan (
	MaBienNhan	nchar(8),
	MaHangHoa	nchar(8),
	SoLuong		int,
	PRIMARY KEY (MaBienNhan, MaHangHoa),
	FOREIGN KEY (MaBienNhan) REFERENCES PhieuBienNhan,
	FOREIGN KEY (MaHangHoa) REFERENCES HangHoa
)
GO

INSERT ChungLoai (MaCL, TenCL) VALUES 
	(N'TV', N'Tivi'),
	(N'MG', N'Máy giặt'),
	(N'NCĐ', N'Nồi cơm điện')
GO

INSERT HangHoa (MaHangHoa, TenHangHoa, ThuongHieu, ChungLoai) VALUES 
	(N'TV001', N'Tivi 32 inch', N'Sony', N'TV'),
	(N'TV002', N'Tivi 43 inch', N'Samsung', N'TV'),
	(N'TV003', N'Tivi 43 inch', N'TCL', N'TV'),
	(N'MG001', N'Máy giặt cửa trên 10 kg', N'Panasonic', N'MG'),
	(N'MG002', N'Máy giặt cửa ngang 12 kg', N'Toshiba', N'MG'),
	(N'NCĐ001', N'Nồi cơm điện 1.8 L', N'Panasonic', N'NCĐ')
GO

INSERT NhanVien (MaNhanVien, TenNhanVien) VALUES 
	(N'NV001', N'Hòa Thành'),
	(N'NV002', N'Minh Trí'),
	(N'NV003', N'Trọng Tín'),
	(N'NV004', N'Thái Thành')
GO

INSERT PhieuBienNhan (MaBienNhan, LoaiPhieu, NgayGioXuatPhieu, MaNhanVien, TongSoLuong) VALUES
	(N'BN0001', N'Nhập', '2022-06-20 08:00', N'NV001', 30),
	(N'BN0002', N'Nhập', '2022-06-27 13:30', N'NV002', 10),
	(N'BN0003', N'Xuất', '2022-06-30 14:45', N'NV003', -8),
	(N'BN0004', N'Nhập', '2022-07-04 09:10', N'NV004', 12),
	(N'BN0005', N'Xuất', '2022-07-14 10:20', N'NV002', -21),
	(N'BN0006', N'Nhập', '2022-07-24 15:25', N'NV001', 30)
GO

INSERT ChiTietBienNhan VALUES
	(N'BN0001', N'TV001', 10),
	(N'BN0001', N'NCĐ001', 20),
	(N'BN0002', N'MG001', 10),
	(N'BN0003', N'TV001', -8),
	(N'BN0004', N'TV003', 12),
	(N'BN0005', N'TV003', -5),
	(N'BN0005', N'MG001', -6),
	(N'BN0005', N'NCĐ001', -10),
	(N'BN0006', N'TV002', 15),
	(N'BN0006', N'TV001', 5),
	(N'BN0006', N'MG001', 10)
GO


