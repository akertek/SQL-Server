/* 
-- Data Types --

1 - Sayısal Veri Tipleri
tinyint: 1 byte /  0 - 255
smallint: 2 byte / 65536
int: 4 byte / 2 milyar
bigint: 8 byte / 9223372036854775808
----------------------------------------
decimal(p,s): p: ondalık dahil toplam s: sadece ondalık kısım ** virgülden sonraki basamak net.
numeric:
float: hassas ölçüm. Bilimsel hesaplamalar için gerekli. (gerekmedikçe kullanma)
real:
money: kullanma (esnek değil)
smallmoney: kullanma
bit: 1,0


2 - Tarihsel Veri Tipleri
datetime: yyyy-mm-dd hh:mm:ss 1753-9999
smalldatetime: 1900-2079
date: yyyy-mm-dd 0001-9999
time: hh:mm:ss
datetime2: 0001-9999
datetimeoffset


3 - Metinsel Veri Tipleri
char: char(10) --> 10 karakter yapar. Sondan boşluk koyar.
nchar: nchar(10) --> Char'la aynı. Sadece UNICODE karakter desteği var. 
varchar:  Sonuna boşluk koymaz. 
nvarchar: Sonuna boşluk koymaz. UNICODE desteği. 

text: 2 GB Kullanma.
ntext: 2 GB Kullanma.
varchar(max): 2 GB
nvarchar(max): 2 GB

----- uniqueidentifer: newId() ----

**Veri Tipi Çeşitleri**

- System Data Types: Yukarıdakiler. 
- Alias Data Types: Create type
- User-defined data types: Custom OOP. SQL'de olmuyor. 

***********************

Conversion: 
 
 - Tarihsel
 - Sayısal 
 - Metinsel

Yukarı yönlü. Implicit. SQL kendisi yapıyor. 
Aşağı yönlü. Explicit. cast,convert,parse fonksiyonları ile yapılıyor. 

try_cast: hata yerine null
try_convert: hata yerine null
*/

SELECT * from Production.Product

SELECT Name,ListPrice,Color FROM Production.Product



-- WHERE --
SELECT * FROM Production.Product
WHERE ListPrice = 0

-- List Price'ı 0 olmayan ürünler
SELECT * FROM Production.Product
WHERE ListPrice != 0     -- <> : Aynı şey.


--- List Price'ı 1000 ile 2000 arasında olanlar

SELECT * FROM Production.Product
WHERE ListPrice >= 1000 AND ListPrice <=2000

SELECT * FROM Production.Product
WHERE ListPrice BETWEEN 1000 AND 2000


-- rengi siyah yada kırmızı olup fiyatı 1000den büyük olan ürünler

SELECT * 
FROM Production.Product
WHERE (Color = 'Black' OR Color = 'Red') AND ListPrice >= 1000

-- IN 

SELECT Name,Color,ListPrice
FROM Production.Product
WHERE Color IN('black','red','blue','yellow')

-- Rengi siyah, mavi, kırmızı, mavi, sarı olmayan

SELECT Name,Color,ListPrice
FROM Production.Product
WHERE Color NOT IN('black','red','blue','yellow')

-- null değerlerde yukarıdaki sorguda  gelm esini istiyorsak

SELECT Name,Color,ListPrice
FROM Production.Product
WHERE Color NOT IN('black','red','blue','yellow') OR Color IS NULL


-- OrderDate 2012 yılında olanlar.

SELECT * 
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = 2012

SELECT * 
FROM SaleS.SalesOrderHeader
WHERE OrderDate BETWEEN '2012-01-01 00:00:00.000' AND '2012-12-31 00:00:00.000'


-- LIKE --

-- LastName'i K ile başlayanlar

SELECT * 
FROM Person.Person
WHERE LastName LIKE 'K%'

-- LastName'i K ile başlayanlar ve sonrasında 2 karakter olan. 

SELECT * 
FROM Person.Person
WHERE LastName LIKE 'K__'

-- LastName'i K ile bitenler

SELECT*
FROM Person.Person
WHERE LastName LIKE '%K'

--  LastName'in içinde K harfi olsun.

SELECT*
FROM Person.Person
WHERE LastName LIKE '%K%'

-- 4. harfi K olsun, devamı önemli değil 

SELECT*
FROM Person.Person
WHERE LastName LIKE '___K%'

-- 4. harfi K ve son harfi olsun 

SELECT*
FROM Person.Person
WHERE LastName LIKE '___K'


-- Bu formattaki telefon numaraları gelsin

SELECT * 
FROM Person.PersonPhone
WHERE PhoneNumber LIKE '___-___-____'

-- Bu formattaki telefon numaraları gelsin. Ama sadece rakamlardan oluşanlar gelsin.

SELECT * 
FROM Person.PersonPhone
WHERE PhoneNumber LIKE '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'

