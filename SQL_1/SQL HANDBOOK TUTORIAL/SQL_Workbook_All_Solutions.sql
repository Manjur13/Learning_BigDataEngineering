-- SQL Hands-On Workbook - all solutions in book order.
-- Run ShopDB_setup.sql first, then run these top to bottom.
USE ShopDB;


-- =====================================================
-- 1.1  Look at every table
-- =====================================================

-- Problem 1.1.1: Show all categories.
SELECT * FROM Categories;

-- Problem 1.1.2: Show all suppliers.
SELECT * FROM Suppliers;

-- Problem 1.1.3: Show all products.
SELECT * FROM Products;

-- Problem 1.1.4: Show all customers.
SELECT * FROM Customers;

-- Problem 1.1.5: Show all employees.
SELECT * FROM Employees;

-- Problem 1.1.6: Show all shippers.
SELECT * FROM Shippers;

-- Problem 1.1.7: Show all orders.
SELECT * FROM Orders;

-- Problem 1.1.8: Show all order line items.
SELECT * FROM OrderDetails;

-- Problem 1.1.9: List every table in the database.
SHOW TABLES;

-- Problem 1.1.10: See the structure (columns, types, keys) of the Products table.
DESCRIBE Products;

-- =====================================================
-- 2.1  SQL Syntax & SELECT
-- =====================================================

-- Problem 2.1.1: The marketing team needs a list of customer names and their cities.
SELECT CustomerName, City
FROM Customers;

-- Problem 2.1.2: Show product name, unit and price for every product.
SELECT ProductName, Unit, Price
FROM Products;

-- =====================================================
-- 2.2  SELECT DISTINCT
-- =====================================================

-- Problem 2.2.1: Which countries do our customers come from? Show each country only once.
SELECT DISTINCT Country
FROM Customers;

-- Problem 2.2.2: How many different countries do we sell to?
SELECT COUNT(DISTINCT Country) AS NumberOfCountries
FROM Customers;

-- Problem 2.2.3: Which unique city + country combinations do suppliers come from?
SELECT DISTINCT City, Country
FROM Suppliers;

-- =====================================================
-- 2.3  WHERE
-- =====================================================

-- Problem 2.3.1: Find all customers located in India.
SELECT * FROM Customers
WHERE Country = 'India';

-- Problem 2.3.2: Get the product with ProductID 8.
SELECT * FROM Products
WHERE ProductID = 8;

-- Problem 2.3.3: Which products cost more than 400?
SELECT ProductName, Price
FROM Products
WHERE Price > 400;

-- Problem 2.3.4: Show orders placed on or after 1 April 2026.
SELECT * FROM Orders
WHERE OrderDate >= '2026-04-01';

-- Problem 2.3.5: Show all customers that are NOT in India using the <> operator.
SELECT CustomerName, Country
FROM Customers
WHERE Country <> 'India';

-- =====================================================
-- 2.4  ORDER BY
-- =====================================================

-- Problem 2.4.1: List products from cheapest to most expensive.
SELECT ProductName, Price
FROM Products
ORDER BY Price;

-- Problem 2.4.2: List products from most expensive to cheapest.
SELECT ProductName, Price
FROM Products
ORDER BY Price DESC;

-- Problem 2.4.3: Sort customers alphabetically by name (text sorts A-Z).
SELECT CustomerName, City
FROM Customers
ORDER BY CustomerName;

-- Problem 2.4.4: Sort customers by Country, and inside each country by CustomerName in reverse order.
SELECT Country, CustomerName
FROM Customers
ORDER BY Country ASC, CustomerName DESC;

-- =====================================================
-- 2.5  AND
-- =====================================================

-- Problem 2.5.1: Find customers in India whose city is Ahmedabad.
SELECT * FROM Customers
WHERE Country = 'India' AND City = 'Ahmedabad';

-- Problem 2.5.2: Find dairy products (CategoryID 3) that cost less than 100.
SELECT ProductName, Price
FROM Products
WHERE CategoryID = 3 AND Price < 100;

-- Problem 2.5.3: Find Indian customers who are in Surat OR Mumbai (combine AND with OR using brackets).
SELECT CustomerName, City
FROM Customers
WHERE Country = 'India' AND (City = 'Surat' OR City = 'Mumbai');

-- =====================================================
-- 2.6  OR
-- =====================================================

-- Problem 2.6.1: Show customers from the UK or the UAE.
SELECT CustomerName, Country
FROM Customers
WHERE Country = 'UK' OR Country = 'UAE';

-- Problem 2.6.2: Show customers who are in Ahmedabad OR whose name starts with 'D'.
SELECT CustomerName, City
FROM Customers
WHERE City = 'Ahmedabad' OR CustomerName LIKE 'D%';

-- =====================================================
-- 2.7  NOT
-- =====================================================

-- Problem 2.7.1: List customers that are not from India.
SELECT CustomerName, Country
FROM Customers
WHERE NOT Country = 'India';

-- Problem 2.7.2: Customers whose name does NOT start with 'S'.
SELECT CustomerName
FROM Customers
WHERE CustomerName NOT LIKE 'S%';

-- Problem 2.7.3: Products whose price is NOT between 100 and 500.
SELECT ProductName, Price
FROM Products
WHERE Price NOT BETWEEN 100 AND 500;

-- Problem 2.7.4: Customers not located in India, UK or USA.
SELECT CustomerName, Country
FROM Customers
WHERE Country NOT IN ('India', 'UK', 'USA');

-- Problem 2.7.5: Products whose price is NOT greater than 100.
SELECT ProductName, Price
FROM Products
WHERE NOT Price > 100;

-- =====================================================
-- 2.8  INSERT INTO
-- =====================================================

-- Problem 2.8.1: A new customer 'Jaipur Rasoi' has signed up. Add them with full details and verify.
INSERT INTO Customers (CustomerName, ContactName, Address, City, PostalCode, Country)
VALUES ('Jaipur Rasoi', 'Kiran Rathore', '3 MI Road', 'Jaipur', '302001', 'India');

SELECT * FROM Customers WHERE CustomerName = 'Jaipur Rasoi';

-- Problem 2.8.2: Another customer 'Pune Pantry' gave only name, city and country. Insert only those columns.
INSERT INTO Customers (CustomerName, City, Country)
VALUES ('Pune Pantry', 'Pune', 'India');

SELECT * FROM Customers WHERE CustomerName = 'Pune Pantry';

-- Problem 2.8.3: Add two new shippers in a single statement.
INSERT INTO Shippers (ShipperName, Phone)
VALUES ('India Post',  '1800-000-1004'),
       ('FedEx India', '1800-000-1005');

SELECT * FROM Shippers;

-- =====================================================
-- 2.9  NULL Values
-- =====================================================

-- Problem 2.9.1: Which customers have no postal code recorded?
SELECT CustomerName, City, PostalCode
FROM Customers
WHERE PostalCode IS NULL;

-- Problem 2.9.2: Show customers that DO have a contact name.
SELECT CustomerName, ContactName
FROM Customers
WHERE ContactName IS NOT NULL;

-- Problem 2.9.3: Find products that have no supplier assigned.
SELECT ProductName, SupplierID
FROM Products
WHERE SupplierID IS NULL;

-- Problem 2.9.4: Common mistake: comparing with = NULL returns nothing, even though NULL rows exist.
SELECT CustomerName FROM Customers
WHERE PostalCode = NULL;

-- =====================================================
-- 2.10  UPDATE
-- =====================================================

-- Problem 2.10.1: Pune Pantry sent their contact person, address and PIN code. Update the record.
UPDATE Customers
SET ContactName = 'Rahul Joshi', Address = '9 FC Road', PostalCode = '411004'
WHERE CustomerName = 'Pune Pantry';

SELECT * FROM Customers WHERE CustomerName = 'Pune Pantry';

-- Problem 2.10.2: Spice prices (CategoryID 5) increase by 10%. Update all of them at once.
UPDATE Products
SET Price = Price * 1.10
WHERE CategoryID = 5;

SELECT ProductName, Price FROM Products WHERE CategoryID = 5;

-- Problem 2.10.3: DANGER - do NOT run: an UPDATE without WHERE changes every row.
/* reference only - not for MySQL / not SQL:
UPDATE Customers
SET Country = 'India';   -- every customer would become Indian!
*/

-- =====================================================
-- 2.11  DELETE
-- =====================================================

