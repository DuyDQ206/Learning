I/ DML

TRIGGERS
CREATE TRIGGER TenTrigger
ON TenBang
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    -- nội dung trigger
END;

11. Ngày mua hàng (NGHD) của một khách hàng thành viên sẽ lớn hơn hoặc bằng ngày
khách hàng đó đăng ký thành viên (NGDK).
create trigger HD_NGHD_NGDK_Ins_Upd on HOADON
for insert,update
as
	declare @NGHD smalldatetime
	declare @MAKH char(4)
	declare @NGDK smalldatetime
	-- lay ve MAKH,NGHD, trong bang INSERTED va luu vao bien @MAKH
	select @MAKH = MAKH,@NGHD = NGHD from INSERTED
	-- lay NGDK cua khach hang ung voi MAKH vua them vao trong HOADON va luu vao bien @NGDK
	select @NGDK = NGDK from KHACHHANG where MAKH = @MAKH
	-- thuc hien kiem tra NGHD co lon hon NGDK
	if (@NGDK > @NGHD)
	begin
	print '--Ngay mua phai lon hon ngay dang ky thanh vien --'
	rollback tran
	end
go
create trigger trg_KH_NGDK_Upd on KHACHHANG
for update
as
if update(NGDK)
begin
	declare @NGDK smalldatetime
	declare @MAKH char(4)
	declare @NGHD smalldatetime
	--lay NGDK va MAKH trong bang INSERTED
	select @MAKH = MAKH, @NGDK = NGDK from inserted
	if (select count(*) from HOADON where MAKH=@MAKH and NGHD
	<@NGDK) > 0
	begin
	print '--Ngay dang ky thanh vien phai lon hon ngay mua hang--'
	rollback tran
	end
end

12. Ngày bán hàng (NGHD) của một nhân viên phải lớn hơn hoặc bằng ngày nhân viên đó
vào làm.
CREATE TRIGGER TRG_HD_NGHD_INS_UPD ON HOADON
FOR INSERT, UPDATE
AS
	DECLARE @NGHD SMALLDATETIME;
	DECLARE @NGVL SMALLDATETIME;
	DECLARE @MANV CHAR(4);
	SELECT @NGHD = NGHD, @MANV = MANV FROM INSERTED
	SELECT @NGVL = NGVL FROM NHANVIEN WHERE MANV = @MANV
	IF(@NGHD < NGVL)
	BEGIN
	PRINT '--NGAY HOA DON PHAI LON HON NGAY VAO LAM CUA NHAN VIEN--'
	ROLLBACK TRAN
	END
GO
CREATE TRIGGER TRG_NV_NGVL_UPD ON NHANVIEN
FOR UPDATE
AS
IF UPDATE(NGVL)
BEGIN
	DECLARE @NGHD SMALLDATETIME;
	DECLARE @NGVL SMALLDATETIME;
	DECLARE @MANV CHAR(4);
	SELECT @MANV = MANV, @NGVL = NGVL FROM INSERTED
	SELECT @NGHD = NGHD FROM HOADON WHERE MANV = @MANV
	IF(@NGHD < NGVL)
	BEGIN
	PRINT '--NGAY VAO LAM PHAI LON HON NGAY HOA DON--'
	ROLLBACK TRAN
	END
END

13. Mỗi một hóa đơn phải có ít nhất một chi tiết hóa đơn.
CREATE TRIGGER TRG_HD_CTHD_
14. Trị giá của một hóa đơn là tổng thành tiền (số lượng*đơn giá) của các chi tiết thuộc hóa
đơn đó.
15. Doanh số của một khách hàng là tổng trị giá các hóa đơn mà khách hàng thành viên đó
đã mua.

III/ SQL
18. Tìm số hóa đơn đã mua tất cả các sản phẩm do Singapore sản xuất
select SOHD
from HOADON
where not exists (Select * from SANPHAM where NUOCSX = 'Singapore' and
not exists (select * from CTHD where CTHD.SOHD = HOADON.SOHD and CTHD.MASP = SANPHAM.MASP))

19. Tìm số hóa đơn trong năm 2006 đã mua ít nhất tất cả các sản phẩm do Singapore sản
xuất.