-- cep telefonları gelsin (500 - 530 - 540 - 550'li numaralar)

SELECT * 
FROM Person.PersonPhone
WHERE PhoneNumber LIKE '[5][0345][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'

-- DISTINCT --

-- Farklı colorlar gelsin

SELECT DISTINCT Color
FROM Production.Product


-- Kompozir olarak distinct getirir

SELECT DISTINCT Color,Size
FROM Production.Product

-- CASE WHEN 

SELECT Name, Color, ListPrice
FROM Production.Product

-- IF mantığı (SELECT'ten sonra virgüle dikkat et hata verdi koymadığında.)
SELECT Name, Color, ListPrice,
CASE WHEN ListPrice >= 0 AND ListPrice <= 1000 THEN 'Ucuz'
WHEN ListPrice > 1000 AND ListPrice <= 2000 THEN 'Ucuz'
WHEN ListPrice > 2000 THEN 'Ucuz'
END AS 'Segment'
FROM Production.Product


-- renk blackse siyah red'se kırmızı yellow'sa sarı yazsın, hiçbiri değilse diğer yazsın.

SELECT Name, Color, ListPrice,
CASE WHEN Color = 'Black' THEN N'Siyah'
WHEN  Color = 'Red' THEN N'Kırmızı'
WHEN Color = 'Yellow' THEN N'Sarı'
ELSE 'Diğer'
END AS 'Renk'
FROM Production.Product

--- renk blackse siyah red'se kırmızı yellow'sa sarı yazsın, diğerlerinde kendi adını yazsın. 

SELECT Name, Color, ListPrice,
CASE WHEN Color = 'Black' THEN N'Siyah'
WHEN  Color = 'Red' THEN N'Kırmızı'
WHEN Color = 'Yellow' THEN N'Sarı'
ELSE 'Diğer'
END as Color
FROM Production.Product

-- ORDER BY 

SELECT Name,Color,ListPrice
FROM Production.Product
ORDER BY ListPrice

-- Fiyatı en pahalı 10 ürün 

SELECT TOP 10 Name,Color,ListPrice
FROM Production.Product
ORDER BY ListPrice DESC

-- ilk yüzde onluk kısmı getirsin.

SELECT TOP 10 PERCENT Name,Color,ListPrice
FROM Production.Product
ORDER BY ListPrice  DESC

-- fiyatı en pahalı ilk 3 ürün 

SELECT DISTINCT TOP 3 WITH TIES ListPrice
FROM Production.Product
ORDER BY ListPrice DESC

-- OFFSET FETCH

-- ilk 20 yi atla devamından 20 getir


SELECT Name,Color,ListPrice
FROM Production.Product
ORDER BY ListPrice DESC
OFFSET 20 ROWS FETCH NEXT 20 ROWS ONLY


SELECT COUNT(*), Color
FROM Production.Product
WHERE ListPrice >= 2000
GROUP BY Color
HAVING COUNT(*) >=1
ORDER BY 1 DESC

/*
SELECT   5
FROM     1
WHERE    2
GROUP BY 3
HAVING   4  group by dan sonra koşul belirtir
ORDER BY 6
*/

-- AS 

SELECT Name AS N'Ürün Adı', Color AS N'Renk', ListPrice AS N'Liste Fiyatı'
FROM Production.Product


/*
AGGREGATE FUNCTIONS
sum, max, min
count, avg
*/

SELECT*
FROM Production.Product

SELECT
SUM(ProductSubcategoryID) AS 'Toplam',
MAX(ProductSubcategoryID) AS 'Max',
MIN(ProductSubcategoryID) AS 'Min',
COUNT(ProductSubcategoryID) AS 'Adet',
AVG(ProductSubcategoryID) AS 'Ortalama',
COUNT(*) AS 'Adet2',
SUM(ProductSubcategoryID)/COUNT(*) AS 'Ortalama2',
AVG(ISNULL(ProductSubcategoryID,0)) as 'Ortalama3'
FROM Production.Product

-- ISNULL --- NULL'sa atadığımız değeri döndür.

SELECT ISNULL(ProductSubcategoryID,99) 
FROM Production.Product

-- GROUP BY 

-- Hangi renkten kaç adet ürün mevcut?

SELECT COUNT(*) as 'Adet',Color
FROM Production.Product
GROUP BY Color


-- Hangi şehirde kaç tane adres var?

SELECT City, COUNT(*) as 'Adet'
FROM Person.Address
GROUP BY City
ORDER BY Adet DESC

-- Her rengin en pahalı, en ucuz ve ort fiyatı gelsin

SELECT Color,
MAX(ListPrice) as 'Maksimum',
MIN(ListPrice) as 'Minimum',
AVG(ISNULL(ListPrice,0)) as 'Ortalama'
FROM Production.Product
GROUP BY Color


-- Her bir yılın toplam subtotali

SELECT YEAR(OrderDate) AS 'Yıl',
SUM(SubTotal) AS 'Toplam'
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate)
ORDER BY YEAR(OrderDate) DESC

-- Bugüne kadar toplamda en az 500.000 TL tutarında sipariş veren müşteriler

SELECT CustomerID, SUM(SubTotal)
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
HAVING SUM(SubTotal) >= 500000
ORDER BY CustomerID DESC

SELECT CustomerID, COUNT(   )
FROM Sales.SalesOrderHeader
GROUP BY CustomerID

SELECT YEAR(OrderDate) AS 'Yıl'
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate)
ORDER BY YEAR(OrderDate) DESC

-- JOIN

SELECT * 
FROM Sales.SalesOrderHeader

SELECT * 
FROM Sales.SalesTerritory

-- TerritoryID üzerinden birleştirildi. 

SELECT *
FROM Sales.SalesOrderHeader as soh
INNER JOIN Sales.SalesTerritory st
ON soh.TerritoryID = st.TerritoryID

/*
INNER: İki tabloda da ortak olanları alır.
OUTER: left,right,full
CROSS: Kartezyen çarpım yapar. 1. satırdaki her elemanı diğer tabloyla çarpılır.

Customer - Order
LEFT JOIN: Customer değerleri gelir , orderda olmayanlar null gelir.
RIGHT JOIN: Order değerleri gelir, customerda olmayanlar null gelir. 
FULL JOIN : LEFT + RIGHT - INNER
*/


-- modeli olsun ya da olmasın tüm ürünler gelsin. ürün adı model adı
SELECT Product.Name as 'Ürün Adı', ProductModel.Name as 'ModelAdı'
FROM Production.Product as Product
LEFT JOIN Production.ProductModel as ProductModel
ON Product.ProductModelID = ProductModel.ProductModelID

SELECT*
FROM Production.Product

SELECT*
FROM Production.ProductModel