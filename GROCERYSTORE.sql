USE master
GO

if exists (SELECT * FROM sysdatabases WHERE name = 'groceryStore')
	DROP DATABASE groceryStore
GO

CREATE DATABASE groceryStore
GO

USE groceryStore
GO

----- Create Tables -----

CREATE TABLE Products (
serialNumber VARCHAR(50) NOT NULL,
maker VARCHAR(30) NOT NULL,
type VARCHAR(20) NOT NULL,
numberOfProducts FLOAT NOT NULL
);

CREATE TABLE Food (
serialNumber VARCHAR(50) NOT NULL,
kind VARCHAR(30) NOT NULL,
name VARCHAR(100) NOT NULL,
unitPrice FLOAT NOT NULL
);

CREATE TABLE Drinks (
serialNumber VARCHAR(50) NOT NULL,
kind VARCHAR(30) NOT NULL,
name VARCHAR(100) NOT NULL,
unitPrice FLOAT NOT NULL
);

CREATE TABLE Cigarettes (
serialNumber VARCHAR(50) NOT NULL,
name VARCHAR(100) NOT NULL,
unitPrice FLOAT NOT NULL
);

CREATE TABLE OtherStocks (
serialNumber VARCHAR(50) NOT NULL,
kind VARCHAR(30) NOT NULL,
name VARCHAR(100) NOT NULL,
unitPrice FLOAT NOT NULL
);

CREATE TABLE HouseholdGoods (
serialNumber VARCHAR(50) NOT NULL,
kind VARCHAR(30) NOT NULL,
name VARCHAR(100) NOT NULL,
unitPrice FLOAT NOT NULL
);

CREATE TABLE DailyTurnover (
serialNumber VARCHAR(50) NOT NULL,
numberOfSold INT NOT NULL,
unitPrice FLOAT NOT NULL,
totalCost AS (numberOfSold*unitPrice) PERSISTED
);

-- MonthTurnover: the sum of all total costs for the stocks sold for the day
CREATE TABLE MonthTurnover(
date DATETIME NOT NULL,
dailyReport FLOAT NOT NULL
);

-- OverallTurnover: the sum of all the dailyReport-s for every day of a given month
CREATE TABLE OverallTurnover (
year INT NOT NULL,
month VARCHAR(10) NOT NULL,
cost FLOAT NOT NULL
);

CREATE TABLE Makers (
companyName VARCHAR(30) NOT NULL,
phoneNumber VARCHAR(10) NOT NULL
);

CREATE TABLE Employees (
egn CHAR(10) NOT NULL,
name VARCHAR(30) NOT NULL,
phoneNumber VARCHAR(10) NOT NULL,
appointmentDate DATETIME NOT NULL,
position VARCHAR(50) NOT NULL,
sector VARCHAR(50) NOT NULL,
salary FLOAT NOT NULL
);

-------------------------------------------- Creating Constraints --------------------------------------------

-- Primary keys
ALTER TABLE Products ADD CONSTRAINT pk_Products PRIMARY KEY (serialNumber);
ALTER TABLE Food ADD CONSTRAINT pk_Food PRIMARY KEY (serialNumber);
ALTER TABLE Drinks ADD CONSTRAINT pk_Drinks PRIMARY KEY (serialNumber);
ALTER TABLE Cigarettes ADD CONSTRAINT pk_Cigarettes PRIMARY KEY (serialNumber);
ALTER TABLE OtherStocks ADD CONSTRAINT pk_OtherStocs PRIMARY KEY (serialNumber);
ALTER TABLE HouseholdGoods ADD CONSTRAINT pk_HouseholdGoods PRIMARY KEY (serialNumber);
ALTER TABLE DailyTurnover ADD CONSTRAINT pk_DailyTurnover PRIMARY KEY (serialNumber);
ALTER TABLE MonthTurnover ADD CONSTRAINT pk_MonthTurnover PRIMARY KEY (date);
ALTER TABLE OverallTurnover ADD CONSTRAINT pk_OverallTurnover PRIMARY KEY (year,month);
ALTER TABLE Makers ADD CONSTRAINT pk_Makers PRIMARY KEY (companyName);
ALTER TABLE Employees ADD CONSTRAINT pk_Åmployees PRIMARY KEY (egn);