-- Problem 2.11.1: Jaipur Rasoi cancelled their account. Delete the customer.
DELETE FROM Customers
WHERE CustomerName = 'Jaipur Rasoi';

SELECT COUNT(*) AS RemainingCustomers FROM Customers;

-- Problem 2.11.2: Remove the two shippers we added earlier (ShipperID above 3).
DELETE FROM Shippers
WHERE ShipperID > 3;

SELECT * FROM Shippers;

-- Problem 2.11.3: DANGER - do NOT run: delete all rows but keep the table structure.
/* reference only - not for MySQL / not SQL:
DELETE FROM Customers;
*/

-- =====================================================
-- 2.12  SELECT TOP / LIMIT / FETCH FIRST
-- =====================================================

-- Problem 2.12.1: Show the 3 most expensive products.
SELECT ProductName, Price
FROM Products
ORDER BY Price DESC
LIMIT 3;

-- Problem 2.12.2: Pagination: show page 2 of the customer list when each page holds 5 customers.
SELECT CustomerID, CustomerName
FROM Customers
ORDER BY CustomerID
LIMIT 5 OFFSET 5;

-- Problem 2.12.3: Show only the first 2 customers from the UK.
SELECT CustomerName, City
FROM Customers
WHERE Country = 'UK'
LIMIT 2;

-- Problem 2.12.4: SQL Server version of 'top 50 percent' (reference only).
/* reference only - not for MySQL / not SQL:
SELECT TOP 50 PERCENT * FROM Customers;
*/

-- =====================================================
-- 2.13  Aggregate Functions
-- =====================================================

-- Problem 2.13.1: Give a one-line price summary of the whole product catalogue.
SELECT MIN(Price)   AS Cheapest,
       MAX(Price)   AS Costliest,
       COUNT(*)     AS TotalProducts,
       SUM(Price)   AS SumOfPrices,
       AVG(Price)   AS AveragePrice
FROM Products;

-- =====================================================
-- 2.14  MIN() and MAX()
-- =====================================================

-- Problem 2.14.1: What is the lowest product price?
SELECT MIN(Price) AS SmallestPrice
FROM Products;

-- Problem 2.14.2: What is the highest product price?
SELECT MAX(Price) AS LargestPrice
FROM Products;

-- Problem 2.14.3: When was our first order and our latest order?
SELECT MIN(OrderDate) AS FirstOrder,
       MAX(OrderDate) AS LatestOrder
FROM Orders;

-- Problem 2.14.4: Find the cheapest price in each category.
SELECT CategoryID, MIN(Price) AS CheapestInCategory
FROM Products
GROUP BY CategoryID;

-- =====================================================
-- 2.15  COUNT()
-- =====================================================

-- Problem 2.15.1: How many products do we sell?
SELECT COUNT(*) AS TotalProducts
FROM Products;

-- Problem 2.15.2: How many products cost more than 200?
SELECT COUNT(ProductID) AS PremiumProducts
FROM Products
WHERE Price > 200;

-- Problem 2.15.3: Compare COUNT(*) and COUNT(PostalCode) to see how NULLs are ignored.
SELECT COUNT(*)          AS AllCustomers,
       COUNT(PostalCode) AS WithPostalCode
FROM Customers;

-- Problem 2.15.4: How many orders did each employee handle?
SELECT EmployeeID, COUNT(*) AS OrdersHandled
FROM Orders
GROUP BY EmployeeID;

-- =====================================================
-- 2.16  SUM()
-- =====================================================

-- Problem 2.16.1: What is the total quantity of all items ever ordered?
SELECT SUM(Quantity) AS TotalItemsOrdered
FROM OrderDetails;

-- Problem 2.16.2: How many units of Basmati Rice (ProductID 8) have been sold?
SELECT SUM(Quantity) AS BasmatiUnitsSold
FROM OrderDetails
WHERE ProductID = 8;

-- Problem 2.16.3: What is the total revenue of the company? (quantity x price of every line item)
SELECT SUM(od.Quantity * p.Price) AS TotalRevenue
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID;

-- =====================================================
-- 2.17  AVG()
-- =====================================================

-- Problem 2.17.1: What is the average product price?
SELECT AVG(Price) AS AveragePrice
FROM Products;

-- Problem 2.17.2: List products priced above the average price.
SELECT ProductName, Price
FROM Products
WHERE Price > (SELECT AVG(Price) FROM Products)
ORDER BY Price DESC;

-- Problem 2.17.3: What is the average quantity per order line, rounded to 2 decimals?
SELECT ROUND(AVG(Quantity), 2) AS AvgQtyPerLine
FROM OrderDetails;

-- =====================================================
-- 2.18  LIKE
-- =====================================================

-- Problem 2.18.1: Customers whose name starts with 'S'.
SELECT CustomerName FROM Customers
WHERE CustomerName LIKE 'S%';

-- Problem 2.18.2: Customers whose name ends with 'Mart'.
SELECT CustomerName FROM Customers
WHERE CustomerName LIKE '%Mart';

-- Problem 2.18.3: Customers whose name contains the word 'Spice'.
SELECT CustomerName FROM Customers
WHERE CustomerName LIKE '%Spice%';

-- Problem 2.18.4: Cities whose second letter is 'u'.
SELECT DISTINCT City FROM Customers
WHERE City LIKE '_u%';

-- Problem 2.18.5: Products that start with 'M' and end with 'i'.
SELECT ProductName FROM Products
WHERE ProductName LIKE 'M%i';

-- =====================================================
-- 2.19  Wildcards
-- =====================================================

-- Problem 2.19.1: Postal codes that are exactly 5 characters long.
SELECT CustomerName, PostalCode FROM Customers
WHERE PostalCode LIKE '_____';

-- Problem 2.19.2: Customer names whose third letter is 'r'.
SELECT CustomerName FROM Customers
WHERE CustomerName LIKE '__r%';

-- Problem 2.19.3: Customers whose name starts with B, D or L (MySQL: use REGEXP).
SELECT CustomerName FROM Customers
WHERE CustomerName REGEXP '^[BDL]';

-- Problem 2.19.4: Customers whose name starts with a letter between A and F.
SELECT CustomerName FROM Customers
WHERE CustomerName REGEXP '^[A-F]';

-- =====================================================
-- 2.20  IN
-- =====================================================

-- Problem 2.20.1: Customers located in the UK, Germany or USA.
SELECT CustomerName, Country
FROM Customers
WHERE Country IN ('UK', 'Germany', 'USA');

-- Problem 2.20.2: Customers NOT in India or the UAE.
SELECT CustomerName, Country
FROM Customers
WHERE Country NOT IN ('India', 'UAE');

-- Problem 2.20.3: Customers who have placed at least one order (IN with subquery).
SELECT CustomerName
FROM Customers
WHERE CustomerID IN (SELECT CustomerID FROM Orders);

-- Problem 2.20.4: Customers who have never ordered.
SELECT CustomerName
FROM Customers
WHERE CustomerID NOT IN (SELECT CustomerID FROM Orders);

-- =====================================================
-- 2.21  BETWEEN
-- =====================================================

-- Problem 2.21.1: Products priced between 100 and 400.
SELECT ProductName, Price
FROM Products
WHERE Price BETWEEN 100 AND 400
ORDER BY Price;

-- Problem 2.21.2: Products priced between 100 and 400 but NOT in category 1 or 2.
SELECT ProductName, CategoryID, Price
FROM Products
WHERE Price BETWEEN 100 AND 400
  AND CategoryID NOT IN (1, 2);

-- Problem 2.21.3: Orders placed in the first quarter of 2026.
SELECT OrderID, OrderDate
FROM Orders
WHERE OrderDate BETWEEN '2026-01-01' AND '2026-03-31';

-- Problem 2.21.4: Products whose names fall alphabetically between 'Banana Chips' and 'Ghee'.
SELECT ProductName
FROM Products
WHERE ProductName BETWEEN 'Banana Chips' AND 'Ghee'
ORDER BY ProductName;

-- =====================================================
-- 2.22  Aliases (AS)
-- =====================================================

-- Problem 2.22.1: Show CustomerID as ID and CustomerName as Customer.
SELECT CustomerID AS ID, CustomerName AS Customer
FROM Customers
LIMIT 5;

-- Problem 2.22.2: Use an alias that contains a space (wrap it in back-ticks or double quotes).
SELECT ProductName AS `Product Name`, Price AS `Price (INR)`
FROM Products
LIMIT 4;