20. Có bao nhiêu hóa đơn không phải của khách hàng đăng ký thành viên mua?
select SOHD
from HOADON as HD 
inner join KHACHHANG as KH on HD.MAKH = KH.MAKH 
where KH.NGDK is NULL;

21. Có bao nhiêu sản phẩm khác nhau được bán ra trong năm 2006
SELECT COUNT(DISTINCT CTHD.MASP)
FROM SANPHAM AS SP
INNER JOIN CTHD ON SP.MASP = CTHD.MASP
INNER JOIN HOADON AS HD ON CTHD.SOHD = HD.SOHD
WHERE YEAR(HD.NGHD) = 2006;

22. Cho biết trị giá hóa đơn cao nhất, thấp nhất là bao nhiêu ?
Select min(TRIGIA), max(TRIGIA)
from HOADON

23. Trị giá trung bình của tất cả các hóa đơn được bán ra trong năm 2006 là bao nhiêu?
Select HD.SOHD,AVG(TRIGIA)
from HOADON as HD
inner join CTHD on HD.SOHD = CTHD.SOHD
where year(NGHD) = 2006
group by HD.SOHD

24. Tính doanh thu bán hàng trong năm 2006
SELECT SUM(TRIGIA) AS DoanhThu2006
FROM HOADON
WHERE YEAR(NGHD) = 2006;

25. Tìm số hóa đơn có trị giá cao nhất trong năm 2006.
SELECT SOHD
FROM HOADON
WHERE TRIGIA = (
      SELECT MAX(TRIGIA)
      FROM HOADON
      WHERE YEAR(NGHD) = 2006);
SELECT TOP 1 SOHD, TRIGIA
FROM HOADON
WHERE YEAR(NGHD) = 2006
ORDER BY TRIGIA DESC;

26. Tìm họ tên khách hàng đã mua hóa đơn có trị giá cao nhất trong năm 2006
Select HOTEN
from KHACHHANG as KH
inner join HOADON as HD on HD.MAKH = KH.MAKH
where TRIGIA = ( select max(TRIGIA)
				from HOADON
				where year(NGHD) = 2006);

27. In ra danh sách 3 khách hàng đầu tiên (MAKH, HOTEN) sắp xếp theo doanh số giảm
dần.
select TOP 3 MAKH,HOTEN
from KHACHHANG
order by DOANHSO desc

28. In ra danh sách các sản phẩm (MASP, TENSP) có giá bán bằng 1 trong 3 mức giá cao
nhất.
Select MASP,TENSP
from SANPHAM as SP
where GIA in (select distinct top 3 GIA from SANPHAM order by GIA desc);

29. In ra danh sách các sản phẩm (MASP, TENSP) do “Thai Lan” sản xuất có giá bằng 1
trong 3 mức giá cao nhất (của tất cả các sản phẩm).
Select MASP,TENSP
FROM SANPHAM AS SP
WHERE NUOCSX = 'Thai Lan'
AND GIA IN (SELECT TOP 3 GIA FROM SANPHAM ORDER BY GIA DESC);

30. In ra danh sách các sản phẩm (MASP, TENSP) do “Trung Quoc” sản xuất có giá bằng 1
trong 3 mức giá cao nhất (của sản phẩm do “Trung Quoc” sản xuất).
SELECT MASP, TENSP
FROM SANPHAM
WHERE GIA IN (
	SELECT TOP 3 GIA
	FROM SANPHAM
	WHERE NUOCSX = 'Trung Quoc'
	ORDER BY GIA DESC)

31. * In ra danh sách khách hàng nằm trong 3 hạng cao nhất (xếp hạng theo doanh số).
SELECT TOP 3 MAKH,HOTEN
FROM KHACHHANG
ORDER BY DOANHSO DESC

32. Tính tổng số sản phẩm do “Trung Quoc” sản xuất.
SELECT COUNT(MASP)
FROM SANPHAM
WHERE NUOCSX = 'Trung Quoc'

33. Tính tổng số sản phẩm của từng nước sản xuất.
SELECT NUOCSX,COUNT(MASP)
FROM SANPHAM
GROUP BY NUOCSX;

