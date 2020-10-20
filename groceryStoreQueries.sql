-------------------------------------------- ������ ����� ������ ����� groceryStore --------------------------------------------
use groceryStore

-------------------------------------------- ������ ������ --------------------------------------------

-- 1. �������� ������, ����� ������� �������� ����� , ����� � ������ �� ������� �� ��� ���� ��� �����, ������ ������ � ��-����� �� 10
SELECT serialNumber, name, unitPrice 
FROM Food
WHERE (kind='meat' OR kind='milky') AND unitPrice < 10
 
-- 2.�������� ������, ����� ������� ������ � ������� �� �������, ����� ��� ������� � �������
SELECT name,unitPrice 
FROM Food
WHERE name LIKE ('croissant %')
 
-- 3. �������� ������, ����� ������� �������� �����, ��� � ���� �� ���������, ����� �� �������� �������
SELECT serialNumber, name, unitPrice
FROM Drinks
WHERE kind <> 'alcoholic'
 
--4. �������� ������, ����� ������� �������� �����, ����� � ������ �� ������, � ����� ��� �� ������� �mix�
SELECT serialNumber,name,unitPrice
FROM OtherStocks
WHERE kind = 'nuts' and name like '%mix%'


--5. �������� ������, ����� ������� ����������� ������ � ������� �� ���� ���������, ����� �� CEO ��� ��������� �� �������, �� �� �� �� ������� test
SELECT phoneNumber ,name
FROM Employees
WHERE sector = 'CEO' OR (sector='milky' AND position <> 'test')

-------------------------------------------- ������ ����� ��� � ������ ������� --------------------------------------------

-- 1. �������� ������, ����� ������� ��������� ������ � ������ �� ����������� �������, ����� �� ��-����� �� 10 � ���������
SELECT Products.serialNumber, unitPrice
FROM Products, Drinks
WHERE kind='alcoholic' AND Products.serialNumber=drinks.serialNumber and Products.numberOfProducts<10
 
-- 2. �������� ������, ����� ������� ������, ����� � ������������� �� ������ ������� � ���� ��-������ �� ������ �� �Monster "Zero"�
SELECT Drinks.name, Drinks.unitPrice, maker
FROM Products, Drinks, Drinks as ProductOfMonsterZero
WHERE  Products.serialNumber = Drinks.serialNumber 
AND ProductOfMonsterZero.name = 'Monster "Zero"' 
AND Drinks.unitPrice > ProductOfMonsterZero.unitPrice
 
-- 3. �������� ������, ����� ������� ����� �� ����������, ���������� � �����, �������� ����� �� ������� � ������,����� �� �������� ���� ������������ �� ���� �� ��������� ����� � ������ �� �������� ������, ��� ���� ������������ ��������� 100
SELECT companyName, phoneNumber, Products.serialNumber, numberOfProducts*unitPrice as totalPrice
FROM Makers, Products, Food
WHERE Makers.companyName = Products.maker 
AND Food.serialNumber = Products.serialNumber 
AND numberOfProducts*unitPrice > 100

-- 4. �������� ������, ����� ������� �����, ������ �� ������������� � �������� � ��������� �� �������� ��������
SELECT companyName, phoneNumber, numberOfProducts
FROM Makers, Products, Food
WHERE Makers.companyName= Products.maker 
AND Food.serialNumber = Products.serialNumber 
AND kind='milky'
 
-- 5. �������� ������, ����� ������� ������ �������� �� ��������� ���� � ������������ �Boznov�
SELECT maker, name, numberOfProducts*unitPrice as totalValue
FROM Products, Food
WHERE maker='Bozmov' 
AND name ='lamb' 
AND Products.serialNumber = Food.serialNumber


-------------------------------------------- ��������� --------------------------------------------

-- 1. �� �� ���e��� ������� �� ���������������, ����� ���� ������� �������� 
-- �� ��� 'householdGoods' � ����������� ��������.
SELECT companyName 
FROM Makers
WHERE companyName IN (SELECT maker FROM Products WHERE type LIKE 'HouseholdGoods');

