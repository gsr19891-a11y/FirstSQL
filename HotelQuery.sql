
CREATE TABLE Hotel(
  Id int primary key Identity(1,1),
  Name NVARCHAR(100) NOT NULL,
  Address NVARCHAR(200) NOT NULL,
  PhoneNumber VARCHAR(15) NOT NULL CHECK(PhoneNumber LIKE '[0-9]%')
);

CREATE TABLE Customers(
  Id int primary key identity(1,1),
  FirstName nvarchar(50) NOT NULL,
  LastName nvarchar(50) NOT NULL,
  Email nvarchar(100) NOT NULL unique,
  PhoneNumber nvarchar(15) NOT NULL check(PhoneNumber LIKE '[0-9]%'),
  PersonalId nvarchar(20) NOT NULL unique check(PersonalId LIKE '[0-9]%' and LEN(PersonalId) = 11)
);

CREATE TABLE Rooms(
  Id int primary key identity(1,1),
  RoomNumber int NOT NULL unique, 
  RoomType NVARCHAR(50) NOT NULL,
  Price DECIMAL(10, 2) NOT NULL CHECK(Price > 0),
  IsAvailable bit NOT NULL default 1,
  HotelId int not null foreign key references dbo.Hotel(Id)
);

CREATE TABLE Bookings (
  Id int Primary key identity(1,1),
  CustomerId int not null foreign key references dbo.Customers(Id),
  RoomId int not null foreign key references dbo.Rooms(Id),
  CheckInDate datetime not null,
  CheckOutDate datetime not null,
  TotalPrice decimal(10, 2) not null check(TotalPrice > 0)
);


CREATE TABLE Payments(
  Id int Primary key identity(1,1),
  BookingId int not null foreign key references dbo.Bookings(Id),
  PaymentDate datetime not null,
  Amount decimal(10, 2) not null CHECK(Amount > 0),
  PaymentMethod NVARCHAR(50) not null
);
GO

--////////////////////////////////////////
-- Шаг 1. Отели
INSERT INTO Hotel (Name, Address, PhoneNumber) VALUES
('Tbilisi Marriott Hotel', '31 Rustaveli Avenue, Tbilisi', '995322772000'),
('Radisson Blu Iveria Hotel', '1 Rose Revolution Square, Tbilisi', '995322402200'),
('Paragraph Freedom Square', '2 Freedom Square, Tbilisi', '995322380000');

-- Шаг 2. Клиенты
INSERT INTO Customers (FirstName, LastName, Email, PhoneNumber, PersonalId) VALUES
('Giorgi', 'Beridze', 'giorgi.beridze@gmail.com', '995599112233', '01024012345'),
('Nino', 'Kapanadze', 'nino.kap@yahoo.com', '995555667788', '01011054321'),
('Levan', 'Tsiklauri', 'levan.ts@mail.ge', '995577889900', '01008098765'),
('Mariam', 'Gelashvili', 'mariam.g@gmail.com', '995511223344', '01031011122');

-- Шаг 3. Комнаты (номера уникальные, чтобы не было конфликта)
INSERT INTO Rooms (RoomNumber, RoomType, Price, IsAvailable, HotelId) VALUES
(101, 'Standard Single', 150.00, 1, 1),
(102, 'Double Deluxe', 250.00, 1, 1),
(103, 'Suite', 450.00, 0, 1),
(201, 'Standard Double', 180.00, 1, 2),
(202, 'Executive Suite', 400.00, 1, 2),
(301, 'Penthouse', 750.00, 0, 3);

-- Шаг 4. Бронирования (ссылаемся на существующие ID комнат и клиентов)
INSERT INTO Bookings (CustomerId, RoomId, CheckInDate, CheckOutDate, TotalPrice) VALUES
(1, 3, '2026-06-01 14:00:00', '2026-06-05 12:00:00', 1800.00),
(2, 6, '2026-06-10 15:00:00', '2026-06-12 11:00:00', 1500.00),
(3, 1, '2026-06-15 14:00:00', '2026-06-20 12:00:00', 750.00);

