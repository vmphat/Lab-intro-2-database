-- Họ và tên: Vũ Minh Phát
-- MSSV: 21127739
-- Lớp: 21CLC01 (Chiều T2)
-- Bài tập trên lớp - Topic 8

SET ANSI_WARNINGS OFF; -- MỞ KHI NỘP BÀI
GO

USE QLGiaoVienThamGiaDeTai
GO

-- ******************** 3. Bài tập tại lớp ********************
Print N'+--------------------------------------------------------+'
Print N'|                   3. BÀI TẬP TẠI LỚP                   |'
Print N'+--------------------------------------------------------+'
Print ''

-- ******************** STORED PROCEDURE ********************
Print '******************** STORED PROCEDURE ********************'
GO

-- a. In 'Hello World'
Print ''
Print N'a. In ra câu chào “Hello World !!!”.'
GO

DROP PROCEDURE sp_InHelloWorld
GO
CREATE PROCEDURE sp_InHelloWorld
AS
	Print 'Hello World !!!'
GO

EXEC sp_InHelloWorld
GO

-- b. In tổng 2 số
Print ''
Print N'b. In ra tổng 2 số.'
GO

DROP PROCEDURE sp_InTongHaiSo
GO
CREATE PROCEDURE sp_InTongHaiSo @num_1 INT, @num_2 INT
AS
	print @num_1 + @num_2
GO

declare @num_1 int = 24
declare @num_2 int = 48

Print N'>> Tổng của ' + cast(@num_1 as varchar) + N' và ' + cast(@num_2 as varchar) + N' là:'
Exec sp_InTongHaiSo @num_1, @num_2
GO

-- c. Tính tổng 2 số (sử dụng biến output để lưu kết quả trả về).
Print ''
Print N'c. Tính tổng 2 số (sử dụng biến output để lưu kết quả trả về).'
GO

DROP PROCEDURE sp_TinhTongHaiSo
GO
CREATE PROCEDURE sp_TinhTongHaiSo @num_1 INT, @num_2 INT, @Tong INT out
AS
	SET @Tong = @num_1 + @num_2
GO

declare @num_1 int = 12
declare @num_2 int = 88
Declare @Tong INT

Print N'>> Tổng của ' + cast(@num_1 as varchar) + N' và ' + cast(@num_2 as varchar) + N' là:'
Exec sp_TinhTongHaiSo @num_1, @num_2, @Tong out
Print @Tong
GO

-- d. In ra tổng 3 số (Sử dụng lại stored procedure Tính tổng 2 số).
Print ''
Print N'd. In ra tổng 3 số (Sử dụng lại stored procedure Tính tổng 2 số).'
GO

DROP PROCEDURE sp_InTongBaSo
GO
CREATE PROCEDURE sp_InTongBaSo @num_1 INT, @num_2 INT, @num_3 INT
AS BEGIN
	Declare @tmp_Sum INT
	Exec sp_TinhTongHaiSo @num_1, @num_2, @tmp_Sum out
	Exec sp_TinhTongHaiSo @tmp_Sum, @num_3, @tmp_Sum out
	Print @tmp_Sum
END
GO

declare @num_1 int = 4
declare @num_2 int = 8
declare @num_3 int = 12

Print N'>> Tổng của 3 số: ' + cast(@num_1 as varchar) + ', ' + cast(@num_2 as varchar) + N' và ' + cast(@num_3 as varchar) + N' là:'
Exec sp_InTongBaSo @num_1, @num_2, @num_3
GO

-- e. In ra tổng các số nguyên từ m đến n.
Print ''
Print N'e. In ra tổng các số nguyên từ m đến n.'

DROP PROCEDURE sp_InTongSoNguyenMN
GO
CREATE PROCEDURE sp_InTongSoNguyenMN @m INT, @n INT
AS BEGIN
	IF @m > @n
		raiserror (N'Giá trị của tham số m phải bé hơn hoặc bằng n!', 16, 1)
	
	Declare @Sum INT
	SET @Sum = (@m + @n) * (@n - @m + 1) / 2
	Print @Sum
END
GO

declare @m int = 12
declare @n int = 24

Print N'>> Tổng các số nguyên từ ' + cast(@m as varchar) + N' đến ' + cast(@n as varchar) + N' là:'
Exec sp_InTongSoNguyenMN @m, @n
GO

-- f. Kiểm tra 1 số nguyên có phải là số nguyên tố hay không.
Print ''
Print N'f. Kiểm tra 1 số nguyên có phải là số nguyên tố hay không.'
GO

DROP PROCEDURE sp_KiemTraSoNguyenTo
GO
CREATE PROCEDURE sp_KiemTraSoNguyenTo @num INT, @isPrime BIT out
AS 
BEGIN
	IF @num < 2
	begin
		SET @isPrime = 0
		return
	end

	Declare @i INT = 2
	Declare @limit INT = sqrt(@num)
	SET @isPrime = 1
	
	WHILE @i <= @limit
	BEGIN
		IF @num % @i = 0
		BEGIN
			SET @isPrime = 0
			BREAK
		END
		SET @i = @i + 1
	END
	
END
GO

Declare @num INT = 9
Declare @isPrime bit = 0
Exec sp_KiemTraSoNguyenTo @num, @isPrime out

Print N'>> Số ' + cast(@num as varchar) + N':'
IF (@isPrime = 1)
	Print N'Là số nguyên tố.'
ELSE
	Print N'Không phải số nguyên tố!'
GO

-- g. In ra tổng các số nguyên tố trong đoạn m, n.
Print ''
Print N'g. In ra tổng các số nguyên tố trong đoạn m, n.'
GO

DROP PROCEDURE sp_InTongSoNguyenToMN
GO
CREATE PROCEDURE sp_InTongSoNguyenToMN @m INT, @n INT
AS
BEGIN
	declare @sum int = 0
	
	if @m > @n
	BEGIN
		Print @sum
		return
	END
	
	declare @x int = @m
	while (@x <= @n)
	begin
		declare @isPrime bit = 0
		Exec sp_KiemTraSoNguyenTo @x, @isPrime out
		if (@isPrime = 1)
			set @sum = @sum + @x
		set @x = @x + 1
	end
	
	Print @sum
END
GO

