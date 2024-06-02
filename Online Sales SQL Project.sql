SELECT TOP 10 *
	FROM Online_sales
	WHERE InvoiceDate is not NULL
	ORDER BY Country;

--To get total rows
SELECT
	COUNT(*) AS TotalRows
	FROM Online_sales;

--Unique Customer
SELECT 
	DISTINCT TOP 10 CustomerID AS UniqueCustomers
	FROM Online_sales;


--Financial statistics summary
SELECT
	SUM(Quantity * Unitprice) AS TotalSales,
	AVG(Quantity * Unitprice) AS AverageSales,
	MIN(Quantity * Unitprice) AS MinSales,
	MAX(Quantity * Unitprice) AS MaxSales
	FROM Online_sales;


--To analyse Monthly Sales performance by formatting invoicedate to mm-yyyy
SELECT
	FORMAT(InvoiceDate,'MM-yyyy') AS Month,
	SUM(Quantity * Unitprice) AS TotalSales,
	AVG(Quantity * Unitprice) AS AverageSales,
	COUNT(DISTINCT InvoiceNo) AS TotalOrders
	FROM Online_sales
	WHERE FORMAT(InvoiceDate,'MM-yyyy') is not null
	GROUP BY FORMAT(InvoiceDate,'MM-yyyy')
	ORDER BY Month;

-- To identify top performing products, along with the countries,total quantities and total orders
SELECT
	Description,
	Country,
	SUM(Quantity) AS TotalQuantity,
	SUM(Quantity * UnitPrice) AS TotalSales,
	COUNT(DISTINCT InvoiceNo) AS TotalOrders
	FROM Online_sales
	GROUP BY Description, Country
	ORDER BY TotalSales DESC;


-- Using CTE(WITH) To detect anomalies/errors

WITH AverageOrderValue AS (
	SELECT AVG(Quantity * UnitPrice) AS AvgOrderValue
	FROM Online_sales)
	SELECT
	Description,
	InvoiceNo,
	CustomerID,
	SUM(Quantity * UnitPrice) AS OrderValue,
	Country
	FROM Online_sales
	GROUP BY Description, InvoiceNo, CustomerID, Country
	HAVING SUM(Quantity * UnitPrice) > (SELECT AvgOrderValue * 3 FROM AverageOrderValue)
	ORDER BY OrderValue DESC;


--To calculate customer purchase frequency
SELECT
	CustomerID, 
	COUNT(DISTINCT InvoiceNo) AS PurchaseFrequency,
	SUM(Quantity * UnitPrice) AS TotalSpent,
	MAX(InvoiceDate) AS LastPurchaseDate
	FROM Online_sales
	GROUP BY CustomerID
	ORDER BY PurchaseFrequency DESC;

--To Track sales for single products over time - inventory management
SELECT
	FORMAT(InvoiceDate,'MM-yyyy') AS Month,
	StockCode, 
	Description,
	SUM(Quantity) AS TotalQuantity,
	SUM(Quantity * UnitPrice) AS TotalSales
	FROM Online_sales
	WHERE FORMAT(InvoiceDate,'MM-yyyy') is not null
	GROUP BY FORMAT(InvoiceDate,'MM-yyyy'), StockCode, Description
	ORDER BY Month , TotalSales DESC;

-- Monthly Sales by Country

SELECT
	FORMAT(InvoiceDate,'MM-yyyy') AS Month,
	Country,
	SUM(Quantity * UnitPrice) AS TotalSales,
	COUNT(DISTINCT InvoiceNo) AS TotalOrders
	FROM Online_sales
	WHERE FORMAT(InvoiceDate,'MM-yyyy') is not null
	GROUP BY FORMAT(InvoiceDate,'MM-yyyy'), Country
	ORDER BY Month , TotalSales DESC;



--Creating View to store data for visualisations to see country sales performance

Create view CountrySalesPerformance AS
SELECT
	Description,
	Country,
	SUM(Quantity) AS TotalQuantity,
	SUM(Quantity * UnitPrice) AS TotalSales,
	COUNT(DISTINCT InvoiceNo) AS TotalOrders
	FROM Online_sales
	GROUP BY Description, Country
	--ORDER BY TotalSales DESC;

SELECT * 
	FROM CountrySalesPerformance
	ORDER BY TotalSales DESC;