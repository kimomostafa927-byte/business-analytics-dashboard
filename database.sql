
-- INSIGHT Business Analytics Database
-- SQL Server

IF DB_ID('InsightDB') IS NULL
    CREATE DATABASE InsightDB;
GO

USE InsightDB;
GO

-- 1. Customers
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    Email VARCHAR(150),
    City VARCHAR(100)
);

-- 2. Products
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Category VARCHAR(50),
    UnitPrice DECIMAL(10,2),
    UnitCost DECIMAL(10,2)
);

-- 3. Orders
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATE NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- 4. Order Details
CREATE TABLE OrderItems (
    OrderItemID INT PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    UnitCost DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Sample Customers
INSERT INTO Customers VALUES
(1, 'Ahmed Hassan', 'ahmed@email.com', 'Cairo'),
(2, 'Sara Ali', 'sara@email.com', 'Giza'),
(3, 'Omar Mohamed', 'omar@email.com', 'Alexandria'),
(4, 'Mona Adel', 'mona@email.com', 'Cairo'),
(5, 'Youssef Samir', 'youssef@email.com', 'Tanta');

-- Sample Products
INSERT INTO Products VALUES
(1, 'Laptop', 'Electronics', 25000, 21000),
(2, 'Headphones', 'Electronics', 1500, 900),
(3, 'Office Chair', 'Furniture', 4000, 2800),
(4, 'Desk', 'Furniture', 6000, 4200),
(5, 'Keyboard', 'Accessories', 800, 450);

-- Sample Orders
INSERT INTO Orders VALUES
(101, 1, '2026-01-05'),
(102, 2, '2026-01-12'),
(103, 3, '2026-02-03'),
(104, 1, '2026-02-15'),
(105, 4, '2026-03-08'),
(106, 5, '2026-03-20'),
(107, 2, '2026-04-02');

-- Sample Order Items
INSERT INTO OrderItems VALUES
(1, 101, 1, 1, 25000, 21000),
(2, 101, 2, 2, 1500, 900),
(3, 102, 3, 1, 4000, 2800),
(4, 103, 4, 2, 6000, 4200),
(5, 104, 5, 3, 800, 450),
(6, 105, 1, 1, 25000, 21000),
(7, 106, 2, 2, 1500, 900),
(8, 107, 3, 2, 4000, 2800);

-- =====================================
-- BUSINESS ANALYTICS QUERIES
-- =====================================

-- 1. Total Revenue
SELECT
    SUM(Quantity * UnitPrice) AS TotalRevenue
FROM OrderItems;

-- 2. Total Profit
SELECT
    SUM(Quantity * (UnitPrice - UnitCost)) AS TotalProfit
FROM OrderItems;

-- 3. Total Orders
SELECT
    COUNT(*) AS TotalOrders
FROM Orders;

-- 4. Revenue by Month
SELECT
    FORMAT(O.OrderDate, 'yyyy-MM') AS SalesMonth,
    SUM(OD.Quantity * OD.UnitPrice) AS MonthlyRevenue
FROM Orders O
JOIN OrderItems OD ON O.OrderID = OD.OrderID
GROUP BY FORMAT(O.OrderDate, 'yyyy-MM')
ORDER BY SalesMonth;

-- 5. Top Selling Products
SELECT
    P.ProductName,
    SUM(OD.Quantity) AS UnitsSold,
    SUM(OD.Quantity * OD.UnitPrice) AS Revenue
FROM Products P
JOIN OrderItems OD ON P.ProductID = OD.ProductID
GROUP BY P.ProductName
ORDER BY Revenue DESC;

-- 6. Revenue by Category
SELECT
    P.Category,
    SUM(OD.Quantity * OD.UnitPrice) AS CategoryRevenue
FROM Products P
JOIN OrderItems OD ON P.ProductID = OD.ProductID
GROUP BY P.Category
ORDER BY CategoryRevenue DESC;

-- 7. Customer Purchase Summary
SELECT
    C.CustomerName,
    COUNT(DISTINCT O.OrderID) AS TotalOrders,
    SUM(OD.Quantity * OD.UnitPrice) AS TotalSpent
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
JOIN OrderItems OD ON O.OrderID = OD.OrderID
GROUP BY C.CustomerName
ORDER BY TotalSpent DESC;
