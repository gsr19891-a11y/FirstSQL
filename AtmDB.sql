-- 1. Удаляем старое представление (если есть)
DROP VIEW IF EXISTS VW_AllUsers;
GO

-- 2. Удаляем старые таблицы в правильном порядке
DROP TABLE IF EXISTS AdminUsers;
DROP TABLE IF EXISTS ClientUsers;
DROP TABLE IF EXISTS Users;
GO

-- 3. Создаем таблицу Users заново
CREATE TABLE Users (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(50) NOT NULL UNIQUE,
    Password NVARCHAR(255) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    Role INT NOT NULL,
    LoanStatus INT NOT NULL DEFAULT 0,
    LoanAmount DECIMAL(18, 2) NOT NULL DEFAULT 0.00,
    IsVerified BIT NOT NULL DEFAULT 0,
    VerificationCode NVARCHAR(10) NULL,
    Balance DECIMAL(18, 2) NOT NULL DEFAULT 0.00
);
GO

-- 4. Создаем дочерние таблицы
CREATE TABLE ClientUsers (
    UserId INT PRIMARY KEY,
    LoanStatus INT NOT NULL DEFAULT 0,
    LoanAmount DECIMAL(18, 2) NOT NULL DEFAULT 0.00,
    CONSTRAINT FK_ClientUsers_Users FOREIGN KEY (UserId) REFERENCES Users(Id) ON DELETE CASCADE
);

CREATE TABLE AdminUsers (
    UserId INT PRIMARY KEY,
    CONSTRAINT FK_AdminUsers_Users FOREIGN KEY (UserId) REFERENCES Users(Id) ON DELETE CASCADE
);
GO

-- 5. Создаем VIEW (теперь оно идет первым в своем пакете после GO)
CREATE VIEW VW_AllUsers AS
SELECT 
    u.Id,
    u.Username,
    u.Password,
    u.Email,
    u.Role,
    u.IsVerified,
    u.VerificationCode,
    u.Balance,
    ISNULL(c.LoanStatus, 0) AS LoanStatus,
    ISNULL(c.LoanAmount, 0.00) AS LoanAmount
FROM Users u
LEFT JOIN ClientUsers c ON u.Id = c.UserId;
GO

INSERT INTO Users (Username, Password, Email, Role, LoanStatus, LoanAmount, IsVerified, VerificationCode, Balance)
VALUES ('alex99', 'hashed_pass_1', 'alex@gmail.com', 0, 0, 0.00, 1, NULL, 550.50);

DECLARE @ClientUserId INT = SCOPE_IDENTITY();
INSERT INTO ClientUsers (UserId, LoanStatus, LoanAmount)
VALUES (@ClientUserId, 1, 200.00);

INSERT INTO Users (Username, Password, Email, Role, LoanStatus, LoanAmount, IsVerified, VerificationCode, Balance)
VALUES ('admin_giorgi', 'hashed_pass_2', 'admin@atm.ge', 1, 0, 0.00, 1, NULL, 0.00);

DECLARE @AdminUserId INT = SCOPE_IDENTITY();
INSERT INTO AdminUsers (UserId)
VALUES (@AdminUserId);


UPDATE Users
SET Password = '$2a$11$V.tUF0cOXihKISjH9hNMrOTneuBKpBHG/hihMf8aEnC.uiPzxcHgG',
    IsVerified = 1
WHERE Username = 'alex99';


UPDATE Users
SET Password = '$2a$11$V.tUF0cOXihKISjH9hNMrOTneuBKpBHG/hihMf8aEnC.uiPzxcHgG',
    IsVerified = 1
WHERE Username = 'admin_giorgi';

Select * FROM VW_AllUsers