declare @m int = 1
declare @n int = 24
print N'>> Tổng các số nguyên tố trong đoạn '+cast(@m as varchar)+', '+cast(@n as varchar)+N' là:'
exec sp_InTongSoNguyenToMN @m, @n
go


-- h. Tính ước chung lớn nhất của 2 số nguyên
Print ''
Print N'h. Tính ước chung lớn nhất của 2 số nguyên.'
GO

DROP PROCEDURE sp_TinhUCLN
GO
CREATE PROCEDURE sp_TinhUCLN @a int, @b int, @ucln int out
AS
BEGIN
	-- Nếu a hoặc b bằng 0 thì trả về số còn lại
	IF (@a = 0)
	begin
		set @ucln = @b
		return
	end
	
	IF (@b = 0)
	begin
		set @ucln = @a
		return
	end
	
	-- Nếu a và b đều khác 0 thì áp dụng thuật toán Euclid
	declare @tmp_a int = @a
	declare @tmp_b int = @b
	while (@tmp_a != @tmp_b)
	begin
		IF (@tmp_a > @tmp_b)
			set @tmp_a = @tmp_a - @tmp_b
		ELSE
			set @tmp_b = @tmp_b - @tmp_a
	end
	SET @ucln = @tmp_a
	
END
GO

declare @a int = 24
declare @b int = 100
declare @ucln int = -1
exec sp_TinhUCLN @a, @b, @ucln out

Print N'>> Uớc chung lớn nhất của '+cast(@a as varchar)+N' và '+cast(@b as varchar)+' là:'
print @ucln
GO

-- i. Tính bội chung nhỏ nhất của 2 số nguyên.
Print ''
Print N'i. Tính bội chung nhỏ nhất của 2 số nguyên.'
GO

DROP PROCEDURE sp_TinhBCNN
GO
CREATE PROCEDURE sp_TinhBCNN @a INT, @b INT, @bcnn INT OUT
AS
BEGIN
	Declare @ucnn INT = -1
	Exec sp_TinhUCLN @a, @b, @ucnn out
	SET @bcnn = @a * @b / @ucnn

END
GO

declare @a int = 10
declare @b int = 24
declare @bcnn int = -1
exec sp_TinhBCNN @a, @b, @bcnn out

Print N'>> Bội chung nhỏ nhất của '+cast(@a as varchar)+N' và '+cast(@b as varchar)+' là:'
print @bcnn
GO

-- ******************** STORED PROCEDURE ********************
Print ''
Print '******************** STORED PROCEDURE ********************'
GO

USE QLGiaoVienThamGiaDeTai
GO

-- j. Xuất ra toàn bộ danh sách giáo viên.
Print ''
Print N'j. Xuất ra toàn bộ danh sách giáo viên.'
go

DROP PROCEDURE sp_XuatDanhSachGV
GO
CREATE PROCEDURE sp_XuatDanhSachGV
AS
BEGIN
	SELECT * FROM GIAOVIEN
END 
GO

Exec sp_XuatDanhSachGV
GO

-- k. Tính số lượng đề tài mà một giáo viên đang thực hiện.
Print ''
Print N'k. Tính số lượng đề tài mà một giáo viên đang thực hiện.'
go

DROP PROCEDURE sp_TinhSoLuongDeTai
GO
CREATE PROCEDURE sp_TinhSoLuongDeTai @MaGV char(5), @SLDeTai INT out
AS
BEGIN
	SELECT @SLDeTai = COUNT(DISTINCT MADT) 
	  FROM THAMGIADT
	 WHERE MAGV = @MaGV
END
GO

Declare @MaGV varchar(5) = '003'
Declare @SLDeTai INT = -1
Exec sp_TinhSoLuongDeTai @MaGV, @SLDeTai out

Print N'>> Số lượng đề tài mà giáo viên ' 
	+ @MaGV + N' đang thực hiện:'
Print @SLDeTai
go

-- l. In thông tin chi tiết của một giáo viên(sử dụng lệnh print): Thông tin cá
--		nhân, Số lượng đề tài tham gia, Số lượng thân nhân của giáo viên đó.
Print ''
Print N'l. In thông tin chi tiết của một giáo viên(sử dụng lệnh print).'
go

DROP PROCEDURE sp_InThongTinChiTietGV
GO
CREATE PROCEDURE sp_InThongTinChiTietGV @magv varchar(5)
AS
BEGIN
	-- Thông tin cá nhân
	declare @HoTen nvarchar(40) = N''
	declare @Luong float = 0
	declare @Phai nvarchar(5) = N''
	declare @NgSinh date
	declare @DiaChi nvarchar(50) = N''
	declare @GVQLCM varchar(5) = ''
	declare @MaBM nvarchar(5) = N''
	
	-- Số lượng đề tài tham gia
	declare @SLDeTai int = -1
	
	-- Số lượng thân nhân
	declare @SLThanNhan int = -1
	
	-- Lấy thông tin cá nhân
	SELECT @HoTen = HOTEN
		 , @Luong = LUONG
		 , @Phai = PHAI
		 , @NgSinh = NGSINH
		 , @DiaChi = DIACHI
		 , @GVQLCM = (CASE WHEN GVQLCM IS NOT NULL THEN GVQLCM ELSE '' END)
		 , @MaBM = MABM 
	  FROM GIAOVIEN gv
	 WHERE MAGV = @magv
	
	-- Lấy số lượng đề tài tham gia
	SELECT @SLDeTai = COUNT(DISTINCT MADT)
	  FROM THAMGIADT
	 WHERE MAGV = @magv
	 
	-- Lấy Số lượng thân nhân
	SELECT @SLThanNhan = COUNT(TEN)
	  FROM NGUOITHAN
	 WHERE MAGV = @magv
	
	-- Xuất các thông tin cần thiết
	Print N'Mã giáo viên: ' + @magv
	Print N'Họ và tên: ' + @HoTen
	Print N'Lương: ' + cast(@Luong as varchar)
	Print N'Phái: ' + @Phai
	Print N'Ngày sinh: ' + cast(@NgSinh as varchar)
	Print N'Địa chỉ: ' + @DiaChi
	Print N'Giáo viên quản lý chuyên môn: ' + @GVQLCM
	Print N'Mã bộ môn: ' + @MaBM
	
	Print N'Số lượng đề tài tham gia: ' + cast(@SLDeTai as varchar)
	Print N'Số lượng thân nhân: ' + cast(@SLThanNhan as varchar)
	
