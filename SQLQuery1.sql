



CREATE DATABASE StepDB

GO

USE StepDB

GO

CREATE TABLE Students
(
  ID int PRIMARY KEY identity(1,1),
  FirstName NVarChar(50) NOT NULL,
  LastName NVarChar(50) NOT NULL,
  Age int,
  Email NVarChar(100) unique,

)

GO

INSERT INTO Students
(FirstName, LastName, Age, Email)
VALUES
('Michael', 'Brown', 21, 'michael.brown@gmail.com'),
('Emily', 'Davis', 23, 'emily.davis@gmail.com'),
('Daniel', 'Wilson', 20, 'daniel.wilson@gmail.com'),
('Sophia', 'Taylor', 19, 'sophia.taylor@gmail.com'),
('James', 'Anderson', 22, 'james.anderson@gmail.com'),
('Olivia', 'Thomas', 21, 'olivia.thomas@gmail.com'),
('David', 'Jackson', 24, 'david.jackson@gmail.com'),
('Emma', 'White', 20, 'emma.white@gmail.com'),
('Alexander', 'Harris', 19, 'alexander.harris@gmail.com'),
('Mia', 'Martin', 22, 'mia.martin@gmail.com'),
('Liam', 'Thompson', 23, 'liam.thompson@gmail.com'),
('Isabella', 'Garcia', 20, 'isabella.garcia@gmail.com'),
('Ethan', 'Martinez', 21, 'ethan.martinez@gmail.com'),
('Ava', 'Robinson', 19, 'ava.robinson@gmail.com'),
('Benjamin', 'Clark', 22, 'benjamin.clark@gmail.com'),
('Charlotte', 'Rodriguez', 20, 'charlotte.rodriguez@gmail.com'),
('Lucas', 'Lewis', 23, 'lucas.lewis@gmail.com'),
('Amelia', 'Lee', 21, 'amelia.lee@gmail.com'),
('Mason', 'Walker', 19, 'mason.walker@gmail.com'),
('Harper', 'Hall', 22, 'harper.hall@gmail.com');

--alter table -- ცვლის ცხრილის სტრუქტურას

GO

Update Students 
SET FirstName = 'JonathanJ'
WHERE ID = 21

GO

Alter Table Students
Add Grade int  NOT NULL default 0

GO

Alter Table Students
Add Phone VarChar(20)  NOT NULL default 'N/A'

GO

ALTER TABLE Students
ADD StatusIsActive  bit NOT NULL default 1

GO

CREATE TABLE Teacher
(
  ID int PRIMARY KEY identity(1,1),
  FirstName NVarChar(50) NOT NULL,
  LastName NVarChar(50) default 'N/A',
  PhoneNumber VarChar(50),
  Email NVarChar(100) unique,
)

GO

INSERT INTO Teacher (FirstName, LastName, PhoneNumber, Email) 
VALUES
('Robert', 'Smith', '+15550101', 'robert.smith@school.com'),
('Sarah', 'Johnson', '+15550102', 'sarah.johnson@school.com'),
('Michael', 'Williams', '+15550103', 'michael.williams@school.com'),
('Emily', 'Brown', '+15550104', 'emily.brown@school.com'),
('David', 'Jones', '+15550105', 'david.jones@school.com'),
('Jessica', 'Garcia', '+15550106', 'jessica.garcia@school.com'),
('James', 'Miller', '+15550107', 'james.miller@school.com'),
('Amanda', 'Davis', '+15550108', 'amanda.davis@school.com'),
('Daniel', 'Rodriguez', '+15550109', 'daniel.rodriguez@school.com'),
('Jennifer', 'Martinez', '+15550110', 'jennifer.martinez@school.com'),
('Christopher', 'Hernandez', '+15550111', 'christopher.hernandez@school.com'),
('Lisa', 'Lopez', '+15550112', 'lisa.lopez@school.com'),
('Matthew', 'Gonzalez', '+15550113', 'matthew.gonzalez@school.com'),
('Ashley', 'Wilson', '+15550114', 'ashley.wilson@school.com'),
('Andrew', 'Anderson', '+15550115', 'andrew.anderson@school.com'),
('Stephanie', 'Thomas', '+15550116', 'stephanie.thomas@school.com'),
('Joshua', 'Taylor', '+15550117', 'joshua.taylor@school.com'),
('Nicole', 'Moore', '+15550118', 'nicole.moore@school.com'),
('Ryan', 'Jackson', '+15550119', 'ryan.jackson@school.com'),
('Elizabeth', 'Martin', '+15550120', 'elizabeth.martin@school.com');

GO

-- M-M many to many


CREATE TABLE Subjects
(
Id int PRIMARY KEY IDENTITY(1,1),
Title NVarChar(100),
AmountOfHours int NOT NULL CHECK(AmountOfHours > 0)
)

GO

INSERT INTO Subjects (Title, AmountOfHours) VALUES
('Mathematics', 120),
('Physics', 90),
('Chemistry', 80),
('Computer Science', 150),
('English Literature', 60),
('World History', 45),
('Biology', 70),
('Algebra & Geometry', 100),
('Database Systems', 110),
('Web Development', 140),
('Software Engineering', 130),
('Philosophy', 40),
('Economics', 50),
('Art & Design', 30),
('Statistics', 85),
('Cybersecurity', 95),
('Linear Algebra', 75),
('Data Structures', 120),
('Operating Systems', 105),
('Discrete Mathematics', 90);

GO



Create Table StudentSubject 
(
Id int PRIMARY KEY IDENTITY(1,1),

StudentID int NOT NULL,
SubjectsID int NOT NULL,

Constraint FK_Student_Subject_StudentId foreign key (StudentID) references Students(Id)
ON DELETE CASCADE,
Constraint FK_Student_Subject_SubjectsId foreign key (SubjectsID) references Subjects(Id)
ON DELETE CASCADE ,
)


GO

select * from Subjects

select * from Students

select * from StudentSubject

GO

insert into StudentSubject(StudentID, SubjectsID)

values
(1,1),
(2,1),
(3,1),
(4,1),
(5,2),
(6,2),
(7,2),
(8,3),
(9,3),
(10,3),
(11,3),
(12,4),
(13,4),
(14,4),
(15,5),
(16,5),
(17,5),
(18,6),
(19,6)

GO



