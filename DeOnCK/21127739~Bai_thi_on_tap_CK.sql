-- Họ và tên: Vũ Minh Phát
-- MSSV: 21127739
-- Lớp: 21CLC01 (Chiều T2)
-- Bài tập: Ôn tập: THI TH-CK MÔN CSDL

-- Sử dụng CSDL-TH : "Quản Lý Đề Tài"
USE QLGiaoVienThamGiaDeTai
GO

-- 1. Cho biết những Bộ Môn nào có nhiều Giáo Viên nhất có Số Điện Thoại.
WITH CTE AS (
	SELECT BM.MABM
		 , COUNT(GV_DT.DIENTHOAI) AS SLDT
	  FROM GIAOVIEN GV
	  JOIN GV_DT ON GV_DT.MAGV = GV.MAGV
	  JOIN BOMON BM ON BM.MABM = GV.MABM
	 GROUP BY BM.MABM
)
SELECT *
  FROM BOMON
 WHERE MABM IN (
	 SELECT MABM
	  FROM CTE
	 WHERE SLDT >= ALL (
		SELECT SLDT
		  FROM CTE
	 )
 )


GO

-- 2. Cho biết những Giáo Viên nào có tham gia tất cả các Đề Tài 
--	của Giáo Viên “Trương Nam Sơn” làm chủ nhiệm đề tài.
WITH DT_TNS_CN AS (
	SELECT DT.MADT
	  FROM GIAOVIEN GV
	  JOIN DETAI DT ON DT.GVCNDT = GV.MAGV
	 WHERE GV.HOTEN LIKE N'Trương Nam Sơn' --AND MADT != '004'
  ), GVTGDT_CO_TNS_CN AS (
	SELECT DISTINCT GV.MAGV
		 , TG.MADT
	  FROM GIAOVIEN GV
	  JOIN THAMGIADT TG ON TG.MAGV = GV.MAGV
	  JOIN DT_TNS_CN T ON T.MADT = TG.MADT
  )
SELECT * 
  FROM GIAOVIEN
 WHERE MAGV IN (
	SELECT MAGV
	  FROM GVTGDT_CO_TNS_CN
	 GROUP BY MAGV
	HAVING COUNT(DISTINCT MADT) = (
			SELECT COUNT(MADT)
			  FROM DT_TNS_CN
	  )
 )

 
GO

-- 3. Cho biết những Giáo Viên nào mà tất cả các Đề Tài 
--	mình tham gia đều có Kinh Phí trên 80 triệu.
WITH CTE AS (
	SELECT DISTINCT GV.MAGV
		 , TG.MADT
		 , DT.KINHPHI
	  FROM GIAOVIEN GV
	  JOIN THAMGIADT TG ON TG.MAGV = GV.MAGV
	  JOIN DETAI DT ON DT.MADT = TG.MADT
  )
SELECT *
  FROM GIAOVIEN
 WHERE MAGV IN (
	SELECT MAGV
	  FROM CTE 
	 WHERE MAGV NOT IN (
		SELECT MAGV
		  FROM CTE
		 WHERE KINHPHI <= 80
	 ) 
 )
GO

-- 4. Viết stored procedure "spHienThi_DSGV_ThamGia_DeTai" 
--	với tham số vào (Từ_Ngày, Đến_Ngày)
Print '*************************************************************************************************************************************************************************************************'
Print N'4. Viết stored procedure "spHienThi_DSGV_ThamGia_DeTai"'
Print ''

DROP FUNCTION fXacDinhCacDeTai
GO
CREATE FUNCTION fXacDinhCacDeTai (@tu_ngay date, @den_ngay date)
RETURNS TABLE
AS
	-- @tu_ngay <= BD && KT <= @den_ngay
	-- tu_ngay - BD <= 0 && den_ngay - KT >= 0
	return (
		SELECT MADT
			 , NGAYBD
			 , NGAYKT
		  FROM DETAI
		 WHERE DATEDIFF(D, NGAYBD, @tu_ngay ) <= 0
		   AND DATEDIFF(D, NGAYKT, @den_ngay) >= 0
	)
GO