-- Foreign keys
ALTER TABLE Products ADD CONSTRAINT fk_Products_Makers FOREIGN KEY(maker) REFERENCES Makers(companyName);
ALTER TABLE Food ADD CONSTRAINT fk_Food_Products FOREIGN KEY (serialNumber) REFERENCES Products(serialNumber);
ALTER TABLE Drinks ADD CONSTRAINT fk_Drinks_Products FOREIGN KEY (serialNumber) REFERENCES Products(serialNumber);
ALTER TABLE Cigarettes ADD CONSTRAINT fk_Cigarettes_Products FOREIGN KEY (serialNumber) REFERENCES Products(serialNumber);
ALTER TABLE OtherStocks ADD CONSTRAINT fk_OtherStocks_Products FOREIGN KEY (serialNumber) REFERENCES Products(serialNumber);
ALTER TABLE HouseholdGoods ADD CONSTRAINT fk_HouseholdGoods_Products FOREIGN KEY (serialNumber) REFERENCES Products(serialNumber);
ALTER TABLE DailyTurnover ADD CONSTRAINT fk_DailyTurnover_Products FOREIGN KEY (serialNumber) REFERENCES Products(serialNumber);


-- Check constraints

-- Products 
ALTER TABLE Products ADD CONSTRAINT ck_Products_serialNumber CHECK(LEN(serialNumber) > 0)
ALTER TABLE Products ADD CONSTRAINT ck_Products_maker CHECK(LEN(maker) > 0)
ALTER TABLE Products ADD CONSTRAINT ck_Products_type CHECK(LEN(type) > 0)
ALTER TABLE Products ADD CONSTRAINT ck_Products_numberOfProducts CHECK(numberOfProducts >= 0)

-- Food
ALTER TABLE Food ADD CONSTRAINT ck_Food_serialNumber CHECK(LEN(serialNumber) > 0)
ALTER TABLE Food ADD CONSTRAINT ck_Food_kind CHECK(LEN(kind) > 0)
ALTER TABLE Food ADD CONSTRAINT ck_Food_name CHECK(LEN(name) > 0)
ALTER TABLE Food ADD CONSTRAINT ck_Food_unitPrice CHECK(unitPrice > 0)

-- Drinks
ALTER TABLE Drinks ADD CONSTRAINT ck_Drinks_serialNumber CHECK(LEN(serialNumber) > 0)
ALTER TABLE Drinks ADD CONSTRAINT ck_Drinks_kind CHECK(LEN(kind) > 0)
ALTER TABLE Drinks ADD CONSTRAINT ck_Drinks_name CHECK(LEN(name) > 0)
ALTER TABLE Drinks ADD CONSTRAINT ck_Drinks_unitPrice CHECK(unitPrice > 0)

-- Cigarettes
ALTER TABLE Cigarettes ADD CONSTRAINT ck_Cigarettes_serialNumber CHECK(LEN(serialNumber) > 0)
ALTER TABLE Cigarettes ADD CONSTRAINT ck_Cigarettes_name CHECK(LEN(name) > 0)
ALTER TABLE Cigarettes ADD CONSTRAINT ck_Cigarettes_unitPrice CHECK(unitPrice > 0)

-- OtherStocks
ALTER TABLE OtherStocks ADD CONSTRAINT ck_OtherStocks_serialNumber CHECK(LEN(serialNumber) > 0)
ALTER TABLE OtherStocks ADD CONSTRAINT ck_OtherStocks_kind CHECK(LEN(kind) > 0)
ALTER TABLE OtherStocks ADD CONSTRAINT ck_OtherStocks_name CHECK(LEN(name) > 0)
ALTER TABLE OtherStocks ADD CONSTRAINT ck_OtherStocks_unitPrice CHECK(unitPrice > 0)