-- 2. �� �� ������� �����, ����� � ���������� ���� �� ���������, 
-- ����� ���� � ��-������ �� ���������� ���� �� ������������ ��������.
SELECT name, kind, unitPrice 
FROM Drinks
WHERE unitPrice > ALL (SELECT unitPrice FROM Food);


-- 3. �� �� ������� ����� � ������ �� �������� � ���-������ ����.
SELECT name, unitPrice
FROM Cigarettes
WHERE unitPrice = (SELECT MAX(unitPrice) FROM Cigarettes);


-- 4. �� �� ������ ����� � ����������� ����� �� ���������������, 
--  ����� �������� �� ���-��������� �� ����.

-- I �������:
SELECT companyName, phoneNumber
FROM Makers
WHERE companyName IN ( 
                       SELECT p.maker
                       FROM Products p
                       JOIN DailyTurnover dt ON p.serialNumber = dt.serialNumber
                       WHERE dt.numberOfSold = (SELECT MAX(numberOfSold) FROM DailyTurnover)
);

-- II �������:
SELECT companyName, phoneNumber
FROM Makers
WHERE companyName IN ( 
                       SELECT maker
                       FROM Products 
                       WHERE serialNumber IN ( 
											   SELECT serialNumber 
								               FROM DailyTurnover
								               WHERE numberOfSold = (
											                          SELECT MAX(numberOfSold)
																	  FROM DailyTurnover
																	 )
		                                      )
);


-- 5. �� �� ������ ��������� �����, �����, ����������� � ���������� ���� �� ������, 
-- ����� � � ���-����� ��������� � ��������.
SELECT  f.serialNumber, f.name, p.numberOfProducts, f.unitPrice 
FROM Products p
JOIN Food f ON p.serialNumber = f.serialNumber 
WHERE p.serialNumber IN ( 
                          SELECT serialNumber 
				          FROM Food 
				          WHERE kind LIKE 'meat'
) AND p.numberOfProducts = ( 
                             SELECT MIN(numberOfProducts) 
					         FROM Products 
					         WHERE serialNumber IN (
									 SELECT serialNumber 
									 FROM Food 
									 WHERE kind LIKE 'meat'
													)
);


-- 6. �� �� ������ ����� � ������ �� ����������� �������, � ���� ��-����� �� ���� �� 
-- 'Whiskey Jack Daniels 700 ml' � � ���������� �� 1 �����.
SELECT name, unitPrice
FROM Drinks
WHERE kind LIKE 'alcoholic' 
AND name LIKE '%1 l'
AND unitPrice < (SELECT unitPrice FROM Drinks WHERE name LIKE 'Whiskey Jack Daniels 700 ml');


-- 7. �� �� ������ ��������� �����, �����, �����, ������ � ����������� �� �������� 
-- �� ��� ����� ��� ������� � ���-������ ����.
SELECT TOP 1 *
FROM (
       SELECT name, unitPrice FROM Food
	   UNION ALL
	   SELECT name, unitPrice FROM Drinks
) d
ORDER BY d.unitPrice DESC;


-------------------------------------------- ���������� --------------------------------------------

-- 1. �� �� ������� ����������� ������ �� ���� �������� (����������), ����� ����������� ����� 
-- � �� ����� �������� �� ������� ���� 15 ���� � ����������� �������
SELECT DISTINCT phoneNumber AS 'company phone number'
FROM Makers
JOIN Products ON companyName=maker
WHERE type = 'Food' AND numberOfProducts >= 15

-- 2. �� �� ������� ������� ����� (���, ���, ��������� �����) � ���������, ����� ������ � ��������, �� �����������, 
-- �� ����� ���� ������� �������� � �������, �� ����� ���������. �� �� ������� ��������� �� ������� �� �����������
SELECT egn,name,phoneNumber,position
FROM Employees
LEFT JOIN Products ON sector = type 
WHERE serialNumber IS NULL
ORDER BY name

-- 3. �� �� ������� ��������� �����, �����, ��������������, ����� ���������
-- �������� � ���������� ���� �� ������ �������� �� ��������� 'HouseholdGoods', 
--�� ����� ����� �� ����������� �������� � �� ������ �� 10% �� ��������� � �������� ��������.
SELECT Products.serialNumber, name AS 'name of product', maker, numberOfSold, HouseholdGoods.unitPrice
FROM Products
JOIN DailyTurnover ON Products.serialNumber = DailyTurnover.serialNumber
JOIN HouseholdGoods ON Products.serialNumber = HouseholdGoods.serialNumber
WHERE numberOfSold <= 0.1*numberOfProducts 

