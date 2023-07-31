CREATE DATABASE school;
use school;

CREATE TABLE dmkhoa(
makhoa varchar(20) primary key,
tenkhoa varchar(255)
);

CREATE TABLE dmnganh(
manganh int primary key auto_increment,
tennganh varchar(255),
makhoa varchar(20),
foreign key (makhoa) references dmkhoa(makhoa)
);

CREATE TABLE dmlop(
malop varchar(20) primary key,
tenlop varchar(255),
manganh int,
khoahoc int,
hedt varchar(255),
namnhaphoc int,
foreign key (manganh) references dmnganh(manganh)
);

CREATE TABLE dmhocphan(
mahp int primary key auto_increment,
tenhp varchar(255),
sodvhp int,
manganh int,
hocky int,
foreign key (manganh) references dmnganh(manganh)
);

CREATE TABLE sinhvien(
masv int primary key auto_increment,
hoten varchar(255),
malop varchar(20),
gioitinh tinyint(1),
ngaysinh date,
diachi varchar(255),
foreign key (malop) references dmlop(malop)
);

CREATE TABLE diemhp(
masv int,
mahp int,
diemhp float,
foreign key (masv) references sinhvien(masv),
foreign key (mahp) references dmhocphan(mahp)
);

insert into dmkhoa value
('CNTT','Công nghệ thông tin'),
('KT','Kế toán'),
('SP','Sư Phạm');

insert into dmnganh value
(140902,"Sư phạm toán tin",'SP'),
(480202,'Tin học ứng dụng', 'CNTT');

insert into dmlop value
('CT11','Cao đẳng tin học', 480202,11,'TC',2013),
('CT12','Cao đẳng tin học', 480202,12,'CĐ',2013),
('CT13','Cao đẳng tin học', 480202,13,'TC',2014);

insert into dmhocphan value 
(1,'Toán cao cấp A1',4,480202,1),
(2,'Tiếng anh 1',3,480202,1),
(3,'Vật lí đại cương',4,480202,1),
(4,'Tiếng anh 2',7,480202,1),
(5,'Tiếng anh 1',3,140902,2),
(6,'Xác xuất thống kê',3,480202,2);

insert into sinhvien value 
(1,'Phan Thanh','CT12',0,'1990-09-12','Tuy Phước'),
(2,'Nguyễn Thị Cẩm','CT12',1,'1994-01-12','Quy Nhơn'),
(3,'Võ Thị Hà','CT12',1,'1995-07-02','An Nhơn'),
(4,'Trần Hoài Nam','CT12',0,'1994-04-05','Tây Sơn'),
(5,'Trần Văn Hoàng','CT13',0,'1995-08-04','Vĩnh Thạnh'),
(6,'Đặng Thị Thảo','CT13',1,'1995-06-12','Quy Nhơn'),
(7,'Lê Thị Sen','CT13',1,'1994-08-12','Phú Mỹ'),
(8,'Nguyễn Văn Huy','CT11',0,'1995-06-04','Tuy Phước'),
(9,'Trần Thị Hoa','CT11',1,'1994-08-09','Hoài Nhơn');

insert into diemhp value 
(2,2,5.9),
(2,3,4.5),
(3,1,4.3),
(3,2,6.7),
(3,3,7.3),
(4,1,4.0),
(4,2,5.2),
(4,3,3.5),
(5,1,9.8),
(5,2,7.9),
(5,3,7.5),
(6,1,6.1),
(6,2,5.6),
(6,3,4.0),
(7,1,6.2);

-- 1.	 Hiển thị danh sách gồm MaSV, HoTên, MaLop, DiemHP, MaHP của những sinh viên có điểm HP >= 5  
select sinhvien.masv,hoten, malop, dhp.diemhp, dhp.mahp from sinhvien
join diemhp dhp on dhp.masv = sinhvien.masv
where dhp.diemhp >= 5;

-- 2.	Hiển thị danh sách MaSV, HoTen, MaLop, MaHP, DiemHP, MaHP được sắp xếp theo ưu tiên MaLop, HoTen tăng dần. 
select sinhvien.masv,hoten, malop, dhp.diemhp, dhp.mahp from sinhvien
join diemhp dhp on dhp.masv = sinhvien.masv
order by sinhvien.malop, sinhvien.hoten;

