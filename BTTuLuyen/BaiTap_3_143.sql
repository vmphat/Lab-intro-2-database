USE QLGiaoVienThamGiaDeTai
GO

-- a.
SELECT GV.MAGV, GV.HOTEN
  FROM GIAOVIEN GV
  JOIN BOMON BM ON BM.TRUONGBM = GV.MAGV
 UNION
SELECT GV.MAGV, GV.HOTEN
  FROM GIAOVIEN GV
  JOIN KHOA K ON K.TRUONGKHOA = GV.MAGV
GO

-- b.
SELECT GV.MAGV MA_GV
	 , GV.HOTEN TEN_GV
	 , QLCM.MAGV MA_GVQL
	 , QLCM.HOTEN TEN_QLCM
  FROM GIAOVIEN GV
  JOIN GIAOVIEN QLCM ON QLCM.MAGV = GV.GVQLCM
 WHERE DATEDIFF(D, GV.NGSINH, QLCM.NGSINH) = 0
GO

-- C.
SELECT MAGV, HOTEN
  FROM GIAOVIEN GV
  JOIN BOMON BM ON BM.MABM = GV.MABM
 WHERE BM.TENBM LIKE N'Hệ thống thông tin'
   AND GV.MAGV NOT IN (
		SELECT MAGV
		  FROM THAMGIADT
   )
GO

-- d.
WITH CTE AS (
	SELECT K.MAKHOA, TENKHOA, COUNT(MABM) SLBM
	  FROM KHOA K
	  JOIN BOMON BM ON BM.MAKHOA = K.MAKHOA
	 GROUP BY K.MAKHOA, TENKHOA
  )
SELECT TENKHOA
  FROM CTE
 WHERE SLBM >= ALL (
	SELECT SLBM FROM CTE
 )
GO

-- e.
WITH CTE AS (
	SELECT DT.TENDT, GV.HOTEN, SUM(PHUCAP) TONG_PC
	  FROM DETAI DT
	  JOIN THAMGIADT TG ON TG.MADT = DT.MADT
	  JOIN GIAOVIEN GV ON GV.MAGV = TG.MAGV
	 GROUP BY DT.MADT, DT.TENDT, GV.MAGV, GV.HOTEN
  ), SUB AS (
	SELECT TENDT, MAX(TONG_PC) MAX_PC
	  FROM CTE
	 GROUP BY TENDT
  )
SELECT *
  FROM CTE T1
 WHERE TONG_PC >= (
	SELECT MAX_PC
	  FROM SUB T2
	 WHERE T2.TENDT LIKE T1.TENDT
 )
GO

-- f.
SELECT TOP (1) HOTEN TEN_TRUONGKHOA
	 , (YEAR(GETDATE()) - YEAR(NGSINH)) AS TUOI_TRUONGKHOA
  FROM KHOA K
  JOIN GIAOVIEN GV ON GV.MAGV = K.TRUONGKHOA
 ORDER BY (YEAR(GETDATE()) - YEAR(NGSINH)) ASC
GO

WITH CTE AS (
	SELECT HOTEN TEN_TRUONGKHOA
		 , (YEAR(GETDATE()) - YEAR(NGSINH)) AS TUOI_TRUONGKHOA
	  FROM KHOA K
	  JOIN GIAOVIEN GV ON GV.MAGV = K.TRUONGKHOA
  )
SELECT *
  FROM CTE
 WHERE TUOI_TRUONGKHOA <= ALL (
	SELECT TUOI_TRUONGKHOA FROM CTE
 )
GO

-- g.
SELECT DISTINCT GV.MAGV, GV.HOTEN
  FROM GIAOVIEN GV
  JOIN THAMGIADT TG ON TG.MAGV = GV.MAGV
 GROUP BY GV.MAGV, GV.HOTEN, TG.MADT
HAVING COUNT(DISTINCT STT) = (
		SELECT COUNT(SOTT)
		  FROM CONGVIEC CV
		 WHERE MADT = TG.MADT
  )
GO

-- h.
SELECT DISTINCT DT.MADT, DT.TENDT
  FROM DETAI DT
  JOIN THAMGIADT TG ON TG.MADT = DT.MADT
  JOIN GIAOVIEN GV ON GV.MAGV = TG.MAGV
  JOIN BOMON BM ON BM.MABM = GV.MABM
 WHERE CAPQL LIKE N'ĐHQG'
   AND TENBM LIKE N'Hệ thống thông tin'
 GROUP BY DT.MADT, DT.TENDT
HAVING COUNT(DISTINCT GV.MAGV) = (
		SELECT COUNT(MAGV)
		  FROM GIAOVIEN GV
		  JOIN BOMON BM ON BM.MABM = GV.MABM
		 WHERE TENBM LIKE N'Hệ thống thông tin' 
  )
GO

-- i.
WITH CTE AS (
	SELECT BM.MABM
		 , GV.MAGV
		 , GV.HOTEN
		 , COUNT(DISTINCT TG.MADT) AS SLDT
	  FROM GIAOVIEN GV
	  JOIN THAMGIADT TG ON TG.MAGV = GV.MAGV
	  JOIN BOMON BM ON BM.MABM = GV.MABM
	 GROUP BY BM.MABM, GV.MAGV, GV.HOTEN
  )
SELECT T1.MAGV, T1.HOTEN
  FROM CTE T1
 WHERE SLDT >= ALL (
	SELECT SLDT
	  FROM CTE T2
	 WHERE T2.MABM = T1.MABM
 )
GO