-- HouseholdGoods
ALTER TABLE HouseholdGoods ADD CONSTRAINT ck_HouseholdGoods_serialNumber CHECK(LEN(serialNumber) > 0)
ALTER TABLE HouseholdGoods ADD CONSTRAINT ck_HouseholdGoods_kind CHECK(LEN(kind) > 0)
ALTER TABLE HouseholdGoods ADD CONSTRAINT ck_HouseholdGoods_name CHECK(LEN(name) > 0)
ALTER TABLE HouseholdGoods ADD CONSTRAINT ck_HouseholdGoods_unitPrice CHECK(unitPrice > 0)

-- MonthTurnover
ALTER TABLE MonthTurnover ADD CONSTRAINT ck_MonthTurnover_date CHECK(ISDATE(date)=1)

-- Makers
ALTER TABLE Makers ADD CONSTRAINT ck_Makers_companyName CHECK(LEN(companyName) > 0)
ALTER TABLE Makers ADD CONSTRAINT ck_Makers_phoneNumber CHECK(LEN(phoneNumber) > 0)

-- Employees
ALTER TABLE Employees ADD CONSTRAINT ck_Employees_name CHECK(LEN(name) > 0)
ALTER TABLE Employees ADD CONSTRAINT ck_Employees_phoneNumber CHECK(LEN(phoneNumber) > 0)
ALTER TABLE Employees ADD CONSTRAINT ck_Employees_appointmentDate CHECK(ISDATE(appointmentDate)=1)
ALTER TABLE Employees ADD CONSTRAINT ck_Employees_position CHECK(LEN(position) > 0)
ALTER TABLE Employees ADD CONSTRAINT ck_Employees_sector CHECK(LEN(sector) > 0)
ALTER TABLE Employees ADD CONSTRAINT ck_Employees_salary CHECK(salary > 0)


-------------------------------------------- Adding values into table Makers --------------------------------------------

INSERT INTO Makers VALUES ('Bozmov','0841594610'); 
INSERT INTO Makers VALUES ('Milk Heaven','084636242'); 
INSERT INTO Makers VALUES ('7 days Bulgaria','024234251'); 
INSERT INTO Makers VALUES ('Coca Cola Bulgaria','053965399'); 
INSERT INTO Makers VALUES ('Monster Bulgaria','0254924524'); 
INSERT INTO Makers VALUES ('Jameson','031752854'); 
INSERT INTO Makers VALUES ('Jack Daniels','062954252'); 
INSERT INTO Makers VALUES ('Savoy','0192412643'); 
INSERT INTO Makers VALUES ('Devin','0249632946'); 
INSERT INTO Makers VALUES ('Davidoff','0234262727'); 
INSERT INTO Makers VALUES ('Marlboro','0296242426'); 
INSERT INTO Makers VALUES ('Parliament','094769476'); 
INSERT INTO Makers VALUES ('Semana','0435353411'); 
INSERT INTO Makers VALUES ('Fairy','0246924765'); 
INSERT INTO Makers VALUES ('Household Goods Bulgaria','029364926'); 
INSERT INTO Makers VALUES ('Emeka','0492649264'); 
INSERT INTO Makers VALUES ('Orbit','026429549'); 
INSERT INTO Makers VALUES ('Lays','016491643'); 
INSERT INTO Makers VALUES ('Grivas','0286412845'); 
INSERT INTO Makers VALUES ('Cappy','0856723123'); 

-------------------------------------------- Adding values into table Products --------------------------------------------

-- Type Food

-- Meat products
INSERT INTO Products VALUES ('151732347','Bozmov','Food',20.0); -- beaf
INSERT INTO Products VALUES ('151732348','Bozmov','Food',25.5); -- lamb
INSERT INTO Products VALUES ('151732349','Bozmov','Food',30.5); -- chicken

-- Milky products
INSERT INTO Products VALUES ('654816513','Milk Heaven','Food',10.0); -- yellow cheese
INSERT INTO Products VALUES ('654816514','Milk Heaven','Food',15.0); -- white cheese
INSERT INTO Products VALUES ('654816515','Milk Heaven','Food',40); -- yoghurt 500gr

