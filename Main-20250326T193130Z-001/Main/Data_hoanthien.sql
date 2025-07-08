CREATE DATABASE LibraryManagement
GO
USE LibraryManagement
GO

CREATE TABLE Roles (
    RoleID int IDENTITY(0,1) NOT NULL PRIMARY KEY,
    RoleName varchar(50) NOT NULL UNIQUE
)
GO

CREATE TABLE Users (
    UserID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    RollNumber varchar(8) NOT NULL UNIQUE,
    Password varchar(255) NOT NULL,
    FullName varchar(255) NOT NULL,
    PhoneNumber varchar(20) NULL,
    Address text NULL,
    Email varchar(255) NOT NULL,
    RoleID int NULL,
    CONSTRAINT FK_Users_Roles FOREIGN KEY (RoleID) REFERENCES Roles(RoleID) ON DELETE CASCADE
)
GO

CREATE TABLE Books (
    BookID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Title varchar(255) NOT NULL,
    Author varchar(255) NOT NULL,
    Publisher varchar(255) NULL,
    Image nvarchar(252) NULL
)
GO

CREATE TABLE Transactions (
    TransactionID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    UserID int NULL,
    BookID int NOT NULL,
    BorrowDate date NOT NULL,
    DueDate date NOT NULL,
    ReturnDate date NULL,
    Fine decimal(10, 2) NULL DEFAULT 0.00,
    ExtendedDays int NULL DEFAULT 0,
    ExtensionReason varchar(max) NULL,
    CONSTRAINT FK_Transactions_Books FOREIGN KEY (BookID) REFERENCES Books(BookID),
    CONSTRAINT FK_Transactions_Users FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE SET NULL
)
GO

CREATE TABLE TransactionHistory (
    HistoryID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    TransactionID int NULL,
    UserID int NULL,
    BookID int NULL,
    BorrowDate date NULL,
    ReturnDate date NULL,
    Fine decimal(10, 2) NULL,
    CONSTRAINT FK_TransactionHistory_Books FOREIGN KEY (BookID) REFERENCES Books(BookID),
    CONSTRAINT FK_TransactionHistory_Transactions FOREIGN KEY (TransactionID) REFERENCES Transactions(TransactionID) ON DELETE CASCADE,
    CONSTRAINT FK_TransactionHistory_Users FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
)
GO

CREATE TABLE LoanSettings (
    SettingID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    DefaultLoanDays int NOT NULL DEFAULT 14,
    ExtendFee int NOT NULL,
    LateFeePerDay decimal(10, 2) NOT NULL DEFAULT 15000,
    MaxBooksAllowed int NOT NULL DEFAULT 10
)
GO

CREATE TABLE NotificationSettings (
    NotificationID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    RollNumber varchar(8) NOT NULL,
    NotificationInterval varchar(10) NOT NULL DEFAULT '24',
    Enabled bit DEFAULT 1
)
GO

