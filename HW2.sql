--HW2--

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