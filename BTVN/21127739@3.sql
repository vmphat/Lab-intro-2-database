-- Họ và tên: Vũ Minh Phát
-- MSSV: 21127739
-- Lớp: 21CLC01 (Chiều T2)
-- BTVN: QLChuyenBay - Topic 3 - TRUY VẤN LỒNG + HÀM

USE QLChuyenBay
GO

-- Q34. Cho biết hãng sản xuất, mã loại và số hiệu của máy bay đã được sử dụng nhiều nhất.
WITH CTE AS (
	SELECT L.HANGSX, L.MALOAI, MB.SOHIEU
		 , COUNT(*) SLSD
	  FROM LOAIMB L
	  JOIN MAYBAY MB ON MB.MALOAI = L.MALOAI
	  JOIN LICHBAY LB ON LB.SOHIEU=MB.SOHIEU AND LB.MALOAI=MB.MALOAI
	 GROUP BY L.HANGSX, L.MALOAI, MB.SOHIEU
  )
SELECT HANGSX, MALOAI, SOHIEU
  FROM CTE
 WHERE SLSD >= ALL (
	SELECT SLSD FROM CTE
 )
GO

-- Q35. Cho biết tên nhân viên được phân công đi nhiều chuyến bay nhất.
WITH CTE AS (
	SELECT NV.MANV, NV.TEN
		 , COUNT(DISTINCT MACB) SLCB
	  FROM NHANVIEN NV
	  JOIN PHANCONG PC ON PC.MANV = NV.MANV
	 GROUP BY NV.MANV, NV.TEN
  )
SELECT TEN TEN_NHANVIEN
  FROM CTE
 WHERE SLCB = (
	SELECT MAX(SLCB) FROM CTE
 )
GO

-- Q36. Cho biết thông tin của phi công (tên, địa chỉ, điện thoại) lái nhiều chuyến bay nhất.
WITH CTE AS (
	SELECT NV.TEN, NV.DCHI, NV.DTHOAI
		 , COUNT(DISTINCT MACB) SLCB
	  FROM NHANVIEN NV
	  JOIN PHANCONG PC ON PC.MANV = NV.MANV
	 WHERE NV.LOAINV = 1
	 GROUP BY NV.TEN, NV.DCHI, NV.DTHOAI
  )
SELECT TEN, DCHI, DTHOAI
  FROM CTE
 WHERE SLCB = ( SELECT MAX(SLCB) FROM CTE )
GO

-- Q37. Cho biết sân bay (SBDEN) và số lượng chuyến bay của sân bay
--	có ít chuyến bay đáp xuống nhất.
WITH CTE AS (
	SELECT CB.SBDEN, COUNT(MACB) SLCB
	  FROM CHUYENBAY CB
	 GROUP BY CB.SBDEN
  )
SELECT *
  FROM CTE 
 WHERE SLCB <= ALL ( SELECT SLCB FROM CTE )
GO

-- Q38. Cho biết sân bay (SBDI) và số lượng chuyến bay của 
--	sân bay có nhiều chuyến bay xuất phát nhất.
WITH CTE AS (
	SELECT CB.SBDI, COUNT(MACB) SLCB
	  FROM CHUYENBAY CB
	 GROUP BY CB.SBDI
  )
SELECT *
  FROM CTE 
 WHERE SLCB >= ALL ( SELECT SLCB FROM CTE )
GO

-- Q39. Cho biết tên, địa chỉ, và điện thoại của khách hàng đã đi trên nhiều chuyến bay nhất.
WITH CTE AS (
	SELECT KH.TEN, KH.DCHI, KH.DTHOAI
		 , COUNT(DISTINCT MACB) SLCB
	  FROM KHACHHANG KH
	  JOIN DATCHO DC ON DC.MAKH = KH.MAKH
	 GROUP BY KH.TEN, KH.DCHI, KH.DTHOAI	
  )
SELECT TEN, DCHI, DTHOAI
  FROM CTE
 WHERE SLCB >= ALL ( SELECT SLCB FROM CTE )
GO

-- Q40. Cho biết mã số, tên và lương của các phi công có khả năng lái nhiều loại máy bay nhất.
WITH CTE AS (
	SELECT NV.MANV, NV.TEN, NV.LUONG
		 , COUNT(MALOAI) AS SL_LOAI_MB
	  FROM NHANVIEN NV
	  JOIN KHANANG KN ON KN.MANV = NV.MANV
	 WHERE NV.LOAINV = 1
	 GROUP BY NV.MANV, NV.TEN, NV.LUONG
  )
SELECT MANV, TEN, LUONG
  FROM CTE
 WHERE SL_LOAI_MB >= ALL ( SELECT SL_LOAI_MB FROM CTE )
GO

-- Q41. Cho biết thông tin (mã nhân viên, tên, lương) của nhân viên có mức lương cao nhất.
SELECT MANV, TEN, LUONG
  FROM NHANVIEN
 WHERE LUONG >= ALL ( SELECT LUONG FROM NHANVIEN )
GO

-- Q42. Cho biết tên, địa chỉ của các nhân viên có lương cao nhất trong phi hành đoàn 
--	(các nhân viên được phân công trong một chuyến bay) mà người đó tham gia.
WITH CTE AS (
	SELECT MACB, NGAYDI, NV.MANV, NV.TEN, NV.DCHI, NV.LUONG
	  FROM NHANVIEN NV
	  JOIN PHANCONG PC ON PC.MANV = NV.MANV  
  ), SUB AS (
	SELECT MACB, NGAYDI, MAX(LUONG) MAX_LUONG
	  FROM CTE
	  GROUP BY MACB, NGAYDI 
  )