-- Шаг 5. Платежи (ссылаемся на существующие ID бронирований)
INSERT INTO Payments (BookingId, PaymentDate, Amount, PaymentMethod) VALUES
(1, '2026-06-01 14:15:00', 1800.00, 'Credit Card'),
(2, '2026-06-10 15:30:00', 1500.00, 'Bank Transfer'),
(3, '2026-06-15 14:05:00', 750.00, 'Cash');
GO

--/////////////////////////////

--1
select count(*) as TotalBookings, c.FirstName, c.LastName, r.RoomNumber as Room, h.Name from Bookings b
join Customers c on b.CustomerId = c.Id
join Rooms r on b.RoomId = r.Id
join Hotel h on r.HotelId = h.Id
Group by FirstName, LastName, r.RoomNumber, h.Name 

--2
select top(1) Count(*), h.Name as Hotel from Bookings b
join Rooms r on b.RoomId = r.Id
join Hotel h on r.HotelId = h.Id
Group by h.Name
order by Count(*) desc

--3

select r.RoomNumber from Rooms r
left Join Bookings b on r.Id = b.Id
where b.RoomId is null


--4
select sum(p.Amount) as TotalSpent, c.FirstName, c.LastName from Bookings b
join Customers c on b.CustomerId = c.Id
join Payments p on b.Id = p.BookingId
group by c.FirstName, c.LastName

--5
select max(p.Amount) as MaxSpent  from Bookings b
join Customers c on b.CustomerId = c.Id
join Payments p on b.Id = p.BookingId

--6
select * from Hotel h
join Rooms r on h.Id = r.HotelId
join Bookings b on r.Id = b.RoomId
where b.CheckInDate not between '2026-06-15' and '2026.08.30' and b.CheckOutDate not between '2026-07-01' and '2026.07.31'





--///////////////////////////////////////////////////////////////////////

-- function--------------------------------------------------------------


create function GetFullName
(
@FirstName nvarchar(50),
@LastName nvarchar(50)
)
returns nvarchar(101)
as
begin
	return @FirstName + ' ' + @LastName
end

select dbo.GetFullName(c.FirstName, c.LastName) as FullName from Customers c



create function ConvertPn1
(
	@Pn varchar(11)
)
returns varchar(12)
as
begin
	return '-' + @Pn
end

select dbo.ConvertPn1(c.PersonalId) as ConvertedPersonalId from Customers c
	


-- procedure-------------------------------------------------------------


create procedure sp_GetHighAmountBookings
(
	@Amount int
)
as
begin
	select b.Id, c.FirstName, c.LastName, p.Amount from Bookings b
	join Customers c on b.CustomerId = c.Id
	join Payments p on b.Id = p.BookingId
	where p.Amount > @Amount
end

exec sp_GetHighAmountBookings 1000


-- view ---------------------------------------------------------------

Create view vw_SelectFullAmountBookings
as
	select b.Id, c.FirstName, c.LastName, p.Amount from Bookings b
	join Customers c on b.CustomerId = c.Id
	join Payments p on b.Id = p.BookingId
	where p.Amount > 50

Create view vw_SelectFullAmountBookings2
as
	select b.Id, c.FirstName, c.LastName, p.Amount from Bookings b
	join Customers c on b.CustomerId = c.Id
	join Payments p on b.Id = p.BookingId
	where p.Amount > 1550

select * from vw_SelectFullAmountBookings2



--/////////////////////////////
--SHCEMA


create schema HotelSchema

create table HotelSchema.Employess
(
Id int primary key identity(1,1),
FirstName nvarchar(50),
LastName nvarchar(50),
Email nvarchar(100)
)


create login hrlogin
with password = 'Pass123'


create user hruser
for login hrlogin
with default_schema = HotelSchema

grant select, insert
on schema::HotelSchema to hruser