SET IDENTITY_INSERT Books ON
INSERT INTO Books (BookID, Title, Author, Publisher, Image) VALUES (1, N'Dac nhan tam', N'Dale Carnegie', N'NXB Tong hop thanh pho Ho Chi Minh', N'1.jpg')
INSERT INTO Books (BookID, Title, Author, Publisher, Image) VALUES (2, N'Quang ganh lo di & vui song', N'Dale Carnegie', N'NXB Tre', N'2.jpg')
INSERT INTO Books (BookID, Title, Author, Publisher, Image) VALUES (3, N'Atomic Habits', N'James Clear', N'NXB Phuong Nam', N'3.jpg')
INSERT INTO Books (BookID, Title, Author, Publisher, Image) VALUES (4, N'7 thoi quen cua nguoi thanh dat', N'Stephen R. Covey', N'NXB Tre', N'4.jpg')
INSERT INTO Books (BookID, Title, Author, Publisher, Image) VALUES (5, N'Lanh dao 101', N'John C. Maxwell', N'NXB Hong Duc', N'5.png')
INSERT INTO Books (BookID, Title, Author, Publisher, Image) VALUES (6, N'Dam bi ghet', N'Ichiro Kishimi & Fumitake Koga', N'', N'6.jpg')
INSERT INTO Books (BookID, Title, Author, Publisher, Image) VALUES (7, N'Ban co the dam phan bat cu dieu gi', N'Herb Cohen', N'NXB Cong Duong', N'7.webp')
INSERT INTO Books (BookID, Title, Author, Publisher, Image) VALUES (8, N'Thay doi de thanh cong', N'Spencer Johnson', N'NXB Van Hoc', N'8.jpeg')
INSERT INTO Books (BookID, Title, Author, Publisher, Image) VALUES (9, N'Nha gia kim', N'Paulo Coelho', N'NXB Van Hoc', N'9.jpg')
INSERT INTO Books (BookID, Title, Author, Publisher, Image) VALUES (10, N'Di tim le song', N'Viktor Frankl', N'NXB Tong hop thanh pho Ho Chi Minh', N'10.jpg')
INSERT INTO Books (BookID, Title, Author, Publisher, Image) VALUES (11, N'Luan ngu', N'Khong Tu', N'NXB Van Hoc', N'11.webp')
INSERT INTO Books (BookID, Title, Author, Publisher, Image) VALUES (12, N'Dao duc kinh', N'Lao Tu', N'NXB Tre', N'12.jpg')
INSERT INTO Books (BookID, Title, Author, Publisher, Image) VALUES (13, N'Kinh phap cu', N'Phat Giao', N'NXB Hong Duc', N'13.jpg')
INSERT INTO Books (BookID, Title, Author, Publisher, Image) VALUES (14, N'Plato in 60 minuten', N'Plato', N'NXB Hong Duc', N'14.jpg')
INSERT INTO Books (BookID, Title, Author, Publisher, Image) VALUES (15, N'Tu thuat thanh Augustino', N'Augustine of Hippo', N'NXB Dong Nai', N'15.webp')
INSERT INTO Books (BookID, Title, Author, Publisher, Image) VALUES (16, N'The gioi cua Sophie', N'Jostein Gaarder', N'NXB The Gioi', N'16.webp')
INSERT INTO Books (BookID, Title, Author, Publisher, Image) VALUES (17, N'Zarathustra da noi nhu the', N'Friedrich Nietzsche', N'NXB Van Hoc', N'17.webp')
INSERT INTO Books (BookID, Title, Author, Publisher, Image) VALUES (18, N'Su an ui cua triet hoc', N'Alain de Botton', N'NXB The Gioi', N'18.jpg')
INSERT INTO Books (BookID, Title, Author, Publisher, Image) VALUES (19, N'Doi thay doi khi chung ta thay doi', N'Andrew Matthews', N'NXB Tre', N'19.jpeg')
INSERT INTO Books (BookID, Title, Author, Publisher, Image) VALUES (20, N'Bi mat cua hanh phuc', N'Matthieu Ricard', N'NXB Tong hop thanh pho Ho Chi Minh', N'20.webp')
INSERT INTO Books (BookID, Title, Author, Publisher, Image) VALUES (21, N'Binh phap Ton Tu', N'Ton Tu', N'NXB Hong Duc', N'21.jpg')
INSERT INTO Books (BookID, Title, Author, Publisher, Image) VALUES (22, N'Luoc su loai nguoi', N'Yuval Noah Harari', N'NXB Tri Thuc', N'22.webp')
INSERT INTO Books (BookID, Title, Author, Publisher, Image) VALUES (23, N'Luoc su tuong lai', N'Yuval Noah Harari', N'NXB Tri Thuc', N'23.jpg')
INSERT INTO Books (BookID, Title, Author, Publisher, Image) VALUES (24, N'Nghe thuat chien tranh', N'Carl von Clausewitz', N'NXB Tri Thuc', N'24.jpg')
INSERT INTO Books (BookID, Title, Author, Publisher, Image) VALUES (25, N'Cuoc doi Napoleon', N'Vincent Cronin', N'NXB Tri Thuc', N'25.jpg')
INSERT INTO Books (BookID, Title, Author, Publisher, Image) VALUES (26, N'Ho Chi Minh bien nien su', N'Nhieu tac gia', N'NXB Chinh tri quoc gia su that', N'26.jpg')
INSERT INTO Books (BookID, Title, Author, Publisher, Image) VALUES (27, N'The chien Z', N'Max Brooks', N'NXB Thong tan', N'27.jpg')
INSERT INTO Books (BookID, Title, Author, Publisher, Image) VALUES (28, N'Diep vien hoan hao', N'Larry Berman', N'NXB Thong tan', N'28.jpg')
INSERT INTO Books (BookID, Title, Author, Publisher, Image) VALUES (29, N'Cuoc doi va su nghiep cua Winston Churchill', N'Winston Churchill', N'NXB Hong Duc', N'29.jpg')
INSERT INTO Books (BookID, Title, Author, Publisher, Image) VALUES (30, N'Quan Vuong', N'Niccolò Machiavelli', N'NXB Dong A', N'30.webp')
SET IDENTITY_INSERT Books OFF
GO

