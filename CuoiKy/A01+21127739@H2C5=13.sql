-- Họ và tên: Vũ Minh Phát
-- MSSV: 21127739
-- Lớp: 21CLC01 (Chiều T2)
-- Thi cuối kỳ (thực hành)
-- Phòng: I62
-- Vị trí: Dòng#2 - Cột#5
-- Mã đề: A01

use master
go
USE QLKHOHANG
GO

--1-- 
SELECT HH.MaHangHoa, HH.TenHangHoa
  FROM HangHoa HH
 WHERE HH.TongSoLuong > (
	SELECT H1.TongSoLuong 
	  FROM HangHoa H1
	 WHERE H1.MaHangHoa = N'NCĐ001'
  )
GO

--2--
SELECT NV.MaNhanVien, NV.TenNhanVien
  FROM NhanVien NV
  JOIN PhieuBienNhan P ON P.MaNhanVien = NV.MaNhanVien
  JOIN ChiTietBienNhan CT ON CT.MaBienNhan = P.MaBienNhan
  JOIN HangHoa HH ON HH.MaHangHoa = CT.MaHangHoa
 WHERE HH.ThuongHieu = 'Sony'
 GROUP BY NV.MaNhanVien, NV.TenNhanVien
HAVING COUNT(DISTINCT HH.MaHangHoa) = (
	SELECT COUNT(MaHangHoa)
	  FROM HangHoa H1
	 WHERE H1.ThuongHieu = 'Sony'
  )
GO

--3--

DROP PROCEDURE sp_KiemDem_HangHoa
GO
CREATE PROCEDURE sp_KiemDem_HangHoa @MaHangHoa nvarchar(10), @capnhat INT out
AS 
BEGIN
	--3.b1--
	IF (@MaHangHoa IS NULL)
	BEGIN
		Print N'@MaHangHoa IS NULL'
		SET @capnhat = 0
		return
	END
	
	IF(NOT EXISTS (SELECT * FROM HangHoa WHERE MaHangHoa=@MaHangHoa))
	BEGIN
		Print N'@MaHangHoa không tồn tại!'
		SET @capnhat = 0
		return
	END
	
	--3.b2--
	declare @slhanghoa INT = 0
	SELECT @slhanghoa = SUM(SoLuong)
	  FROM ChiTietBienNhan
	 WHERE MaHangHoa = @MaHangHoa
	 
	--Print N'3.b2. Số lượng hàng hóa là: ' + cast(@slhanghoa as varchar)
	
	--3.b3--
	declare @kiemkegannhat INT = 0
	select @kiemkegannhat = TongSoLuong
	  from HangHoa
	 where MaHangHoa = @MaHangHoa
	
	-- chạy tiếp
	if (@kiemkegannhat IS NOT NULL AND @kiemkegannhat = @slhanghoa)
	BEGIN
		Print N'3.b3. Số lượng ko đổi.'
		SET @capnhat = 0
		return
	END
	
	--3.b4--
	UPDATE HangHoa
	SET NgayKiemKe = GETDATE(), TongSoLuong = @slhanghoa
	WHERE MaHangHoa = @MaHangHoa
	
	Print N'3.b4. Đã cập nhật.'
	SET @capnhat = 1

END
GO

--Exec sp_KiemDem_HangHoa null
declare @capnhat INT = -1
declare @mahh nvarchar(10) = N'NCĐ001'
Print N'3. @mahh = ' + @mahh
Exec sp_KiemDem_HangHoa @mahh, @capnhat OUT
Print N'>> @capnhat = ' + cast(@capnhat as varchar)
GO
--4--

DROP PROCEDURE sp_KiemDem_All_HangHoa
GO
CREATE PROCEDURE sp_KiemDem_All_HangHoa
AS
BEGIN
	--4.b1--
	declare @count int = -1
	
	-- tìm sl hàng hóa
	SELECT @count = COUNT(MaHangHoa)
	  FROM HangHoa
	
	declare @i int = 1
	declare @slhh_duoc_capnhat INT = 0
	declare @mahh nvarchar(10)
	WHILE (@i <= @count) 
	begin
		declare @capnhat INT = -1
		
		select top(@i) @mahh=MaHangHoa
		  from HangHoa
		
		Print ''
		Print N'===== Loop ' + cast(@i as varchar) + N' # @mahh = ' + @mahh +N' ====='
		
		--4.b1.1--
		Exec sp_KiemDem_HangHoa @mahh, @capnhat out
		
		if (@capnhat = 1)
		BEGIN
			SET @slhh_duoc_capnhat = @slhh_duoc_capnhat + 1
		END
	
		SET @i = @i + 1
	END
	
	--4.b2--
	Print ''
	Print N'Số lượng những hàng hóa được cập nhật là: ' + cast(@slhh_duoc_capnhat as varchar)
	
END 
GO

Exec sp_KiemDem_All_HangHoa
GO