SELECT MACB, NGAYDI, TEN, DCHI
  FROM CTE
 WHERE LUONG = (
	SELECT MAX_LUONG
	  FROM SUB
	 WHERE SUB.MACB = CTE.MACB AND SUB.NGAYDI = CTE.NGAYDI
 )
GO

-- Q43. Cho biết mã chuyến bay, giờ đi và giờ đến của chuyến bay bay sớm nhất trong ngày.
WITH CTE AS (
	SELECT CB.MACB, CB.GIODI, CB.GIODEN, LB.NGAYDI
	  FROM CHUYENBAY CB
	  JOIN LICHBAY LB ON LB.MACB = CB.MACB
  ), SUB AS (
	SELECT NGAYDI
		 , MIN(GIODI) MIN_GIODI
	  FROM CTE
	 GROUP BY NGAYDI
  )
SELECT NGAYDI, MACB, GIODI, GIODEN
  FROM CTE
 WHERE GIODI = (
	SELECT MIN_GIODI FROM SUB WHERE SUB.NGAYDI = CTE.NGAYDI
 )
GO

-- Q44. Cho biết mã chuyến bay có thời gian bay dài nhất. 
--	Xuất ra mã chuyến bay và thời gian bay (tính bằng phút).
WITH CTE AS (
	SELECT *
		 , DATEDIFF(MINUTE, GIODI, GIODEN) TG_BAY
	  FROM CHUYENBAY
  )
SELECT MACB, TG_BAY
  FROM CTE
 WHERE TG_BAY >= ALL (SELECT TG_BAY FROM CTE)
GO

-- Q45. Cho biết mã chuyến bay có thời gian bay ít nhất. Xuất ra mã chuyến bay và thời gian bay.
WITH CTE AS (
	SELECT *
		 , DATEDIFF(MINUTE, GIODI, GIODEN) TG_BAY
	  FROM CHUYENBAY
  )
SELECT MACB, TG_BAY
  FROM CTE
 WHERE TG_BAY <= ALL (SELECT TG_BAY FROM CTE)
GO

-- Q46. Cho biết mã chuyến bay và ngày đi của những chuyến bay 
--	bay trên loại máy bay B747 nhiều nhất
WITH CTE AS (
	SELECT LB.MACB
		 , COUNT(*) SLCB
	  FROM LICHBAY LB
	 WHERE MALOAI = 'B747'
	 GROUP BY LB.MACB
  )
SELECT MACB, NGAYDI
  FROM LICHBAY
 WHERE MACB IN (
	 SELECT MACB
	   FROM CTE
	  WHERE SLCB >= ALL ( SELECT SLCB FROM CTE )
 )
GO

-- Q47. Với mỗi chuyến bay có trên 2 hành khách, cho biết mã chuyến bay và số lượng nhân viên
--	trên chuyến bay đó. Xuất ra mã chuyến bay và số lượng nhân viên.
WITH CTE AS (
	SELECT LB.NGAYDI, LB.MACB
	  FROM KHACHHANG KH
	  JOIN DATCHO DC ON DC.MAKH = KH.MAKH
	  JOIN LICHBAY LB ON LB.NGAYDI=DC.NGAYDI AND LB.MACB=DC.MACB
	 GROUP BY LB.NGAYDI, LB.MACB
	HAVING COUNT(KH.MAKH) > 2
  )
SELECT CTE.NGAYDI, CTE.MACB
	 , COUNT(DISTINCT MANV) SLNV
  FROM CTE
  LEFT JOIN PHANCONG PC ON PC.NGAYDI=CTE.NGAYDI AND PC.MACB=CTE.MACB
 GROUP BY CTE.NGAYDI, CTE.MACB
GO

-- Q48. Với mỗi loại nhân viên có tổng lương trên 600000, cho biết số lượng nhân viên trong
--	từng loại nhân viên đó. Xuất ra loại nhân viên, và số lượng nhân viên tương ứng.
SELECT LOAINV
	 , COUNT(MANV) SLNV
	 , SUM(LUONG) TONG_LUONG
  FROM NHANVIEN
 GROUP BY LOAINV
HAVING SUM(LUONG) > 600000
GO

-- Q49. Với mỗi chuyến bay có trên 3 nhân viên, cho biết mã chuyến bay và số lượng khách hàng
--	đã đặt chỗ trên chuyến bay đó.
WITH CTE AS (
	SELECT PC.NGAYDI, PC.MACB
		 , COUNT(MANV) SLNV
	  FROM PHANCONG PC
	 GROUP BY PC.NGAYDI, PC.MACB
	HAVING COUNT(MANV) > 3
  )
SELECT CTE.NGAYDI, CTE.MACB
	 , COUNT(MAKH) AS SLKH
  FROM CTE
  LEFT JOIN DATCHO DC ON DC.NGAYDI=CTE.NGAYDI AND DC.MACB=CTE.MACB
 GROUP BY CTE.NGAYDI, CTE.MACB
GO

-- Q50. Với mỗi loại máy bay có nhiều hơn một chiếc, cho biết số lượng chuyến bay đã được bố
--	trí bay bằng loại máy bay đó. Xuất ra mã loại và số lượng.
WITH CTE AS (
	SELECT MALOAI
		 --, COUNT(SOHIEU) SLMB
	  FROM MAYBAY MB
	 GROUP BY MALOAI
	HAVING COUNT(SOHIEU) > 1
  )
SELECT CTE.MALOAI
	 , COUNT(*) SLCB
  FROM CTE
  LEFT JOIN LICHBAY LB ON LB.MALOAI=CTE.MALOAI
 GROUP BY CTE.MALOAI
GO

/*
SELECT MALOAI, COUNT(*) SLCB
  FROM LICHBAY
 GROUP BY MALOAI
*/