-- Problem 2.22.3: Combine several columns into one 'FullAddress' column.
SELECT CustomerName,
       CONCAT(Address, ', ', City, ' - ', PostalCode, ', ', Country) AS FullAddress
FROM Customers
WHERE Country = 'India';

-- Problem 2.22.4: Use table aliases (c, o) to shorten a query: orders of customer 'Desi Mart'.
SELECT o.OrderID, o.OrderDate, c.CustomerName
FROM Customers AS c, Orders AS o
WHERE c.CustomerName = 'Desi Mart'
  AND c.CustomerID = o.CustomerID;

-- =====================================================
-- 2.23  JOINS - overview
-- =====================================================

-- Problem 2.23.1: Show each order with the customer's name (Orders.CustomerID links to Customers.CustomerID).
SELECT Orders.OrderID, Customers.CustomerName, Orders.OrderDate
FROM Orders
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID;

-- =====================================================
-- 2.24  INNER JOIN
-- =====================================================

-- Problem 2.24.1: List every product with its category name.
SELECT p.ProductName, c.CategoryName
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID;

-- Problem 2.24.2: Show orders with customer name AND shipper name (joining three tables).
SELECT o.OrderID, c.CustomerName, s.ShipperName
FROM ((Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID)
INNER JOIN Shippers  s ON o.ShipperID  = s.ShipperID);

-- Problem 2.24.3: Show every line of order 1003 with product name, quantity and line total.
SELECT od.OrderID, p.ProductName, od.Quantity, p.Price,
       od.Quantity * p.Price AS LineTotal
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
WHERE od.OrderID = 1003;

-- =====================================================
-- 2.25  LEFT JOIN
-- =====================================================

-- Problem 2.25.1: List ALL customers and their order IDs - including customers with no orders.
SELECT c.CustomerName, o.OrderID
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
ORDER BY c.CustomerName;

-- Problem 2.25.2: Find only the customers who have never placed an order.
SELECT c.CustomerName, c.City
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;

-- =====================================================
-- 2.26  RIGHT JOIN
-- =====================================================

-- Problem 2.26.1: List ALL employees and the orders they handled - including employees with no orders.
SELECT o.OrderID, e.FirstName, e.LastName
FROM Orders o
RIGHT JOIN Employees e ON o.EmployeeID = e.EmployeeID
ORDER BY e.EmployeeID, o.OrderID;

-- Problem 2.26.2: List every supplier and its products, keeping suppliers without products.
SELECT s.SupplierName, p.ProductName
FROM Products p
RIGHT JOIN Suppliers s ON p.SupplierID = s.SupplierID
ORDER BY s.SupplierName;

-- =====================================================
-- 2.27  FULL OUTER JOIN
-- =====================================================

-- Problem 2.27.1: Show all products and all suppliers: products without a supplier AND suppliers without products must both appear.
SELECT p.ProductName, s.SupplierName
FROM Products p
LEFT JOIN Suppliers s ON p.SupplierID = s.SupplierID
UNION
SELECT p.ProductName, s.SupplierName
FROM Products p
RIGHT JOIN Suppliers s ON p.SupplierID = s.SupplierID;

-- =====================================================
-- 2.28  SELF JOIN
-- =====================================================

-- Problem 2.28.1: Show each employee with the name of their manager.
SELECT CONCAT(e.FirstName, ' ', e.LastName) AS Employee,
       CONCAT(m.FirstName, ' ', m.LastName) AS Manager
FROM Employees e
LEFT JOIN Employees m ON e.ManagerID = m.EmployeeID;

-- Problem 2.28.2: Find pairs of customers located in the same city.
SELECT A.CustomerName AS Customer1, B.CustomerName AS Customer2, A.City
FROM Customers A, Customers B
WHERE A.CustomerID < B.CustomerID
  AND A.City = B.City;

-- =====================================================
-- 2.29  UNION
-- =====================================================

-- Problem 2.29.1: List every distinct city where we have a customer or a supplier.
SELECT City FROM Customers
UNION
SELECT City FROM Suppliers
ORDER BY City;

-- Problem 2.29.2: Indian cities only, from both tables.
SELECT City, Country FROM Customers WHERE Country = 'India'
UNION
SELECT City, Country FROM Suppliers WHERE Country = 'India'
ORDER BY City;

-- Problem 2.29.3: Build a contact list of customers and suppliers, labelled with their type.
SELECT 'Customer' AS Type, ContactName, City, Country FROM Customers WHERE Country = 'UK'
UNION
SELECT 'Supplier', ContactName, City, Country FROM Suppliers WHERE Country = 'UK';

-- =====================================================
-- 2.30  UNION ALL
-- =====================================================

-- Problem 2.30.1: List the countries of all customers and suppliers, keeping duplicates.
SELECT Country FROM Customers
UNION ALL
SELECT Country FROM Suppliers
ORDER BY Country;

-- =====================================================
-- 2.31  GROUP BY
-- =====================================================

-- Problem 2.31.1: How many customers are there in each country? Show the biggest country first.
SELECT Country, COUNT(CustomerID) AS Customers
FROM Customers
GROUP BY Country
ORDER BY COUNT(CustomerID) DESC;

-- Problem 2.31.2: How many orders did each shipper deliver?
SELECT s.ShipperName, COUNT(o.OrderID) AS NumberOfOrders
FROM Orders o
LEFT JOIN Shippers s ON o.ShipperID = s.ShipperID
GROUP BY s.ShipperName;

-- Problem 2.31.3: What is the revenue for each category?
SELECT c.CategoryName, SUM(od.Quantity * p.Price) AS Revenue
FROM OrderDetails od
JOIN Products   p ON od.ProductID = p.ProductID
JOIN Categories c ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryName
ORDER BY Revenue DESC;

-- =====================================================
-- 2.32  HAVING
-- =====================================================

-- Problem 2.32.1: Which countries have more than 2 customers?
SELECT Country, COUNT(CustomerID) AS Customers
FROM Customers
GROUP BY Country
HAVING COUNT(CustomerID) > 2;

-- Problem 2.32.2: Which employees handled more than 3 orders?
SELECT e.FirstName, e.LastName, COUNT(o.OrderID) AS NumberOfOrders
FROM Orders o
INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
GROUP BY e.EmployeeID, e.FirstName, e.LastName
HAVING COUNT(o.OrderID) > 3;

-- Problem 2.32.3: Which categories earned more than 20,000 in revenue?
SELECT c.CategoryName, SUM(od.Quantity * p.Price) AS Revenue
FROM OrderDetails od
JOIN Products   p ON od.ProductID = p.ProductID
JOIN Categories c ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryName
HAVING Revenue > 20000;

-- =====================================================
-- 2.33  EXISTS
-- =====================================================

-- Problem 2.33.1: List suppliers that supply at least one product cheaper than 100.
SELECT SupplierName
FROM Suppliers s
WHERE EXISTS (SELECT ProductName FROM Products p
              WHERE p.SupplierID = s.SupplierID AND p.Price < 100);

-- Problem 2.33.2: List suppliers that have NO products at all.
SELECT SupplierName
FROM Suppliers s
WHERE NOT EXISTS (SELECT 1 FROM Products p WHERE p.SupplierID = s.SupplierID);

-- =====================================================
-- 2.34  ANY
-- =====================================================

-- Problem 2.34.1: Which products were ordered in a quantity of exactly 10 in any order line?
SELECT ProductName
FROM Products
WHERE ProductID = ANY (SELECT ProductID FROM OrderDetails WHERE Quantity = 10);

-- Problem 2.34.2: Which products were ordered in quantities greater than 40 at least once?
SELECT ProductName
FROM Products
WHERE ProductID = ANY (SELECT ProductID FROM OrderDetails WHERE Quantity > 40);

-- =====================================================
-- 2.35  ALL
-- =====================================================

-- Problem 2.35.1: Which products are more expensive than ALL snacks (CategoryID 2)?
SELECT ProductName, Price
FROM Products
WHERE Price > ALL (SELECT Price FROM Products WHERE CategoryID = 2)
ORDER BY Price;

-- Problem 2.35.2: Find the most expensive product using >= ALL.
SELECT ProductName, Price
FROM Products
WHERE Price >= ALL (SELECT Price FROM Products);

-- Problem 2.35.3: ALL can also be used with SELECT: select all rows including duplicates (the default).
SELECT ALL Country FROM Suppliers;

-- =====================================================
-- 2.36  SELECT INTO
-- =====================================================

