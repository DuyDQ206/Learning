set dateformat dmy
II. Ngôn ngữ thao tác dữ liệu (Data Manipulation Language):
1. Nhập dữ liệu cho các quan hệ trên. 
2. Tạo quan hệ SANPHAM1 chứa toàn bộ dữ liệu của quan hệ SANPHAM. Tạo quan hệ
KHACHHANG1 chứa toàn bộ dữ liệu của quan hệ KHACHHANG.
select * into SANPHAM1
from SANPHAM;
select * into KHACHHANG1
from KHACHHANG;
3. Cập nhật giá tăng 5% đối với những sản phẩm do “Thai Lan” sản xuất (cho quan hệ
SANPHAM1)
UPDATE SANPHAM1
SET GIA = GIA*1.05
where NUOCSX='Thai Lan'
4. Cập nhật giá giảm 5% đối với những sản phẩm do “Trung Quoc” sản xuất có giá từ
10.000 trở xuống (cho quan hệ SANPHAM1).
UPDATE SANPHAM1
SET GIA = GIA*0.95
where NUOCSX='Trung Quoc'
	and GIA < 10000
5. Cập nhật giá trị LOAIKH là “Vip” đối với những khách hàng đăng ký thành viên trước
ngày 1/1/2007 có doanh số từ 10.000.000 trở lên hoặc khách hàng đăng ký thành viên từ
1/1/2007 trở về sau có doanh số từ 2.000.000 trở lên (cho quan hệ KHACHHANG1).
alter table KHACHHANG1 add LOAIKH varchar(20)
UPDATE KHACHHANG1
SET LOAIKH='Vip'
where NGDK < '1/1/2007' and DOANHSO >= 10000000
	or NGDK >= '1/1/2007' and DOANHSO >= 2000000
III. Ngôn ngữ truy vấn dữ liệu:
1. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất.
select MASP,TENSP
from SANPHAM as SP
where SP.NUOCSX='Trung Quoc'
2. In ra danh sách các sản phẩm (MASP, TENSP) có đơn vị tính là “cay”, ”quyen”.
select MASP,TENSP
from SANPHAM
where DVT='cay'
	or DVT='quyen';
3. In ra danh sách các sản phẩm (MASP,TENSP) có mã sản phẩm bắt đầu là “B” và kết
thúc là “01”.
select MASP,TENSP
from SANPHAM
where MASP like 'B%01'
4. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quốc” sản xuất có giá từ 30.000
đến 40.000.
select MASP,TENSP
from SANPHAM 
where NUOCSX='Trung Quoc'
	and GIA between 30000 and 40000;
5. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” hoặc “Thai Lan” sản
xuất có giá từ 30.000 đến 40.000.
select MASP,TENSP
from SANPHAM
where GIA between 30000 and 40000
	and NUOCSX='Trung Quoc' or NUOCSX='Thai Lan';
6. In ra các số hóa đơn, trị giá hóa đơn bán ra trong ngày 1/1/2007 và ngày 2/1/2007.
select SOHD,TRIGIA
from HOADON
where NGHD='1/1/2007' or NGHD='2/1/2007'
7. In ra các số hóa đơn, trị giá hóa đơn trong tháng 1/2007, sắp xếp theo ngày (tăng dần) và
trị giá của hóa đơn (giảm dần).
Select SOHD,TRIGIA
from HOADON
where NGHD between '1/1/2007' and '30/1/2007'
order by NGHD asc,TRIGIA desc;
8. In ra danh sách các khách hàng (MAKH, HOTEN) đã mua hàng trong ngày 1/1/2007.
select KHACHHANG.MAKH,HOTEN
from KHACHHANG inner join HOADON on KHACHHANG.MAKH = HOADON.MAKH
where NGHD = '1/1/2007';
9. In ra số hóa đơn, trị giá các hóa đơn do nhân viên có tên “Nguyen Van B” lập trong ngày
28/10/2006.
select SOHD,TRIGIA
from HOADON inner join NHANVIEN on HOADON.MANV=NHANVIEN.MANV
where HOTEN='Nguyen Van B' and NGHD='28/10/2006';
10. In ra danh sách các sản phẩm (MASP,TENSP) được khách hàng có tên “Nguyen Van A”
mua trong tháng 10/2006.
select SP.MASP,SP.TENSP
from (KHACHHANG as KH inner join HOADON as HD on KH.MAKH = HD.MAKH) 
	inner join (SANPHAM as SP inner join CTHD on SP.MASP = CTHD.MASP) on HD.SOHD = CTHD.SOHD
where HOTEN='Nguyen Van A'
	and NGHD between '1/10/2006' and '31/10/2006';
11. Tìm các số hóa đơn đã mua sản phẩm có mã số “BB01” hoặc “BB02”.
select SOHD
from CTHD
where MASP='BB01' or MASP='BB02';
12. Tìm các số hóa đơn đã mua sản phẩm có mã số “BB01” hoặc “BB02”, mỗi sản phẩm
mua với số lượng từ 10 đến 20.
select SOHD
from CTHD
where (MASP='BB01' and SL between 10 and 20) or (MASP='BB02' and SL between 10 and 20);
13. Tìm các số hóa đơn mua cùng lúc 2 sản phẩm có mã số “BB01” và “BB02”, mỗi sản
phẩm mua với số lượng từ 10 đến 20.
select CT1.SOHD
from CTHD as CT1 inner join CTHD as CT2 on CT1.SOHD = CT2.SOHD
where CT1.MASP='BB01' and CT2.MASP='BB02' and CT1.SL in (10,20) and CT2.SL in (10,20)
14. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất hoặc các sản
phẩm được bán ra trong ngày 1/1/2007.
select SANPHAM.MASP,SANPHAM.TENSP
from (SANPHAM inner join CTHD on SANPHAM.MASP=CTHD.MASP) inner join HOADON on CTHD.SOHD = HOADON.SOHD
where NUOCSX='Trung Quoc' or NGHD='1/1/2007'
15. In ra danh sách các sản phẩm (MASP,TENSP) không bán được.
select SP1.MASP,SP1.TENSP
from SANPHAM as SP1 left join CTHD on SP1.MASP = CTHD.MASP
where CTHD.MASP is NULL;
16. In ra danh sách các sản phẩm (MASP,TENSP) không bán được trong năm 2006.
SELECT SP.MASP,SP.TENSP
FROM SANPHAM AS SP
LEFT JOIN (
    SELECT CT.MASP
    FROM CTHD AS CT INNER JOIN HOADON AS HD ON CT.SOHD = HD.SOHD
    WHERE YEAR(HD.NGHD) = 2006
    GROUP BY CT.MASP
) AS SP_BAN_2006
ON SP.MASP = SP_BAN_2006.MASP
WHERE SP_BAN_2006.MASP IS NULL;
17. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất không bán
được trong năm 2006.
SELECT SP.MASP, SP.TENSP
FROM SANPHAM AS SP
LEFT JOIN (
    SELECT CT.MASP
    FROM CTHD AS CT INNER JOIN HOADON AS HD ON CT.SOHD = HD.SOHD
    WHERE YEAR(HD.NGHD) = 2006
    GROUP BY CT.MASP
) AS SP_BAN_2006
ON SP.MASP = SP_BAN_2006.MASP
WHERE SP.NUOCSX = 'Trung Quoc' and SP_BAN_2006.MASP IS NULL;