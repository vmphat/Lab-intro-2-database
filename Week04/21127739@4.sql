-- Họ và tên: Vũ Minh Phát
-- MSSV: 21127739
-- Bài tập tuần 4

-- Chọn DB để thao tác
-- Có thể thay bằng 1 tên khác (tùy theo tên DB đã đặt)
USE QLGiaoVienThamGiaDeTai
GO

-- Q27: Slg GV và tổng lương
SELECT COUNT(*) SOLUONG_GV
	 , SUM(LUONG) TONGLUONG_GV
  FROM GIAOVIEN
----------------------------------------

-- Q28: SLg GV và lương TB từng bộ môn
SELECT BM.MABM
	 , BM.TENBM
	 , COUNT(GV.MAGV) SLGV_CUA_BM
	 , CAST(AVG(GV.LUONG) AS DECIMAL(10, 1)) LUONG_TB
  FROM BOMON BM
  LEFT JOIN GIAOVIEN GV ON BM.MABM = GV.MABM 
 GROUP BY BM.MABM, BM.TENBM
----------------------------------------

-- Q29: Tên CD và sl DT thuộc về CD đó
SELECT CD.TENCD
	 , COUNT(DT.MADT) SLDT_CUA_CD
  FROM CHUDE CD
  LEFT JOIN DETAI DT ON DT.MACD = CD.MACD
 GROUP BY CD.TENCD
----------------------------------------

-- Q30: Tên GV và slg DT mà GV tham gia
SELECT GV.HOTEN AS TEN_GV
--	 , GV.MAGV
	 , COUNT(DISTINCT TGDT.MADT) SLDT_THAMGIA
  FROM GIAOVIEN GV
  LEFT JOIN THAMGIADT TGDT ON TGDT.MAGV = GV.MAGV
 GROUP BY GV.HOTEN, GV.MAGV

-- SELECT MAGV, COUNT(DISTINCT MADT) FROM THAMGIADT GROUP BY MAGV
----------------------------------------

-- Q31: Tên GV và sl DT GV làm chủ nhiệm
SELECT GV.HOTEN AS TEN_GV
--	 , GV.MAGV
	 , COUNT(DT.MADT) SLDT_GVCN
  FROM GIAOVIEN GV
  LEFT JOIN DETAI DT ON DT.GVCNDT = GV.MAGV
 GROUP BY GV.HOTEN, GV.MAGV
----------------------------------------

-- Q32:	Với mỗi GV -> Tên + sl Người thân
SELECT GV.HOTEN	AS TEN_GV
--	 , GV.MAGV
	 , COUNT(NT.TEN) SL_NGUOITHAN
  FROM GIAOVIEN GV
  LEFT JOIN NGUOITHAN NT ON NT.MAGV = GV.MAGV
 GROUP BY GV.HOTEN, GV.MAGV
----------------------------------------

-- Q33: Tên GV tham gia từ 3 đề tài trở lên
--		(Có thể ko có GV nào)
SELECT GV.HOTEN AS TEN_GV
--	 , GV.MAGV
	 , COUNT(DISTINCT TGDT.MADT) SLDT_THAMGIA
  FROM GIAOVIEN GV
  JOIN THAMGIADT TGDT ON TGDT.MAGV = GV.MAGV
 GROUP BY GV.HOTEN, GV.MAGV
HAVING COUNT(DISTINCT TGDT.MADT) >= 3

/*
SELECT GV.HOTEN, COUNT(DISTINCT TG.MADT) SOLUONGDT
FROM GIAOVIEN GV, THAMGIADT TG
WHERE GV.MAGV = TG.MAGV
GROUP BY GV.MAGV, GV.HOTEN
HAVING COUNT(DISTINCT TG.MADT) >= 1
*/
----------------------------------------

-- Q34: SL GV tham gia DT Ứng dụng hóa học xanh
SELECT DT.TENDT
	 , DT.MADT
	 , COUNT(DISTINCT TGDT.MAGV) SLGV_TGDT
  FROM DETAI DT
  LEFT JOIN THAMGIADT TGDT ON TGDT.MADT = DT.MADT
 WHERE DT.TENDT = N'Ứng dụng hóa học xanh'
 GROUP BY DT.TENDT, DT.MADT
----------------------------------------