-- Problem 2.36.1: Create a full backup copy of the Customers table.
CREATE TABLE CustomersBackup AS
SELECT * FROM Customers;

SELECT COUNT(*) AS RowsCopied FROM CustomersBackup;

-- Problem 2.36.2: Copy only Indian customers (and only a few columns) into a new table.
CREATE TABLE IndiaCustomers AS
SELECT CustomerName, ContactName, City
FROM Customers
WHERE Country = 'India';

SELECT * FROM IndiaCustomers;

-- Problem 2.36.3: Create an EMPTY table with the same structure as Products (copy no rows).
CREATE TABLE ProductsTemplate AS
SELECT * FROM Products WHERE 1 = 0;

SELECT COUNT(*) AS RowsInTemplate FROM ProductsTemplate;

-- Problem 2.36.4: MySQL variable: store the highest price into @maxPrice and use it.
SELECT MAX(Price) INTO @maxPrice FROM Products;

SELECT ProductName, Price FROM Products WHERE Price = @maxPrice;

-- =====================================================
-- 2.37  INSERT INTO SELECT
-- =====================================================

-- Problem 2.37.1: Create a single contact directory table and fill it with both customers and suppliers.
CREATE TABLE AllContacts (
    Name     VARCHAR(100),
    City     VARCHAR(50),
    Country  VARCHAR(50),
    Type     VARCHAR(10)
);

INSERT INTO AllContacts (Name, City, Country, Type)
SELECT CustomerName, City, Country, 'Customer' FROM Customers;

INSERT INTO AllContacts (Name, City, Country, Type)
SELECT SupplierName, City, Country, 'Supplier' FROM Suppliers;

SELECT Type, COUNT(*) AS Total FROM AllContacts GROUP BY Type;

-- Problem 2.37.2: Copy only German suppliers into the IndiaCustomers-style table 'ForeignPartners'.
CREATE TABLE ForeignPartners (Name VARCHAR(100), City VARCHAR(50));

INSERT INTO ForeignPartners (Name, City)
SELECT SupplierName, City FROM Suppliers WHERE Country = 'Germany';

SELECT * FROM ForeignPartners;

-- =====================================================
-- 2.38  CASE
-- =====================================================

-- Problem 2.38.1: Label every product as Budget, Mid-range or Premium based on its price.
SELECT ProductName, Price,
    CASE
        WHEN Price < 100  THEN 'Budget'
        WHEN Price <= 400 THEN 'Mid-range'
        ELSE 'Premium'
    END AS PriceBand
FROM Products
ORDER BY Price;

-- Problem 2.38.2: Describe each order line's quantity in words.
SELECT OrderID, Quantity,
    CASE
        WHEN Quantity > 30 THEN 'Bulk order'
        WHEN Quantity = 30 THEN 'Exactly 30'
        ELSE 'Regular order'
    END AS QuantityText
FROM OrderDetails
WHERE OrderID IN (1001, 1003, 1010);

-- Problem 2.38.3: Sort customers by City, but if City is NULL sort by Country instead (CASE in ORDER BY).
SELECT CustomerName, City, Country
FROM Customers
ORDER BY
    (CASE WHEN City IS NULL THEN Country ELSE City END)
LIMIT 6;

-- =====================================================
-- 2.39  NULL Functions - IFNULL(), COALESCE(), NULLIF()
-- =====================================================

-- Problem 2.39.1: Show postal codes, but print 'N/A' where the postal code is missing.
SELECT CustomerName, IFNULL(PostalCode, 'N/A') AS PostalCode
FROM Customers
WHERE Country IN ('UAE', 'Germany');

-- Problem 2.39.2: Show a 'best available' contact: ContactName, else City, else 'Unknown'.
SELECT CustomerName,
       COALESCE(ContactName, City, 'Unknown') AS ReachVia
FROM Customers
WHERE CustomerName IN ('Pune Pantry', 'Desi Mart');

-- Problem 2.39.3: Show products whose SupplierID is NULL as 'No supplier' using COALESCE with a join.
SELECT p.ProductName, COALESCE(s.SupplierName, 'No supplier') AS Supplier
FROM Products p
LEFT JOIN Suppliers s ON p.SupplierID = s.SupplierID
WHERE p.CategoryID = 6;

-- Problem 2.39.4: Use NULLIF to avoid 'division by zero' (returns NULL instead of an error).
SELECT 100 / NULLIF(0, 0) AS SafeDivision,
       100 / NULLIF(4, 0) AS NormalDivision;

-- =====================================================
-- 2.40  Stored Procedures
-- =====================================================

-- Problem 2.40.1: Create a procedure that returns all customers and call it.
DELIMITER //
CREATE PROCEDURE SelectAllCustomers()
BEGIN
    SELECT CustomerID, CustomerName, Country FROM Customers;
END //
DELIMITER ;

CALL SelectAllCustomers();

-- Problem 2.40.2: Create a procedure with one parameter: customers of a given country.
DELIMITER //
CREATE PROCEDURE GetCustomersByCountry(IN p_country VARCHAR(50))
BEGIN
    SELECT CustomerName, City FROM Customers WHERE Country = p_country;
END //
DELIMITER ;

CALL GetCustomersByCountry('Germany');

-- Problem 2.40.3: Create a procedure with two parameters: customers of a country AND city.
DELIMITER //
CREATE PROCEDURE GetCustomersByCity(IN p_country VARCHAR(50), IN p_city VARCHAR(50))
BEGIN
    SELECT CustomerName, ContactName FROM Customers
    WHERE Country = p_country AND City = p_city;
END //
DELIMITER ;

CALL GetCustomersByCity('India', 'Ahmedabad');

-- Problem 2.40.4: Create a procedure with an OUT parameter that returns the number of products in a category.
DELIMITER //
CREATE PROCEDURE CountProducts(IN p_cat INT, OUT p_total INT)
BEGIN
    SELECT COUNT(*) INTO p_total FROM Products WHERE CategoryID = p_cat;
END //
DELIMITER ;

CALL CountProducts(1, @total);
SELECT @total AS BeverageProducts;

-- Problem 2.40.5: SQL Server version of the same idea (reference only).
/* reference only - not for MySQL / not SQL:
CREATE PROCEDURE SelectAllCustomers @City nvarchar(30)
AS
SELECT * FROM Customers WHERE City = @City
GO;

EXEC SelectAllCustomers @City = 'London';
*/

-- =====================================================
-- 2.41  Comments
-- =====================================================

-- Problem 2.41.1: Use a single-line comment to explain a query.
-- Select all Indian customers
SELECT CustomerName FROM Customers WHERE Country = 'India'; -- end-of-line comment works too

-- Problem 2.41.2: Use a multi-line comment and a comment in the middle of a statement.
/* This query lists products
   from the Spices category */
SELECT ProductName, /* Unit, */ Price
FROM Products
WHERE CategoryID = 5;

-- Problem 2.41.3: Temporarily disable a condition with a comment while debugging.
SELECT CustomerName, Country FROM Customers
WHERE Country = 'UK'
# AND City = 'London'
;

-- =====================================================
-- 2.42  Operators
-- =====================================================

-- Problem 2.42.1: Try the arithmetic operators.
SELECT 30 + 20 AS AddOp, 30 - 20 AS SubOp, 30 * 20 AS MulOp,
       30 / 20 AS DivOp, 17 % 5 AS ModOp, 17 DIV 5 AS IntDiv;

-- Problem 2.42.2: Show the price of each spice product with 18% GST added (arithmetic on columns).
SELECT ProductName, Price, ROUND(Price * 1.18, 2) AS PriceWithGST
FROM Products
WHERE CategoryID = 5;

-- Problem 2.42.3: Try bitwise operators.
SELECT 5 & 1 AS BitAnd, 5 | 2 AS BitOr, 5 ^ 1 AS BitXor;

-- Problem 2.42.4: SOME is a synonym of ANY: products ordered in quantity 50 or more.
SELECT ProductName FROM Products
WHERE ProductID = SOME (SELECT ProductID FROM OrderDetails WHERE Quantity >= 50);

-- =====================================================
-- 3.1  CREATE DATABASE
-- =====================================================

-- Problem 3.1.1: Create a practice database named TestDB and check that it exists.
CREATE DATABASE TestDB;

SHOW DATABASES LIKE 'TestDB';

-- Problem 3.1.2: Create a database only if it does not already exist (no error on re-run).
CREATE DATABASE IF NOT EXISTS TestDB;

