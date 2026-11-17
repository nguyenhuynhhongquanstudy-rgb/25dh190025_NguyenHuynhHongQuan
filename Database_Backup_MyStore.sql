-- ================================================================
-- DATABASE BACKUP SCRIPT CHO DỰ ÁN 25dh190025_NguyenHuynhHongQuan
-- Sinh viên: Nguyễn Huỳnh Hồng Quân - MSSV: 25DH190025
-- ================================================================

USE [master];
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'MyStore')
BEGIN
    CREATE DATABASE [MyStore];
END
GO

USE [MyStore];
GO

-- 1. BẢNG TÀI KHOẢN (USER)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'User')
BEGIN
    CREATE TABLE [dbo].[User] (
        [Username] NVARCHAR(50) NOT NULL PRIMARY KEY,
        [Password] NVARCHAR(50) NOT NULL,
        [UserRole] NVARCHAR(20) NOT NULL
    );
END
GO

-- 2. BẢNG KHÁCH HÀNG (CUSTOMER)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Customer')
BEGIN
    CREATE TABLE [dbo].[Customer] (
        [CustomerID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [CustomerName] NVARCHAR(MAX) NOT NULL,
        [CustomerPhone] NVARCHAR(15) NOT NULL,
        [CustomerEmail] NVARCHAR(MAX) NULL,
        [CustomerAddress] NVARCHAR(MAX) NOT NULL,
        [Username] NVARCHAR(50) NOT NULL,
        CONSTRAINT [FK_Customer_User] FOREIGN KEY ([Username]) REFERENCES [dbo].[User] ([Username]) ON DELETE CASCADE
    );
END
GO

-- 3. BẢNG DANH MỤC SẢN PHẨM (CATEGORY)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Category')
BEGIN
    CREATE TABLE [dbo].[Category] (
        [CategoryID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [CategoryName] NVARCHAR(MAX) NOT NULL
    );
END
GO

-- 4. BẢNG SẢN PHẨM (PRODUCT)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Product')
BEGIN
    CREATE TABLE [dbo].[Product] (
        [ProductID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [CategoryID] INT NOT NULL,
        [ProductName] NVARCHAR(MAX) NOT NULL,
        [ProductDescription] NVARCHAR(MAX) NOT NULL,
        [ProductPrice] DECIMAL(18,2) NOT NULL,
        [ProductImage] NVARCHAR(MAX) NULL,
        [Quantity] INT NOT NULL DEFAULT 0,
        [SoldQuantity] INT NOT NULL DEFAULT 0,
        CONSTRAINT [FK_Product_Category] FOREIGN KEY ([CategoryID]) REFERENCES [dbo].[Category] ([CategoryID]) ON DELETE CASCADE
    );
END
GO

-- 5. BẢNG ĐƠN HÀNG (ORDER)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Order')
BEGIN
    CREATE TABLE [dbo].[Order] (
        [OrderID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [OrderDate] DATETIME NOT NULL,
        [CustomerID] INT NOT NULL,
        [TotalAmount] DECIMAL(18,2) NOT NULL,
        [PaymentStatus] NVARCHAR(MAX) NOT NULL,
        [ShippingAddress] NVARCHAR(MAX) NOT NULL,
        [ShippingMethod] NVARCHAR(MAX) NOT NULL,
        [DeliveryStatus] NVARCHAR(MAX) NOT NULL,
        CONSTRAINT [FK_Order_Customer] FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[Customer] ([CustomerID]) ON DELETE CASCADE
    );
END
GO

-- 6. BẢNG CHI TIẾT ĐƠN HÀNG (ORDERDETAIL)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'OrderDetail')
BEGIN
    CREATE TABLE [dbo].[OrderDetail] (
        [ID] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [ProductID] INT NOT NULL,
        [OrderID] INT NOT NULL,
        [Quantity] INT NOT NULL,
        [UnitPrice] DECIMAL(18,2) NOT NULL,
        CONSTRAINT [FK_OrderDetail_Order] FOREIGN KEY ([OrderID]) REFERENCES [dbo].[Order] ([OrderID]) ON DELETE CASCADE,
        CONSTRAINT [FK_OrderDetail_Product] FOREIGN KEY ([ProductID]) REFERENCES [dbo].[Product] ([ProductID]) ON DELETE CASCADE
    );
END
GO

-- NẠP DỮ LIỆU TÀI KHOẢN ADMIN VÀ CUSTOMER
IF NOT EXISTS (SELECT 1 FROM [User] WHERE Username = 'admin')
    INSERT INTO [User] ([Username], [Password], [UserRole]) VALUES ('admin', 'admin123', 'Admin');

IF NOT EXISTS (SELECT 1 FROM [User] WHERE Username = N'QUÂN NGUYỄN')
    INSERT INTO [User] ([Username], [Password], [UserRole]) VALUES (N'QUÂN NGUYỄN', 'Quan123@', 'Customer');

IF NOT EXISTS (SELECT 1 FROM [Customer] WHERE Username = N'QUÂN NGUYỄN')
    INSERT INTO [Customer] ([CustomerName], [CustomerPhone], [CustomerEmail], [CustomerAddress], [Username])
    VALUES (N'Nguyễn Huỳnh Hồng Quân', '0900000000', '25dh190025@student.edu.vn', N'TP. Hồ Chí Minh', N'QUÂN NGUYỄN');
GO
