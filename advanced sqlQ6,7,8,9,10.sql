CREATE TABLE Products (
ProductID INT PRIMARY KEY,
ProductName VARCHAR(100),
Category VARCHAR(50),
Price DECIMAL(10,2));
use common;
select * from Products;
create database common;
INSERT INTO Products VALUES
(1, "Keyboard", "Electronics",1200 ),
(2, "Mouse","Electronics", 800),
(3, "Chair" , "Furniture",2500 ),
(4, "Desk","Furniture",5500 );
CREATE TABLE Sales (
SaleID INT PRIMARY KEY,
ProductID INT,
Quantity INT,
SaleDate DATE,
FOREIGN KEY (ProductID) REFERENCES Products(ProductID));
drop table sales;
select * from sales;
INSERT INTO Sales VALUES
(1, 1, 4,'2024-01-05'),
(2, 2, 10,'2024-01-08'),
(3, 3,  2,'2024-01-10'),
(4, 4, 1,'2024-01-11');
# Q6. Write a CTE to calculate the total revenue for each product  (Revenues = Price × Quantity), and return only products where  revenue > 3000.
WITH RevenueCTE AS (
    SELECT 
        p.ProductID,
        p.ProductName,
        SUM(p.Price * s.Quantity) AS Revenue
    FROM Products p
    JOIN Sales s
        ON p.ProductID = s.ProductID
    GROUP BY p.ProductID, p.ProductName
)
SELECT * FROM RevenueCTE
WHERE Revenue > 3000;
#Q7. Create a view named  vw_CategorySummary Category, TotalProducts, AveragePrice.  that shows:
CREATE VIEW vw_CategorySummary AS
SELECT
    Category,
    COUNT(*) AS TotalProducts,
    AVG(Price) AS AveragePrice
FROM Products
GROUP BY Category;
SELECT * FROM vw_CategorySummary;
#Q8. Create an updatable view containing ProductID, ProductName, and Price.  Then update the price of ProductID = 1 using the view.
CREATE VIEW vw_ProductPrice AS
SELECT
    ProductID,
    ProductName,
    Price
FROM Products;
select * from vw_ProductPrice;
UPDATE vw_ProductPrice
SET Price = 500
WHERE ProductID = 1;
# Q9. Create a stored procedure that accepts a category name and returns all products belonging to that category
use common;
DROP PROCEDURE IF EXISTS GetProductCategory;
DELIMITER $$
CREATE PROCEDURE GetProductCategory(IN cat_name VARCHAR(50))
BEGIN
    SELECT ProductID, ProductName, Category, Price
    FROM Products
    WHERE Category = cat_name;
END $$
DELIMITER ;
CALL GetProductCategory('Electronics');
# Q10. Create an AFTER DELETE trigger on the  table ProductArchive timestamp. Products table that archives deleted product rows into a new . The archive should store ProductID, ProductName, Category, Price, and DeletedAt
CREATE TABLE Products_Archive (
    ProductID INT,
    ProductName VARCHAR(50),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    DeletedAt TIMESTAMP
);
DELIMITER $$

CREATE TRIGGER trg_after_product_delete
AFTER DELETE ON Products
FOR EACH ROW
BEGIN
    INSERT INTO Products_Archive
    VALUES (
        OLD.ProductID,
        OLD.ProductName,
        OLD.Category,
        OLD.Price,
        CURRENT_TIMESTAMP
    );
END $$

DELIMITER ;

