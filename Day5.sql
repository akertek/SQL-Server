-- Day 5 

-- INDEX
-- Hızı arttırır. Performans yüksektir. 
/*
Table Scan
Index Seek

Heap Tablolar:
1- Clustered Index --> ID 
2- Non-Clustered Index --> Name - clustered'la look-up yapar. 
*/

-- INDEX GÖZLEMLEME - fragmantasyon yüzdesini gösteriyor.
SELECT*
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'detailed')
ORDER BY avg_fragmentation_in_percent DESC

-- Index Statistics 4. aşamada kullanılır.
-- INCLUDE: Nonclustered indexin lookup yapmasını önler. 
/* 
Tablo1: 
ID, Name, SayfaSayısı, YayınTarihi, kategori

nonclustered(name) INCLUDE sayfaSayısı, YayınTarihi --> direkt getirir ID'ile lookup yapmaz. 

SELECT SayfaSayısı, yayıntarihi -- > ID ile lookup yapmaz. 
WHERE Name = ...

SELECT SayfaSayısı, yayıntarihi, kategori --> Mecburen ID ile lookup yapar. Kategoriyi oradan getirir. 
WHERE Name = ...

*/

-- Columnstore Index 
-- Pagelerde tek bir sütuna ait bilgileri tutar, gruplama, analiz, hesaplama

-----------------

-- Nested: Bir küçük bir büyük tablo 
-- Merge Join: İki büyük tablo, aynı ID'ye göre sıralı. 
-- Hash Match: İki büyük tablo farklı ID'ye göre sıralı.