-- Step 1 - Create and select the database Create a fresh database called ShopDB and make it the active database.
-- DROP ... IF EXISTS lets you re-run the whole script any time to reset everything. 

DROP DATABASE IF EXISTS ShopDB;
CREATE DATABASE ShopDB;
USE ShopDB;

-- Step 2 - Categories table Product categories (Beverages, Snacks, ...).

CREATE TABLE Categories (
	CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL,
    Description VARCHAR(255)
);

INSERT INTO Categories (CategoryName, Description) VALUES
('Beverages', 'Tea, coffee and juices'),
('Snacks', 'Namkeen, chips and dry snacks'),
('Dairy', 'Milk products'),
('Grains', 'Rice, flour and cereals'),
('Spices', 'Whole and ground spices'),
('Sweets', 'Indian mithai and dessert mixes');

-- Step 3 - Suppliers table Companies that supply our products.

CREATE TABLE Suppliers (
    SupplierID    INT AUTO_INCREMENT PRIMARY KEY,
    SupplierName  VARCHAR(100) NOT NULL,
    ContactName   VARCHAR(100),
    City          VARCHAR(50),
    Country       VARCHAR(50),
    Phone         VARCHAR(20)
);
 
INSERT INTO Suppliers (SupplierName, ContactName, City, Country, Phone) VALUES
('Amul Traders',      'Mahesh Shah',    'Anand',    'India',   '+91-2692-000001'),
('Himalaya Foods',    'Deepa Rawat',    'Dehradun', 'India',   '+91-135-0000002'),
('Spice Route Ltd',   'Oliver Smith',   'London',   'UK',      '+44-20-00000003'),
('Bavaria Imports',   'Klaus Weber',    'Munich',   'Germany', '+49-89-00000004'),
('Gulf Fresh LLC',    'Ahmed Saeed',    'Dubai',    'UAE',     '+971-4-0000005'),
('Kerala Coconut Co', 'Thomas Mathew',  'Kochi',    'India',   '+91-484-0000006');

-- Step 4 - Products table
-- Each product belongs to one supplier and one category (FOREIGN KEYs). 'Gulab Jamun Mix' has no supplier (NULL).
CREATE TABLE Products (
    ProductID    INT AUTO_INCREMENT PRIMARY KEY,
    ProductName  VARCHAR(100) NOT NULL,
    SupplierID   INT NULL,
    CategoryID   INT,
    Unit         VARCHAR(50),
    Price        DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);
 
INSERT INTO Products (ProductName, SupplierID, CategoryID, Unit, Price) VALUES
('Masala Chai',       2,    1, '500 g pack',  250.00),
('Filter Coffee',     2,    1, '250 g pack',  320.00),
('Mango Juice',       5,    1, '1 L bottle',  120.00),
('Banana Chips',      2,    2, '200 g pack',   90.00),
('Bhujia Namkeen',    1,    2, '400 g pack',  110.00),
('Paneer',            1,    3, '200 g block',  95.00),
('Ghee',              1,    3, '1 L tin',     650.00),
('Basmati Rice',      5,    4, '5 kg bag',    780.00),
('Whole Wheat Atta',  1,    4, '10 kg bag',   460.00),
('Garam Masala',      3,    5, '100 g box',    85.00),
('Saffron',           3,    5, '1 g box',     399.00),
('Kaju Katli',        4,    6, '500 g box',   540.00),
('Gulab Jamun Mix',   NULL, 6, '200 g pack',   75.00);
 
-- Step 5 - Customers table
-- Our buyers across India, UK, Germany, UAE and USA. Some PostalCodes are NULL; Texas Tandoor and Kolkata Sweets never ordered.
CREATE TABLE Customers (
    CustomerID    INT AUTO_INCREMENT PRIMARY KEY,
    CustomerName  VARCHAR(100) NOT NULL,
    ContactName   VARCHAR(100),
    Address       VARCHAR(150),
    City          VARCHAR(50),
    PostalCode    VARCHAR(20),
    Country       VARCHAR(50)
);
 
INSERT INTO Customers (CustomerName, ContactName, Address, City, PostalCode, Country) VALUES
('Sharma General Store', 'Rakesh Sharma', '12 MG Road',        'Ahmedabad', '380001', 'India'),
('Patel Supermart',      'Nisha Patel',   '45 CG Road',        'Ahmedabad', '380009', 'India'),
('Mehta Kirana',         'Anil Mehta',    '7 Station Road',    'Surat',     '395003', 'India'),
('Fresh Basket',         'Priya Nair',    '21 Brigade Road',   'Bengaluru', '560025', 'India'),
('Desi Mart',            'Imran Khan',    '88 Linking Road',   'Mumbai',    '400050', 'India'),
('London Spice House',   'James Brown',   '10 Brick Lane',     'London',    'E1 6QL', 'UK'),
('Curry Corner',         'Sophie Clark',  '5 Oxford Street',   'Manchester','M1 5AN', 'UK'),
('Berlin Bazaar',        'Hans Mueller',  'Friedrichstr. 12',  'Berlin',    '10117',  'Germany'),
('Munich Deli',          'Anna Schmidt',  'Marienplatz 4',     'Munich',    '80331',  'Germany'),
('Dubai Gourmet',        'Omar Hassan',   'Sheikh Zayed Road', 'Dubai',     NULL,     'UAE'),
('Sharjah Traders',      'Fatima Ali',    'Al Wahda Street',   'Sharjah',   NULL,     'UAE'),
('New York Masala',      'David Lee',     '120 Lexington Ave', 'New York',  '10016',  'USA'),
('Texas Tandoor',        'Maria Garcia',  '800 Main St',       'Houston',   '77002',  'USA'),
('Kolkata Sweets',       'Sourav Das',    '15 Park Street',    'Kolkata',   '700016', 'India');
 
