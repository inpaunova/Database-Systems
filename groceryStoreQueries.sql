-------------------------------------------- Заявки върху базата данни groceryStore --------------------------------------------
use groceryStore

-------------------------------------------- Прости заявки --------------------------------------------

-- 1. Напишете заявка, която извежда серийния номер , името и цената на храната от тип месо или мляко, където цената е по-малка от 10
SELECT serialNumber, name, unitPrice 
FROM Food
WHERE (kind='meat' OR kind='milky') AND unitPrice < 10
 
-- 2.Напишете заявка, която извежда цената и имената на храните, чийто име започва с кроасан
SELECT name,unitPrice 
FROM Food
WHERE name LIKE ('croissant %')
 
-- 3. Напишете заявка, която извежда серийния номер, име и цена на напитките, които не съдържат алкохол
SELECT serialNumber, name, unitPrice
FROM Drinks
WHERE kind <> 'alcoholic'
 
--4. Напишете заявка, която извежда серийния номер, името и цената на ядките, в чийто име се съдържа ‘mix’
SELECT serialNumber,name,unitPrice
FROM OtherStocks
WHERE kind = 'nuts' and name like '%mix%'


--5. Напишете заявка, която извежда телефонните номера и имената на тези служители, които са CEO или отговарят за млеката, но не са на позиция test
SELECT phoneNumber ,name
FROM Employees
WHERE sector = 'CEO' OR (sector='milky' AND position <> 'test')

-------------------------------------------- Заявки върху две и повече релации --------------------------------------------

-- 1. Напишете заявка, която извежда серийните номера и цената на алкохолните напитки, които са по-малко от 10 в наличност
SELECT Products.serialNumber, unitPrice
FROM Products, Drinks
WHERE kind='alcoholic' AND Products.serialNumber=drinks.serialNumber and Products.numberOfProducts<10
 
-- 2. Напишете заявка, която извежда цената, името и производителя на всички напитки с цена по-висока от цената на ‘Monster "Zero"’
SELECT Drinks.name, Drinks.unitPrice, maker
FROM Products, Drinks, Drinks as ProductOfMonsterZero
WHERE  Products.serialNumber = Drinks.serialNumber 
AND ProductOfMonsterZero.name = 'Monster "Zero"' 
AND Drinks.unitPrice > ProductOfMonsterZero.unitPrice
 
-- 3. Напишете заявка, която извежда името на компанията, телефонния й номер, серийния номер на храната и цената,която се образува като произведение на броя на наличната стока и цената за единична бройка, ако това произведение надхвърля 100
SELECT companyName, phoneNumber, Products.serialNumber, numberOfProducts*unitPrice as totalPrice
FROM Makers, Products, Food
WHERE Makers.companyName = Products.maker 
AND Food.serialNumber = Products.serialNumber 
AND numberOfProducts*unitPrice > 100

-- 4. Напишете заявка, която извежда името, номера на производителя и бройките в наличност на млечните продукти
SELECT companyName, phoneNumber, numberOfProducts
FROM Makers, Products, Food
WHERE Makers.companyName= Products.maker 
AND Food.serialNumber = Products.serialNumber 
AND kind='milky'
 
-- 5. Напишете заявка, която извежда общата стойност на агнешкото месо с производител ‘Boznov’
SELECT maker, name, numberOfProducts*unitPrice as totalValue
FROM Products, Food
WHERE maker='Bozmov' 
AND name ='lamb' 
AND Products.serialNumber = Food.serialNumber


-------------------------------------------- Подзаявки --------------------------------------------

-- 1. Да се извeдат имената на производителите, които имат налични продукти 
-- от тип 'householdGoods' в хранителния магазина.
SELECT companyName 
FROM Makers
WHERE companyName IN (SELECT maker FROM Products WHERE type LIKE 'HouseholdGoods');

-- 2. Да се изведат името, типът и единичната цена на напитките, 
-- чиято цена е по-висока от единичните цени на хранителните продукти.
SELECT name, kind, unitPrice 
FROM Drinks
WHERE unitPrice > ALL (SELECT unitPrice FROM Food);


