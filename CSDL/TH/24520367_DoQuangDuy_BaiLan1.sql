1. Viết các câu lệnh SQL thực hiện các câu truy vấn sau:
1.1. Liệt kê tất cả các suất chiếu (MaSuat, GioChieu, TenPH, TenPhim, ThoiLuong) được
chiếu trong ngày 22/10/2025. (2đ)
SELECT MaSuat, GioChieu, TenPH, TenPhim, ThoiLuong
FROM SUATCHIEU 
INNER JOIN PHIM ON SUATCHIEU.MaPhim = PHIM.MaPhim
INNER JOIN PHONGCHIEU ON SUATCHIEU.MaPH = PHONGCHIEU.MaPH
WHERE NGAYCHIEU = '22/10/2025'

1.2. Thống kê số suất chiếu của mỗi phòng chiếu (MaPH, TenPH) trong năm 2025. (2đ)
SELECT MAPH,TenPH, COUNT(MASUAT)
FROM PHONGCHIEU 
INNER JOIN SUATCHIEU ON PHONGCHIEU.MaPH = SUATCHIEU.MaPH
WHERE YEAR(NgayChieu) = 2025
GROUP BY MaPH,TenPH

1.3. Tính doanh thu của từng phim (MaPhim ,TenPhim, DoanhThu). (2đ)
SELECT MaPhim ,TenPhim, sum(GiaVe*SLVE) as DoanhThu
from PHIM 
inner join SUATCHIEU on PHIM.MaPhim = SUATCHIEU.MaPhim
inner join THONGTIN on SUATCHIEU.MaSuat = THONGTIN.Masuat
group by MaPhim,TenPhim

1.4. Thống kê (MaPhim, TenPhim) có lượng vé bán ra của mỗi phim trong ngày
22/10/2025. (2đ)
select MaPhim,TenPhim, SUM(SLVE)
from THONGTIN 
inner join SUATCHIEU on THONGTIN.MaSuat = SUATCHIEU.MaSuat
inner join PHIM on SUATCHIEU.MaPhim = PHIM.MaPhim
where NgayChieu = '22/10/2025'
group by MaPhim,TenPhim

1.5. Thống kê số lần chiếu của mỗi phim (MaPhim, TenPhim) được chiếu trong năm 2025. 
select MaPhim,TenPhim, count(MaSuat) as SLChieu
from PHIM inner join SUATCHIEU on PHIM.MaPhim = SUATCHIEU.MaPhim
where year(NgayChieu) = 2025
group by MaPhim,TenPhim
