-- Họ và tên: Vũ Minh Phát
-- MSSV: 21127739
-- Lớp: 21CLC01 (chiều T2)
-- Bài tập tuần 5

USE QLGiaoVienThamGiaDeTai
GO

-- Q35. Mức lương cao nhất của GV
SELECT DISTINCT GV1.LUONG AS LUONG_CAO_NHAT_CUA_GV
  FROM GIAOVIEN GV1
 WHERE GV1.LUONG = (
	SELECT MAX(GV2.LUONG)
	  FROM GIAOVIEN GV2
 )

GO

-- Q36. Những GV có lương lớn nhất
SELECT GV1.*
  FROM GIAOVIEN GV1
 WHERE GV1.LUONG = (
	SELECT MAX(GV2.LUONG)
	  FROM GIAOVIEN GV2
 )

GO

-- Q37. Lương cao nhất trong bm 'HTTT'
SELECT MAX(GV_HTTT.LUONG) AS LUONG_CAO_NHAT_BM_HTTT
  FROM (
	SELECT LUONG
	  FROM GIAOVIEN
	 WHERE MABM = 'HTTT'
  ) AS GV_HTTT

GO

-- Q38. Tên GV lớn tuổi nhất bm 'Hệ thống thông tin'
-- Cách 2
WITH GV_BM_HTTT AS (
	SELECT GV.* 
		 , DATEDIFF(YYYY, GV.NGSINH, GETDATE()) TUOI_GV
	  FROM GIAOVIEN GV
	  JOIN BOMON BM ON BM.MABM=GV.MABM
	 WHERE BM.TENBM = N'Hệ thống thông tin' 
	)

SELECT T1.HOTEN AS TEN_GV_LON_TUOI_NHAT_BM_HTTT
  FROM GV_BM_HTTT T1
 WHERE T1.TUOI_GV >= ALL(
	SELECT T2.TUOI_GV
	  FROM GV_BM_HTTT T2
 )
---- Cách 1
--SELECT GV.HOTEN AS TEN_GV_LON_TUOI_NHAT_BM_HTTT
--  FROM GIAOVIEN GV
--  JOIN BOMON BM ON BM.MABM=GV.MABM
-- WHERE BM.TENBM = N'Hệ thống thông tin'
--   AND DATEDIFF(YYYY, GV.NGSINH, GETDATE()) = (
--	SELECT MAX(DATEDIFF(YYYY, GV.NGSINH, GETDATE()))
--	  FROM GIAOVIEN GV
--	  JOIN BOMON BM ON BM.MABM=GV.MABM
--	 WHERE BM.TENBM = N'Hệ thống thông tin'
--	)

GO

-- Q39. Tên GV nhỏ tuổi nhất khoa 'Công nghệ thông tin'
WITH GV_KHOA_CNTT AS (
	SELECT GV.*
		 , DATEDIFF(YYYY, GV.NGSINH, GETDATE()) AS TUOI_GV
	  FROM GIAOVIEN GV
	  JOIN BOMON BM ON BM.MABM=GV.MABM
	  JOIN KHOA K ON K.MAKHOA=BM.MAKHOA
	 WHERE K.TENKHOA = N'Công nghệ thông tin'
	)

SELECT T1.HOTEN AS TEN_GV_NHO_TUOI_NHAT_KHOA_CNTT
  FROM GV_KHOA_CNTT T1
 WHERE T1.TUOI_GV <= ALL(
	SELECT T2.TUOI_GV
	  FROM GV_KHOA_CNTT T2
 )

GO

-- Q40. Tên GV và tên Khoa của GV lương cao nhất
SELECT GV1.HOTEN AS TEN_GV
	 , K.TENKHOA
  FROM GIAOVIEN GV1
  LEFT JOIN BOMON BM ON BM.MABM=GV1.MABM
  LEFT JOIN KHOA K ON K.MAKHOA=BM.MAKHOA
 WHERE GV1.LUONG = (
	SELECT MAX(GV2.LUONG)
	  FROM GIAOVIEN GV2
 ) 

GO

