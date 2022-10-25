/*
E-Commerce Analysis
*/

SELECT *
FROM project.dbo.ECommerceData
ORDER BY Country

--Formatting(Quanitity)
SELECT CAST(Quantity AS int) AS Quantity_int
FROM project.dbo.ECommerceData

UPDATE project.dbo.ECommerceData
SET Quantity = CAST(Quantity AS int)

Alter TABLE project.dbo.ECommerceData
ADD Quantity_int int

UPDATE project.dbo.ECommerceData
SET Quantity_int = CAST(Quantity AS int)

SELECT * 
FROM project.dbo.ECommerceData



--Finding and deleting duplicates
WITH ECommerceDataCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY InvoiceNo,
				 Description,
				 StockCode,
				 CustomerID,
				 Quantity
				 ORDER BY
					InvoiceNo
					) AS row_num

FROM Project.dbo.Customer_Segmentation
)
DELETE FROM ECommerceDataCTE
WHERE row_num > 1

--Finding and dealing with negative values in Quantity and UnitPrice Columns
SELECT Quantity_int
FROM project.dbo.ECommerceData
WHERE Quantity_int < 0
GROUP BY Quantity_int

SELECT ABS(Quantity_int) AS AbsoluteQuantity
FROM project.dbo.ECommerceData
GROUP BY Quantity_int

UPDATE project.dbo.ECommerceData
SET Quantity_int = ABS(Quantity_int)

ALTER TABLE project.dbo.ECommerceData
ADD AbsoluteQuantity int

UPDATE project.dbo.ECommerceData
SET AbsoluteQuantity = ABS(Quantity_int)


SELECT UnitPrice
FROM project.dbo.ECommerceData
WHERE UnitPrice < 0
GROUP BY UnitPrice

SELECT ABS(UnitPrice) AS A_UnitPrice
FROM project.dbo.ECommerceData
GROUP BY UnitPrice

UPDATE project.dbo.ECommerceData
SET UnitPrice = ABS(UnitPrice)

ALTER TABLE project.dbo.ECommerceData
ADD A_UnitPrice float

UPDATE project.dbo.ECommerceData
SET A_UnitPrice = ABS(UnitPrice)

--Checking for Null values/ CustomerID column has 135080 nulls, Description has 1454 nulls
SElECT CustomerID, COUNT(*)
FROM project.dbo.ECommerceData 
WHERE CustomerID is null
GROUP BY CustomerID

SELECT Description, COUNT(*)
FROM project.dbo.ECommerceData 
WHERE Description is null
GROUP BY Description

SELECT Description, CustomerID, InvoiceNo, AbsoluteQuantity, Country
FROM project.dbo.ECommerceData
WHERE Description is null


--1.Total And Average Revenue for Each Month of 2011
SELECT YEAR(InvoiceDate) AS Year, MONTH(InvoiceDate) AS Month, 
SUM(AbsoluteQuantity * UnitPrice) AS Revenue, AVG(AbsoluteQuantity * UnitPrice) AS AveragePerMonth
FROM project.dbo.ECommerceData
WHERE YEAR(InvoiceDate) = 2011
GROUP BY YEAR(InvoiceDate), MONTH(InvoiceDate)
ORDER BY YEAR(InvoiceDate), MONTH(InvoiceDate)


--2. Number of Sold Items Per Product
SELECT Description, 
SUM(AbsoluteQuantity) AS TotalPerProduct
FROM project.dbo.ECommerceData
WHERE UnitPrice is not null AND Description is not null AND Description <> '?' AND UnitPrice <> 0
GROUP BY Description
Order BY TotalPerProduct DESC


--3.Total Revenue Per Product
SELECT Description, 
SUM(AbsoluteQuantity * UnitPrice) AS Revenue,
Max(AbsoluteQuantity * UnitPrice) AS MaxRevenue
FROM project.dbo.ECommerceData
WHERE UnitPrice is not null AND Description is not null AND Description <> '?' AND UnitPrice <> 0
GROUP BY Description
ORDER BY Revenue Desc

--4. Maximum Revenue Per Product
SELECT Description, 
Max(AbsoluteQuantity * UnitPrice) AS MaxRevenue, AVG(AbsoluteQuantity * UnitPrice) AS AvgRevenue
FROM project.dbo.ECommerceData
WHERE UnitPrice is not null AND Description is not null AND Description <> '?' AND UnitPrice <> 0
GROUP BY Description
ORDER BY MaxRevenue Desc

--5. Total Revenue Per Customer
SELECT CustomerID, Country,
SUM(AbsoluteQuantity * UnitPrice) AS RevenuePerCustomer
FROM project.dbo.ECommerceData
WHERE CustomerID is not null
GROUP BY CustomerID, Country
ORDER BY RevenuePerCustomer Desc

--6.Average Revenue Per Customer
SELECT CustomerID, Country,
AVG(AbsoluteQuantity * UnitPrice) AS AVGRevenuePerCustomer
FROM project.dbo.ECommerceData
WHERE CustomerID is not null 
GROUP BY CustomerID, Country
ORDER BY AVGRevenuePerCustomer Desc


--7.Total Revenue Per country
SELECT Country, COUNT(*) totalCount
FROM project.dbo.ECommerceData
WHERE UnitPrice is not null AND Description is not null AND Description <> '?' 
GROUP BY Country
ORDER BY totalCount Desc


SELECT Country,
SUM(AbsoluteQuantity * UnitPrice) AS RevenuePerCountry
FROM project.dbo.ECommerceData
WHERE UnitPrice is not null AND Description is not null AND Description <> '?'
GROUP BY Country
ORDER BY RevenuePerCountry Desc


SELECT CustomerID, COUNT(*) TotalCustomerID
FROM project.dbo.ECommerceData
WHERE CustomerID is not null AND Description is not null AND Description <> '?' 
GROUP BY CustomerID
ORDER BY TotalCustomerID Desc