END
GO

declare @magv varchar(5) = '001'
Print N'>> Thông tin chi tiết của giáo viên có mã ' + @magv + ':'
Exec sp_InThongTinChiTietGV @magv
GO

-- m. Kiểm tra xem một giáo viên có tồn tại hay không (dựa vào MAGV).
Print ''
Print N'm. Kiểm tra xem một giáo viên có tồn tại hay không (dựa vào MAGV).'
GO

DROP PROCEDURE sp_KiemTraGVTonTai
GO
CREATE PROCEDURE sp_KiemTraGVTonTai @magv varchar(5)
AS
BEGIN
	IF(EXISTS(SELECT * FROM GIAOVIEN WHERE MAGV = @magv))
		--Print N'Giáo viên có mã ' + @magv + N' tồn tại.'
		Print N'Tồn tại.'
	ELSE
		Print N'Không tồn tại!'
END
GO

declare @magv varchar(5) = '001'
Print N'>> Giáo viên có mã ' + @magv + N' :'
Exec sp_KiemTraGVTonTai @magv
GO

-- n. Kiểm tra quy định của một giáo viên: Chỉ được thực hiện các đề tài mà bộ
--	môn của giáo viên đó làm chủ nhiệm.
Print ''
Print N'n. Kiểm tra quy định của một giáo viên.'
GO

DROP FUNCTION fKiemTraGVTonTai
GO
CREATE FUNCTION fKiemTraGVTonTai (@magv char(5))
RETURNS BIT 
AS
BEGIN
	IF(EXISTS(SELECT * FROM GIAOVIEN WHERE MAGV = @magv))
		RETURN 1
	RETURN 0
END 
GO

DROP FUNCTION fKiemTraQuyDinhGV
GO
CREATE FUNCTION fKiemTraQuyDinhGV (@magv char(5))
RETURNS BIT
AS
BEGIN
	declare @counter INT = -1;
	-- Ý tưởng: Tìm tất cả BM chủ nhiệm những đề tài có @magv tham gia.
	--			Nếu tất cả BM tìm được đều trùng khớp vs MABM của @magv
	--				thì @magv được xem là phù hợp với quy định
	WITH BMCNDT AS (
		SELECT DISTINCT BM.MABM BM_GVCNDT
		  FROM THAMGIADT TG
		  JOIN DETAI DT ON DT.MADT = TG.MADT
		  JOIN GIAOVIEN GV ON GV.MAGV = DT.GVCNDT
		  JOIN BOMON BM ON BM.MABM = GV.MABM
		 WHERE TG.MAGV = @magv
	  ), CTE AS (
		SELECT BM_GVCNDT
		  FROM BMCNDT
		EXCEPT
		SELECT BM.MABM
		  FROM GIAOVIEN GV
		  JOIN BOMON BM ON BM.MABM = GV.MABM
		 WHERE GV.MAGV = @magv
	   )
	SELECT @counter = COUNT(*)
	  FROM CTE

	IF (@counter = 0)
		return 1
	return 0
END
GO

DROP PROCEDURE sp_KiemTraQuyDinhGV
GO
CREATE PROCEDURE sp_KiemTraQuyDinhGV @magv varchar(5)
AS
BEGIN
	IF (dbo.fKiemTraGVTonTai(@magv) = 0)
	BEGIN
		Print N'Không tồn tại giáo viên có mã ' + @magv + '!'
		return
	END
	
	IF (dbo.fKiemTraQuyDinhGV(@magv) = 1)
		Print N'Phù hợp quy định.'
	ELSE
		Print N'Không phù hợp với quy định!'

END
GO

declare @magv varchar(5) = '001';
Print N'>> Kiểm tra quy định của giáo viên có mã ' + @magv + N', kết quả là:'
Exec sp_KiemTraQuyDinhGV @magv
GO

-- o. Thực hiện thêm một phân công cho giáo viên thực hiện một công việc của
--		đề tài:
Print ''
Print N'o. Thực hiện thêm một phân công...'
go

DROP FUNCTION fKiemTraCongViecTonTai
GO
CREATE FUNCTION fKiemTraCongViecTonTai (@madt varchar(5), @stt varchar(2))
RETURNS BIT
AS
BEGIN
	IF (EXISTS(SELECT * FROM CONGVIEC WHERE MADT=@madt AND SOTT=@stt))
		return 1
	return 0
END
GO

DROP FUNCTION fKiemTraTGDTTonTai
GO
CREATE FUNCTION fKiemTraTGDTTonTai(@magv varchar(5), @madt varchar(5), @stt varchar(2))
RETURNS BIT
AS
BEGIN
	IF (EXISTS(SELECT * FROM THAMGIADT WHERE MAGV=@magv AND MADT=@madt AND STT=@stt))
		return 1
	return 0
END
GO

DROP FUNCTION fKiemTraQuyDinhGVTGDT
GO
CREATE FUNCTION fKiemTraQuyDinhGVTGDT (@magv char(5), @madt varchar(5))
RETURNS BIT
AS
BEGIN
	declare @counter INT = -1;
	WITH BM_GVCNDT AS (
		SELECT GV.MABM MABM_GVCNDT
		  FROM DETAI DT
		  JOIN GIAOVIEN GV ON GV.MAGV = DT.GVCNDT
		 WHERE DT.MADT = @madt 
	  ), BM_GV AS (
		SELECT MABM GV_MABM
		  FROM GIAOVIEN GV
		 WHERE MAGV = @magv
	  )
	SELECT @counter = COUNT(*)
	  FROM (
		SELECT MABM_GVCNDT FROM BM_GVCNDT
		EXCEPT
		SELECT GV_MABM FROM BM_GV
	  ) as T

	IF (@counter = 0)
		return 1
	return 0
END
GO