-- Snack
INSERT INTO Products VALUES ('561792742','7 days Bulgaria','Food',50); -- croissant chocolate
INSERT INTO Products VALUES ('561792743','7 days Bulgaria','Food',50); -- croissant cream "Brule"
INSERT INTO Products VALUES ('561792744','7 days Bulgaria','Food',50); -- croissant cream "Cherry"	

-- Type Drinks

-- Non-alcoholic drinks
INSERT INTO Products VALUES ('809412896','Coca Cola Bulgaria','Drinks',30); -- Coca Cola 0,500 l
INSERT INTO Products VALUES ('809412897','Coca Cola Bulgaria','Drinks',20); -- Coca Cola 2 l
INSERT INTO Products VALUES ('809412898','Coca Cola Bulgaria','Drinks',20); -- Fanta 2 l
INSERT INTO Products VALUES ('809412899','Coca Cola Bulgaria','Drinks',20); -- Sprite 2 l
INSERT INTO Products VALUES ('481623946','Cappy','Drinks',20); -- Cappy juice "Apple"
INSERT INTO Products VALUES ('481623947','Cappy','Drinks',20); -- Cappy juice "Orange"
INSERT INTO Products VALUES ('481623948','Cappy','Drinks',20); -- Cappy juice "Banana"

-- Water
INSERT INTO Products VALUES ('151637234','Devin','Drinks',30); -- Water 1,5 liter
INSERT INTO Products VALUES ('151637235','Devin','Drinks',50); -- Water 0,5 liter
INSERT INTO Products VALUES ('151637236','Devin','Drinks',10); -- Water 10 liters

-- Energy drinks
INSERT INTO Products VALUES ('156186573','Monster Bulgaria','Drinks',10); -- Energy drink "Classic"
INSERT INTO Products VALUES ('156186574','Monster Bulgaria','Drinks',5); -- Energy drink "Ultra red"
INSERT INTO Products VALUES ('156186575','Monster Bulgaria','Drinks',5); -- Energy drink "Ultra blue"
INSERT INTO Products VALUES ('156186576','Monster Bulgaria','Drinks',5); -- Energy drink "Zero"

-- Alcoholic drinks
INSERT INTO Products VALUES ('715017555','Jameson','Drinks',5); -- Whiskey Jameson 1 l
INSERT INTO Products VALUES ('715017556','Jameson','Drinks',5); -- Whiskey Jameson 700 ml
INSERT INTO Products VALUES ('916641477','Jack Daniels','Drinks',5); -- Whiskey Jack Daniels 1 l
INSERT INTO Products VALUES ('916641476','Jack Daniels','Drinks',5); -- Whiskey Jack Daniels 700 ml
INSERT INTO Products VALUES ('507207575','Savoy','Drinks',5); -- Whiskey Savoy 1 l
INSERT INTO Products VALUES ('507207576','Savoy','Drinks',5); -- Vodka Savoy l

-- Type Cigarettes
INSERT INTO Products VALUES ('156196505','Davidoff','Cigarettes',20); -- Davidoff Silver
INSERT INTO Products VALUES ('156196506','Davidoff','Cigarettes',20); -- Davidoff Gold
INSERT INTO Products VALUES ('156196507','Davidoff','Cigarettes',20); -- Davidoff Classic
INSERT INTO Products VALUES ('156196508','Davidoff','Cigarettes',20); -- Davidoff Slims 
INSERT INTO Products VALUES ('769159715','Marlboro','Cigarettes',20); -- Marlboro Red 
INSERT INTO Products VALUES ('769159716','Marlboro','Cigarettes',20); -- Marlboro Black 
INSERT INTO Products VALUES ('713163193','Parliament','Cigarettes',20); --Parliament Classic

-- Type Household goods
INSERT INTO Products VALUES ('236464845','Semana','HouseholdGoods',10); -- fabric softener "Freshness"
INSERT INTO Products VALUES ('236464846','Semana','HouseholdGoods',10); -- washing powder "Îlowers"
INSERT INTO Products VALUES ('762755341','Fairy','HouseholdGoods',20); -- dishwashing detergent "Lemon"
INSERT INTO Products VALUES ('762755342','Fairy','HouseholdGoods',20); -- dishwashing detergent "Mint"
INSERT INTO Products VALUES ('924647204','Household Goods Bulgaria','HouseholdGoods',3); -- plastic basin 15 l
INSERT INTO Products VALUES ('924647205','Emeka','HouseholdGoods',20); -- toilet paper