-- 3. Да се изведат името и цената на цигарите с най-висока цена.
SELECT name, unitPrice
FROM Cigarettes
WHERE unitPrice = (SELECT MAX(unitPrice) FROM Cigarettes);


-- 4. Да се изведе името и телефонният номер на производителите, 
--  чиито продукти са най-продавани за деня.

-- I вариант:
SELECT companyName, phoneNumber
FROM Makers
WHERE companyName IN ( 
                       SELECT p.maker
                       FROM Products p
                       JOIN DailyTurnover dt ON p.serialNumber = dt.serialNumber
                       WHERE dt.numberOfSold = (SELECT MAX(numberOfSold) FROM DailyTurnover)
);

-- II вариант:
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


-- 5. Да се изведе серийният номер, името, наличността и единичната цена на месото, 
-- което е с най-малка наличност в магазина.
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


-- 6. Да се изведе името и цената на алкохолната напитка, с цена по-ниска от тази на 
-- 'Whiskey Jack Daniels 700 ml' и в разфасовка от 1 литър.
SELECT name, unitPrice
FROM Drinks
WHERE kind LIKE 'alcoholic' 
AND name LIKE '%1 l'
AND unitPrice < (SELECT unitPrice FROM Drinks WHERE name LIKE 'Whiskey Jack Daniels 700 ml');


-- 7. Да се изведе серийният номер, името, типът, цената и наличността на продукта 
-- от тип храни или напитки с най-висока цена.
SELECT TOP 1 *
FROM (
       SELECT name, unitPrice FROM Food
	   UNION ALL
	   SELECT name, unitPrice FROM Drinks
) d
ORDER BY d.unitPrice DESC;


-------------------------------------------- Съединения --------------------------------------------

-- 1. Да се изведат телефонните номера на тези компании (различните), които произвеждат храни 
-- и от чиито продукти са налични поне 15 броя в хранителния магазин
SELECT DISTINCT phoneNumber AS 'company phone number'
FROM Makers
JOIN Products ON companyName=maker
WHERE type = 'Food' AND numberOfProducts >= 15

-- 2. Да се изведат личните данни (ЕГН, име, телефонен номер) и позицията, която заемат в магазина, на служителите, 
-- за които няма налични продукти в сектора, за който отговарят. Да се сортира резултата по имената на служителите
SELECT egn,name,phoneNumber,position
FROM Employees
LEFT JOIN Products ON sector = type 
WHERE serialNumber IS NULL
ORDER BY name

-- 3. Да се изведат серийният номер, името, производителят, броят продадени
-- продукти и единичната цена на всички продукти от категория 'HouseholdGoods', 
--за които броят на продадените продукти е не повече от 10% от наличните в магазина продукти.
SELECT Products.serialNumber, name AS 'name of product', maker, numberOfSold, HouseholdGoods.unitPrice
FROM Products
JOIN DailyTurnover ON Products.serialNumber = DailyTurnover.serialNumber
JOIN HouseholdGoods ON Products.serialNumber = HouseholdGoods.serialNumber
WHERE numberOfSold <= 0.1*numberOfProducts 

-- 4. Време е да се поръча стока за магазина. За целта трябва да се проведат 
-- телефонни разговори с всички производители, за да се извършат необходимите поръчки. 
-- Да се напише заявка, която извежда различните типове на продуктите (храни, напитки и т.н.) 
-- и техните производители, за които координатите на производителите липсват в базата от данни 
-- на магазина и следователно е невъзможно те да бъдат поръчани.
SELECT DISTINCT(type), maker
FROM Products p
LEFT JOIN Makers m ON p.maker = m.companyName
WHERE companyName IS NULL

-- 5. Да се изведат имената на производителите, имената на продуктите и единичната им цена 
-- за тези продукти от тип OtherStocks, чиято единична цена е най-много средната единична 
-- цена за всички продукти от този тип.
SELECT maker,name AS 'name of product', unitPrice
FROM OtherStocks os
JOIN Products p ON os.serialNumber=p.serialNumber
WHERE unitPrice <= (SELECT AVG(unitPrice)
					FROM otherStocks) 


-------------------------------------------- Групиране --------------------------------------------