-- 4. ����� � �� �� ������ ����� �� ��������. �� ����� ������ �� �� �������� 
-- ��������� ��������� � ������ �������������, �� �� �� �������� ������������ �������. 
-- �� �� ������ ������, ����� ������� ���������� ������ �� ���������� (�����, ������� � �.�.) 
-- � ������� �������������, �� ����� ������������ �� ��������������� ������� � ������ �� ����� 
-- �� �������� � ������������ � ���������� �� �� ����� ��������.
SELECT DISTINCT(type), maker
FROM Products p
LEFT JOIN Makers m ON p.maker = m.companyName
WHERE companyName IS NULL

-- 5. �� �� ������� ������� �� ���������������, ������� �� ���������� � ���������� �� ���� 
-- �� ���� �������� �� ��� OtherStocks, ����� �������� ���� � ���-����� �������� �������� 
-- ���� �� ������ �������� �� ���� ���.
SELECT maker,name AS 'name of product', unitPrice
FROM OtherStocks os
JOIN Products p ON os.serialNumber=p.serialNumber
WHERE unitPrice <= (SELECT AVG(unitPrice)
					FROM otherStocks) 


-------------------------------------------- ��������� --------------------------------------------

-- 1. ��������� �� ���� �� ����������. ��������� �� ���� � ���� ��������, ����� ��������� �������� �� ���������� ���.
SELECT  type, COUNT(type) AS numberOfProducts 
FROM Products 
GROUP BY type
 
-- 2. ��������� �� ������� �� ������ �� �����������. ��������� �� ������� � ����������� �� ������, ����� ������� � ������� ������.
SELECT sector, COUNT(sector) AS numberOfPeople 
FROM Employees 
GROUP BY sector
 
-- 3. ��������� �� ��������� �� ������. �������� �� ��������� �� ������.
SELECT year, SUM(cost) AS money 
FROM OverallTurnover 
GROUP BY year
 
-- 4. ��������� �� ���������� �� ��������� �� �����������. ����������� �� ������, ���������� ����������� �������.
SELECT salary, COUNT(salary) AS numberOfPeople 
FROM Employees 
GROUP BY salary
 
-- 5. ����������� �� ��������� ����� �� ���������������, �� �� �� ������� �������, ����� �������� �� �������� ���� ����� ���� �� ��������.
SELECT phoneNumber, COUNT(phoneNumber) AS numberOfProducts 
FROM Makers JOIN Products ON Makers.companyName = Products.maker 
GROUP BY phoneNumber

-------------------------------------------- ��������� --------------------------------------------
-- 1. �������� �� �������� � ���-����� ���� �� ��� ����� (��� ��� ��� �������� � ����� � �������� ���� , �� ������ � ����� ��������).
SELECT name  
FROM Food 
WHERE unitPrice = (SELECT MIN(unitPrice) FROM Food)
 

-- 2. �������� �� �������� � ���-������ ���� �� ��� ����� (��� ��� ��� �������� � ����� � �������� ����, �� ������ � ����� ��������).
SELECT	name  
FROM Food 
WHERE unitPrice = (SELECT MAX(unitPrice) FROM Food)
 
-- 3. ����������� �� �������� ���� �� ������ ������ ��������.
SELECT 'milky' AS type, AVG(unitPrice) AS averagePrice 
FROM Food 
WHERE kind = 'milky'

-- 4. ����������� �� �������� ���� �� ������ ������ � ����� Davidoff.
SELECT 'Davidoff' AS maker, AVG(unitPrice) AS averagePrice 
FROM Cigarettes 
WHERE name LIKE '%Davidoff%'
 
-- 5. ����������� �� ������ ��������, ����� Coca Cola ������� �� ��������

SELECT 'Coca Cola' AS maker, COUNT(maker) AS numberOfProducts  
FROM Products 
WHERE maker LIKE '%Coca Cola%'
 
