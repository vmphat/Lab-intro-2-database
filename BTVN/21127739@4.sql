-- Họ và tên: Vũ Minh Phát
-- MSSV: 21127739
-- Lớp: 21CLC01 (Chiều T2)
-- BTVN: QLChuyenBay - Topic 4 - PHÉP CHIA

USE QLChuyenBay
GO

-- Q51. Cho biết mã những chuyến bay đã bay tất cả các máy bay của hãng "Boeing".
SELECT MACB
	 , COUNT(DISTINCT L.MALOAI) SLMB
  FROM LICHBAY LB
  JOIN MAYBAY MB ON MB.MALOAI=LB.MALOAI AND MB.SOHIEU=LB.SOHIEU
  JOIN LOAIMB L ON L.MALOAI = MB.MALOAI
 WHERE HANGSX = 'Boeing'
 GROUP BY MACB
HAVING COUNT(DISTINCT L.MALOAI) = (
		SELECT COUNT(MALOAI)
		  FROM LOAIMB
		 WHERE HANGSX = 'Boeing'
  )
GO

-- Q52. Cho biết mã và tên phi công có khả năng lái tất cả các máy bay của hãng "Airbus".
SELECT NV.MANV, NV.TEN
  FROM NHANVIEN NV
  JOIN KHANANG KN ON KN.MANV = NV.MANV
  JOIN LOAIMB L ON L.MALOAI = KN.MALOAI
 WHERE L.HANGSX = 'Airbus'
 GROUP BY NV.MANV, NV.TEN
HAVING COUNT(DISTINCT L.MALOAI) = (
		SELECT COUNT(MALOAI)
		  FROM LOAIMB
		 WHERE HANGSX = 'Airbus'
  )
GO

-- Q53. Cho biết tên nhân viên (không phải là phi công) được phân công bay vào tất cả các
--	chuyến bay có mã 100.
SELECT NV.MANV, NV.TEN
	 , COUNT(DISTINCT NGAYDI) SLCB
  FROM NHANVIEN NV
  JOIN PHANCONG PC ON PC.MANV = NV.MANV
 WHERE NV.LOAINV != 1
   AND PC.MACB = '100'
 GROUP BY NV.MANV, NV.TEN
HAVING COUNT(DISTINCT NGAYDI) = (
		SELECT COUNT(*)
		  FROM LICHBAY
		 WHERE MACB = '100'
  )
GO

-- Q54. Cho biết ngày đi nào mà có tất cả các loại máy bay của hãng "Boeing" tham gia.
SELECT LB.NGAYDI
	 , COUNT(DISTINCT L.MALOAI) SLMB
  FROM LICHBAY LB
  JOIN LOAIMB L ON L.MALOAI=LB.MALOAI 
 WHERE HANGSX = 'Boeing'
 GROUP BY LB.NGAYDI
HAVING COUNT(DISTINCT L.MALOAI) = (
		SELECT COUNT(MALOAI)
		  FROM LOAIMB
		 WHERE HANGSX = 'Boeing'
  )
GO

DROP PROCEDURE sp_XuatThongTin
GO
CREATE PROCEDURE sp_XuatThongTin @macb varchar(5)
AS 
BEGIN
	declare @t table(ma varchar(5))
	insert into  @t
	select MACB from CHUYENBAY
	
	declare @count INT = 0
	declare @i INT = 1
	
	SELECT @count = COUNT(*)
	  FROM @t
	  
	Print cast(@count as varchar)
	print ''
	
	while (@i <= @count)
	BEGIN 
		SELECT TOP(@i) *
		  FROM CHUYENBAY
		
		SET @i= @i+1
	END
	
END
GO



Exec sp_XuatThongTin '100'
GO