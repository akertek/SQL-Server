
-- 1)Sales.SalesOrderDetail tablosunda salesorderId'si 3'ten fazla olan kayıtlar ve kaç tane bulunduğu bilgisi

SELECT SalesOrderID, COUNT(*) AS Total
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID
HAVING COUNT(*) > 3 

-- 2)Sales.SalesOrderDetail tablosunda salesorderId'sine göre line total'in toplamı 1000'den büyük olan kayıtlar
SELECT SalesOrderID, SUM(LineTotal) AS Total
FROM SALES.SalesOrderDetail
GROUP BY SalesOrderID 
HAVING SUM(LineTotal) > 1000
-- 3)Product tablosunda productmodel ID sadece 1 kaydı bulunan modelID'ler ve kaç tane bulunduğu
SELECT ProductModelID, COUNT(*)
FROM Production.Product AS Total 
GROUP BY ProductModelID
HAVING COUNT(*) = 1 
-- 4)3.soruya ek olarak sadece rengi blue ya da red olan ürünleri hesaplasın 
SELECT COUNT(*) as Total, Color
FROM Production.Product AS Total 
GROUP BY Color
HAVING Color = 'Blue' OR Color = 'Red'
-- 5) vwCustomerTotals isminde bir view oluşturun.  Bu view her müşteri için yıl ve aya göre toplam totaldue bilgisini getirsin 

GO
CREATE VIEW dbo.vwCustomerTotals
AS
(
SELECT cus.CustomerID, YEAR(OrderDate) as OrderYear, MONTH(OrderDate) AS OrderMonth, SUM(TotalDue) as TotalSales
FROM Sales.Customer AS cus 
INNER JOIN Sales.SalesOrderHeader AS hea 
ON cus.CustomerID = hea.CustomerID
GROUP BY cus.CustomerID, YEAR(OrderDate), MONTH(OrderDate)
)

-- döndürmesini istediğimiz tablo: 
-- customerId, orderdate(year),orderdate(month),TotalSales(sum)

-- gerekli tablolar: customer, salesorderheader

------------------------------------------------------------------------------------------

---- Functions ----
-- Aggregate Functions
-- System Functions: left, right, upper, lower, length, trim

---- Scaler Function ---- 
-- Deterministic:
-- Non-Deterministic: Her defasında değişebilen:

---- Table Valued Functions ----
-- Inline: Tek Select
-- Multistatement: Performans olarak düşükçok tercih edilmez. 


-- Girilen renge sahip ürünleri getirsin. 
GO
CREATE FUNCTION fnRengeGöreÜrünGetir
(
    @Renk NVARCHAR(20)
)
RETURNS TABLE
AS RETURN 
    SELECT*
    FROM Production.Product
    WHERE Color = @Renk
GO

SELECT* 
FROM dbo.fnRengeGöreÜrünGetir('Red')

-- Girilen Size'a Göre Getiren fonksiyonu yaz.

SELECT*
FROM Production.Product

GO
CREATE FUNCTION fnBoyutaGöreÜrünGetir
(
    @Boyut NVARCHAR(20)
)
RETURNS TABLE
AS RETURN 
    SELECT*
    FROM Production.Product
    WHERE Size = @Boyut
GO


-- Girilen müşterinin girilen adet kadar son siğarişleri gelsin. sales.salesorderheader

GO
CREATE FUNCTION fcMüşteriSiparişDetay
(
    @MüşteriID INT,
    @Adet INT
)
RETURNS TABLE
AS RETURN 
    SELECT TOP (@Adet) CustomerID, SubTotal, OrderDate
    FROM Sales.SalesOrderHeader
    WHERE CustomerID = @MüşteriID
    ORDER BY OrderDate DESC
GO

SELECT*
FROM fcMüşteriSiparişDetay(29565,5)

-- Girilen sayıları toplayan func

GO
CREATE FUNCTION fnToplama
(
    @Sayı1 INT,
    @Sayı2 INT
)
RETURNS BIGINT
AS 
BEGIN 
    RETURN @Sayı1 + @Sayı2
END
GO

SELECT dbo.fnToplama(1,5) 


-- Stored Procedure
-- Query Execution Phases:
/*
1- Syntax Check
2- Name Resolution
3- Compile
4- Execution Plan 
5- Execute
*/