DROP PROCEDURE sp_ThemMotPhanCong
GO
CREATE PROCEDURE sp_ThemMotPhanCong @magv varchar(5)
, @madt varchar(5), @stt varchar(2), @tgthamgia int
AS
BEGIN
	-- Kiểm tra thông tin đầu vào hợp lệ
	IF (dbo.fKiemTraGVTonTai(@magv) = 0)
	BEGIN
		DECLARE @msg_gv nvarchar(50) = N'Mã giáo viên ' + @magv + N' không tồn tại!'
		raiserror (@msg_gv, 16, 1)
		return
	END
	
	IF (dbo.fKiemTraCongViecTonTai(@madt, @stt) = 0)
	BEGIN
		DECLARE @msg_cv nvarchar(100) = N'Công việc với mã đề tài ' + @madt 
		+ N' và số thứ tự ' + @stt + N' không tồn tại!'
		raiserror (@msg_cv, 16, 1)
		return
	END
	
	IF (@tgthamgia <= 0)
	BEGIN
		raiserror (N'Thời gian tham gia phải > 0 !', 16, 1)
		return
	END
	
	-- Kiểm tra quy định ở câu n.
	IF (dbo.fKiemTraQuyDinhGVTGDT(@magv, @madt) = 0)
		BEGIN
		raiserror (N'Giáo viên chỉ được thực hiện các đề tài do bộ môn của giáo viên đó làm chủ nhiệm!', 16, 1)
		return
	END
		
	-- Nếu mọi tham số đều hợp lệ thì ta thêm một phân công tương ứng
	IF (dbo.fKiemTraTGDTTonTai(@magv, @madt, @stt) = 0)
	begin
		INSERT INTO THAMGIADT(MAGV, MADT, STT)
		VALUES (@magv, @madt, @stt)
	end	
	Print N'Đã thêm thành công 1 phân công mới!'

END
GO

declare @magv varchar(5) = '002'
declare @madt varchar(5) = '001'
declare @stt varchar(2) = '3'
declare @tgthamgia int = 4

Print N'>> Thêm 1 phân công với:'
Print N'  (+) Mã giáo viên: ' + @magv
Print N'  (+) Công việc có mã đề tài: ' + @madt + N' và số thứ tự: ' + @stt
Print N'  (+) Thời gian tham gia: ' + cast(@tgthamgia as varchar)

exec sp_ThemMotPhanCong @magv, @madt, @stt, @tgthamgia
go

-- p. Thực hiện xoá một giáo viên theo mã. Nếu giáo viên có thông tin liên quan
--		(Có thân nhân, có làm đề tài, …) thì báo lỗi.
Print ''
Print N'p. Thực hiện xoá một giáo viên theo mã.'
GO

DROP FUNCTION f_is_GV_in_NGUOITHAN
GO
CREATE FUNCTION f_is_GV_in_NGUOITHAN (@magv varchar(5))
RETURNS BIT
AS
BEGIN
	IF (EXISTS(SELECT * FROM NGUOITHAN WHERE MAGV = @magv))
		return 1
	return 0
END
GO

DROP FUNCTION f_is_GV_in_GV_DT
GO
CREATE FUNCTION f_is_GV_in_GV_DT (@magv varchar(5))
RETURNS BIT
AS
BEGIN
	IF (EXISTS(SELECT * FROM GV_DT WHERE MAGV = @magv))
		return 1
	return 0
END
GO

DROP FUNCTION f_is_GV_in_BOMON
GO
CREATE FUNCTION f_is_GV_in_BOMON (@magv varchar(5))
RETURNS BIT
AS
BEGIN
	IF (EXISTS(SELECT * FROM BOMON WHERE TRUONGBM = @magv))
		return 1
	return 0
END
GO

DROP FUNCTION f_is_GV_in_KHOA
GO
CREATE FUNCTION f_is_GV_in_KHOA (@magv varchar(5))
RETURNS BIT
AS
BEGIN
	IF (EXISTS(SELECT * FROM KHOA WHERE TRUONGKHOA = @magv))
		return 1
	return 0
END
GO

DROP FUNCTION f_is_GV_in_THAMGIADT
GO
CREATE FUNCTION f_is_GV_in_THAMGIADT (@magv varchar(5))
RETURNS BIT
AS
BEGIN
	IF (EXISTS(SELECT * FROM THAMGIADT WHERE MAGV = @magv))
		return 1
	return 0
END
GO

DROP FUNCTION f_is_GV_in_DETAI
GO
CREATE FUNCTION f_is_GV_in_DETAI (@magv varchar(5))
RETURNS BIT
AS
BEGIN
	IF (EXISTS(SELECT * FROM DETAI WHERE GVCNDT = @magv))
		return 1
	return 0
END
GO

DROP FUNCTION f_is_GV_is_GVQLCM
GO
CREATE FUNCTION f_is_GV_is_GVQLCM (@magv varchar(5))
RETURNS BIT
AS
BEGIN
	IF (EXISTS(SELECT * FROM GIAOVIEN WHERE GVQLCM = @magv))
		return 1
	return 0
END
GO

