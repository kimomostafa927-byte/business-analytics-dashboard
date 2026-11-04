
PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS Sales;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Products;

CREATE TABLE Customers (
    CustomerID INTEGER PRIMARY KEY,
    CustomerName TEXT NOT NULL
);

CREATE TABLE Products (
    ProductID INTEGER PRIMARY KEY,
    ProductName TEXT NOT NULL,
    Category TEXT NOT NULL,
    Price REAL NOT NULL,
    Cost REAL NOT NULL
);

CREATE TABLE Sales (
    SaleID INTEGER PRIMARY KEY,
    CustomerID INTEGER,
    ProductID INTEGER,
    Quantity INTEGER DEFAULT 1,
    SaleDate TEXT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Customers VALUES
(1, 'Ahmed Ali'),
(2, 'Sara Mohamed'),
(3, 'Omar Hassan'),
(4, 'Mona Adel'),
(5, 'Youssef Samir'),
(6, 'Nour Ahmed'),
(7, 'Ali Mostafa'),
(8, 'Laila Karim');

INSERT INTO Products VALUES
(1, 'Laptop', 'Electronics', 1200, 900),
(2, 'Headphones', 'Electronics', 250, 150),
(3, 'Office Chair', 'Furniture', 400, 260),
(4, 'Desk', 'Furniture', 650, 420),
(5, 'Smart Watch', 'Electronics', 500, 350),
(6, 'Notebook', 'Stationery', 80, 30),
(7, 'Printer', 'Electronics', 700, 500),
(8, 'Bookshelf', 'Furniture', 350, 220);

INSERT INTO Sales VALUES
(1001, 1, 1, 1, '2026-01-05'),
(1002, 2, 2, 1, '2026-01-10'),
(1003, 3, 3, 1, '2026-02-03'),
(1004, 4, 4, 1, '2026-02-15'),
(1005, 5, 5, 1, '2026-03-08'),
(1006, 6, 6, 1, '2026-03-12'),
(1007, 7, 7, 1, '2026-04-02'),
(1008, 8, 8, 1, '2026-04-15');

-- 1. Revenue and Profit by Product
SELECT
    P.ProductName,
    SUM(S.Quantity * P.Price) AS Revenue,
    SUM(S.Quantity * (P.Price - P.Cost)) AS Profit
FROM Products P
JOIN Sales S ON P.ProductID = S.ProductID
GROUP BY P.ProductName;

-- 2. Monthly Revenue
SELECT
    strftime('%Y-%m', S.SaleDate) AS Month,
    SUM(S.Quantity * P.Price) AS Revenue
FROM Sales S
JOIN Products P ON S.ProductID = P.ProductID
GROUP BY Month
ORDER BY Month;

-- 3. Revenue by Category
SELECT
    P.Category,
    SUM(S.Quantity * P.Price) AS Revenue
FROM Products P
JOIN Sales S ON P.ProductID = S.ProductID
GROUP BY P.Category
ORDER BY Revenue DESC;

-- 4. Top Selling Products
SELECT
    P.ProductName,
    SUM(S.Quantity) AS UnitsSold
FROM Products P
JOIN Sales S ON P.ProductID = S.ProductID
GROUP BY P.ProductName
ORDER BY UnitsSold DESC;

-- 5. Customer Spending
SELECT
    C.CustomerName,
    COUNT(S.SaleID) AS TotalOrders,
    SUM(S.Quantity * P.Price) AS TotalSpent
FROM Customers C
JOIN Sales S ON C.CustomerID = S.CustomerID
JOIN Products P ON S.ProductID = P.ProductID
GROUP BY C.CustomerID, C.CustomerName
ORDER BY TotalSpent DESC;