-- Q41. Những GV lương lớn nhất trong bm của họ
SELECT GV1.*
  FROM GIAOVIEN GV1
  JOIN (
	SELECT MAX(LUONG) LUONG_CAO_NHAT
		 , MABM
	  FROM GIAOVIEN
	 GROUP BY MABM
  ) AS SUB_TABLE
    ON SUB_TABLE.MABM = GV1.MABM
 WHERE GV1.LUONG = SUB_TABLE.LUONG_CAO_NHAT

GO

-- Q42. Tên DT mà 'Nguyễn Hoài An' chưa tham gia
SELECT TENDT AS TEN_DE_TAI
  FROM DETAI
 WHERE MADT NOT IN (
	-- Những DT mà 'Nguyễn Hoài An' đã tham gia
	SELECT TGDT.MADT
	  FROM GIAOVIEN GV
	  JOIN THAMGIADT TGDT ON TGDT.MAGV = GV.MAGV
	 WHERE GV.HOTEN = N'Nguyễn Hoài An'	
 )

GO

-- Q43. DT mà 'Nguyễn Hoài An' chưa tham gia -> TENDT VÀ TEN GVCNDT
SELECT DT.TENDT AS TEN_DE_TAI
	 , GV.HOTEN AS TEN_NGUOI_CNDT
  FROM DETAI DT
  LEFT JOIN GIAOVIEN GV ON GV.MAGV=DT.GVCNDT
 WHERE DT.MADT NOT IN (
	-- Những DT mà 'Nguyễn Hoài An' đã tham gia
	SELECT TGDT.MADT
	  FROM GIAOVIEN GV
	  JOIN THAMGIADT TGDT ON TGDT.MAGV = GV.MAGV
	 WHERE GV.HOTEN = N'Nguyễn Hoài An'
 )

GO

-- Q44. Tên GV khoa 'Công nghệ thông tin' chưa tham gia DT
SELECT GV.HOTEN AS TEN_GV
  FROM GIAOVIEN GV
  JOIN BOMON BM ON BM.MABM = GV.MABM
  JOIN KHOA K ON K.MAKHOA = BM.MAKHOA
 WHERE K.TENKHOA = N'Công nghệ thông tin'
   AND GV.MAGV NOT IN (
	SELECT DISTINCT TGDT.MAGV
	  FROM THAMGIADT TGDT   
   )

GO

-- Q45. GV không tham gia DT nào
SELECT *
  FROM GIAOVIEN
 WHERE MAGV NOT IN (
	 SELECT DISTINCT MAGV
	   FROM THAMGIADT 
 )

GO

-- Q46. GV lương > 'Nguyễn Hoài An'
SELECT *
  FROM GIAOVIEN
 WHERE LUONG > (
	SELECT LUONG
	  FROM GIAOVIEN
	 WHERE HOTEN = N'Nguyễn Hoài An'
 )

GO

-- Q47. Trưởng BM (GV) tham gia tối thiểu 1 DT
SELECT GV.*
  FROM GIAOVIEN GV
  JOIN BOMON BM ON BM.TRUONGBM = GV.MAGV
 WHERE GV.MAGV IN (
	 SELECT DISTINCT MAGV
	   FROM THAMGIADT
 )

GO

-- Q48. GV trùng tên và cùng giới tính vs gv khác trong bm
SELECT GV.*
  FROM GIAOVIEN GV
 WHERE EXISTS (
	SELECT 1
	  FROM GIAOVIEN GV2
	 WHERE GV2.HOTEN LIKE GV.HOTEN
	   AND GV2.PHAI = GV.PHAI
	   AND GV2.MABM = GV.MABM
	   AND GV2.MAGV != GV.MAGV
 )

GO

-- Q49. GV lương > ít nhất 1 gv bm 'Công nghệ phần mềm'
SELECT *
  FROM GIAOVIEN
 WHERE LUONG > ANY(
	SELECT GV.LUONG
	  FROM GIAOVIEN GV
	  JOIN BOMON BM ON BM.MABM = GV.MABM
	 WHERE BM.TENBM = N'Công nghệ phần mềm'  -- N'Công nghệ phần mềm'
 )

GO

-- Q50. GV có lương > tất cả GV bm 'Hệ thống thông tin'
SELECT *
  FROM GIAOVIEN
 WHERE LUONG > ALL(
	SELECT GV.LUONG
	  FROM GIAOVIEN GV
	  JOIN BOMON BM ON BM.MABM = GV.MABM
	 WHERE BM.TENBM = N'Hệ thống thông tin'
 )