-- CREATE PROCEDURE
GO
CREATE PROC spSiparişAralığıGetir
(
    @başlangıçTarihi DATETIME,
    @bitişTarihi DATETIME
)
AS
BEGIN
    SELECT CustomerID, OrderDate, Subtotal
    FROM Sales.SalesOrderHeader
    WHERE OrderDate BETWEEN @başlangıçTarihi AND @bitişTarihi

END
GO

EXEC spSiparişAralığıGetir '2012-01-01','2012-12-31'

-- ALTER PROCEDURE

GO
ALTER PROC spSiparişAralığıGetir
(
    @başlangıçTarihi DATETIME,
    @bitişTarihi DATETIME
)
AS
BEGIN
    SELECT CustomerID, OrderDate, Subtotal
    FROM Sales.SalesOrderHeader
    WHERE OrderDate >= @başlangıçTarihi AND OrderDate < @bitişTarihi

END
GO

EXEC spSiparişAralığıGetir '2012-01-01','2012-12-31'

-- Ürün adının içinde yazdığım parametre geçenler güncellensin

GO
CREATE PROC spÜrünİsimGüncelle
(
    @ürünAdı NVARCHAR(20),
    @tutar MONEY
)
AS
BEGIN
    UPDATE Production.Product
    SET ListPrice = ListPrice - @tutar
    WHERE NAME LIKE '%' + @ürünAdı + '%'
END
GO

EXEC spÜrünİsimGüncelle 'men',100



SELECT ListPrice,Name
FROM Production.Product
WHERE Name LIKE '%MEN%'

---
GO
CREATE PROCEDURE spMüşteriSiparişDetay
(
    @müşteriID INT,
    @siparişAdet INT OUTPUT
)
AS
BEGIN
    SELECT @siparişAdet = COUNT(*)
    FROM Sales.SalesOrderHeader
    WHERE CustomerID = @müşteriID
END 
GO

DECLARE @Adet INT 
EXEC dbo.spMüşteriSiparişDetay 11000, @Adet OUTPUT
SELECT @Adet

/*

begin try
kod
end try

begin catch
error handling code
end catch

commit -- commitler
rollback -- geri alır
*/

-- her rengin en pahalı fiyatı 

SELECT Name, Color, ListPrice, 
RANK() OVER(ORDER BY ListPrice DESC) AS SıraNo,
DENSE_RANK() OVER(ORDER BY ListPrice DESC) AS SıraNo2,
ROW_NUMBER() OVER(ORDER BY ListPrice DESC) AS SıraNo3
FROM Production.Product

-- Group by = Partition by 
-- Renklere göre grupla 
SELECT Name, Color, ListPrice,
RANK() OVER(PARTITION BY Color ORDER BY ListPrice DESC) AS SıraNo,
DENSE_RANK() OVER(PARTITION BY Color ORDER BY ListPrice DESC) AS SıraNo,
ROW_NUMBER() OVER(PARTITION BY Color ORDER BY ListPrice DESC) AS SıraNo
FROM Production.Product

-- sıra no <= 3


SELECT*
FROM
(
SELECT Name, Color, ListPrice,
RANK() OVER(PARTITION BY Color ORDER BY ListPrice DESC) AS SıraNo,
DENSE_RANK() OVER(PARTITION BY Color ORDER BY ListPrice DESC) AS SıraNo1,
ROW_NUMBER() OVER(PARTITION BY Color ORDER BY ListPrice DESC) AS SıraNo2
FROM Production.Product
) as tbl
WHERE SıraNo1 <= 3 

-- her müşterinin vermiş olduğu son 3 adet sipariş

-------  !!!!!!!!!! Customer ID'ye göre gruplayıp o içeride çektiğin diğer her şeye sıra numarası veriyor bu dalga !!!!!!!!!!!!
SELECT*
FROM
(
SELECT CustomerID, OrderDate,
ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY OrderDate DESC) AS SıraNo
FROM Sales.SalesOrderHeader
) AS tbl 
WHERE SıraNo <=3 

-- sales.salesorderdetail salesorderIDlere göre OrderQty
-- LAG 
GO
SELECT SalesOrderID, SUM(OrderQty) AS Quantity,
LAG(SUM(OrderQty),1,0) OVER (ORDER BY SalesOrderID) AS Önceki,
LAG(SUM(OrderQty),1,0) OVER (ORDER BY SalesOrderID) AS Sonraki
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID
ORDER BY SalesOrderID
GO

-- INDEX
-- Hızı arttırır. Performans yüksektir. 
/*
Table Scan
Index Seek

Heap Tablolar:
1- Clustered Index 
2- Non-Clustered Index
*/