-- 1. Групиране по типа на продуктите. Извеждане на типа и броя продукти, които магазинът предлага от конкретния тип.
SELECT  type, COUNT(type) AS numberOfProducts 
FROM Products 
GROUP BY type
 
-- 2. Групиране по сектора на работа на служителите. Извеждане на сектора и преброяване на хората, които работят в дадения сектор.
SELECT sector, COUNT(sector) AS numberOfPeople 
FROM Employees 
GROUP BY sector
 
-- 3. Групиране на приходите по година. Сумиране на приходите по година.
SELECT year, SUM(cost) AS money 
FROM OverallTurnover 
GROUP BY year
 
-- 4. Групиране по стойността на заплатата на служителите. Преброяване на хората, получаващи съответната заплата.
SELECT salary, COUNT(salary) AS numberOfPeople 
FROM Employees 
GROUP BY salary
 
-- 5. Групириране по телефония номер на производителите, за да се направи справка, колко продукти са поръчани през всеки един от номерата.
SELECT phoneNumber, COUNT(phoneNumber) AS numberOfProducts 
FROM Makers JOIN Products ON Makers.companyName = Products.maker 
GROUP BY phoneNumber

-------------------------------------------- Агрегация --------------------------------------------
-- 1. Избиране на продукта с най-ниска цена от тип Храни (ако има два продукта с равна и минмална цена , ще изведе и двата продукта).
SELECT name  
FROM Food 
WHERE unitPrice = (SELECT MIN(unitPrice) FROM Food)
 

-- 2. Избиране на продукта с най-висока цена от тип Храни (ако има два продукта с равна и минмална цена, ще изведе и двата продукта).
SELECT	name  
FROM Food 
WHERE unitPrice = (SELECT MAX(unitPrice) FROM Food)
 
-- 3. Изчисляване на средната цена на всички млечни продукти.
SELECT 'milky' AS type, AVG(unitPrice) AS averagePrice 
FROM Food 
WHERE kind = 'milky'

-- 4. Изчисляване на средната цена на всички цигари с марка Davidoff.
SELECT 'Davidoff' AS maker, AVG(unitPrice) AS averagePrice 
FROM Cigarettes 
WHERE name LIKE '%Davidoff%'
 
-- 5. Преброяване на всички продукти, които Coca Cola доставя на магазина

SELECT 'Coca Cola' AS maker, COUNT(maker) AS numberOfProducts  
FROM Products 
WHERE maker LIKE '%Coca Cola%'
 
-- 6. Извеждане на броя на различните видове кроасани, които магазина предлага.
SELECT 'Croissant' AS kind, COUNT(name) AS numberOfProducts 
FROM Food 
WHERE name LIKE '%Croissant%'
 

-- 7. Показване на името на продукта, който има най-малко налични бройки и колко налични бройки има магазина в момента 
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


-------------------------------------------- Изгледи и индекси --------------------------------------------

CREATE NONCLUSTERED INDEX ix_Products_Maker
ON Products(maker);

CREATE NONCLUSTERED INDEX ix_Products_Number
ON Products(numberOfProducts);

-- Сериен номер и цена на всички налични продукти в базата на магазина.
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

-- Общо оборот за деня.
CREATE VIEW DailyReport AS 
	SELECT SUM (numberOfSold * unitPrice) AS totalCostOfTheDay
	FROM DailyTurnover;

-- Общо оборот за месеца.
CREATE VIEW MonthlyReport AS 
	SELECT SUM(dailyReport) AS monthTotalCost
	FROM MonthTurnover;

-- Информация за оборота по години.
CREATE VIEW AnnualTurnover AS
	SELECT year, SUM(cost) as annualReport
	FROM OverallTurnover
	GROUP BY year;

-- Датата на последноно добавения запис в MonthTurnover, която ще се използва 
-- при създаването на месечния отчет и прехвърлянето му в OverallTurnover.
CREATE VIEW MonthlyReportDate AS
	SELECT TOP 1 date 
	FROM MonthTurnover
	ORDER BY date DESC;

-------------------------------------------- Тригери --------------------------------------------

-- След продажба на продукт (добавяне на продукт в DailyTurnover) се обновява количеството на съответния продукт
-- (numberOfProducts) в Products.
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