-- 6. ��������� �� ���� �� ���������� ������ ��������, ����� �������� ��������.
SELECT 'Croissant' AS kind, COUNT(name) AS numberOfProducts 
FROM Food 
WHERE name LIKE '%Croissant%'
 

-- 7. ��������� �� ����� �� ��������, ����� ��� ���-����� ������� ������ � ����� ������� ������ ��� �������� � ������� 
SELECT *
FROM (SELECT name,numberOfProducts FROM Food JOIN Products ON Food.serialNumber=Products.serialNumber
	  UNION ALL
	  SELECT name,numberOfProducts FROM Drinks JOIN Products ON Drinks.serialNumber=Products.serialNumber
	  UNION ALL
	  SELECT name,numberOfProducts FROM Cigarettes JOIN Products ON Cigarettes.serialNumber=Products.serialNumber
	  UNION ALL
	  SELECT name,numberOfProducts FROM OtherStocks JOIN Products ON OtherStocks.serialNumber=Products.serialNumber
	  UNION ALL
	  SELECT name,numberOfProducts FROM HouseholdGoods JOIN Products ON HouseholdGoods.serialNumber=Products.serialNumber) innerQuery
WHERE numberOfProducts <= (SELECT MIN(numberOfProducts) FROM Products)
ORDER BY numberOfProducts


-------------------------------------------- ������� � ������� --------------------------------------------

CREATE NONCLUSTERED INDEX ix_Products_Maker
ON Products(maker);

CREATE NONCLUSTERED INDEX ix_Products_Number
ON Products(numberOfProducts);

-- ������ ����� � ���� �� ������ ������� �������� � ������ �� ��������.
CREATE VIEW ProductsPriceAndNumber (serialNumber, unitPrice) AS 
	SELECT serialNumber, unitPrice FROM dbo.Food
	UNION ALL
	SELECT serialNumber, unitPrice FROM dbo.Drinks
	UNION ALL
	SELECT serialNumber, unitPrice FROM dbo.Cigarettes
	UNION ALL
	SELECT serialNumber, unitPrice FROM dbo.HouseholdGoods
	UNION ALL
	SELECT serialNumber, unitPrice FROM dbo.OtherStocks;

-- ���� ������ �� ����.
CREATE VIEW DailyReport AS 
	SELECT SUM (numberOfSold * unitPrice) AS totalCostOfTheDay
	FROM DailyTurnover;

-- ���� ������ �� ������.
CREATE VIEW MonthlyReport AS 
	SELECT SUM(dailyReport) AS monthTotalCost
	FROM MonthTurnover;

-- ���������� �� ������� �� ������.
CREATE VIEW AnnualTurnover AS
	SELECT year, SUM(cost) as annualReport
	FROM OverallTurnover
	GROUP BY year;

-- ������ �� ���������� ��������� ����� � MonthTurnover, ����� �� �� �������� 
-- ��� ����������� �� �������� ����� � ������������� �� � OverallTurnover.
CREATE VIEW MonthlyReportDate AS
	SELECT TOP 1 date 
	FROM MonthTurnover
	ORDER BY date DESC;

-------------------------------------------- ������� --------------------------------------------

-- ���� �������� �� ������� (�������� �� ������� � DailyTurnover) �� �������� ������������ �� ���������� �������
-- (numberOfProducts) � Products.
CREATE TRIGGER tr_DecreaseNumberOfProduct
ON dbo.DailyTurnover
AFTER INSERT 
AS
BEGIN
      UPDATE Products
      SET numberOfProducts = numberOfProducts - (SELECT numberOfSold FROM inserted)
      WHERE serialNumber = (SELECT serialNumber FROM inserted);
END
GO

-- � ��������� �� ������� ������ ��� ����� �� ���������� ���� �� ������� ���, 
-- ���� ���� ���������� �� �� �� ���������� � ������� ��� � MonthTurnover � �� �������� �� DailyTurnover, 
-- �� �� �� ������� �� �� ��������� ���. ��������� ����� ������� ������ (����� �� �������, 
-- ���� ���������, �������� ���� � ���� ����) �� ��������, � �� �� ������� ������� �� ���, ������ ������������ 
-- �� ���� �� �� ����� ����������, �.�. ���� �� �� ������ �� �� ��������������. 
CREATE TRIGGER tr_RemoveDailyInfo
ON dbo.MonthTurnover
AFTER INSERT 
AS
BEGIN
      DELETE FROM DailyTurnover