SHOW DATABASES LIKE 'TestDB';

-- =====================================================
-- 3.2  DROP DATABASE
-- =====================================================

-- Problem 3.2.1: Delete the TestDB practice database.
DROP DATABASE TestDB;

SHOW DATABASES LIKE 'TestDB';

-- Problem 3.2.2: Drop a database only if it exists.
DROP DATABASE IF EXISTS TestDB;

-- =====================================================
-- 3.3  BACKUP DATABASE
-- =====================================================

-- Problem 3.3.1: MySQL: back up the whole ShopDB database to a file (terminal command).
/* reference only - not for MySQL / not SQL:
mysqldump -u root -p ShopDB > ShopDB_backup.sql
*/

-- Problem 3.3.2: MySQL: restore the backup into a database (terminal command).
/* reference only - not for MySQL / not SQL:
mysql -u root -p ShopDB < ShopDB_backup.sql
*/

-- Problem 3.3.3: SQL Server: full backup and differential backup (reference only).
/* reference only - not for MySQL / not SQL:
BACKUP DATABASE ShopDB
TO DISK = 'D:\backups\ShopDB.bak';

BACKUP DATABASE ShopDB
TO DISK = 'D:\backups\ShopDB.bak'
WITH DIFFERENTIAL;
*/

-- =====================================================
-- 3.4  CREATE TABLE
-- =====================================================

-- Problem 3.4.1: Create a table 'Persons' with ID, last name, first name, address and city. Then look at its structure.
CREATE TABLE Persons (
    PersonID   INT,
    LastName   VARCHAR(255),
    FirstName  VARCHAR(255),
    Address    VARCHAR(255),
    City       VARCHAR(255)
);

DESCRIBE Persons;

-- Problem 3.4.2: Insert two people into Persons and read them back.
INSERT INTO Persons VALUES (1, 'Shah', 'Aarav', '11 Law Garden', 'Ahmedabad'),
                           (2, 'Rao',  'Meera', '4 Jubilee Hills', 'Hyderabad');

SELECT * FROM Persons;

-- Problem 3.4.3: Create a new table from an existing table (structure + data).
CREATE TABLE UKCustomers AS
SELECT CustomerName, ContactName, City
FROM Customers
WHERE Country = 'UK';

SELECT * FROM UKCustomers;

-- =====================================================
-- 3.5  DROP TABLE and TRUNCATE TABLE
-- =====================================================

-- Problem 3.5.1: Empty the UKCustomers table but keep its structure.
TRUNCATE TABLE UKCustomers;

SELECT COUNT(*) AS RowsLeft FROM UKCustomers;

-- Problem 3.5.2: Now delete the UKCustomers table completely.
DROP TABLE UKCustomers;

SHOW TABLES LIKE 'UKCustomers';

-- Problem 3.5.3: Drop a table only if it exists (safe in scripts).
DROP TABLE IF EXISTS ProductsTemplate;

-- =====================================================
-- 3.6  ALTER TABLE
-- =====================================================

-- Problem 3.6.1: Add an Email column to Persons.
ALTER TABLE Persons
ADD Email VARCHAR(255);

DESCRIBE Persons;

-- Problem 3.6.2: Add a DateOfBirth column, then change its type from DATE to YEAR.
ALTER TABLE Persons ADD DateOfBirth DATE;

ALTER TABLE Persons
MODIFY COLUMN DateOfBirth YEAR;

DESCRIBE Persons;

-- Problem 3.6.3: Rename the column DateOfBirth to BirthYear.
ALTER TABLE Persons
RENAME COLUMN DateOfBirth TO BirthYear;

SELECT * FROM Persons;

-- Problem 3.6.4: Delete the BirthYear column.
ALTER TABLE Persons
DROP COLUMN BirthYear;

DESCRIBE Persons;

-- Problem 3.6.5: Rename the whole table from Persons to People and back again.
ALTER TABLE Persons RENAME TO People;
SHOW TABLES LIKE 'People';

ALTER TABLE People RENAME TO Persons;

-- =====================================================
-- 3.7  Constraints - overview
-- =====================================================

-- Problem 3.7.1: Create a 'Members' table that uses every kind of constraint at once.
CREATE TABLE Members (
    MemberID   INT          NOT NULL AUTO_INCREMENT,
    FullName   VARCHAR(100) NOT NULL,
    Email      VARCHAR(100) UNIQUE,
    Age        INT          CHECK (Age >= 18),
    City       VARCHAR(50)  DEFAULT 'Ahmedabad',
    JoinedOn   DATE         DEFAULT (CURRENT_DATE),
    ReferredBy INT,
    PRIMARY KEY (MemberID),
    FOREIGN KEY (ReferredBy) REFERENCES Members(MemberID)
);

DESCRIBE Members;

-- =====================================================
-- 3.8  NOT NULL
-- =====================================================

-- Problem 3.8.1: Insert a valid member (FullName given).
INSERT INTO Members (FullName, Email, Age)
VALUES ('Aarav Shah', 'aarav@example.com', 25);

SELECT MemberID, FullName, Email, Age FROM Members;

-- Problem 3.8.2: Try to insert a member without a name - the database rejects it.
INSERT INTO Members (FullName, Email, Age)
VALUES (NULL, 'noname@example.com', 30);

-- Problem 3.8.3: Make the Address column of Persons mandatory after the table exists.
UPDATE Persons SET Address = 'Unknown' WHERE Address IS NULL;
ALTER TABLE Persons MODIFY Address VARCHAR(255) NOT NULL;

DESCRIBE Persons;

-- =====================================================
-- 3.9  UNIQUE
-- =====================================================

-- Problem 3.9.1: Try to insert a second member with the same email - rejected.
INSERT INTO Members (FullName, Email, Age)
VALUES ('Another Aarav', 'aarav@example.com', 40);

-- Problem 3.9.2: Add a named UNIQUE constraint on Persons (PersonID + LastName combination).
ALTER TABLE Persons
ADD CONSTRAINT UC_Person UNIQUE (PersonID, LastName);

SELECT INDEX_NAME, COLUMN_NAME, NON_UNIQUE
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA = 'ShopDB' AND TABLE_NAME = 'Persons';

-- Problem 3.9.3: Remove that UNIQUE constraint again.
ALTER TABLE Persons
DROP INDEX UC_Person;

SELECT INDEX_NAME, COLUMN_NAME, NON_UNIQUE
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA = 'ShopDB' AND TABLE_NAME = 'Persons';

-- =====================================================
-- 3.10  PRIMARY KEY
-- =====================================================

-- Problem 3.10.1: Add a primary key to Persons.PersonID after the table was created.
ALTER TABLE Persons
ADD PRIMARY KEY (PersonID);

DESCRIBE Persons;

-- Problem 3.10.2: Try to insert a duplicate PersonID - rejected by the primary key.
INSERT INTO Persons (PersonID, LastName, FirstName, Address, City)
VALUES (1, 'Kapoor', 'Riya', '8 Ring Road', 'Surat');

-- Problem 3.10.3: Create a table with a composite (two-column) primary key: one enrolment per student per course.
CREATE TABLE Enrolments (
    StudentID INT,
    CourseID  INT,
    Grade     CHAR(2),
    CONSTRAINT PK_Enrolment PRIMARY KEY (StudentID, CourseID)
);

INSERT INTO Enrolments VALUES (1, 101, 'A'), (1, 102, 'B'), (2, 101, 'A');
SELECT * FROM Enrolments;

-- Problem 3.10.4: Drop the primary key of Enrolments.
ALTER TABLE Enrolments DROP PRIMARY KEY;

SELECT INDEX_NAME, COLUMN_NAME, NON_UNIQUE
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA = 'ShopDB' AND TABLE_NAME = 'Enrolments';

-- =====================================================
-- 3.11  FOREIGN KEY
-- =====================================================

-- Problem 3.11.1: See the foreign keys already defined on the Orders table.
SELECT CONSTRAINT_NAME, COLUMN_NAME, REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'ShopDB' AND TABLE_NAME = 'Orders'
  AND REFERENCED_TABLE_NAME IS NOT NULL;

-- Problem 3.11.2: Try to create an order for customer 999 who does not exist - the foreign key blocks it.
INSERT INTO Orders (CustomerID, EmployeeID, OrderDate, ShipperID)
VALUES (999, 1, '2026-07-01', 1);