-- В таблицата за дневния оборот има данни за продажбите само за текущия ден, 
-- като след изтичането му те се прехвърлят в обобщен вид в MonthTurnover и се изтриват от DailyTurnover, 
-- за да се изчисти тя за следващия ден. Детайлите около дневния оборот (номер на продукт, 
-- брой продадени, единична цена и обща цена) се изтриват, а не се създава история за тях, защото впоследствие 
-- те няма да ни бъдат необходими, т.е. няма да се налага да ги възстановяваме. 
CREATE TRIGGER tr_RemoveDailyInfo
ON dbo.MonthTurnover
AFTER INSERT 
AS
BEGIN
      DELETE FROM DailyTurnover
END
GO

-- В таблицата за месечния оборот има данни за само за текущия месец, 
-- като след изтичането му те се прехвърлят в обобщен вид OverallTurnover и се изтриват от MonthTurnover, 
-- за да се изчисти тя за следващия месец. Детайлите около месечния оборот (дата и оборот за нея) 
-- се изтриват, а не се създава история за тях, защото впоследствие 
-- те няма да ни бъдат необходими, т.е. няма да се налага да ги възстановяваме. 
CREATE TRIGGER tr_RemoveMonthlyInfo
ON dbo.OverallTurnover
AFTER INSERT 
AS
BEGIN
      DELETE FROM MonthTurnover
END
GO

-------------------------------------------- Допълнителни функции и заявки --------------------------------------------

-- В реална система текущата база данни не съществува самостоятелно, а напротив, част е от по-голяма софтуерна система,
-- в която има и други модули. Базата получава заявки от тях и им връща съответните отговори.

-- Функция, която комуникира със системата на касовата зона и при маркиране приема
-- номера на закупения продукт като параметър и го връща заедно с цената на продукта 
CREATE FUNCTION ProductForSale (@ProductSerialNumber VARCHAR(50)) 
RETURNS TABLE AS 
RETURN 
	SELECT serialNumber, unitPrice
	FROM ProductsPriceAndNumber
	WHERE serialNumber = @ProductSerialNumber;

-- Задаване като променливи на:
--		номера на продукта, който се закупува;
--		количеството на закупувания продукт;
--		единичната цена на продукта, получена от функцията ProductForSale;
--		крайната цена, пресметната въз основа на единичната и количеството на продукта, който се закупува.

DECLARE @ProductSerialNumber VARCHAR(50),
		@QuantityOfProduct FLOAT,
		@UnitPrice FLOAT,
		@TotalCost FLOAT;

SET @ProductSerialNumber = '125313467'; -- серийният номер е въведен ръчно с цел тестване (в реална система този номер се получава от други модули)
SET @QuantityOfProduct = 1; -- броят продукти е въведен ръчно с цел тестване (в реална система този номер се получава от други модули)
SET @UnitPrice = (SELECT unitPrice FROM ProductForSale(@ProductSerialNumber));
SET @totalCost = @QuantityOfProduct * @UnitPrice;

-- Продаване на продукта - записване в DailyTurnover 
INSERT INTO DailyTurnover (serialNumber, numberOfSold, unitPrice, totalCost)
VALUES	(@ProductSerialNumber, @QuantityOfProduct, @UnitPrice, @TotalCost); 

-- Отчитане на дневния оборот и пренасянето му в MonthTurnover
INSERT INTO MonthTurnover (date, dailyReport) VALUES (GETDATE(), (SELECT * FROM DailyReport));

-- Запазване на данни от месечния оборот в променливи месец и година, получени от изгледа MonthlyReportDate,
-- и на месечния оборот от MonthlyReport
DECLARE @Month VARCHAR(10), 
		@Year INT,
		@MonthTotalCost FLOAT;

SET @MonthTotalCost = (SELECT monthTotalCost FROM MonthlyReport);
SET @Month = (SELECT DATENAME(month, (SELECT * FROM MonthlyReportDate)));
SET @Year = (SELECT YEAR((SELECT * FROM MonthlyReportDate))); 

-- Отчитане на месечния оборот и пренасянето му в OverallTurnover
INSERT INTO OverallTurnover (year, month, cost) VALUES (@Year, @Month, @MonthTotalCost);