-- Type OtherStocks
INSERT INTO Products VALUES ('456123578','Orbit','OtherStocks',50); -- gums "Mint"
INSERT INTO Products VALUES ('456123579','Orbit','OtherStocks',50); --gums "Double Mint"
INSERT INTO Products VALUES ('151345366','Lays','OtherStocks',10); -- Lays "Cheese"
INSERT INTO Products VALUES ('151345367','Lays','OtherStocks',10); -- Lays "Pepper"
INSERT INTO Products VALUES ('125313466','Grivas','OtherStocks',20); -- peanuts
INSERT INTO Products VALUES ('125313467','Grivas','OtherStocks',20); -- seeds
INSERT INTO Products VALUES ('125313468','Grivas','OtherStocks',20); -- party mix
INSERT INTO Products VALUES ('125313469','Grivas','OtherStocks',20); -- beer peanuts


-------------------------------------------- Adding values into table Food --------------------------------------------

INSERT INTO Food VALUES ('151732347','meat','beaf',16.5); -- beaf
INSERT INTO Food VALUES ('151732348','meat','lamb',15); -- lamb
INSERT INTO Food VALUES ('151732349','meat','chicken',6); --chicken

INSERT INTO Food VALUES ('654816513','milky','yellow cheese',12.2); --yellow cheese
INSERT INTO Food VALUES ('654816514','milky','white cheese',9.8); --white cheese
INSERT INTO Food VALUES ('654816515','milky','yoghurt 500 gr',0.95); --yoghurt 500 gr

INSERT INTO Food VALUES ('561792742','snack','croissant "Chocolate"',0.9); --croissant "Chocolate"
INSERT INTO Food VALUES ('561792743','snack','croissant cream "Brule"',0.9); --croissant cream "Brule"
INSERT INTO Food VALUES ('561792744','snack','croissant cream "Cherry"',0.9); --croissant cream "Cherry"


-------------------------------------------- Adding values into table Drinks --------------------------------------------

-- Non-alcoholic drinks
INSERT INTO Drinks VALUES ('809412896','non-alcoholic','Coca Cola 0,500 l',1.2); --Coca Cola 0,500 l
INSERT INTO Drinks VALUES ('809412897','non-alcoholic','Coca Cola 2 l',2.5); --Coca Cola 2 l
INSERT INTO Drinks VALUES ('809412898','non-alcoholic','Fanta 2 l',2.4); --Fanta 2 l
INSERT INTO Drinks VALUES ('809412899','non-alcoholic','Sprite 2 l',2.3); --Sprite 2 l
INSERT INTO Drinks VALUES ('481623946','non-alcoholic','Cappy juice "Apple"',2); --Cappy juice "Apple"
INSERT INTO Drinks VALUES ('481623947','non-alcoholic','Cappy juice "Orange"',2); --Cappy juice "Orange"
INSERT INTO Drinks VALUES ('481623948','non-alcoholic','Cappy juice "Banana"',2); --Cappy juice "Banana"

-- Water
INSERT INTO drinks VALUES ('151637234','water','Water Devin 1,5 l',1.6); --Water 1,5 l
INSERT INTO drinks VALUES ('151637235','water','Water Devin 0,5 l',0.7); --Water 0,5 l
INSERT INTO drinks VALUES ('151637236','water','Water Devin 10 l',3.2); --Water 10 l

-- Energy drinks
INSERT INTO Drinks VALUES ('156186573','energy','Monster "Classic"',1.99); --Monster "Classic"
INSERT INTO Drinks VALUES ('156186574','energy','Monster "Ultra red"',1.99); --Monster "Ultra red"
INSERT INTO Drinks VALUES ('156186575','energy','Monster "Ultra blue"',1.99); --Monster "Ultra blue"
INSERT INTO Drinks VALUES ('156186576','energy','Monster "Zero"',1.99); --Monster "Zero"

