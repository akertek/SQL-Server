-- Day 3 --

-- Person.Person tablosu BusinessEntityID, FirstName, MiddleName, LastName last name 3. basamağı o ya da a olanlar 

SELECT*
FROM Person.Person 
WHERE LastName LIKE '__[ao]%'

-- last name ja ile başlayıp es ile bitenler

SELECT*
FROM Person.Person
WHERE LastName LIKE 'ja%es'

-- last name ja ile başlayıp arada bir basamak olup es ile bitenler

SELECT*
FROM Person.Person
WHERE LastName LIKE 'ja_es'

--Sales.SalesOrderHeader tablosunda SalesOrderID, OrderDate, TotalDue, SalesPersonID, TerritoryID koşul: TotalDue 100den büyük olanların içinden  SalesPersonID'si 279 veya  TerritoryID'si  6 veya 4 olanlar
 
 SELECT SalesOrderID, OrderDate, TotalDue, SalesPersonID, TerritoryID
 FROM Sales.SalesOrderHeader
 WHERE TotalDue > 100 AND (SalesPersonID = 279 OR TerritoryID in (6,4))

-- Production.Product tablosunda ID ve Name'i tek bir kolonda birleştirip araya ":" koyup kolonun adını IDName olarak döndürsün

SELECT ProductID, Name, CAST(ProductID AS varchar) + ': ' + Name
FROM Production.Product 
 
 -- Production.Product tablosundan color,size, productmodel tablosundan catalogdescription kolonu

SELECT pro.Color, pro.Size, model.CatalogDescription
FROM Production.Product as pro
INNER JOIN Production.ProductModel as model
ON pro.ProductModelID = model.ProductModelID

/*
Product tablosunda kaydı olan person'ların firstname,middlename,last name'i gelsin ve person tablosundaki name gelsin.
Bu sorgu için ihtiyacınız olan tablolar: 
Sales.Customer
Person.Person
Sales.SalesOrderHeader
Sales.SalesOrderDetail
Production.Product
*/


SELECT TOP 10 * FROM Sales.Customer
SELECT TOP 10 * FROM Sales.SalesOrderDetail
SELECT TOP 10 * FROM Sales.SalesOrderHeader
SELECT TOP 10 * FROM Person.Person
SELECT TOP 10 * FROM Production.Product

SELECT FirstName,MiddleName,LastName,prod.Name
FROM Sales.Customer AS c
INNER JOIN Person.Person AS p 
ON c.PersonID = BusinessEntityID
INNER JOIN Sales.SalesOrderHeader AS soh 
ON c.CustomerID = soh.CustomerID
INNER JOIN Sales.SalesOrderDetail as sod 
ON soh.SalesOrderID = sod.SalesOrderID
INNER JOIN Production.Product AS prod 
ON prod.ProductID = sod.ProductID

-- businessentitiyId,salespersonId,salesorderID , salesYTD bilgileri gelsin . salesorderheaderda olmasa da salesperson tablosundaki tüm business entity id'ler gelsin 

SELECT BusinessEntityID,SalesPersonID,SalesOrderID,SalesYTD
FROM Sales.SalesPerson AS p
LEFT JOIN Sales.SalesOrderHeader AS h
ON p.BusinessEntityID = h.SalesPersonID

--  üstteki sorudaki aynı senaryoya ek olarak person.person tablosundan firstname,lastnami getirsin

SELECT p.BusinessEntityID,SalesPersonID,SalesOrderID,SalesYTD,per.FirstName,per.LastName
FROM Sales.SalesPerson AS p
LEFT JOIN Sales.SalesOrderHeader AS h
ON p.BusinessEntityID = h.SalesPersonID
LEFT JOIN Person.Person AS per
ON p.BusinessEntityID =per.BusinessEntityID


-- Her departmanın Org level = 1 olan yöneticisini bulun 

SELECT emp.OrganizationLevel, dep.Name, emp.JobTitle 
FROM HumanResources.Employee as emp
INNER JOIN HumanResources.EmployeeDepartmentHistory as his
ON emp.BusinessEntityID = his.BusinessEntityID
INNER JOIN HumanResources.Department as dep
ON his.DepartmentID = dep.DepartmentID
WHERE emp.OrganizationLevel = 1 


SELECT*
FROM HumanResources.Employee


-- TABLE MANIPULATIONS 

-- CREATE

CREATE TABLE dbo.MüşteriTablosu
(
MüşteriID INT PRIMARY KEY IDENTITY(1,1)  -- 1'le başlasın birer birer artsın. 
)


CREATE TABLE dbo.Sipariş
(
SiparişID INT PRIMARY KEY IDENTITY(1,1),  -- 1'le başlasın birer birer artsın. 
SiparişTarihi DATETIME2 NOT NULL,
SiparişTutar DECIMAL(15,2),
MüşteriID INT FOREIGN KEY REFERENCES dbo.MüşteriTablosu(MüşteriID)
)