DROP PROCEDURE sp_XoaGVTheoMa 
GO
CREATE PROCEDURE sp_XoaGVTheoMa @magv varchar(5)
AS 
BEGIN
	-- Nếu MAGV không tồn tại
	IF (dbo.fKiemTraGVTonTai(@magv) = 0)
	begin
		Print N'Mã giáo viên ' + @magv + N' không tồn tại!'
		return
	end
	
	-- Kiểm tra trong table NGUOITHAN
	if (dbo.f_is_GV_in_NGUOITHAN(@magv) = 1)
	BEGIN
		declare @msg_nt nvarchar(100) = N'Giáo viên mã ' + @magv
		+ N' có người thân nên không xóa được!'
		raiserror (@msg_nt, 16, 1)
		return
	END

	-- Kiểm tra trong table GV_DT
	if (dbo.f_is_GV_in_GV_DT(@magv) = 1)
	BEGIN
		declare @msg_gv_dt nvarchar(100) = N'Giáo viên mã ' + @magv
		+ N' có số điện thoại nên không xóa được!'
		raiserror (@msg_gv_dt, 16, 1)
		return
	END
	
	-- Kiểm tra trong table BOMON
	if (dbo.f_is_GV_in_BOMON(@magv) = 1)
	BEGIN
		declare @msg_bm nvarchar(100) = N'Giáo viên mã ' + @magv
		+ N' đang là trưởng bộ môn nên không xóa được!'
		raiserror (@msg_bm, 16, 1)
		return
	END
	
	-- Kiểm tra trong table KHOA
	if (dbo.f_is_GV_in_KHOA(@magv) = 1)
	BEGIN
		declare @msg_k nvarchar(100) = N'Giáo viên mã ' + @magv
		+ N' đang là trưởng khoa nên không xóa được!'
		raiserror (@msg_k, 16, 1)
		return
	END
	
	-- Kiểm tra trong table THAMGIADT
	if (dbo.f_is_GV_in_THAMGIADT(@magv) = 1)
	BEGIN
		declare @msg_tgdt nvarchar(100) = N'Giáo viên mã ' + @magv
		+ N' có tham gia đề tài nên không xóa được!'
		raiserror (@msg_tgdt, 16, 1)
		return
	END
	
	-- Kiểm tra trong table DETAI
	if (dbo.f_is_GV_in_DETAI(@magv) = 1)
	BEGIN
		declare @msg_dt nvarchar(100) = N'Giáo viên mã ' + @magv
		+ N' đang làm giáo viên chủ nhiệm đề tài nên không xóa được!'
		raiserror (@msg_dt, 16, 1)
		return
	END
	
	-- Nếu GV có @magv làm nhiệm vụ quản lý chuyên môn
	if (dbo.f_is_GV_is_GVQLCM(@magv) = 1)
	BEGIN
		declare @msg_gvqlcm nvarchar(100) = N'Giáo viên mã ' + @magv
		+ N' đang làm nhiệm vụ quản lý chuyên môn cho giáo viên khác nên không xóa được!'
		raiserror (@msg_gvqlcm, 16, 1)
		return
	END
	
	-- Tiến hành xóa GV
	DELETE FROM GIAOVIEN
	WHERE MAGV = @magv
	
	Print N'Đã xóa thành công giáo viên có mã ' + @magv + ' !'
	
END
GO

declare @magv varchar(5) = '024'
--insert into GIAOVIEN(MAGV) values(@magv)
Print N'>> Xóa một giáo viên có mã: ' + @magv + N', kết quả là:'
Exec sp_XoaGVTheoMa @magv
go

-- q. In ra danh sách giáo viên của một phòng ban nào đó 
--cùng với số lượng đề tài mà giáo viên tham gia, số thân nhân
--, số giáo viên mà giáo viên đó quản lý nếu có, …
Print ''
Print N'q. In ra danh sách giáo viên của một phòng ban...'
GO

DROP FUNCTION fKiemTraBMTonTai
GO
CREATE FUNCTION fKiemTraBMTonTai (@mabm nvarchar(5))
RETURNS BIT
AS 
BEGIN
	IF (EXISTS(SELECT * FROM BOMON WHERE MABM = @mabm))
		return 1
	return 0
END
GO

DROP PROCEDURE sp_InThongTinChiTietGV_MoRong
GO
CREATE PROCEDURE sp_InThongTinChiTietGV_MoRong @magv varchar(5)
AS
BEGIN
	-- In ra các thông tin đã có
	Exec sp_InThongTinChiTietGV @magv
	
	-- số giáo viên mà giáo viên đó quản lý
	declare @SoGVDuocQL int = 0;
	select @SoGVDuocQL = COUNT(*)
	  from GIAOVIEN ql
	  join GIAOVIEN gv on gv.GVQLCM = ql.MAGV
	 where ql.MAGV = @magv
	 
	Print N'Số lượng giáo viên được người này quản lý: ' + cast(@SoGVDuocQL as varchar)
	
	-- số lượng số điện thoại người này có
	declare @SLsdt int = 0;
	select @SLsdt = COUNT(DIENTHOAI)
	  from GIAOVIEN GV
	  LEFT JOIN GV_DT ON GV_DT.MAGV = GV.MAGV
	 WHERE GV.MAGV = @magv
	 
	Print N'Số lượng số điện thoại: ' + cast(@SLsdt as varchar)
	
	-- số lượng detai người này chủ nhiệm
	declare @SLDeTaiCN int = 0;
	select @SLDeTaiCN = COUNT(MADT)
	  FROM GIAOVIEN GV
	  LEFT JOIN DETAI DT ON DT.GVCNDT = GV.MAGV
	 WHERE GV.MAGV = @magv
	
	Print N'Số lượng đề tài do giáo viên chủ nhiệm: ' + cast(@SLDeTaiCN as varchar)
	
END
GO

DROP FUNCTION fDanhSachGVCuaBM
GO
CREATE FUNCTION fDanhSachGVCuaBM (@mabm nvarchar(5))
RETURNS table
AS
	return (
		SELECT GV.MAGV
		  FROM GIAOVIEN GV
		  JOIN BOMON BM ON BM.MABM = GV.MABM
		 WHERE BM.MABM = @mabm
	)
GO

DROP PROCEDURE sp_InDanhSachGVCuaBM
GO
CREATE PROCEDURE sp_InDanhSachGVCuaBM @mabm nvarchar(5)
AS
BEGIN 
	-- Kiểm tra mabm tồn tại
	IF (dbo.fKiemTraBMTonTai(@mabm) = 0)
	BEGIN
		Print N'Mã bộ môn ' + @mabm + N' không tồn tại!'
		return 
	END
	
	-- Lấy các magv thuộc bm @mabm 
	declare @t table (magv varchar(5))
	insert into @t select * from dbo.fDanhSachGVCuaBM(@mabm)
	
	-- Duyệt qua từng magv tìm được, in ra các thông tin được yêu cầu
	declare @tmp_magv varchar(5)
	while exists (select * from @t)
	begin
		select top 1 @tmp_magv = magv from @t
		delete from @t where magv = @tmp_magv
		-- prints each row of the table
		Exec sp_InThongTinChiTietGV_MoRong @tmp_magv
		print ''
	end
	
END
GO

declare @mabm nvarchar(5) = 'HTTT'
Print N'>> Danh sách giáo viên của bộ môn có mã ' + @mabm + ' :'
exec sp_InDanhSachGVCuaBM @mabm
GO

-- r. Kiểm tra quy định của 2 giáo viên a, b: Nếu a là trưởng bộ môn c của b
--	thì lương của a phải cao hơn lương của b. (a, b: mã giáo viên)
print ''
print N'r. Kiểm tra quy định của 2 giáo viên'
GO