SET IDENTITY_INSERT LoanSettings ON
INSERT INTO LoanSettings (SettingID, DefaultLoanDays, ExtendFee, LateFeePerDay, MaxBooksAllowed) 
VALUES (1, 14, 10000, CAST(15000.00 AS Decimal(10, 2)), 10)
SET IDENTITY_INSERT LoanSettings OFF
GO

SET IDENTITY_INSERT NotificationSettings ON
INSERT INTO NotificationSettings (NotificationID, RollNumber, NotificationInterval) VALUES (1, N'CE123456', N'24')
SET IDENTITY_INSERT NotificationSettings OFF
GO

SET IDENTITY_INSERT Roles ON
INSERT INTO Roles (RoleID, RoleName) VALUES (0, N'admin')
INSERT INTO Roles (RoleID, RoleName) VALUES (1, N'user')
SET IDENTITY_INSERT Roles OFF
GO


CREATE TRIGGER TR_Books_Delete
ON Books
INSTEAD OF DELETE
AS
BEGIN
    
    DELETE FROM TransactionHistory
    WHERE BookID IN (SELECT BookID FROM deleted);

    DELETE FROM Transactions
    WHERE BookID IN (SELECT BookID FROM deleted);
    
    DELETE FROM Books
    WHERE BookID IN (SELECT BookID FROM deleted);
END;
GO

INSERT INTO Users (RollNumber, Password, FullName, PhoneNumber, Address, Email, RoleID)
VALUES ('admin', 'e10adc3949ba59abbe56e057f20f883e', 'Administrator', '9999999999', 'HCM', 'admin@gmail.com', 0)
GO

------------ Tới Đây Ngưng --------------------
Use master


-- Cần thiết
Select* FROM Users
SELECT * FROM Users WHERE UserID = 1;

SELECT * FROM Books
SELECT * FROM Books WHERE BookID = 33;

SELECT * FROM Transactions
SELECT * FROM Transactions WHERE TransactionID = 33;

DELETE FROM Transactions WHERE TransactionID = 19
DELETE FROM Transactions WHERE BookID = 18

INSERT INTO Transactions (UserID, BookID, BorrowDate, DueDate, ReturnDate, Fine, ExtendedDays)
VALUES (2, 20, '2025-03-24', '2025-04-07', NULL, 0.00, 0) --xanh 11 ngày
GO

INSERT INTO Transactions (UserID, BookID, BorrowDate, DueDate, ReturnDate, Fine, ExtendedDays)
VALUES (2, 19, '2025-03-21', '2025-04-04', NULL, 0.00, 0) --vàng 8 ngày
GO

INSERT INTO Transactions (UserID, BookID, BorrowDate, DueDate, ReturnDate, Fine, ExtendedDays)
VALUES (2, 18, '2025-03-17', '2025-03-31', NULL, 0.00, 0) --đỏ 4 ngày
GO

INSERT INTO NotificationSettings (RollNumber, NotificationInterval) 
VALUES ('CE123456', '12')
GO

UPDATE LoanSettings 
SET DefaultLoanDays = 50, MaxBooksAllowed = 5, LateFeePerDay = 50000, ExtendFee = 100000
GO




-- Không cần thiết
DELETE FROM Users WHERE UserID = 1
DELETE FROM Users WHERE UserID = 2
Delete FROM Users
SELECT * FROM Books
SELECT * FROM Transactions
SELECT * FROM LoanSettings
SELECT * FROM TransactionHistory
SELECT * FROM NotificationSettings

SELECT * FROM NotificationSettings 
WHERE RollNumber = 'CE123456'
GO

SELECT SUM(DATEDIFF(day, DueDate, GETDATE())) as LateDays 
FROM Transactions 
WHERE UserID = 3 AND DueDate < GETDATE() AND ReturnDate IS NULL
GO

SELECT TOP 1 DueDate 
FROM Transactions 
WHERE UserID = 3 AND ReturnDate IS NULL 
ORDER BY DueDate DESC
GO

SELECT LateFeePerDay 
FROM LoanSettings
GO