END
GO

-- � ��������� �� �������� ������ ��� ����� �� ���� �� ������� �����, 
-- ���� ���� ���������� �� �� �� ���������� � ������� ��� OverallTurnover � �� �������� �� MonthTurnover, 
-- �� �� �� ������� �� �� ��������� �����. ��������� ����� �������� ������ (���� � ������ �� ���) 
-- �� ��������, � �� �� ������� ������� �� ���, ������ ������������ 
-- �� ���� �� �� ����� ����������, �.�. ���� �� �� ������ �� �� ��������������. 
CREATE TRIGGER tr_RemoveMonthlyInfo
ON dbo.OverallTurnover
AFTER INSERT 
AS
BEGIN
      DELETE FROM MonthTurnover
END
GO

-------------------------------------------- ������������ ������� � ������ --------------------------------------------

-- � ������ ������� �������� ���� ����� �� ���������� �������������, � ��������, ���� � �� ��-������ ��������� �������,
-- � ����� ��� � ����� ������. ������ �������� ������ �� ��� � �� ����� ����������� ��������.

-- �������, ����� ���������� ��� ��������� �� �������� ���� � ��� ��������� ������
-- ������ �� ��������� ������� ���� ��������� � �� ����� ������ � ������ �� �������� 
CREATE FUNCTION ProductForSale (@ProductSerialNumber VARCHAR(50)) 
RETURNS TABLE AS 
RETURN 
	SELECT serialNumber, unitPrice
	FROM ProductsPriceAndNumber
	WHERE serialNumber = @ProductSerialNumber;

-- �������� ���� ���������� ��:
--		������ �� ��������, ����� �� ��������;
--		������������ �� ����������� �������;
--		���������� ���� �� ��������, �������� �� ��������� ProductForSale;
--		�������� ����, ����������� ��� ������ �� ���������� � ������������ �� ��������, ����� �� ��������.

DECLARE @ProductSerialNumber VARCHAR(50),
		@QuantityOfProduct FLOAT,
		@UnitPrice FLOAT,
		@TotalCost FLOAT;

SET @ProductSerialNumber = '125313467'; -- ��������� ����� � ������� ����� � ��� �������� (� ������ ������� ���� ����� �� �������� �� ����� ������)
SET @QuantityOfProduct = 1; -- ����� �������� � ������� ����� � ��� �������� (� ������ ������� ���� ����� �� �������� �� ����� ������)
SET @UnitPrice = (SELECT unitPrice FROM ProductForSale(@ProductSerialNumber));
SET @totalCost = @QuantityOfProduct * @UnitPrice;

-- ��������� �� �������� - ��������� � DailyTurnover 
INSERT INTO DailyTurnover (serialNumber, numberOfSold, unitPrice, totalCost)
VALUES	(@ProductSerialNumber, @QuantityOfProduct, @UnitPrice, @TotalCost); 

-- �������� �� ������� ������ � ����������� �� � MonthTurnover
INSERT INTO MonthTurnover (date, dailyReport) VALUES (GETDATE(), (SELECT * FROM DailyReport));

-- ��������� �� ����� �� �������� ������ � ���������� ����� � ������, �������� �� ������� MonthlyReportDate,
-- � �� �������� ������ �� MonthlyReport
DECLARE @Month VARCHAR(10), 
		@Year INT,
		@MonthTotalCost FLOAT;

SET @MonthTotalCost = (SELECT monthTotalCost FROM MonthlyReport);
SET @Month = (SELECT DATENAME(month, (SELECT * FROM MonthlyReportDate)));
SET @Year = (SELECT YEAR((SELECT * FROM MonthlyReportDate))); 

-- �������� �� �������� ������ � ����������� �� � OverallTurnover
INSERT INTO OverallTurnover (year, month, cost) VALUES (@Year, @Month, @MonthTotalCost);