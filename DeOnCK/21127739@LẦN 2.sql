-- Họ và tên: Vũ Minh Phát
-- MSSV: 21127739
-- Lớp: 21CLC01 (Chiều T2)
-- Bài tập tuần 09
USE QLGiaoVienThamGiaDeTai
GO

-- 1. Cho biết những Bộ Môn nào có nhiều Giáo Viên nhất có Số Điện Thoại.;WITH CTE AS (	select BM.MABM, COUNT(GV_DT.DIENTHOAI) SLDT	  from GIAOVIEN GV	  JOIN BOMON BM ON BM.MABM = GV.MABM	  JOIN GV_DT ON GV_DT.MAGV = GV.MAGV	 GROUP BY BM.MABM   )SELECT *  FROM BOMON WHERE MABM IN (	 SELECT MABM	  FROM CTE 	 WHERE SLDT = (		SELECT MAX(SLDT) FROM CTE	 )  )--GO-- 2. Cho biết những Giáo Viên nào có tham gia tất cả các
-- Đề Tài của Giáo Viên “Trương Nam Sơn” làm chủ nhiệm đề tài.;WITH DT_TNS_CN AS (	Select DT.MADT	  from DETAI DT	  JOIN GIAOVIEN GV ON GV.MAGV = DT.GVCNDT	 WHERE GV.HOTEN LIKE N'Trương Nam Sơn' --AND MADT != '004'  ), GV_TGDT AS (	SELECT DISTINCT TG.MAGV, TG.MADT	  FROM THAMGIADT TG	  JOIN DT_TNS_CN ON TG.MADT = DT_TNS_CN.MADT    )SELECT *  FROM GIAOVIEN WHERE MAGV IN (	SELECT MAGV	  FROM GV_TGDT	 GROUP BY MAGV	HAVING COUNT(DISTINCT MADT) = (		SELECT COUNT(MADT)		  FROM DT_TNS_CN	  )  )--GO-- 3. Cho biết những Giáo Viên nào mà tất cả các Đề Tài mình tham gia đều có Kinh Phí trên 80 triệu.;WITH DT_TREN_80 AS (	SELECT DISTINCT DT.MADT, GV.MAGV, KINHPHI	  FROM GIAOVIEN GV	  JOIN THAMGIADT TG ON TG.MAGV= GV.MAGV	  JOIN DETAI DT ON DT.MADT = TG.MADT	 WHERE KINHPHI > 80  ), DT_GV_TG AS (	SELECT DISTINCT GV.MAGV, TG.MADT	  FROM GIAOVIEN GV	  JOIN THAMGIADT TG ON TG.MAGV= GV.MAGV  )SELECT *   FROM GIAOVIEN WHERE MAGV IN (	 SELECT MAGV	  FROM DT_GV_TG	 GROUP BY MAGV	HAVING COUNT(DISTINCT MADT) = (		SELECT COUNT(DT_TREN_80.MADT)		  FROM DT_TREN_80		 WHERE DT_TREN_80.MAGV = DT_GV_TG.MAGV	  ) )--GO--4. Viết stored procedure "spHienThi_DSGV_ThamGia_DeTai" với tham số vào (Từ_Ngày,
--Đến_Ngày) với nội dung như sau:Print ''Print N'4.'GODROP FUNCTION fXacDinhDTGOCREATE FUNCTION fXacDinhDT (@tu_ngay date, @den_ngay date)RETURNS tableAS	return (		SELECT MADT 		  FROM DETAI		 WHERE DATEDIFF(D, @tu_ngay, NGAYBD) >= 0		   AND DATEDIFF(D, @den_ngay, NGAYKT) >= 0	)DROP PROCEDURE spHienThi_DSGV_ThamGia_DeTai
GO
CREATE PROCEDURE spHienThi_DSGV_ThamGia_DeTai 
@tu_ngay date, @den_ngay date
AS
BEGIN
	--Kiểm tra giá trị đầu vào có hợp lệ không 
	--(Từ_Ngày phải nhỏ hơn Đến_Ngày). Nếu không thì báo lỗi & kết thúc
	IF (datediff(d, @tu_ngay, @den_ngay) <= 0)
	BEGIN
		raiserror(N'Lỗi: Từ_Ngày phải nhỏ hơn Đến_Ngày, vui lòng thử lại!', 16,1)
		return
	END
		--Xác định các đề tài có thời gian thực hiện nằm trong 	--khoảng thời gian theo yêu cầu.	--declare @t table (madt varchar(5))
	--insert into @t select * from dbo.fXacDinhDT(@tu_ngay, @den_ngay)
	--select * from @t
	
	--Declare @tmp_Sum INT
	--Exec sp_TinhTongHaiSo @num_1, @num_2, @tmp_Sum out
	--Exec sp_TinhTongHaiSo @tmp_Sum, @num_3, @tmp_Sum out
	--Print @tmp_Sum
END
GO

declare @d_1 date = '2020-10-10'
declare @d_2 date = '2020-10-11'
Exec spHienThi_DSGV_ThamGia_DeTai @d_1, @d_2
GO