-- Alcoholic drinks
INSERT INTO Drinks VALUES ('715017555','alcoholic','Whiskey Jameson 1 l',28.99); --Whiskey Jameson 1 l
INSERT INTO Drinks VALUES ('715017556','alcoholic','Whiskey Jameson 700 ml',21.99); --Whiskey Jameson 700 ml
INSERT INTO Drinks VALUES ('916641477','alcoholic','Whiskey Jack Daniels 1 l',46); --Whiskey Jack Daniels 1 l
INSERT INTO Drinks VALUES ('916641476','alcoholic','Whiskey Jack Daniels 700 ml',39.99); --Whiskey Jack Daniels 700 ml
INSERT INTO Drinks VALUES ('507207575','alcoholic','Whiskey Savoy 1 l',12); --Whiskey Savoy 1 l
INSERT INTO Drinks VALUES ('507207576','alcoholic','Vodka Savoy 1 l',9.99); --Vodka Savoy l


-------------------------------------------- Adding values into table Cigarettes --------------------------------------------

INSERT INTO Cigarettes VALUES ('156196505','Davidoff Silver',5.2); --Davidoff Silver
INSERT INTO Cigarettes VALUES ('156196506','Davidoff Gold',5.3); --Davidoff Gold
INSERT INTO Cigarettes VALUES ('156196507','Davidoff Classic',5); --Davidoff Classic
INSERT INTO Cigarettes VALUES ('156196508','Davidoff Slims',5.1); --Davidoff Slims 
INSERT INTO Cigarettes VALUES ('769159715','Marlboro Red',5.6); --Marlboro Red 
INSERT INTO Cigarettes VALUES ('769159716','Marlboro Black',5.7); --Marlboro Black 
INSERT INTO cigarettes VALUES ('713163193','Parliament Classic',6.1); --Parliament Classic


-------------------------------------------- Adding values into table HouseholdGoods --------------------------------------------

INSERT INTO HouseholdGoods VALUES ('236464845','detergents','fabric softener "Freshness" Semana',7.5); -- fabric softener "Freshness"
INSERT INTO HouseholdGoods VALUES ('236464846','detergents','washing powder "Flowers" Semana" Semana',12.5); -- washing powder "Îlowers"
INSERT INTO HouseholdGoods VALUES ('762755341','cleaning','dishwashing detergent "Lemon" Fairy',4.5); -- dishwashing detergent "Lemon"
INSERT INTO HouseholdGoods VALUES ('762755342','cleaning','dishwashing detergent "Mint" Fairy',5); -- dishwashing detergent "Mint"
INSERT INTO HouseholdGoods VALUES ('924647204','other','plastic basin 15 l',6); -- plastic basin 15 l
INSERT INTO HouseholdGoods VALUES ('924647205','other','toilet paper',19.99); -- toilet paper


-------------------------------------------- Adding values into table OtherStocks --------------------------------------------
INSERT INTO OtherStocks VALUES ('456123578','gums','gums "Mint" Orbit 10 gr',1); --gums "Mint"
INSERT INTO OtherStocks VALUES ('456123579','gums','gums "Double Mint" Orbit 10 gr',1); --gums "Double Mint"
INSERT INTO OtherStocks VALUES ('151345366','snack','chips Lays "Cheese" 200 gr',2.4); --Lays  "Cheese"
INSERT INTO OtherStocks VALUES ('151345367','snack','chips Lays "Pepper" 200 gr',2.6); --Lays "Pepper"
INSERT INTO OtherStocks VALUES ('125313466','nuts','peanuts Grivas 500 gr',4); --peanuts
INSERT INTO OtherStocks VALUES ('125313467','nuts','seeds Grivas 500 gr',2.1); --seeds
INSERT INTO OtherStocks VALUES ('125313468','nuts','party mix Grivas 500 gr',3.5); --party mix
INSERT INTO OtherStocks VALUES ('125313469','nuts','beer peanuts Grivas 500 gr',2.1); --beer peanuts