-- Problem 3.11.3: Add a named foreign key: Enrolments.StudentID must exist in a new Students table.
CREATE TABLE Students (StudentID INT PRIMARY KEY, Name VARCHAR(50));
INSERT INTO Students VALUES (1, 'Aarav'), (2, 'Meera');

ALTER TABLE Enrolments
ADD CONSTRAINT FK_StudentEnrol
FOREIGN KEY (StudentID) REFERENCES Students(StudentID);

SELECT e.StudentID, s.Name, e.CourseID, e.Grade
FROM Enrolments e JOIN Students s ON e.StudentID = s.StudentID;

-- Problem 3.11.4: Drop that foreign key.
ALTER TABLE Enrolments
DROP FOREIGN KEY FK_StudentEnrol;

-- =====================================================
-- 3.12  CHECK
-- =====================================================

-- Problem 3.12.1: Try to add a 16-year-old member - the CHECK (Age >= 18) rule rejects it.
INSERT INTO Members (FullName, Email, Age)
VALUES ('Young Kid', 'kid@example.com', 16);

-- Problem 3.12.2: Add a named CHECK constraint: every product price must be above zero.
ALTER TABLE Products
ADD CONSTRAINT CHK_Price CHECK (Price > 0);

UPDATE Products SET Price = -5 WHERE ProductID = 1;

-- Problem 3.12.3: Drop the CHK_Price constraint.
ALTER TABLE Products
DROP CONSTRAINT CHK_Price;

-- =====================================================
-- 3.13  DEFAULT
-- =====================================================

-- Problem 3.13.1: Insert a member without City and JoinedOn - the defaults are applied.
INSERT INTO Members (FullName, Email, Age)
VALUES ('Meera Rao', 'meera@example.com', 29);

SELECT FullName, City, JoinedOn FROM Members WHERE FullName = 'Meera Rao';

-- Problem 3.13.2: Give Persons.City a default value of 'Ahmedabad', then insert without a city.
ALTER TABLE Persons
ALTER City SET DEFAULT 'Ahmedabad';

INSERT INTO Persons (PersonID, LastName, FirstName, Address)
VALUES (3, 'Patel', 'Dev', '22 SG Highway');

SELECT * FROM Persons;

-- Problem 3.13.3: Remove the default from Persons.City.
ALTER TABLE Persons
ALTER City DROP DEFAULT;

-- =====================================================
-- 3.14  CREATE INDEX
-- =====================================================

-- Problem 3.14.1: Create an index on Customers.City because we often filter by city.
CREATE INDEX idx_customer_city
ON Customers (City);

SELECT INDEX_NAME, COLUMN_NAME, NON_UNIQUE
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA = 'ShopDB' AND TABLE_NAME = 'Customers'
  AND INDEX_NAME = 'idx_customer_city';

-- Problem 3.14.2: Create a composite index on Employees (LastName, FirstName).
CREATE INDEX idx_emp_name
ON Employees (LastName, FirstName);

SELECT INDEX_NAME, COLUMN_NAME, NON_UNIQUE
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA = 'ShopDB' AND TABLE_NAME = 'Employees'
  AND INDEX_NAME = 'idx_emp_name';

-- Problem 3.14.3: Create a UNIQUE index so no two shippers can have the same phone number.
CREATE UNIQUE INDEX idx_shipper_phone
ON Shippers (Phone);

SELECT INDEX_NAME, COLUMN_NAME, NON_UNIQUE
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA = 'ShopDB' AND TABLE_NAME = 'Shippers'
  AND INDEX_NAME = 'idx_shipper_phone';

-- Problem 3.14.4: Use EXPLAIN to see which index a query uses.
EXPLAIN SELECT * FROM Customers WHERE City = 'Ahmedabad';

-- Problem 3.14.5: Drop the index on Employees.
ALTER TABLE Employees
DROP INDEX idx_emp_name;

-- =====================================================
-- 3.15  AUTO_INCREMENT
-- =====================================================

-- Problem 3.15.1: Create a Tickets table whose IDs start at 100, insert two rows without giving an ID.
CREATE TABLE Tickets (
    TicketID  INT NOT NULL AUTO_INCREMENT,
    Subject   VARCHAR(100),
    PRIMARY KEY (TicketID)
);
ALTER TABLE Tickets AUTO_INCREMENT = 100;

INSERT INTO Tickets (Subject) VALUES ('Late delivery'), ('Wrong item received');

SELECT * FROM Tickets;

-- Problem 3.15.2: Find out which ID was generated by the last insert.
INSERT INTO Tickets (Subject) VALUES ('Refund request');
SELECT LAST_INSERT_ID() AS NewTicketID;

-- =====================================================
-- 3.16  Dates
-- =====================================================

-- Problem 3.16.1: Find orders placed on 14 February 2026.
SELECT * FROM Orders
WHERE OrderDate = '2026-02-14';

-- Problem 3.16.2: Find all orders placed in March 2026 using YEAR() and MONTH().
SELECT OrderID, OrderDate
FROM Orders
WHERE YEAR(OrderDate) = 2026 AND MONTH(OrderDate) = 3;

-- Problem 3.16.3: How many orders were placed in each month?
SELECT DATE_FORMAT(OrderDate, '%Y-%m') AS Month, COUNT(*) AS Orders
FROM Orders
GROUP BY DATE_FORMAT(OrderDate, '%Y-%m')
ORDER BY Month;

-- Problem 3.16.4: How old was each employee on 1 January 2026?
SELECT FirstName, BirthDate,
       TIMESTAMPDIFF(YEAR, BirthDate, '2026-01-01') AS AgeOn2026
FROM Employees;

-- Problem 3.16.5: Show how many days passed between each order and 30 June 2026.
SELECT OrderID, OrderDate,
       DATEDIFF('2026-06-30', OrderDate) AS DaysAgo
FROM Orders
WHERE OrderID > 1011;

-- =====================================================
-- 3.17  VIEWS
-- =====================================================

-- Problem 3.17.1: Create a view listing Indian customers and query it like a table.
CREATE VIEW vw_IndianCustomers AS
SELECT CustomerName, ContactName, City
FROM Customers
WHERE Country = 'India';

SELECT * FROM vw_IndianCustomers;

-- Problem 3.17.2: Create a view of products priced above the average price.
CREATE VIEW vw_AboveAvgProducts AS
SELECT ProductName, Price
FROM Products
WHERE Price > (SELECT AVG(Price) FROM Products);

SELECT * FROM vw_AboveAvgProducts ORDER BY Price DESC;

-- Problem 3.17.3: Create a reporting view that hides a 4-table join: order totals per order.
CREATE VIEW vw_OrderTotals AS
SELECT o.OrderID, o.OrderDate, c.CustomerName, c.Country,
       SUM(od.Quantity * p.Price) AS OrderTotal
FROM Orders o
JOIN Customers    c  ON o.CustomerID = c.CustomerID
JOIN OrderDetails od ON o.OrderID    = od.OrderID
JOIN Products     p  ON od.ProductID = p.ProductID
GROUP BY o.OrderID, o.OrderDate, c.CustomerName, c.Country;

SELECT * FROM vw_OrderTotals ORDER BY OrderTotal DESC LIMIT 5;

-- Problem 3.17.4: Update the Indian customers view to also show PostalCode (CREATE OR REPLACE).
CREATE OR REPLACE VIEW vw_IndianCustomers AS
SELECT CustomerName, City, PostalCode
FROM Customers
WHERE Country = 'India';

SELECT * FROM vw_IndianCustomers LIMIT 3;

-- Problem 3.17.5: Drop the above-average view.
DROP VIEW vw_AboveAvgProducts;

-- =====================================================
-- 3.18  SQL Injection
-- =====================================================

-- Problem 3.18.1: Normal input '5' builds a harmless query.
SELECT CustomerID, CustomerName FROM Customers WHERE CustomerID = 5;

-- Problem 3.18.2: Attacker types  105 OR 1=1  -> the condition is ALWAYS true, so every customer leaks.
SELECT CustomerID, CustomerName FROM Customers WHERE CustomerID = 105 OR 1=1;

-- Problem 3.18.3: Login bypass: attacker enters  " or ""="  as both username and password.
/* reference only - not for MySQL / not SQL:
SELECT * FROM Users WHERE Name = "" or ""="" AND Pass = "" or ""="";
*/

-- Problem 3.18.4: Batched statements: input  105; DROP TABLE Suppliers  would run TWO statements.
/* reference only - not for MySQL / not SQL:
SELECT * FROM Users WHERE UserId = 105; DROP TABLE Suppliers;
*/

