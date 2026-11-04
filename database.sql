
CREATE TABLE Products (
    ProductID INTEGER PRIMARY KEY,
    ProductName TEXT,
    Category TEXT,
    Price REAL,
    Cost REAL
);

CREATE TABLE Sales (
    SaleID INTEGER PRIMARY KEY,
    ProductID INTEGER,
    Quantity INTEGER,
    SaleDate TEXT,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Products VALUES
(1, 'Laptop', 'Electronics', 25000, 21000),
(2, 'Headphones', 'Electronics', 1500, 900),
(3, 'Chair', 'Furniture', 4000, 2800);

INSERT INTO Sales VALUES
(1, 1, 2, '2026-01-05'),
(2, 2, 5, '2026-01-10'),
(3, 3, 3, '2026-02-05'),
(4, 1, 1, '2026-02-15');

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
    strftime('%Y-%m', SaleDate) AS Month,
    SUM(Quantity * Price) AS MonthlyRevenue
FROM Sales
JOIN Products ON Sales.ProductID = Products.ProductID
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