-------------------------------------------- Adding values into table DailyTurnover --------------------------------------------
INSERT INTO DailyTurnover VALUES ('654816513',2.5,12.2); 
INSERT INTO DailyTurnover VALUES ('156186575',1,5);
INSERT INTO DailyTurnover VALUES ('156196506',3,5.3);
INSERT INTO DailyTurnover VALUES ('762755342',1,5);
INSERT INTO DailyTurnover VALUES ('125313466',2,4);
INSERT INTO DailyTurnover VALUES ('125313469',2,2.1);

-------------------------------------------- Adding values into table MonthTurnover --------------------------------------------
INSERT INTO MonthTurnover VALUES ('2020-04-1',200.6);
INSERT INTO MonthTurnover VALUES ('2020-04-2',215.0);
INSERT INTO MonthTurnover VALUES ('2020-04-3',223.6);
INSERT INTO MonthTurnover VALUES ('2020-04-4',223.9);
INSERT INTO MonthTurnover VALUES ('2020-04-5',345.3);
INSERT INTO MonthTurnover VALUES ('2020-04-6',643.0);
INSERT INTO MonthTurnover VALUES ('2020-04-7',242.5);
INSERT INTO MonthTurnover VALUES ('2020-04-8',124.6);
INSERT INTO MonthTurnover VALUES ('2020-04-9',451.2);
INSERT INTO MonthTurnover VALUES ('2020-04-10',20.5);
INSERT INTO MonthTurnover VALUES ('2020-04-11',312.6);
INSERT INTO MonthTurnover VALUES ('2020-04-12',212.2);
INSERT INTO MonthTurnover VALUES ('2020-04-13',100.7);
INSERT INTO MonthTurnover VALUES ('2020-04-14',900.0);
INSERT INTO MonthTurnover VALUES ('2020-04-15',230.3);
INSERT INTO MonthTurnover VALUES ('2020-04-16',320.7);
INSERT INTO MonthTurnover VALUES ('2020-04-17',700.3);
INSERT INTO MonthTurnover VALUES ('2020-04-18',223.6);
INSERT INTO MonthTurnover VALUES ('2020-04-19',223.9);
INSERT INTO MonthTurnover VALUES ('2020-04-20',345.3);
INSERT INTO MonthTurnover VALUES ('2020-04-21',643.0);
INSERT INTO MonthTurnover VALUES ('2020-04-22',242.5);
INSERT INTO MonthTurnover VALUES ('2020-04-23',124.6);
INSERT INTO MonthTurnover VALUES ('2020-04-24',451.2);
INSERT INTO MonthTurnover VALUES ('2020-04-25',20.5);
INSERT INTO MonthTurnover VALUES ('2020-04-26',312.6);
INSERT INTO MonthTurnover VALUES ('2020-04-27',212.2);
INSERT INTO MonthTurnover VALUES ('2020-04-28',100.7);
INSERT INTO MonthTurnover VALUES ('2020-04-29',900.0);
INSERT INTO MonthTurnover VALUES ('2020-04-30',230.3);

-------------------------------------------- Adding values into table OverallTurnover --------------------------------------------
INSERT INTO OverallTurnover VALUES (2019,'November',7000);
INSERT INTO OverallTurnover VALUES (2019,'December',12000);
INSERT INTO OverallTurnover VALUES (2020,'January',8240.6);
INSERT INTO OverallTurnover VALUES (2020,'February',10873.8);
INSERT INTO OverallTurnover VALUES (2020,'March',12394.9);


-------------------------------------------- Adding values into table Employees -------------------------------------------------
INSERT INTO Employees VALUES ('123452898','Martin Ivanov','0957654217','2017-10-10','main','meat',1234);
INSERT INTO Employees VALUES ('124214566','Emil Popov','0987651217','2017-10-10','main','drinks',1234);
INSERT INTO Employees VALUES ('123412892','Ivo Andonov','0987624217','2016-10-10','main','CEO',1234);
INSERT INTO Employees VALUES ('425371345','Iva Marinova','0286482464','2019-10-10','test','drinks',1234);
INSERT INTO Employees VALUES ('137463145','Petq Goshova','0285414619','2019-10-10','test','milky',1234);
INSERT INTO Employees VALUES ('515161616','Petur Peshov','0281414619','2019-09-10','cashier','checkout',1000);