DROP FUNCTION f_a_la_truong_bm_cua_b
GO
CREATE FUNCTION f_a_la_truong_bm_cua_b (@magv_a varchar(5), @magv_b varchar(5))
RETURNS BIT
AS 
BEGIN
	declare @counter int = -1;
	SELECT @counter = COUNT(*)
	  FROM (
	  	select MAGV from GIAOVIEN WHERE MAGV = @magv_a
		except
		select TRUONGBM
		  from BOMON BM
		  JOIN GIAOVIEN GV ON GV.MABM = BM.MABM
		 WHERE GV.MAGV = @magv_b
	  ) AS T

	IF (@counter = 0)
		return 1
	return 0
END
GO

DROP FUNCTION f_luong_cua_a_cao_hon_b
GO
CREATE FUNCTION f_luong_cua_a_cao_hon_b (@magv_a varchar(5), @magv_b varchar(5))
RETURNS BIT
AS 
BEGIN
	declare @luong_a float = 0;
	declare @luong_b float = 0;
	
	select @luong_a = LUONG
	  from GIAOVIEN where MAGV = @magv_a
	select @luong_b = LUONG
	  from GIAOVIEN where MAGV = @magv_b

	IF (@luong_a > @luong_b)
		return 1
	return 0
END
GO

DROP PROCEDURE sp_KiemTraQuyDinh2GV
GO
CREATE PROCEDURE sp_KiemTraQuyDinh2GV @magv_a varchar(5), @magv_b varchar(5)
AS
BEGIN
	-- Kiểm tra thông tin trưởng bm
	IF (dbo.f_a_la_truong_bm_cua_b(@magv_a, @magv_b) = 1)
	BEGIN
		IF (dbo.f_luong_cua_a_cao_hon_b(@magv_a, @magv_b) = 0)
		BEGIN
			Print N'Không phù hợp với quy định!'
			return
		END
	END
	
	Print N'Phù hợp với quy định.'
	
END
GO

declare @magv_a varchar(5) = '002' -- 001
declare @magv_b varchar(5) = '003' -- 009
Print N'>> Kiểm tra quy định của gv a ' + @magv_a + N' và gv b ' + @magv_b + ' :'
exec sp_KiemTraQuyDinh2GV @magv_a, @magv_b
GO

-- s. Thêm một giáo viên: Kiểm tra các quy định: Không trùng tên, tuổi > 18,
-- lương > 0
Print ''
Print N's. Thêm một giáo viên: Kiểm tra các quy định:...'
GO

DROP FUNCTION fKiemTraTenTonTai
GO
CREATE FUNCTION fKiemTraTenTonTai (@hoten nvarchar(40))
RETURNS BIT
AS
BEGIN
	IF (EXISTS(SELECT * FROM GIAOVIEN WHERE HOTEN LIKE @hoten))
		return 1
	return 0
END
GO

DROP FUNCTION fTinhTuoi
GO
CREATE FUNCTION fTinhTuoi (@ngsinh date)
RETURNS INT
AS
BEGIN
	return year(getdate()) - year(@ngsinh)
END
GO

DROP PROCEDURE sp_Them1GV
GO
CREATE PROCEDURE sp_Them1GV @magv varchar(5), @hoten nvarchar(40)
, @luong float, @phai nvarchar(5), @ngsinh date
AS
BEGIN
	-- Kiểm tra MAGV
	if (dbo.fKiemTraGVTonTai(@magv) = 1)
	BEGIN
		Print N'Mã giáo viên ' + @magv 
		+ N' đã tồn tại, vui lòng thử lại mã giáo viên khác.'
		return 
	END
	
	-- Kiểm tra tên
	if (dbo.fKiemTraTenTonTai(@hoten) = 1)
	BEGIN
		Print N'Họ tên giáo viên ' + @hoten 
		+ N' đã tồn tại, vui lòng thử lại 1 tên khác.'
		return 
	END
	
	-- Kiểm tra lương
	if (@luong <= 0)
	BEGIN
		Print N'Lương của giáo viên phải > 0'
		+ N', vui lòng thử lại với 1 mức lương khác.'
		return 
	END
	
	-- Kiểm tra tuổi
	if (dbo.fTinhTuoi(@ngsinh) <= 18)
	BEGIN
		Print N'Tuổi của giáo viên phải > 18'
		+ N', vui lòng thử lại với 1 ngày sinh khác.'
		return 
	END
	
	-- Thêm dữ liệu cho 1 GV mới
	INSERT INTO GIAOVIEN(MAGV, HOTEN, LUONG, PHAI, NGSINH)
	VALUES (@magv, @hoten, @luong, @phai, @ngsinh)
	Print N'Đã thêm thành công 1 giáo viên mới!'
	
END
GO

declare @magv varchar(5) = '024'
declare @hoten nvarchar(40) = N'Vũ Minh Phát' -- Vũ Minh Phát
declare @luong float = 2400
declare @phai nvarchar(5) = 'Nam'
declare @ngsinh date = '2002-09-03'
Print N'>> Tiến hành thêm 1 giáo viên với các tham số: ' 
	+ @magv + ', ' + @hoten + ', ' + cast(@luong as varchar)
	+ ', ' + @phai + ', ' + cast(@ngsinh as varchar)
exec sp_Them1GV @magv, @hoten, @luong, @phai, @ngsinh
GO

-- t. Mã giáo viên được xác định tự động theo quy tắc:...
Print ''
Print N't. Mã giáo viên được xác định tự động theo quy tắc:...'
GO

DROP PROCEDURE sp_XacDinhMaGVMoi
GO
CREATE PROCEDURE sp_XacDinhMaGVMoi @magv varchar(5) out
as
begin
	declare @t table(magv varchar(5));
	INSERT INTO @t
	SELECT MAGV FROM GIAOVIEN
	
	declare @magv_num int = 1
	declare @tmp_magv varchar(5)
	
	while exists (select * from @t)
	begin
	  select top 1 @tmp_magv = magv from @t
	  delete from @t where magv = @tmp_magv
	  
	  -- Xử lý MAGV
	  if (@magv_num != CAST(@tmp_magv AS INT))
	  BEGIN
		set @magv = REPLACE(STR(@magv_num, 3), ' ', '0')
		return
	  END
	  
	  SET @magv_num = @magv_num + 1
	end
	