-- =====================================================
-- 3.19  SQL Parameters and Prepared Statements
-- =====================================================

-- Problem 3.19.1: Prepare a customer lookup with a ? placeholder and run it for customer 5.
PREPARE findCustomer FROM
  'SELECT CustomerID, CustomerName, City FROM Customers WHERE CustomerID = ?';

SET @id = 5;
EXECUTE findCustomer USING @id;

DEALLOCATE PREPARE findCustomer;

-- Problem 3.19.2: Pass the attack string '105 OR 1=1' as a parameter - it is treated as a plain value, so nothing leaks.
PREPARE findCustomer FROM
  'SELECT CustomerID, CustomerName FROM Customers WHERE CustomerName = ?';

SET @input = '105 OR 1=1';
EXECUTE findCustomer USING @input;

DEALLOCATE PREPARE findCustomer;

-- Problem 3.19.3: Prepared statement with two parameters: products in a category under a price.
PREPARE cheapInCat FROM
  'SELECT ProductName, Price FROM Products WHERE CategoryID = ? AND Price < ?';

SET @cat = 1, @maxPrice = 300;
EXECUTE cheapInCat USING @cat, @maxPrice;

DEALLOCATE PREPARE cheapInCat;

-- Problem 3.19.4: The same safe query from a Java (JDBC) application.
/* reference only - not for MySQL / not SQL:
String sql = "SELECT CustomerName, City FROM Customers WHERE CustomerID = ?";
try (PreparedStatement ps = conn.prepareStatement(sql)) {
    ps.setInt(1, Integer.parseInt(userInput));
    ResultSet rs = ps.executeQuery();
    while (rs.next()) {
        System.out.println(rs.getString("CustomerName"));
    }
}
*/

-- =====================================================
-- 4.1  String Functions
-- =====================================================

-- Problem 4.1.1: CONCAT / CONCAT_WS: build a display label and a comma-separated line.
SELECT CONCAT(FirstName, ' ', LastName)            AS FullName,
       CONCAT_WS(' | ', FirstName, LastName, Notes) AS Profile
FROM Employees
LIMIT 3;

-- Problem 4.1.2: UPPER / LOWER (also UCASE / LCASE): normalise text case.
SELECT UPPER(CustomerName) AS Upper_Name, LOWER(City) AS lower_city,
       UCASE(Country) AS UCase_Country
FROM Customers
LIMIT 3;

-- Problem 4.1.3: LENGTH / CHAR_LENGTH: how long is each product name?
SELECT ProductName, LENGTH(ProductName) AS Bytes, CHAR_LENGTH(ProductName) AS Chars
FROM Products
ORDER BY Chars DESC
LIMIT 4;

-- Problem 4.1.4: SUBSTRING / LEFT / RIGHT / MID: create short codes from names.
SELECT CustomerName,
       LEFT(CustomerName, 3)          AS First3,
       RIGHT(CustomerName, 4)         AS Last4,
       SUBSTRING(CustomerName, 1, 5)  AS Sub1to5,
       MID(CustomerName, 3, 4)        AS Mid3_4
FROM Customers
LIMIT 4;

-- Problem 4.1.5: REPLACE / REVERSE / REPEAT: transform text.
SELECT ProductName,
       REPLACE(ProductName, ' ', '_') AS Slug,
       REVERSE(ProductName)           AS Reversed,
       REPEAT('*', 3)                 AS Stars
FROM Products
LIMIT 3;

-- Problem 4.1.6: TRIM / LTRIM / RTRIM: remove unwanted spaces.
SELECT CONCAT('[', TRIM('   Masala   '), ']')  AS Trimmed,
       CONCAT('[', LTRIM('   Masala   '), ']') AS LeftTrimmed,
       CONCAT('[', RTRIM('   Masala   '), ']') AS RightTrimmed;

-- Problem 4.1.7: LPAD / RPAD: format order IDs and pad names to fixed width.
SELECT LPAD(OrderID, 8, '0')      AS PaddedID,
       RPAD(ShipperID, 4, '-')    AS RightPad
FROM Orders
LIMIT 3;

-- Problem 4.1.8: INSTR / LOCATE / POSITION: where does a word appear inside a name?
SELECT CustomerName,
       INSTR(CustomerName, 'a')              AS Instr_a,
       LOCATE('Mart', CustomerName)          AS Locate_Mart,
       POSITION('Store' IN CustomerName)     AS Pos_Store
FROM Customers
WHERE CustomerID IN (1, 2, 5);

-- Problem 4.1.9: SUBSTRING_INDEX: split a text by a delimiter (first name / last name from ContactName).
SELECT ContactName,
       SUBSTRING_INDEX(ContactName, ' ', 1)  AS FirstName,
       SUBSTRING_INDEX(ContactName, ' ', -1) AS LastName
FROM Customers
LIMIT 4;

-- Problem 4.1.10: FORMAT / FIELD / FIND_IN_SET / STRCMP / ASCII / SPACE.
SELECT FORMAT(1234567.891, 2)                  AS Formatted,
       FIELD('UK', 'India', 'UK', 'USA')          AS FieldPos,
       FIND_IN_SET('b', 'a,b,c')                AS SetPos,
       STRCMP('Apple', 'Banana')                AS Cmp,
       ASCII('A')                               AS AsciiA,
       CONCAT('A', SPACE(3), 'B')               AS Spaced;

-- =====================================================
-- 4.2  Numeric Functions
-- =====================================================

-- Problem 4.2.1: ROUND / CEIL / FLOOR / TRUNCATE: different ways to cut decimals (price with 18% GST).
SELECT ProductName, Price * 1.18 AS WithGST,
       ROUND(Price * 1.18, 1)    AS Rounded,
       CEIL(Price * 1.18)        AS Ceil,
       FLOOR(Price * 1.18)       AS Floor,
       TRUNCATE(Price * 1.18, 1) AS Truncated
FROM Products
WHERE CategoryID = 5;

-- Problem 4.2.2: ABS / SIGN / MOD / POWER / SQRT / PI.
SELECT ABS(-250)      AS AbsVal,
       SIGN(-250)     AS SignVal,
       MOD(17, 5)     AS ModVal,
       POWER(2, 10)   AS Pow,
       SQRT(144)      AS SqRoot,
       ROUND(PI(), 4) AS PiVal;

-- Problem 4.2.3: GREATEST / LEAST: compare values across columns in one row.
SELECT GREATEST(120, 450, 90) AS Biggest,
       LEAST(120, 450, 90)    AS Smallest;

-- Problem 4.2.4: How far is each product's price from the average price? (ABS + subquery)
SELECT ProductName, Price,
       ROUND(ABS(Price - (SELECT AVG(Price) FROM Products)), 2) AS DistanceFromAvg
FROM Products
ORDER BY DistanceFromAvg
LIMIT 4;

-- Problem 4.2.5: RAND: pick 2 random products (the result changes every time you run it).
SELECT ProductName FROM Products
ORDER BY RAND()
LIMIT 2;

-- =====================================================
-- 4.3  Date Functions
-- =====================================================

-- Problem 4.3.1: NOW / CURDATE / CURTIME: current date and time (your values will differ).
SELECT NOW() AS NowValue, CURDATE() AS Today, CURTIME() AS TimeNow;

-- Problem 4.3.2: DATE_FORMAT: show order dates in Indian style dd-mm-yyyy and with day names.
SELECT OrderID,
       DATE_FORMAT(OrderDate, '%d-%m-%Y')   AS IndianFormat,
       DATE_FORMAT(OrderDate, '%W, %d %M %Y') AS LongFormat
FROM Orders
LIMIT 3;

-- Problem 4.3.3: DAY / MONTH / YEAR / DAYNAME / MONTHNAME / QUARTER / WEEK.
SELECT OrderDate, DAY(OrderDate) AS D, MONTH(OrderDate) AS M, YEAR(OrderDate) AS Y,
       DAYNAME(OrderDate) AS DayName, MONTHNAME(OrderDate) AS MonthName,
       QUARTER(OrderDate) AS Q, WEEK(OrderDate) AS Wk
FROM Orders
LIMIT 4;

-- Problem 4.3.4: DATE_ADD / DATE_SUB / ADDDATE: expected delivery 7 days after order, and 1 month before.
SELECT OrderID, OrderDate,
       DATE_ADD(OrderDate, INTERVAL 7 DAY)   AS ExpectedDelivery,
       DATE_SUB(OrderDate, INTERVAL 1 MONTH) AS OneMonthBefore,
       ADDDATE(OrderDate, 30)                AS PaymentDue
