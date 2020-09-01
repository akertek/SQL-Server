-- Day2 -

-- Job title, birthdate, firstname, lastname getirsinn

SELECT*
FROM HumanResources.Employee

SELECT*
FROM Person.Person

SELECT JobTitle, BirthDate, FirstName, LastName
FROM HumanResources.Employee as emp
INNER JOIN  Person.Person AS per
ON emp.BusinessEntityID = per.BusinessEntityID

--

SELECT*
FROM Person.Person
SELECT*
FROM Sales.Customer
SELECT*
FROM Sales.SalesOrderHeader

SELECT CustomerID, StoreID, TerritoryID, FirstName, MiddleName, LastName
FROM Person.Person as per
INNER JOIN  Sales.Customer as cus
ON per.BusinessEntityID = cus.PersonID

-- customer ID, store, id, territory id, firstname, lastname ,salesorderıd 3 farklı tablodan çek.

SELECT sal.CustomerID,StoreID,sal.TerritoryID,FirstName,LastName,SalesOrderID
FROM Sales.Customer AS cus
INNER JOIN  Person.Person as per
ON cus.PersonID = per.BusinessEntityID
INNER JOIN Sales.SalesOrderHeader as sal
ON per.BusinessEntityID = sal.CustomerID


--- salesorder ID, product ID, name - salesorderdetail tablosunda bulunmasada hepsini getir.
SELECT*
FROM Sales.SalesOrderDetail
SELECT*
FROM Production.Product

SELECT SalesOrderID, sal.ProductID, Name
FROM Production.Product as pro
LEFT JOIN Sales.SalesOrderDetail as sal
ON sal.ProductID = pro.ProductID

--- currencyrateid,averagerate,shipbase,salesorderid
SELECT*
FROM Sales.SalesOrderHeader
SELECT*
FROM Sales.CurrencyRate
select*
FROM Purchasing.ShipMethod

-- LEFT koyarsan left te olmayanlar için NULL atar
SELECT hea.CurrencyRateID, AverageRate,ShipBase, SalesOrderID, CreditCardApprovalCode
FROM Sales.SalesOrderHeader AS hea
LEFT JOIN Sales.CurrencyRate as cur
ON hea.CurrencyRateID = cur.CurrencyRateID
LEFT JOIN Purchasing.ShipMethod as ship
ON hea.ShipMethodID = ship.ShipMethodID
WHERE CreditCardApprovalCode LIKE '%0%2'

-- Order quantitiy kolonu 0 - 3 under 3 yazsın 3 - 6 6 

SELECT OrderQty,
CASE WHEN OrderQty < 3 THEN 'Under 3'
WHEN OrderQty >= 3 AND OrderQty <= 6 THEN '3 - 6'
WHEN OrderQty >= 7 AND OrderQty <= 9 THEN '7 - 9'
WHEN OrderQty >= 10  THEN 'Over 10'
END AS 'Sipariş Sayısı'
FROM Sales.SalesOrderDetail

-- Stringleri Birleştirip Yazma 
SELECT FirstName, LastName, FirstName + ' ' + LastName as FullName
FROM Person.Person

-- PersonType IN, SC, SP ise lastname sırala değilse firstname sırala

SELECT PersonType, FirstName, LastName 
FROM Person.Person
ORDER BY
CASE WHEN PersonType IN ('IN', 'SC', 'SP') THEN LastName
ELSE FirstName
END

-- yıl ve aya göre order
SELECT SalesOrderID, OrderDate,YEAR(OrderDate),MONTH(OrderDate)
FROM Sales.SalesOrderHeader
ORDER BY YEAR(OrderDate),MONTH(OrderDate)

-- tarihsel - sayısal - metinsel
-- bu olur çünkü sayı - metin oluyor 
SELECT*
FROM Production.Product
WHERE ListPrice = '0'

-- bu olmaz çünkü sayı - tarih olmuyor 
SELECT*
FROM Sales.SalesOrderHeader
WHERE OrderDate >= 2012-04-30 00:00:00.000

-- karaktere karakter yazdık sıkıntı yok. 
SELECT Name, ISNULL(Color,'Renksiz'), ListPrice, ProductModelID
FROM Production.Product

--CAST
SELECT ISNULL(CAST(ProductModelID AS nvarchar),'Modelsiz')
FROM Production.Product

-- CONVERT
SELECT OrderDate,
CONVERT(nvarchar,OrderDate,104),
CONVERT(nvarchar,OrderDate,130),
CONVERT(nvarchar,OrderDate,108)
FROM Sales.SalesOrderHeader

-- SUBQUERY

-- En pahalı ürünün rengi
SELECT TOP 1 ListPrice, Color 
FROM Production.Product
ORDER BY ListPrice desc

-- En pahalı ürünün bütün özellikleri
SELECT*
FROM Production.Product
WHERE Color = (SELECT TOP 1 Color
               FROM Production.Product
               ORDER BY ListPrice DESC)

-- En son sipariş tarihinde verilen tüm siparişler

SELECT*
FROM Sales.SalesOrderHeader
WHERE OrderDate = (SELECT TOP 1 OrderDate
                   FROM Sales.SalesOrderHeader
                   ORDER BY OrderDate DESC)

SELECT*
FROM Sales.SalesOrderHeader
WHERE OrderDate = (SELECT MAX(OrderDate)
                   FROM Sales.SalesOrderHeader)


-- fiyatı en pahalı olan ürünün rengindeki bütün ürünler

SELECT*
FROM Production.Product
WHERE Color = (SELECT TOP 1 Color
               FROM Production.Product
               WHERE ListPrice = (SELECT MAX(ListPrice)
                                  FROM Production.Product )
                
)

SELECT*
FROM Production.Product
WHERE Color = (SELECT TOP 1 Color
               FROM Production.Product
               ORDER BY ListPrice DESC)

-- name'de bolts geçenlerin listprice neyse o listprice'a sahip ürünler
SELECT*
FROM Production.Product
WHERE ListPrice = (SELECT ListPrice
                   FROM Production.Product
                   WHERE Name LIKE '%bolts%'
)


SELECT pro1.Name, pro2.ListPrice
FROM Production.Product as pro1
INNER JOIN Production.Product as pro2
ON pro1.ListPrice = pro2.ListPrice
WHERE pro1.Name LIKE '%bolts'


/*
-- SET OPERATORS
-UNION ALL 
-UNION
-INTERSECT
-EXCEPT
*/

-- Database değiştirme

use TSQL2012

-- İki tablodan kolonları çekip alt alta koyar. İlk sorgudan isimleri çeker.
SELECT country, city
FROM HR.Employees -- 9 
UNION ALL 
SELECT country,city 
FROM Sales.Customers -- 91


-- Tekrar edenleri sildi. 
SELECT country, city
FROM HR.Employees -- 9 
UNION 
SELECT country,city 
FROM Sales.Customers -- 91

--Kesişim 
SELECT country, city
FROM HR.Employees -- 9 
INTERSECT
SELECT country,city 
FROM Sales.Customers -- 91
--Except
SELECT country, city
FROM HR.Employees -- 9 
EXCEPT
SELECT country,city 
FROM Sales.Customers -- 91


use AdventureWorks2016

SELECT*
FROM Person.PersonPhone
WHERE PhoneNumber LIKE '___-___-____'





