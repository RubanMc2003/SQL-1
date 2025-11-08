CREATE DATABASE IF NOT EXISTS retail_store;
USE retail_store;


/*Customers Table*/
CREATE TABLE IF NOT EXISTS customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    City VARCHAR(30),
    Gender VARCHAR(10)
);

/* Products Table*/
CREATE TABLE IF NOT EXISTS products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    Category VARCHAR(30),
    Price DECIMAL(10,2)
);

/* Orders Table*/
CREATE TABLE IF NOT EXISTS orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    ProductID INT,
    Quantity INT,
    OrderDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES customers(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES products(ProductID)
);

/*Insert Sample Data Customers*/
INSERT INTO customers VALUES
(101, 'John Doe', 'Bangalore', 'Male'),
(102, 'Jane Smith', 'Chennai', 'Female'),
(103, 'Robert Brown', 'Mumbai', 'Male'),
(104, 'Emily Davis', 'Delhi', 'Female'),
(105, 'Michael Wilson', 'Pune', 'Male');

/*Products*/
INSERT INTO products VALUES
(1, 'Laptop', 'Electronics', 55000.00),
(2, 'Mobile Phone', 'Electronics', 20000.00),
(3, 'Office Chair', 'Furniture', 7000.00),
(4, 'Headphones', 'Accessories', 2500.00),
(5, 'Wrist Watch', 'Accessories', 4000.00);

/*Orders*/
INSERT INTO orders VALUES
(1001, 101, 1, 1, '2023-01-10'),
(1002, 102, 2, 2, '2023-01-15'),
(1003, 103, 4, 1, '2023-01-18'),
(1004, 101, 3, 1, '2023-02-02'),
(1005, 105, 5, 1, '2023-02-10');

select * from customers;
select * from products;
select * from orders;
/*-------------------------INNER JOIN--------------------------------------------------------

Fetch customer names, products purchased, and quantities:*/

SELECT
C.CUSTOMERNAME,
P.PRODUCTNAME,
O.QUANTITY
FROM ORDERS O
INNER JOIN CUSTOMERS C ON O.CUSTOMERID=C.CUSTOMERID
INNER JOIN PRODUCTS P ON O.PRODUCTID=P.PRODUCTID ;



/*Explaination: Shows only matching data across all three tables.*/


/* -------------------------LEFT JOIN--------------------------------------------------------

Show all customers and their order details (even those who never ordered):*/
select
c.CustomerName,
o.orderID,
o.customerid,
o.productid,
o.quantity,
o.orderdate
from Orders o
left join Customers c on o.customerID = c.customerID;



/*Explaination: Shows all customers; NULL for those with no orders.*/


/*-------------------------RIGHT JOIN--------------------------------------------------------

Show all products and which customers purchased them:*/
SELECT
c.customername,
p.productname,
o.orderid,
o.customerid,
o.productid,
o.quantity,
o.orderdate
FROM orders o
right JOIN customers c ON o.customerid=c.customerid
right JOIN Products p ON o.productid=p.productid;



/* Shows all products; NULL for unpurchased ones.


/* -------------------------UNION--------------------------------------------------------
 

Combine customers from Bangalore and customers from Chennai into a single list:*/
SELECT CUSTOMERNAME,CITY FROM CUSTOMERS WHERE CITY="BANGALORE"
UNION
SELECT CUSTOMERNAME,CITY FROM CUSTOMERS WHERE CITY="CHENNAI";


/*Explaination:Removes duplicates.*/

/* --------------------------UNION ALL----------------------------------------------------------

Same query but includes duplicates:*/
SELECT CUSTOMERNAME,CITY FROM CUSTOMERS WHERE CITY="BANGALORE"
UNION ALL
SELECT CUSTOMERNAME,CITY FROM CUSTOMERS WHERE CITY="CHENNAI";



/*Explaination: Includes duplicates.*/





/*--------------------------Advanced----------------------------------------------------------*/

/*JOIN + WHERE + ALIAS

Find orders placed after Feb 1, 2023, with customer and product names:*/
select c.customername,
o.*
from customers c
left join orders o on o.customerid=c.customerid
where o.orderid is null;








/*LEFT JOIN + IS NULL

Find customers who have never placed an order:*/

select c.customername,
o.*
from customers c
left join orders o on o.customerid=c.customerid
where o.orderid is null;





/*INNER JOIN + Calculated Column

Calculate total amount spent by each customer:*/

SELECT
C.CUSTOMERNAME,
SUM(P.PRICE*O.QUANTITY) AS TOTALSPENT
FROM ORDERS O 
INNER JOIN CUSTOMERS C ON C.CUSTOMERID=O.CUSTOMERID
INNER JOIN PRODUCTS P ON P.PRODUCTID=O.PRODUCTID
GROUP BY C.CUSTOMERNAME;





/*---------------------------------------------------------------------------------------------
                                CTE (Common Table Expression)

A Common Table Expression (CTE) in SQL is a named, temporary result set defined within the scope of a single SELECT, INSERT, UPDATE, or DELETE statement. 
It functions similarly to a derived table but offers enhanced readability and reusability within the same query. 

🔹 Example 1: Using CTE to Simplify Total Spent Query

/* Using CTE to find total spent by each customer */

WITH CustomerSpending AS (
    SELECT 
        c.CustomerName,
        SUM(p.Price * o.Quantity) AS TotalSpent
    FROM orders o
    INNER JOIN customers c ON o.CustomerID = c.CustomerID
    INNER JOIN products p ON o.ProductID = p.ProductID
    GROUP BY c.CustomerName
)
SELECT * FROM CustomerSpending where Totalspent>200;

/*Window Function
Rank Customers by Total Spending*/

SELECT 
    c.CustomerName,
    SUM(p.Price * o.Quantity) AS TotalSpent,
    RANK() OVER (ORDER BY SUM(p.Price * o.Quantity) DESC) AS SpendingRank
FROM orders o
INNER JOIN customers c ON o.CustomerID = c.CustomerID
INNER JOIN products p ON o.ProductID = p.ProductID
GROUP BY c.CustomerName;

/*Explaination
* RANK() is a window function that assigns ranks without collapsing rows.
* OVER() defines the window — how we want to look at the data.

In this example, we order by spending in descending order, so top spenders get RANK = 1.*/

/* Add Ranking Within City (Partition)*/
SELECT 
    c.City,
    c.CustomerName,
    SUM(p.Price * o.Quantity) AS TotalSpent,
    RANK() OVER (PARTITION BY c.City ORDER BY SUM(p.Price * o.Quantity) DESC) AS CityRank
FROM orders o
INNER JOIN customers c ON o.CustomerID = c.CustomerID
INNER JOIN products p ON o.ProductID = p.ProductID
GROUP BY c.City, c.CustomerName;

/*-------------------------------------------------------------
Challenge 1: Average Order Value per Customer using CTE
---------------------------------------------------------------*/