-- 3.	Hiển thị danh sách gồm MaSV, HoTen, MaLop, DiemHP, HocKy của những sinh viên có DiemHP từ 5  7 ở học kỳ I. 
select sinhvien.masv,hoten, malop, dhp.diemhp, dhp.mahp, dmhp.hocky from sinhvien
join diemhp dhp on dhp.masv = sinhvien.masv
join dmhocphan dmhp on dmhp.mahp = dhp.mahp
where dmhp.hocky = 1 and dhp.diemhp between 5.0 and 7.0;

-- 4.	Hiển thị danh sách sinh viên gồm MaSV, HoTen, MaLop, TenLop, MaKhoa của Khoa có mã CNTT 
select sinhvien.masv,hoten, sinhvien.malop, dml.tenlop, dmn.makhoa from sinhvien
join dmlop dml on dml.malop = sinhvien.malop
join dmnganh dmn on dmn.manganh = dml.manganh
where dmn.makhoa = 'CNTT';

-- 5.	Cho biết MaLop, TenLop, tổng số sinh viên của mỗi lớp (SiSo)
select dml.malop, dml.tenlop, count(sinhvien.masv) as SiSo from sinhvien
join dmlop dml on dml.malop = sinhvien.malop
group by dml.malop, dml.tenlop;

-- 6. 	Cho biết điểm trung bình chung của mỗi sinh viên ở mỗi học kỳ, biết công thức tính DiemTBC như sau:
-- DiemTBC = ∑▒〖(DiemHP*Sodvhp)/∑(Sodvhp)〗
select dmhp.hocky, sv.masv,sum(diemhp * dmhp.sodvhp)/sum(dmhp.sodvhp) as 'Điểm trung bình' from diemhp
join sinhvien sv on sv.masv = diemhp.masv
join dmhocphan dmhp on dmhp.mahp = diemhp.mahp
group by dmhp.hocky, sv.masv;

-- 7.	Cho biết MaLop, TenLop, số lượng nam nữ theo từng lớp.
select dml.malop, dml.tenlop,
count(case when gioitinh = 1 then 1 end) as 'Số lượng nam',
count(case when gioitinh = 0 then 1 end) as 'Số lượng nữ'
    from sinhvien
join dmlop dml on dml.malop = sinhvien.malop
group by dml.malop, dml.tenlop;

-- 8.	Cho biết điểm trung bình chung của mỗi sinh viên ở học kỳ 1
-- Biết: DiemTBC = ∑▒〖(DiemHP*Sodvhp)/∑(Sodvhp)〗
select dhp.masv, sum(dhp.diemhp * dmhocphan.sodvhp)/sum(dmhocphan.sodvhp) as 'Điểm trung bình' from dmhocphan 
join diemhp dhp on dhp.mahp = dmhocphan.mahp
group by dhp.masv;

-- 9.	Cho biết MaSV, HoTen, Số các học phần thiếu điểm (DiemHP<5) của mỗi sinh viên
select sv.masv, sv.hoten,count(dhp.diemhp) from sinhvien sv
join diemhp dhp on dhp.masv = sv.masv
where dhp.diemhp < 5
group by sv.masv, sv.hoten;

-- 10.	Đếm số sinh viên có điểm HP <5 của mỗi học phần
select dhp.mahp,count(sv.masv) from diemhp dhp
join sinhvien sv on sv.masv = dhp.masv
where dhp.diemhp < 5
group by dhp.mahp;

-- 11.	Tính tổng số đơn vị học trình có điểm HP<5 của mỗi sinh viên
select sv.masv, sv.hoten, sum(dmhocphan.sodvhp) as 'Tongdvht' from sinhvien sv
join diemhp on diemhp.masv = sv.masv
join dmhocphan on dmhocphan.mahp = diemhp.mahp
where diemhp.diemhp < 5
group by sv.masv;

-- 12.	Cho biết MaLop, TenLop có tổng số sinh viên >2.
select sv.malop, dml.tenlop,count(sv.masv) as 'SiSo' from sinhvien sv
join dmlop dml on dml.malop = sv.malop
group by sv.malop, dml.tenlop
having  count(sv.masv) > 2;

-- 13.	Cho biết HoTen sinh viên có ít nhất 2 học phần có điểm <5. 
select sv.masv, sv.hoten, count(sv.masv) as 'Soluong' from sinhvien sv
join diemhp dhp on dhp.masv = sv.masv
where dhp.diemhp < 5
group by sv.masv
having count(sv.masv) >= 2;

-- 14.	Cho biết HoTen sinh viên học ít nhất 3 học phần mã 1,2,3
select sv.hoten from sinhvien sv
join diemhp dhp on dhp.masv = sv.masv

