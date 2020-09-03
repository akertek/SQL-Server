--1)-- yıllara göre (product model tablosu modified date) product model ID'lerin en yüksek standart cost'u nu veren sorgu 
--proc,view ve function yazın. 
--Parametre alacak olanların parametreleri: girilen productmodelID

-- SP
SELECT*
FROM Production.ProductModel
SELECT*
FROM Production.Product

GO
CREATE PROC spCostGetir
(
    @ID INT
)
AS
BEGIN
    SELECT mod.ProductModelID, MAX(pro.StandardCost), mod.ModifiedDate
    FROM Production.ProductModel AS mod
    INNER JOIN Production.Product AS pro
    ON mod.ProductModelID = pro.ProductModelID
    GROUP BY mod.ProductModelID, mod.ModifiedDate
    HAVING mod.ProductModelID = @ID

END
GO
-- VIEW
GO
CREATE VIEW vwCost1
AS 
(
    SELECT mod.ProductModelID as ID , MAX(pro.StandardCost) AS MaxCost, mod.ModifiedDate AS Date
    FROM Production.ProductModel AS mod
    INNER JOIN Production.Product AS pro
    ON mod.ProductModelID = pro.ProductModelID
    GROUP BY mod.ProductModelID, mod.ModifiedDate
    
)
GO

-- FUNC


GO
CREATE FUNCTION fnCostGetir
(
    @ID INT
)
RETURNS TABLE
AS RETURN 
    SELECT mod.ProductModelID as ID , MAX(pro.StandardCost) AS MaxCost, mod.ModifiedDate AS Date
    FROM Production.ProductModel AS mod
    INNER JOIN Production.Product AS pro
    ON mod.ProductModelID = pro.ProductModelID
    GROUP BY mod.ProductModelID, mod.ModifiedDate
    
GO


select * from Sales.SalesTerritory

--2)a)Sales.SalesTerritory tablosunda name'e göre ortalama salesytd değerlerini bulun ve bu değerlere sırano atayın 
--b) bu sorguyu view olarak kaydedin
--c)bu view'ı sorgulayarak her name'in yanına yazdırdığınız ort salesytd değerlerinin de yanına bir önceki salesytd değeri bir sonraki ytd değerini yazdırın 


SELECT Name, AVG(ISNULL(SalesYTD,0)) AS Ortalama,
ROW_NUMBER() OVER(PARTITION BY Name ORDER BY AVG(ISNULL(SalesYTD,0)) DESC) AS SıraNo
FROM Sales.SalesTerritory

GO
CREATE VIEW vwGetSalesYTD
AS 
(
    SELECT Name AS İsim, AVG(ISNULL(SalesYTD,0)) AS Ortalama,
    ROW_NUMBER() OVER( ORDER BY Name DESC) AS SıraNo
    FROM Sales.SalesTerritory
    GROUP BY Name
    
)
GO

/*
Designing and Implementing Tables 
- Şema Kavramı 

*/


-- Advanced Table Design 
-- Partitioning 





