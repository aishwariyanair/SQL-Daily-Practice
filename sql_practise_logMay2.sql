use practisedb;

CREATE TABLE CUSTOMERS(
  CUSTOMERID INT PRIMARY KEY,
  FIRSTNAME VARCHAR(50),
  LASTNAME VARCHAR(50),
  EMAIL VARCHAR(50),
  AGE INT,
  CITY VARCHAR(50)
  );
  
  
  CREATE TABLE ORDERS(
     ORDERID INT PRIMARY KEY,
     CUSTOMERID INT,
     ORDERDATE DATE,
     TOTAL_AMOUNT DECIMAL(10,2),
     FOREIGN KEY (CUSTOMERID) REFERENCES  CUSTOMERS(CUSTOMERID)
     );
     
     INSERT INTO Customers (CustomerID, FirstName, LastName, Email, Age, City)
VALUES
(1, 'Alice', 'Smith', 'alice@example.com', 28, 'New York'),
(2, 'Bob', 'Johnson', 'bob@example.com', 34, 'Chicago'),
(3, 'Charlie', 'Brown', 'charlie@example.com', 25, 'San Francisco'),
(4, 'Diana', 'Evans', 'diana@example.com', 42, 'New York'),
(5, 'Ethan', 'Hunt', 'ethan@example.com', 30, 'Los Angeles');

INSERT INTO Orders (OrderID, CustomerID, OrderDate, Total_Amount)
VALUES
(101, 1, '2024-12-01', 250.50),
(102, 2, '2024-12-05', 120.00),
(103, 1, '2025-01-15', 300.00),
(104, 3, '2025-02-20', 80.75),
(105, 4, '2025-03-10', 450.00),
(106, 2, '2025-03-22', 200.00),
(107, 5, '2025-04-01', 150.00);

select * from customers;
select *from orders;



-- Get a list of customers with their orders

SELECT c.CustomerID, c.FirstName, c.LastName, o.OrderID, o.OrderDate, o.Total_Amount
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID;

-- Find customers who has spent more than the avg order amount

SELECT c.FirstName, c.LastName, o.Total_Amount
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE o.Total_Amount > (SELECT AVG(Total_Amount) FROM Orders);


-- Find the Customer with the Highest Total Order Amount
SELECT c.FirstName, c.LastName, SUM(o.Total_Amount) AS TotalSpent
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID
ORDER BY TotalSpent DESC
LIMIT 1;
     
-- Find the total amount spent by each customer.
-- List the CustomerID, FirstName, LastName, and their total TotalAmount from all their orders.
-- Sort the results by total spending in descending order.   

SELECT c.CustomerID, c.FirstName, c.LastName, SUM(o.Total_Amount) AS TotalSpent
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID
ORDER BY TotalSpent DESC;

-- Find the customer(s) who have placed the most number of orders.
SELECT c.CustomerID, c.FirstName, c.LastName, COUNT(*) AS Counts
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID
ORDER BY Counts DESC;
  
-- Find all customers who have never placed an order.
SELECT c.CustomerID, c.FirstName, c.LastName
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;

-- List each customer along with their most recent order date.
SELECT c.CustomerID, c.FirstName, c.LastName, MAX(o.OrderDate) AS LatestOrderDate
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID;

-- List customers who have placed more than one order.
SELECT c.CustomerID, c.FirstName, c.LastName, COUNT(*) AS OrderCount
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID
HAVING COUNT(*) > 1;

-- Show the customers who placed an order with the highest TotalAmount.
SELECT c.CustomerID, c.FirstName, c.LastName, o.Total_Amount
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.Total_Amount = (SELECT MAX(Total_Amount) FROM Orders);

select *   from orders;

-- Find the average order amount for each customer.
SELECT c.CustomerID, c.FirstName, c.LastName, AVG(o.Total_Amount) AS AverageOrderAmount
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName;

-- Assign a row number to each order, ordered by TotalAmount in descending order, for each customer.
SELECT c.CustomerID, o.OrderID, o.Total_Amount, 
       ROW_NUMBER() OVER (PARTITION BY c.CustomerID ORDER BY o.Total_Amount DESC) AS RowNumber
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID;

-- Find the cumulative sum of TotalAmount for each customer, ordered by OrderDate.
SELECT c.CustomerID, o.OrderID, o.OrderDate, o.Total_Amount,
       SUM(o.Total_Amount) OVER (PARTITION BY c.CustomerID ORDER BY o.OrderDate) AS CumulativeTotal
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID;

-- Find the rank of each order for every customer, based on the TotalAmount, with the highest order amount ranked first.
SELECT c.CustomerID, o.OrderID, o.Total_Amount,
       RANK() OVER (PARTITION BY c.CustomerID ORDER BY o.Total_Amount DESC) AS Ranked
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID;

-- Find the second highest Total_Amount for each customer.
SELECT *
FROM (
    SELECT *, 
           ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY Total_Amount DESC) AS rn
    FROM Orders
) ranked
WHERE rn = 2;

select * from orders;