end
go

declare @magv varchar(5) = ''
Exec sp_XacDinhMaGVMoi @magv out
Print N'>> MAGV của giáo viên mới là: '
Print @magv
GO

-- ******************** 4 Bài tập về nhà ********************
print ''
Print N'+-------------------------------------------------------+'
Print N'|                   4. BÀI TẬP VỀ NHÀ                   |'
Print N'+-------------------------------------------------------+'
Print ''

USE master
GO
DROP DATABASE QLKhachSan
GO
CREATE DATABASE QLKhachSan
GO
USE QLKhachSan
GO

-- Tạo bảng
CREATE TABLE PHONG (
	MAPHONG CHAR(10) PRIMARY KEY
	, TINHTRANG NVARCHAR(10)
	, LOAIPHONG varchar(5)
	, DONGIA FLOAT
	
	, CHECK(TINHTRANG IN (N'Rảnh', N'Bận'))
)
GO

CREATE TABLE KHACH (
	MAKH CHAR(8) PRIMARY KEY
	, HOTEN NVARCHAR(40)
	, DIACHI NVARCHAR(50)
	, DIENTHOAI char(15)
)
GO

CREATE TABLE DATPHONG (
	MA int PRIMARY KEY NOT NULL
	, MAKH CHAR(8)
	, MAPHONG CHAR(10)
	, NGAYDP date
	, NGAYTRA date DEFAULT NULL
	, THANHTIEN float DEFAULT NULL
	
	, FOREIGN KEY (MAKH) REFERENCES KHACH(MAKH)
	, FOREIGN KEY (MAPHONG) REFERENCES PHONG(MAPHONG)
)
GO

-- Thêm dữ liệu
INSERT INTO PHONG
VALUES ('P001', N'Bận', '1', 2000)
	 , ('P002', N'Bận', '3', 1000)
	 , ('P003', N'Rảnh', '3', 1200)
	 , ('P004', N'Bận', '2', 1800)
	 , ('P005', N'Bận', '2', 1600)
	 , ('P006', N'Rảnh', '1', 2200)
GO

INSERT INTO KHACH
VALUES ('KH001', N'Trần Hào', N'1/2 Nguyễn Khuyến', '123456789')
	 , ('KH002', N'Hà Lê', N'24 Hoàng Xuân', '111222333')
	 , ('KH003', N'Ngọc Hoa', N'93/15 Camelte', '444555666')
	 , ('KH004', N'Như Ý', N'81/51 Cô Bắc', '0185891923')
	 , ('KH005', N'Thu Hạ', N'2 Đồng Hoa', '0884892393')
	 , ('KH006', N'Lý Thắng', N'2/4/6/8 Lam Sơn', '0928712423')
GO

INSERT INTO DATPHONG(MA, MAPHONG, MAKH, NGAYDP)
VALUES (1, 'P001', 'KH001', '2020-10-08')
	 , (2, 'P002', 'KH006', '2020-09-12')
	 , (3, 'P004', 'KH002', '2020-08-08')
	 , (4, 'P005', 'KH004', '2020-09-08')
GO

-- 1. Viết stored procedure sau sau
Print ''
Print N'1. Viết stored procedure sau'
GO

DROP FUNCTION fKiemTraMaKHHopLe
GO
CREATE FUNCTION fKiemTraMaKHHopLe(@makh VARCHAR(8))
RETURNS BIT
AS
BEGIN
	IF (EXISTS(SELECT * FROM KHACH WHERE MAKH = @makh))
		return 1
	return 0
END
GO

DROP FUNCTION fKiemTraMaPhongHopLe
GO
CREATE FUNCTION fKiemTraMaPhongHopLe(@maphong VARCHAR(10))
RETURNS BIT
AS
BEGIN
	IF (EXISTS(SELECT * FROM PHONG WHERE MAPHONG = @maphong))
		return 1
	return 0
END
GO

DROP FUNCTION fKiemTraPhongRanh
GO
CREATE FUNCTION fKiemTraPhongRanh (@maphong VARCHAR(10))
RETURNS BIT
AS
BEGIN
	IF (EXISTS(SELECT * FROM PHONG WHERE MAPHONG = @maphong AND TINHTRANG = N'Rảnh'))
		return 1
	return 0
END
GO

DROP PROCEDURE spTaoMaDatPhongTuDong
GO
CREATE PROCEDURE spTaoMaDatPhongTuDong @madp INT OUT
AS 
BEGIN
	-- Nếu bảng DATPHONG trống (không có bất cứ dữ liệu nào)
	IF (NOT EXISTS(SELECT * FROM DATPHONG))
	BEGIN
		SET @madp = 1
		return
	END
	
	declare @max_madp INT = -1;
	SELECT @max_madp = MAX(MA)
	FROM DATPHONG
	
	SET @madp = @max_madp + 1
END
GO

DROP PROCEDURE spCapNhatTinhTrangPhongThanhBan
GO
CREATE PROCEDURE spCapNhatTinhTrangPhongThanhBan @maphong VARCHAR(10)
AS
BEGIN
	UPDATE PHONG
	SET TINHTRANG = N'Bận'
	WHERE MAPHONG = @maphong
END
GO

