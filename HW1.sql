-- HW -- 

SELECT emp.EmployeeID,emp.ReportsTo,
							(
							SELECT LastName 
							FROM dbo.Employees
							WHERE EmployeeID=emp.ReportsTo
							) FROM dbo.Employees AS emp

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
--Sales.SalesOrderDetail tablosunda da bulunan productId'ler(Production.Product)
SELECT * 
FROM Production.Product
WHERE ProductID IN (
					 SELECT ProductID
					 FROM Sales.SalesOrderDetail	
					)

--Sales.SalesOrderDetail tablosunda bulunmayan productId'ler
SELECT * 
FROM Production.Product
WHERE ProductID NOT IN (
					 SELECT ProductID
					 FROM Sales.SalesOrderDetail
					 WHERE ProductID IS NOT NULL	
					)