DROP PROCEDURE spXuatThongTinDeTaiVaSoLuong
GO
CREATE PROCEDURE spXuatThongTinDeTaiVaSoLuong @madt char(5)
AS 
BEGIN
	WITH SLGV_TGDT AS (
			SELECT MADT
				 , COUNT(DISTINCT MAGV) SLGV_THAMGIA
			  FROM THAMGIADT
			 GROUP BY MADT
	  )
	SELECT DT.*
		 , SLGV_THAMGIA
	  FROM DETAI DT
	  JOIN SLGV_TGDT TG ON TG.MADT = DT.MADT
	 WHERE DT.MADT = @madt
END
GO

DROP PROCEDURE spXuatThongTinGVCNDT
GO
CREATE PROCEDURE spXuatThongTinGVCNDT @madt char(5)
AS
BEGIN
	SELECT *
	  FROM GIAOVIEN
	 WHERE MAGV IN (
		SELECT GVCNDT
		  FROM DETAI
		 WHERE MADT = @madt
	 )
END
GO

DROP PROCEDURE spXuatDanhSachGVTGDT
GO
CREATE PROCEDURE spXuatDanhSachGVTGDT @madt char(5)
AS
BEGIN
	SELECT *
	  FROM GIAOVIEN
	 WHERE MAGV IN (
		SELECT MAGV
		  FROM THAMGIADT
		 WHERE MADT = @madt
	 )
	 ORDER BY NGSINH ASC
END
GO

DROP PROCEDURE spHienThi_DSGV_ThamGia_DeTai
GO
CREATE PROCEDURE spHienThi_DSGV_ThamGia_DeTai @tu_ngay date, @den_ngay date
AS
BEGIN
	-- Kiểm tra giá trị đầu vào có hợp lệ không (Từ_Ngày phải nhỏ hơn Đến_Ngày)
	-- . Nếu không thì báo lỗi & kết thúc.
	-- tu < den <=> den - tu > 0
	IF (DATEDIFF(D, @tu_ngay, @den_ngay) <= 0)
	BEGIN
		raiserror(N'[!] Lỗi: Từ_Ngày phải nhỏ hơn Đến_Ngày, vui lòng thử lại', 16, 1)
		return
	END
	
	-- Xác định các đề tài có thời gian thực hiện nằm trong khoảng thời gian theo yêu cầu.
	declare @t table(madt char(5), ngaydb date, ngaykt date)
	INSERT INTO @t
	SELECT * FROM dbo.fXacDinhCacDeTai(@tu_ngay, @den_ngay)
	
	-- In thông báo số lượng đề tài thỏa yêu cầu. Nếu = 0 thì kết thúc.
	declare @count INT = -1
	SELECT @count = COUNT(madt) from @t
	Print N'Số lượng đề tài thỏa yêu cầu là: ' + cast(@count as varchar)
	IF (@count = 0)
	BEGIN
		Print N'Kết thúc vì @count = 0'
		return
	END
	
	-- Với mỗi đề tài được xác định ở trên (theo thứ tự đề tài mới nhất trước tiên, cũ nhất sau cùng)
	declare @i INT = 1
	declare @tmp_madt varchar(5) = ''
	WHILE (@i <= @count)
	BEGIN
		SELECT TOP (@i) @tmp_madt = madt
		  FROM @t
		 ORDER BY ngaydb DESC
		
		-- Xuất tất cả thông tin của đề tài đó kèm theo 
		--	Số lượng GV tham gia đề tài đó (bỏ qua GVCNDT nếu có).
		Exec spXuatThongTinDeTaiVaSoLuong @tmp_madt
		
		-- Xuất thông tin GV làm chủ nhiệm đề tài này.
		Exec spXuatThongTinGVCNDT @tmp_madt
		
		-- Xuất danh sách các GV tham gia đề tài này (bỏ qua GVCNDT nếu có)
		--	theo tuổi giảm dần.
		Exec spXuatDanhSachGVTGDT @tmp_madt
		
		SET @i = @i + 1
	END
	
END
GO

declare @tu_ngay date = '2006-10-20'
declare @den_ngay date = '2009-10-20'
Print N'Với ngày tham số Từ_ngày và Đến_ngày lần lượt là: ' + cast(@tu_ngay as varchar) 
+ ' và ' + cast(@den_ngay as varchar) 
Exec spHienThi_DSGV_ThamGia_DeTai @tu_ngay, @den_ngay
GO