FROM Orders
LIMIT 3;

-- Problem 4.3.5: LAST_DAY / DAYOFWEEK / DAYOFYEAR / EXTRACT.
SELECT OrderDate,
       LAST_DAY(OrderDate)           AS MonthEnd,
       DAYOFWEEK(OrderDate)          AS DayOfWeekNo,
       DAYOFYEAR(OrderDate)          AS DayOfYearNo,
       EXTRACT(YEAR_MONTH FROM OrderDate) AS YearMonth
FROM Orders
LIMIT 3;

-- Problem 4.3.6: STR_TO_DATE: convert Indian-style text '15-08-2026' into a real DATE.
SELECT STR_TO_DATE('15-08-2026', '%d-%m-%Y') AS IndependenceDay2026,
       DAYNAME(STR_TO_DATE('15-08-2026', '%d-%m-%Y')) AS FallsOn;

-- Problem 4.3.7: TIME functions: TIMEDIFF / ADDTIME / TIME_TO_SEC / SEC_TO_TIME / MAKEDATE.
SELECT TIMEDIFF('18:30:00', '09:15:00')    AS ShiftLength,
       ADDTIME('09:15:00', '01:30:00')    AS AfterBreak,
       TIME_TO_SEC('01:00:00')            AS SecondsInHour,
       SEC_TO_TIME(5400)                  AS Seconds5400,
       MAKEDATE(2026, 100)                AS Day100of2026;

-- =====================================================
-- 4.4  Advanced Functions
-- =====================================================

-- Problem 4.4.1: IF(): label each order line as Big or Small.
SELECT OrderID, ProductID, Quantity,
       IF(Quantity >= 25, 'Big', 'Small') AS OrderSize
FROM OrderDetails
WHERE OrderID IN (1001, 1008);

-- Problem 4.4.2: CAST / CONVERT: change data types.
SELECT CAST('2026-03-15' AS DATE)       AS TextToDate,
       CAST(399.99 AS SIGNED)          AS DecimalToInt,
       CONVERT(250, CHAR)              AS NumberToText,
       CAST(Price AS CHAR) AS PriceText
FROM Products
LIMIT 1;

-- Problem 4.4.3: COALESCE / IFNULL / NULLIF / ISNULL together.
SELECT CustomerName,
       IFNULL(PostalCode, 'none')       AS IfNullVal,
       COALESCE(PostalCode, City)       AS CoalesceVal,
       ISNULL(PostalCode)               AS IsItNull,
       NULLIF(Country, 'UAE')           AS NullIfUAE
FROM Customers
WHERE Country IN ('UAE', 'UK');

-- Problem 4.4.4: System information: current database, user and server version.
SELECT DATABASE() AS CurrentDB, CURRENT_USER() AS CurrentUser, VERSION() AS ServerVersion;

-- Problem 4.4.5: BIN / CONV: number system conversions.
SELECT BIN(10) AS Binary10, CONV('ff', 16, 10) AS HexFFtoDecimal, CONV(255, 10, 2) AS DecToBinary;

-- ===================== 5. Practice challenges =====================

-- Challenge 1: Who are our top 3 customers by total amount spent?
SELECT c.CustomerName, SUM(od.Quantity * p.Price) AS TotalSpent
FROM Customers c
JOIN Orders o        ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID    = od.OrderID
JOIN Products p      ON od.ProductID = p.ProductID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY TotalSpent DESC
LIMIT 3;

-- Challenge 2: Show the revenue for each month of 2026.
SELECT MONTHNAME(o.OrderDate) AS Month, SUM(od.Quantity * p.Price) AS Revenue
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p      ON od.ProductID = p.ProductID
WHERE YEAR(o.OrderDate) = 2026
GROUP BY MONTH(o.OrderDate), MONTHNAME(o.OrderDate)
ORDER BY MONTH(o.OrderDate);

-- Challenge 3: Which product sold the most units?
SELECT p.ProductName, SUM(od.Quantity) AS UnitsSold
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY UnitsSold DESC
LIMIT 1;

-- Challenge 4: Which products have never been ordered?
SELECT ProductName
FROM Products
WHERE ProductID NOT IN (SELECT DISTINCT ProductID FROM OrderDetails);

-- Challenge 5: Employee performance: orders handled and revenue generated by each employee (include employees with zero).
SELECT CONCAT(e.FirstName, ' ', e.LastName) AS Employee,
       COUNT(DISTINCT o.OrderID)           AS Orders,
       IFNULL(SUM(od.Quantity * p.Price), 0) AS Revenue
FROM Employees e
LEFT JOIN Orders o        ON e.EmployeeID = o.EmployeeID
LEFT JOIN OrderDetails od ON o.OrderID    = od.OrderID
LEFT JOIN Products p      ON od.ProductID = p.ProductID
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY Revenue DESC;

-- Challenge 6: Which customers bought Saffron?
SELECT DISTINCT c.CustomerName, c.Country
FROM Customers c
JOIN Orders o        ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID    = od.OrderID
JOIN Products p      ON od.ProductID = p.ProductID
WHERE p.ProductName = 'Saffron';

-- Challenge 7: What is the average order value?
SELECT ROUND(AVG(OrderTotal), 2) AS AvgOrderValue
FROM (
    SELECT od.OrderID, SUM(od.Quantity * p.Price) AS OrderTotal
    FROM OrderDetails od
    JOIN Products p ON od.ProductID = p.ProductID
    GROUP BY od.OrderID
) AS t;

-- Challenge 8: Which customers ordered more than once?
SELECT c.CustomerName, COUNT(o.OrderID) AS Orders
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName
HAVING COUNT(o.OrderID) > 1;

-- Challenge 9: What is the second highest product price?
SELECT MAX(Price) AS SecondHighestPrice
FROM Products
WHERE Price < (SELECT MAX(Price) FROM Products);

-- Challenge 10: Which orders contain more than 2 different products?
SELECT OrderID, COUNT(*) AS LineItems
FROM OrderDetails
GROUP BY OrderID
HAVING COUNT(*) > 2;

-- Challenge 11: Revenue by customer country, split into domestic (India) and international.
SELECT c.Country,
       CASE WHEN c.Country = 'India' THEN 'Domestic' ELSE 'International' END AS Market,
       SUM(od.Quantity * p.Price) AS Revenue
FROM Customers c
JOIN Orders o        ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID    = od.OrderID
JOIN Products p      ON od.ProductID = p.ProductID
GROUP BY c.Country
ORDER BY Revenue DESC;

-- Challenge 12: Which shipper carries the most international orders?
SELECT s.ShipperName, COUNT(*) AS InternationalOrders
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Shippers s  ON o.ShipperID  = s.ShipperID
WHERE c.Country <> 'India'
GROUP BY s.ShipperName
ORDER BY InternationalOrders DESC;

-- Challenge 13: For each category, show the most expensive product (correlated subquery).
SELECT c.CategoryName, p.ProductName, p.Price
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE p.Price = (SELECT MAX(p2.Price) FROM Products p2
                 WHERE p2.CategoryID = p.CategoryID)
ORDER BY p.Price DESC;

-- Challenge 14: Find suppliers whose products have generated more than 30,000 in sales.
SELECT s.SupplierName, SUM(od.Quantity * p.Price) AS Sales
FROM Suppliers s
JOIN Products p      ON s.SupplierID = p.SupplierID
JOIN OrderDetails od ON p.ProductID  = od.ProductID
GROUP BY s.SupplierID, s.SupplierName
HAVING Sales > 30000
ORDER BY Sales DESC;

-- Challenge 15: Bonus (window function, MySQL 8+): rank customers by spend within their country.
SELECT Country, CustomerName, TotalSpent,
       RANK() OVER (PARTITION BY Country ORDER BY TotalSpent DESC) AS RankInCountry
FROM (
    SELECT c.Country, c.CustomerName, SUM(od.Quantity * p.Price) AS TotalSpent
    FROM Customers c
    JOIN Orders o        ON c.CustomerID = o.CustomerID
    JOIN OrderDetails od ON o.OrderID    = od.OrderID
    JOIN Products p      ON od.ProductID = p.ProductID
    GROUP BY c.Country, c.CustomerName
) AS t
ORDER BY Country, RankInCountry;
