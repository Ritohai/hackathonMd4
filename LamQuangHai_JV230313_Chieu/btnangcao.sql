CREATE DATABASE school2;
use school2;

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

-- 1.	 Cho biết họ tên sinh viên KHÔNG học học phần nào 
SELECT hoten
FROM sinhvien
WHERE masv NOT IN (
    SELECT masv
    FROM diemhp
);

-- 2.	Cho biết họ tên sinh viên CHƯA học học phần nào có mã 
select sv.masv, sv.hoten from sinhvien sv
where sv.masv not in (
select sv.masv from sinhvien sv
left join diemhp on diemhp.masv = sv.masv
where diemhp.mahp = 1
);

-- 3.	Cho biết Tên học phần KHÔNG có sinh viên điểm HP <5
select dmhp.mahp, dmhp.tenhp from dmhocphan dmhp
where dmhp.mahp not in (
select dmhp.mahp from dmhocphan dmhp
left join diemhp on diemhp.mahp = dmhp.mahp
where diemhp.diemhp < 5
);

-- 4.	Cho biết Họ tên sinh viên KHÔNG có sinh viên điểm HP <5. 
select sv.masv, sv.hoten from sinhvien sv
where sv.masv not in (
select sv.masv from sinhvien sv
left join diemhp on diemhp.masv = sv.masv
where diemhp.diemhp < 5
);

-- 5.	Cho biết Tên lớp có sinh viên tên Hoa
select dmlop.tenlop from sinhvien sv
join dmlop on sv.malop = dmlop.malop
where sv.hoten like '%Hoa';

-- 6.	Cho biết HoTen sinh viên có điểm học phần 1 là <5.
select sv.hoten from diemhp 
join sinhvien sv on diemhp.masv = sv.masv
where diemhp < 5 and mahp = 1;

-- 7.	Cho biết danh sách các học phần có số đơn vị học trình lớn hơn hoặc bằng số đơn vị học trình của học phần mã 1.
select * from dmhocphan
where dmhocphan.sodvhp >= (
select dmhocphan.sodvhp from dmhocphan
where dmhocphan.mahp = 1
);

-- 8.	Cho biết HoTen sinh viên có DiemHP cao nhất (ALL)
select sv.masv, sv.hoten, diemhp.mahp, diemhp.diemhp from sinhvien sv
join diemhp on diemhp.masv = sv.masv
where diemhp.diemhp >= all(select diemhp.diemhp from diemhp);

-- 9.	Cho biết MaSV, HoTen sinh viên có điểm học phần mã 1 cao nhất (ALL)
select sv.masv, sv.hoten from sinhvien sv
join diemhp on diemhp.masv = sv.masv
where diemhp.diemhp >= all(select max(diemhp.diemhp) from diemhp where diemhp.mahp = 1);

-- 10.	Cho biết MaSV, MaHP có điểm HP lớn hơn bất kì các điểm HP của sinh viên mã 3 (ANY).
SELECT DISTINCT sv.masv, diemhp.mahp
FROM sinhvien sv
JOIN diemhp ON diemhp.masv = sv.masv
WHERE diemhp.diemhp > ANY (
    SELECT diemhp.diemhp
    FROM sinhvien sv
    JOIN diemhp ON diemhp.masv = sv.masv
    WHERE sv.masv = 3
);

-- 11.	Cho biết MaSV, HoTen sinh viên ít nhất một lần học học phần nào đó (EXISTS)
SELECT sv.masv, sv.hoten
FROM sinhvien sv
WHERE EXISTS (
    SELECT 1 FROM diemhp dh
    WHERE dh.masv = sv.masv
);

-- 12.	Cho biết MaSV, HoTen sinh viên đã không học học phần nào. (EXISTS)
select sv.masv, sv.hoten from sinhvien sv
where not exists (
select 1 from diemhp
where diemhp.masv = sv.masv
);

-- 13.	Cho biết MaSV đã học ít nhất một trong hai học phần có mã 1, 2. 
SELECT masv FROM diemhp
WHERE mahp = 1
UNION
SELECT masv FROM diemhp
WHERE mahp = 2;

-- 14.	Tạo thủ tục có tên KIEM_TRA_LOP cho biết HoTen sinh viên KHÔNG có điểm HP <5 ở lớp có mã chỉ định (tức là tham số truyền vào procedure là mã lớp). 
-- Phải kiểm tra MaLop chỉ định có trong danh mục hay không, nếu không thì hiển thị thông báo ‘Lớp này không có trong danh mục’. Khi lớp tồn tại thì đưa ra kết quả.
-- Ví dụ gọi thủ tục: Call KIEM_TRA_LOP(‘CT12’).

drop  procedure KIEM_TRA_LOP;

-- 15.	Tạo một trigger để kiểm tra tính hợp lệ của dữ liệu nhập vào bảng sinhvien là MaSV không được rỗng  Nếu rỗng hiển thị thông báo ‘Mã sinh viên phải được nhập’.
delimiter //
create trigger before_masv
before insert on sinhvien
for each row
begin
	if new.masv is null then
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Mã sinh viên phải được nhập';
	end if;
end;
// delimiter 
-- drop trigger before_masv;

-- 16.	Tạo một TRIGGER khi thêm một sinh viên trong bảng sinh vien ở một lớp nào đó thì cột SiSo của lớp đó trong bảng dmlop (các bạn tạo thêm một cột SiSo trong bảng dmlop) tự động tăng lên 1, đảm bảo tính toàn vẹn dữ liệu khi thêm một sinh viên mới trong bảng sinhvien thì sinh viên đó phải có mã lớp trong bảng dmlop. Đảm bảo tính toàn vẹn dữ liệu khi thêm là mã lớp phải có trong bảng dmlop.
ALTER TABLE dmlop 
ADD COLUMN SiSo INT;
DELIMITER //
CREATE TRIGGER before_masv2
AFTER INSERT ON sinhvien
FOR EACH ROW
BEGIN
    DECLARE siso_count INT;
    
    SELECT COUNT(sv.malop) INTO siso_count
    FROM sinhvien sv
    WHERE sv.malop = NEW.malop
    GROUP BY sv.malop;
    
    UPDATE dmlop
    SET SiSo = siso_count
    WHERE dmlop.malop = NEW.malop;
END //
DELIMITER ;
-- drop TRIGGER before_masv2;

