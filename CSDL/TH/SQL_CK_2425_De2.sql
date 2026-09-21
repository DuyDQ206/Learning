1.2. Thực hiện các câu truy vấn sau bằng ngôn ngữ SQL: (6 điểm) [G2]
a. Liệt kê các mã đặt vé, mã lịch bay, mã khách hàng thành viên và tổng tiền thanh toán của
các khách hàng thành viên có sinh nhật trong tháng 12. Sắp xếp kết quả trả về theo tổng tiền thanh
toán giảm dần. (1 điểm)
select madv,malb,matv,tongtientt
from datve as dv innet join thanhvien as tv on dv.matv = tv.matv
where month(tv.ngaysinh) = 12
order by tongtientt desc;

b. Liệt kê số hiệu chuyến bay, mã sân bay đi, mã sân bay đến của những chuyến bay có điểm
đến là sân bay có tên “Phú Bài” và có giờ đến là 12:30:00 ngày 22/12/2024. (1 điểm)
select SoHieuCB,SBDi,SBDen
from CHUYENBAY as cb inner join LICHBAY as lb on cb.SoHieuCB = lb.SoHieuCB
inner join SANBAY as sb on sb.MASB = cb.SBDen
where GioDen = 22/12/2024 12:30:00 and TenSB = 'Phu Bai'

c. Cho biết mã, họ và tên của các khách hàng thành viên có đặt vé trong năm 2024 nhưng chưa
từng đặt loại vé nào có hạng ghế “Thương gia” và có giá lớn hơn 10 triệu trong các lần đặt vé. (1
điểm)
select MATV,HoTV,TenTV 
from THANHVIEN as TV inner join DATVE as DV on TV.MATV = DATVE.MATV
inner join CTDV on DV.MADV = CTDV.MADV
inner join LOAIVE as LV on CTDV.MALV = LV.MALV
where year(ThoiGianDV) = 2024 and HangGhe = 'Thuong gia' and TongTienTT >= 10000000

d. Với mỗi sân bay, cho biết tổng số lượng vé đã được đặt trong tháng 12 năm 2024 cho các
lịch bay của các chuyến bay có điểm khởi hành là sân bay đó. Thông tin hiển thị bao gồm: Mã
sân bay, tên sân bay, tổng số lượng vé. (1 điểm)
select MASB,TENSB,sum(SLVe)
from SANBAY as SB inner join LICHBAY as LB on SB.MASB = LB.MASB
inner join DATVE as DV on LB.MALB = DV.MALB
where month(ThoiGianDV) = 12 and year(ThoiGianDV) = 2024
group by MASB,TENSB,sum(SLVe)

e. Tìm thông tin đặt vé (mã đặt vé, mã khách hàng thành viên) đã đặt tất cả các loại vé của lịch
bay có số hiệu chuyến bay “VN602” khởi hành vào lúc 08:15:00 ngày 08/01/2025. (1 điểm)


f. Trong các lịch bay của chuyến bay có số hiệu “VN330” khởi hành trong năm 2025, tìm các
loại vé đã được đặt hết. Thông tin hiển thị: Mã lịch bay, thời gian khởi hành, mã loại vé. (1 điểm)