34. Với từng nước sản xuất, tìm giá bán cao nhất, thấp nhất, trung bình của các sản phẩm.
SELECT NUOCSX,MIN(GIA),MAX(GIA),AVG(GIA)
FROM SANPHAM
GROUP BY NUOCSX;

35. Tính doanh thu bán hàng mỗi ngày.
SELECT NGHD,SUM(TRIGIA)
FROM HOADON
GROUP BY NGHD;

36. Tính tổng số lượng của từng sản phẩm bán ra trong tháng 10/2006.
SELECT CTHD.MASP,SUM(SL)
FROM CTHD
INNER JOIN HOADON ON CTHD.SOHD = HOADON.SOHD
WHERE MONTH(NGHD) = 10 AND YEAR(NGHD) = 2006
GROUP BY CTHD.MASP;

37. Tính doanh thu bán hàng của từng tháng trong năm 2006.
SELECT MONTH(HOADON.NGHD), SUM(TRIGIA)
FROM HOADON
WHERE YEAR(NGHD) = 2006
GROUP BY MONTH(NGHD);

38. Tìm hóa đơn có mua ít nhất 4 sản phẩm khác nhau.
SELECT SOHD
FROM CTHD
GROUP BY SOHD
HAVING COUNT(MASP) >= 4;

39. Tìm hóa đơn có mua 3 sản phẩm do “Viet Nam” sản xuất (3 sản phẩm khác nhau).
SELECT CTHD.SOHD
FROM CTHD
INNER JOIN SANPHAM ON CTHD.MASP = SANPHAM.MASP
WHERE NUOCSX = 'Viet Nam'
GROUP BY CTHD.SOHD
HAVING COUNT(CTHD.MASP) = 3

40. Tìm khách hàng (MAKH, HOTEN) có số lần mua hàng nhiều nhất.
SELECT KH.MAKH, KH.HOTEN
FROM KHACHHANG KH
WHERE KH.MAKH IN (
    SELECT TOP 1 HD.MAKH
    FROM HOADON HD
    GROUP BY HD.MAKH
    ORDER BY COUNT(HD.SOHD) DESC
);


41. Tháng mấy trong năm 2006, doanh số bán hàng cao nhất ?
SELECT TOP 1 MONTH(NGHD) AS Thang
FROM HOADON
WHERE YEAR(NGHD) = 2006
GROUP BY MONTH(NGHD)
ORDER BY SUM(TRIGIA) DESC;

42. Tìm sản phẩm (MASP, TENSP) có tổng số lượng bán ra thấp nhất trong năm 2006.
SELECT TOP 1 SP.MASP, SP.TENSP, SUM(CTHD.SL) AS TongSL
FROM CTHD
INNER JOIN SANPHAM AS SP ON CTHD.MASP = SP.MASP
INNER JOIN HOADON AS HD ON CTHD.SOHD = HD.SOHD
WHERE YEAR(HD.NGHD) = 2006
GROUP BY SP.MASP, SP.TENSP
ORDER BY SUM(CTHD.SL) ASC;


43. *Mỗi nước sản xuất, tìm sản phẩm (MASP,TENSP) có giá bán cao nhất.
SELECT SP.MASP, SP.TENSP, SP.NUOCSX, SP.GIA
FROM SANPHAM SP
INNER JOIN (
    SELECT NUOCSX, MAX(GIA) AS MaxGia
    FROM SANPHAM
    GROUP BY NUOCSX
) AS MaxSP
ON SP.NUOCSX = MaxSP.NUOCSX AND SP.GIA = MaxSP.MaxGia;

44. Tìm nước sản xuất sản xuất ít nhất 3 sản phẩm có giá bán khác nhau.
SELECT NUOCSX, COUNT(*)
FROM SANPHAM 
GROUP BY NUOCSX
HAVING COUNT(DISTINCT GIA) >= 3

45. *Trong 10 khách hàng có doanh số cao nhất, tìm khách hàng có số lần mua hàng nhiều
nhất
SELECT TOP 1 MAKH,HOTEN
FROM KHACHHANG KH
WHERE MAKH IN (
	SELECT TOP 10 MAKH,HOTEN
	FROM KHACHHANG
	ORDER BY DOANHSO DESC)