GO

-- Q51. Tên Khoa đông GV nhất
WITH KHOA_VA_SLGV AS (
	SELECT K.TENKHOA
		 , COUNT(*) AS SLGV
	  FROM GIAOVIEN GV
	  JOIN BOMON BM ON BM.MABM = GV.MABM
	  JOIN KHOA K ON K.MAKHOA = BM.MAKHOA
	 GROUP BY K.TENKHOA	
	)

SELECT TENKHOA AS TEN_KHOA
  FROM KHOA_VA_SLGV
 WHERE SLGV = (
	SELECT MAX(SLGV)
	  FROM KHOA_VA_SLGV
 )

GO

-- Q52. Hoten GV CN nhiều DT nhất
SELECT GV.HOTEN AS HOTEN_GV
  FROM GIAOVIEN GV
  JOIN DETAI DT ON DT.GVCNDT = GV.MAGV
 GROUP BY GV.HOTEN
HAVING COUNT(MADT) >= ALL(
	SELECT COUNT(MADT) AS SLDT
	  FROM DETAI
	 GROUP BY GVCNDT
	)

GO

-- Q53. MABM nhiều GV nhất
SELECT MABM AS MA_BOMON
  FROM GIAOVIEN
 GROUP BY MABM
HAVING COUNT(*) >= ALL(
	SELECT COUNT(*) AS SLGV
		 --, MABM
	  FROM GIAOVIEN
	 GROUP BY MABM
  )

GO

-- Q54. Tên GV và tên BM -> Tham gia nhiều DT nhất
SELECT GV.HOTEN AS TEN_GIAOVIEN
	 , BM.TENBM AS TEN_BOMON
  FROM GIAOVIEN GV
  JOIN BOMON BM ON BM.MABM = GV.MABM
  JOIN THAMGIADT TGDT ON TGDT.MAGV = GV.MAGV
 GROUP BY GV.HOTEN, BM.TENBM
HAVING COUNT(DISTINCT TGDT.MADT) >= ALL(
	SELECT COUNT(DISTINCT MADT)
		 --, MAGV
	  FROM THAMGIADT
	 GROUP BY MAGV
  )

GO
 
-- Q55. Tên GV tham gia nhiều DT nhất BM 'HTTT'
WITH GV_BM_HTTT_TGDT AS (
	SELECT GV.HOTEN AS TEN_GV
		 , COUNT(DISTINCT TGDT.MADT) AS SLDT
	  FROM GIAOVIEN GV
	  JOIN THAMGIADT TGDT ON TGDT.MAGV = GV.MAGV
	 WHERE GV.MABM = N'HTTT'
	 GROUP BY GV.HOTEN
  )
  
SELECT T1.TEN_GV
  FROM GV_BM_HTTT_TGDT T1
 WHERE T1.SLDT >= ALL (
	SELECT T2.SLDT
	  FROM GV_BM_HTTT_TGDT T2
 )
 
GO

-- Q56. Tên GV và tên BM của GV có nhiều NT nhất
SELECT GV.HOTEN AS TEN_GV
	 , BM.TENBM AS TEN_BOMON
  FROM GIAOVIEN GV
  JOIN BOMON BM ON BM.MABM = GV.MABM
  JOIN NGUOITHAN NT ON NT.MAGV = GV.MAGV
 GROUP BY GV.HOTEN, BM.TENBM
HAVING COUNT(NT.TEN) >= ALL (
	SELECT COUNT(TEN)
		 --, MAGV
	  FROM NGUOITHAN
	 GROUP BY MAGV
  )

GO

-- Q57. Tên trưởng BM (GV) chủ nhiệm nhiều DT nhất
SELECT GV.HOTEN
  FROM GIAOVIEN GV
  JOIN BOMON BM ON BM.TRUONGBM = GV.MAGV
  JOIN DETAI DT ON DT.GVCNDT = GV.MAGV
 GROUP BY GV.HOTEN
HAVING COUNT(DT.MADT) >= ALL (
	SELECT COUNT(MADT)
		 --, GVCNDT
	  FROM DETAI
	 GROUP BY GVCNDT
  )

GO