-- Ghi nhận thông tin đặt phòng của khách hàng xuống cơ sở dữ liệu.
DROP PROCEDURE spDatPhong
GO
CREATE PROCEDURE spDatPhong @makh VARCHAR(8), @maphong VARCHAR(10), @ngaydat date
AS
BEGIN
	-- Kiểm tra mã khách hàng phải hợp lệ (phải xuất hiện trong bảng KHÁCH HÀNG)
	If (dbo.fKiemTraMaKHHopLe(@makh) = 0)
	BEGIN
		Print N'Mã khách hàng ' + @makh + N' không xuất hiện trong bảng KHÁCH HÀNG'
		+ N', vui lòng thử lại!'
		return
	END
	
	-- Kiểm tra mã phòng hợp lệ (phải xuất hiện trong bảng PHÒNG)
	If (dbo.fKiemTraMaPhongHopLe(@maphong) = 0)
	BEGIN
		Print N'Mã phòng ' + @maphong + N' không xuất hiện trong bảng PHÒNG'
		+ N', vui lòng thử lại!'
		return
	END
	
	-- Chỉ được đặt phòng khi tình trạng của phòng là “Rảnh”
	If (dbo.fKiemTraPhongRanh(@maphong) = 0)
	BEGIN
		Print N'Mã phòng ' + @maphong + N' hiện đang không "Rảnh"'
		+ N', vui lòng đặt phòng khác!'
		return
	END
	
	-- Nếu các kiểm tra hợp lệ thì ghi nhận thông tin đặt phòng xuống CSDL 
	-- (Ngày trả và thành tiền của khi đặt phòng là NULL)
	
	-- Tạo mã đặt phòng tự động
	declare @madp INT = -1
	Exec spTaoMaDatPhongTuDong @madp OUT
	
	-- Ghi nhận thông tin đặt phòng xuống CSDL  
	INSERT INTO DATPHONG(MA, MAKH, MAPHONG, NGAYDP)
	VALUES (@madp, @makh, @maphong, @ngaydat)
	
	-- Sau khi đặt phòng thành công thì phải cập nhật tình trạng của phòng là “Bận”
	Exec spCapNhatTinhTrangPhongThanhBan @maphong
	
	Print N'Thành công ghi nhận thông tin đặt phòng của khách hàng xuống cơ sở dữ liệu!'
	
END
GO

declare @makh varchar(8) = 'KH001'
declare @maphong varchar(10) = 'P003'
declare @ngaydat date = '2020-10-10'
Print N'>> Thực hiện đặt phòng với các tham số: ' + @makh
+ ', ' + @maphong + ', ' + cast(@ngaydat as varchar)
Exec spDatPhong @makh, @maphong, @ngaydat
GO

-- 2. Stored procedure/function
Print ''
Print N'2. Stored procedure/function'
GO

DROP FUNCTION fKiemTraMaDPVaMaKH
GO
CREATE FUNCTION fKiemTraMaDPVaMaKH(@madp INT, @makh VARCHAR(8))
RETURNS BIT
AS
BEGIN
	IF (EXISTS(SELECT * FROM DATPHONG WHERE MA=@madp AND MAKH=@makh))
		return 1
	return 0
END
GO

DROP PROCEDURE spLayThongTinMaPhong
GO
CREATE PROCEDURE spLayThongTinMaPhong @madp INT, @maphong VARCHAR(10) out
AS
BEGIN
	SELECT @maphong = MAPHONG
	  FROM DATPHONG
	 WHERE MA = @madp
END
GO

DROP PROCEDURE spLayThongTinNgayDatPhong
GO
CREATE PROCEDURE spLayThongTinNgayDatPhong @madp INT, @ngaydat date out
AS
BEGIN
	SELECT @ngaydat = NGAYDP
	  FROM DATPHONG
	 WHERE MA = @madp
END
GO

DROP PROCEDURE spTinhTienThanhToan
GO
CREATE PROCEDURE spTinhTienThanhToan @maphong VARCHAR(10)
, @ngaydat date, @ngaytra date, @tien float OUT
AS 
BEGIN
	-- Lấy đơn giá của phòng
	declare @dongia float = 0;
	SELECT @dongia = DONGIA
	  FROM PHONG
	 WHERE MAPHONG = @maphong
	
	-- Tien = Số ngày mượn x đơn giá của phòng
	declare @songaymuon INT = 0
	SET @songaymuon = datediff(day, @ngaydat, @ngaytra)
	SET @tien = @songaymuon * @dongia
	
END
GO

DROP PROCEDURE spCapNhatTinhTrangPhongThanhRanh
GO
CREATE PROCEDURE spCapNhatTinhTrangPhongThanhRanh @maphong VARCHAR(10)
AS
BEGIN
	UPDATE PHONG
	SET TINHTRANG = N'Rảnh'
	WHERE MAPHONG = @maphong
END
GO

-- Ghi nhận thông tin trả phòng của khách hàng xuống cơ sở dữ liệu.
DROP PROCEDURE spTraPhong
GO
CREATE PROCEDURE spTraPhong @madp INT, @makh VARCHAR(8)
AS
BEGIN
	-- Kiểm tra tính hợp lệ của mã đặt phòng, mã khách hàng: 
	-- Hợp lệ nếu khách hàng có thực hiện việc đặt phòng.
	IF (dbo.fKiemTraMaDPVaMaKH(@madp, @makh) = 0)
	BEGIN
		Print N'Không tìm thấy thông tin đặt phòng ' + cast(@madp as varchar)
		+ N' của khách hàng ' + @makh + N', vui lòng kiểm tra lại.'
		return
	END
	
	-- Ngày trả phòng chính là ngày hiện hành.
	declare @ngaytra date = getdate()
	
	-- Tiền thanh toán được tính theo công thức: 
	--	Tien = Số ngày mượn x đơn giá của phòng.
	
	-- B1. Lấy mã phòng
	declare @maphong VARCHAR(10) = ''
	Exec spLayThongTinMaPhong @madp, @maphong OUT
	
	-- B2. Lấy ngày đặt phòng
	declare @ngaydat date
	Exec spLayThongTinNgayDatPhong @madp, @ngaydat OUT
	
	-- B3. Tính tiền thanh toán 
	declare @tien float = 0
	Exec spTinhTienThanhToan @maphong, @ngaydat, @ngaytra, @tien OUT
	
	-- Ngày trả, Thành tiền sẽ được cập nhật khi KH trả phòng
	-- Cập nhật ngày trả và tiền vào CSDL
	UPDATE DATPHONG
	SET NGAYTRA = @ngaytra, THANHTIEN = @tien
	WHERE MA = @madp
	
	-- Phải thực hiện việc cập nhật tình trạng của phòng là “Rảnh”
	--	sau khi ghi nhận thông tin trả phòng.
	Exec spCapNhatTinhTrangPhongThanhRanh @maphong
	
	Print N'Thành công ghi nhận thông tin trả phòng!'

END
GO

declare @madp INT = 1
declare @makh VARCHAR(8) = 'KH001'
Print N'>> Thực hiện trả phòng với các tham số: ' + cast(@madp as varchar)
+ N' và ' + @makh
Exec spTraPhong 1, 'KH001'
GO