--INSERT INTO

INSERT INTO dbo.Sipariş
(SiparişTarihi,SiparişTutar,MüşteriID)
VALUES
(GETDATE(),2555.40,5)

INSERT INTO dbo.Sipariş
(SiparişTarihi,SiparişTutar,MüşteriID)
VALUES
(GETDATE(),2555.40,5),
(GETDATE(),1500,3),
(GETDATE(),9999.90,4),
(GETDATE(),2895.00,4)

--UPDATE

UPDATE dbo.Sipariş 
SET SiparişTutar = SiparişTutar*1.1
WHERE SiparişID = 3 

-- DELETE

DELETE FROM dbo.Sipariş
WHERE SiparişID = 3 


-- TerritoryID'ye göre salesYTD'lerin toplamı
SELECT*
FROM Sales.SalesPerson

SELECT TerritoryID AS ID,
SUM(SalesYTD) AS 'Toplam'
FROM Sales.SalesPerson
GROUP BY TerritoryID
ORDER BY TerritoryID ASC

-- Yıla Göre Subtoplamlar


SELECT YEAR(OrderDate) AS 'Yıl',
SUM(SubTotal) AS 'Toplam'
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate)
ORDER BY YEAR(OrderDate) DESC

-- Production.Product mdoele göre toplam listprice, max size min size ort size

SELECT ProductModelID, SUM(ListPrice), MAX(Size), MIN(Size)
FROM Production.Product
GROUP BY ProductModelID

-- 1'den fazla kaydı olan product modelleri getirsin ve kaç satır

SELECT ProductModelID, COUNT(*) AS Total
FROM Production.Product
GROUP BY ProductModelID
HAVING COUNT(*) >=1



-- Production.Product mdoele göre toplam listprice, max size min size ort size + productmodel min modified date


SELECT pro.ProductModelID, SUM(ListPrice) as Total, MAX(Size) as MaximumSize, MIN(Size) as MinimumSize, MIN(mod.ModifiedDate) as ModifiedDate
FROM Production.Product AS pro
INNER JOIN Production.ProductModel as mod
ON pro.ProductModelID = mod.ProductModelID
GROUP BY pro.ProductModelID


-- ListPrice Ucuz Orta Pahalı Segment

SELECT Name, Color, ListPrice,
CASE WHEN ListPrice >= 0 AND ListPrice <= 1000 THEN 'Ucuz'
WHEN ListPrice > 1000 AND ListPrice <= 2000 THEN 'Orta'
WHEN ListPrice > 2000 THEN 'Pahalı'
END AS 'Segment'
FROM Production.Product


-- Tabloya içeriden kolon atıp sonrasında WHERE sorgusu yapma 

SELECT*
FROM (
    SELECT Name, Color, ListPrice,
    CASE WHEN ListPrice >= 0 AND ListPrice <= 1000 THEN 'Ucuz'
    WHEN ListPrice > 1000 AND ListPrice <= 2000 THEN 'Orta'
    WHEN ListPrice > 2000 THEN 'Pahalı'
    END AS 'Segment'
    FROM Production.Product
     ) as tbl
    WHERE Segment = 'Orta'

-- Yukarıdakinin aynısı sadece grupladık.  Gruplarken select'te olması lazım  

SELECT Segment, COUNT(*) as Total
FROM (
    SELECT Name, Color, ListPrice,
    CASE WHEN ListPrice >= 0 AND ListPrice <= 1000 THEN 'Ucuz'
    WHEN ListPrice > 1000 AND ListPrice <= 2000 THEN 'Orta'
    WHEN ListPrice > 2000 THEN 'Pahalı'
    END AS 'Segment'
    FROM Production.Product
     ) as tbl


/*
1. Derived Column (Subquery)
2. Common Table Function 
3. View
4. Table-Valued Function
*/

-- Common Table Function 

WITH abc
AS
    (
        SELECT Name,Color,ListPrice,
        CASE WHEN ListPrice >= 0 AND ListPrice <= 1000 THEN 'Ucuz'
        WHEN ListPrice > 1000 AND ListPrice <= 2000 THEN 'Orta'
        WHEN ListPrice > 2000 THEN 'Pahalı'
        END AS 'Segment'
        FROM Production.Product

    )
SELECT Segment,COUNT(*) as Quantity
from abc
GROUP BY Segment

-- Views 

CREATE VIEW vwÜrünBelgesi
AS 
SELECT Name,Color,ListPrice,
CASE WHEN ListPrice >= 0 AND ListPrice <= 1000 THEN 'Ucuz'
WHEN ListPrice > 1000 AND ListPrice <= 2000 THEN 'Orta'
WHEN ListPrice > 2000 THEN 'Pahalı'
END AS 'Segment'
FROM Production.Product



