-- Step 6 - Employees table
-- Sales staff. ManagerID points back to the same table (used for SELF JOIN). Neha Joshi has not handled any order yet.
CREATE TABLE Employees (
    EmployeeID  INT AUTO_INCREMENT PRIMARY KEY,
    FirstName   VARCHAR(50) NOT NULL,
    LastName    VARCHAR(50) NOT NULL,
    BirthDate   DATE,
    Notes       VARCHAR(255),
    ManagerID   INT NULL,
    FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID)
);
 
INSERT INTO Employees (FirstName, LastName, BirthDate, Notes, ManagerID) VALUES
('Arjun',  'Mehta',  '1980-05-14', 'Sales Head',                    NULL),
('Kavya',  'Iyer',   '1988-11-02', 'Senior sales, South region',    1),
('Rohan',  'Desai',  '1992-03-21', 'Sales executive, West region',  1),
('Sara',   'Thomas', '1995-07-30', 'International accounts',        2),
('Vikram', 'Singh',  '1990-01-09', 'Sales executive, North region', 2),
('Neha',   'Joshi',  '1998-12-15', 'Trainee',                       3);
 
-- Step 7 - Shippers table
-- Courier companies that deliver orders.
CREATE TABLE Shippers (
    ShipperID    INT AUTO_INCREMENT PRIMARY KEY,
    ShipperName  VARCHAR(100) NOT NULL,
    Phone        VARCHAR(20)
);
 
INSERT INTO Shippers (ShipperName, Phone) VALUES
('BlueDart Express', '1800-000-1001'),
('Delhivery',        '1800-000-1002'),
('DHL Global',       '1800-000-1003');
 
-- Step 8 - Orders table
-- One row per order. Links a customer, the employee who handled it and the shipper. Order IDs start at 1001.
CREATE TABLE Orders (
    OrderID     INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID  INT,
    EmployeeID  INT,
    OrderDate   DATE,
    ShipperID   INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (ShipperID)  REFERENCES Shippers(ShipperID)
) AUTO_INCREMENT = 1001;
 
INSERT INTO Orders (CustomerID, EmployeeID, OrderDate, ShipperID) VALUES
(1,  3, '2026-01-05', 2),
(2,  3, '2026-01-12', 1),
(6,  4, '2026-01-20', 3),
(4,  2, '2026-02-03', 1),
(5,  5, '2026-02-14', 2),
(1,  3, '2026-02-25', 2),
(8,  4, '2026-03-04', 3),
(10, 4, '2026-03-15', 3),
(3,  3, '2026-03-28', 1),
(12, 4, '2026-04-06', 3),
(2,  2, '2026-04-18', 1),
(7,  4, '2026-05-02', 3),
(9,  1, '2026-05-20', 3),
(11, 5, '2026-06-01', 2),
(5,  5, '2026-06-11', 2);
 
-- Step 9 - OrderDetails table
-- The line items of each order: which product and how many. CHECK makes sure Quantity is always positive.
CREATE TABLE OrderDetails (
    OrderDetailID  INT AUTO_INCREMENT PRIMARY KEY,
    OrderID        INT,
    ProductID      INT,
    Quantity       INT CHECK (Quantity > 0),
    FOREIGN KEY (OrderID)   REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
 
INSERT INTO OrderDetails (OrderID, ProductID, Quantity) VALUES
(1001, 1, 10), (1001, 5, 20), (1001, 6, 15),
(1002, 7, 5),  (1002, 9, 8),
(1003, 10, 50),(1003, 11, 10),(1003, 1, 25),
(1004, 2, 12), (1004, 4, 30),
(1005, 8, 6),  (1005, 12, 4), (1005, 3, 24),
(1006, 6, 20), (1006, 7, 3),
(1007, 11, 5), (1007, 12, 10),
(1008, 8, 40), (1008, 3, 60),
(1009, 5, 15), (1009, 9, 10), (1009, 10, 20),
(1010, 1, 30), (1010, 12, 15),(1010, 11, 8),
(1011, 4, 25), (1011, 6, 10),
(1012, 10, 35),(1012, 2, 20),
(1013, 12, 6), (1013, 7, 4),
(1014, 8, 25), (1014, 3, 48), (1014, 1, 12),
(1015, 5, 40), (1015, 4, 40);