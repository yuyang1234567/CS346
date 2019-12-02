DROP database IF EXISTS tpcholtp;
create database tpcholtp;
use tpcholtp;
source ~/CS346cwk/tpch.sql;






-- Import Data from the .txt files --
LOAD DATA INFILE '~/CS346cwk/tpch-files/supplier.txt' INTO TABLE supplier FIELDS TERMINATED BY ','  OPTIONALLY ENCLOSED BY '"'  LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE '~/CS346cwk/tpch-files/customer.txt' INTO TABLE customer FIELDS TERMINATED BY ','  OPTIONALLY ENCLOSED BY '"'  LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE '~/CS346cwk/tpch-files/part.txt' INTO TABLE part FIELDS TERMINATED BY ','  OPTIONALLY ENCLOSED BY '"'  LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE '~/CS346cwk/tpch-files/partsupp.txt' INTO TABLE partsupp FIELDS TERMINATED BY ','  OPTIONALLY ENCLOSED BY '"'  LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE '~/CS346cwk/tpch-files/region.txt' INTO TABLE region FIELDS TERMINATED BY ','  OPTIONALLY ENCLOSED BY '"'  LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE '~/CS346cwk/tpch-files/nation.txt' INTO TABLE nation FIELDS TERMINATED BY ','  OPTIONALLY ENCLOSED BY '"'  LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE '~/CS346cwk/tpch-files/orders.txt' INTO TABLE orders FIELDS TERMINATED BY ','  OPTIONALLY ENCLOSED BY '"'  LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
LOAD DATA INFILE '~/CS346cwk/tpch-files/lineitem.txt' INTO TABLE lineitem FIELDS TERMINATED BY ','  OPTIONALLY ENCLOSED BY '"'  LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

-- Tune the tpcholtp database by adding all appropriate keys --
ALTER TABLE region ADD PRIMARY KEY (R_REGIONKEY);
ALTER TABLE part ADD PRIMARY KEY (P_PARTKEY);
ALTER TABLE nation ADD PRIMARY KEY (N_NATIONKEY);
ALTER TABLE nation ADD FOREIGN KEY (N_REGIONKEY) REFERENCES region (R_REGIONKEY);
ALTER TABLE customer ADD PRIMARY KEY (C_CUSTKEY);
ALTER TABLE customer ADD FOREIGN KEY (C_NATIONKEY) REFERENCES nation (N_NATIONKEY);
ALTER TABLE orders ADD PRIMARY KEY (O_ORDERKEY);
ALTER TABLE orders ADD FOREIGN KEY (O_CUSTKEY) REFERENCES customer (C_CUSTKEY);
ALTER TABLE supplier ADD PRIMARY KEY (S_SUPPKEY);
ALTER TABLE supplier ADD FOREIGN KEY (S_NATIONKEY) REFERENCES nation (N_NATIONKEY);
ALTER TABLE partsupp ADD FOREIGN KEY (PS_PARTKEY) REFERENCES part (P_PARTKEY);
ALTER TABLE partsupp ADD FOREIGN KEY (PS_SUPPKEY) REFERENCES supplier (S_SUPPKEY);
ALTER TABLE partsupp ADD CONSTRAINT PS_Key UNIQUE (PS_PARTKEY, PS_SUPPKEY);
ALTER TABLE lineitem ADD FOREIGN KEY (L_PARTKEY) REFERENCES part (P_PARTKEY);
ALTER TABLE lineitem ADD FOREIGN KEY (L_SUPPKEY) REFERENCES supplier (S_SUPPKEY);
ALTER TABLE lineitem ADD FOREIGN KEY (L_ORDERKEY) REFERENCES orders (O_ORDERKEY);
ALTER TABLE lineitem ADD CONSTRAINT L_Key UNIQUE (L_ORDERKEY, L_PARTKEY, L_SUPPKEY, L_LINENUMBER);

-- Create the VIEW to generate the shape tables in tpcholap --
CREATE VIEW Product AS
SELECT P_PARTKEY AS ProductKey,
P_NAME AS Name,
P_MFGR AS Mfgr,
P_BRAND AS Brand,
P_TYPE AS Type,
P_SIZE AS Size,
P_CONTAINER AS Container,
P_RETAILPRICE AS RetailPrice,
CAST(MIN(partsupp.PS_SUPPLYCOST) AS decimal(18, 2)) AS MinCost,
CAST(MAX(partsupp.PS_SUPPLYCOST) AS decimal(18, 2)) AS MaxCost,
CAST(AVG(partsupp.PS_SUPPLYCOST) AS decimal(18, 2)) AS AvgCost
FROM part RIGHT JOIN partsupp
ON part.P_PARTKEY=partsupp.PS_PARTKEY
GROUP BY part.P_PARTKEY
;
-- ALTER TABLE Product ADD PRIMARY KEY (ProductKey);

CREATE VIEW Customer AS
SELECT C_CUSTKEY AS CustKey,
C_NAME AS Name,
N_NAME AS Nation,
R_NAME AS Region,
C_MKTSEGMENT AS MktSegment
FROM customer LEFT JOIN nation
ON customer.C_NATIONKEY=nation.N_NATIONKEY
LEFT JOIN region
ON nation.N_REGIONKEY=region.R_REGIONKEY
GROUP BY customer.C_CUSTKEY
;
-- ALTER TABLE Customer ADD PRIMARY KEY (CustKey);

CREATE TABLE holiday (
H_id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
H_date DATETIME
);
INSERT INTO holiday (H_date) VALUES ('1992-01-01'), ('1992-04-17'), ('1992-05-04'), ('1992-05-25'), ('1992-12-25'), ('1992-12-26');
INSERT INTO holiday (H_date) VALUES ('1993-01-01'), ('1993-04-09'), ('1993-05-03'), ('1993-05-31'), ('1993-12-27'), ('1993-12-28');
INSERT INTO holiday (H_date) VALUES ('1994-01-03'), ('1994-04-01'), ('1994-05-02'), ('1994-05-30'), ('1994-12-26'), ('1994-12-27');
INSERT INTO holiday (H_date) VALUES ('1995-01-02'), ('1995-04-14'), ('1995-05-08'), ('1995-05-29'), ('1995-12-25'), ('1995-12-26');
INSERT INTO holiday (H_date) VALUES ('1996-01-01'), ('1996-04-05'), ('1996-05-06'), ('1996-05-27'), ('1996-12-25'), ('1996-12-26');
INSERT INTO holiday (H_date) VALUES ('1997-01-01'), ('1997-03-28'), ('1997-05-05'), ('1997-05-26'), ('1997-12-25'), ('1997-12-26');
INSERT INTO holiday (H_date) VALUES ('1998-01-01'), ('1998-04-10'), ('1998-05-04'), ('1998-05-25');

CREATE VIEW Time AS
SELECT DISTINCT O_ORDERDATE AS Date,
TO_DAYS(O_ORDERDATE) AS TimeKey,
DAYOFWEEK(O_ORDERDATE) AS Day_of_week,
DAYOFYEAR(O_ORDERDATE) AS Day_in_number,
WEEKOFYEAR(O_ORDERDATE) AS Week_in_year,
MONTH(O_ORDERDATE) AS Month,
YEAR(O_ORDERDATE) AS Year,
QUARTER(O_ORDERDATE) AS Quarter,
IF(EXISTS(SELECT * from holiday WHERE H_DATE=O_ORDERDATE),'holiday','working day') AS Holiday_flag,
IF((WEEKDAY(O_ORDERDATE) =5 OR WEEKDAY(O_ORDERDATE)=6),'weekend','weekday') AS Weekday_flag
FROM orders
ORDER BY Date ASC;

CREATE VIEW Sales AS
SELECT L_PARTKEY AS ProductKey,
TO_DAYS(O_ORDERDATE) AS TimeKey,
O_CUSTKEY AS CustKey,
L_QUANTITY AS Quantity,
L_EXTENDEDPRICE/L_QUANTITY AS ExtendedPrice
FROM orders
RIGHT JOIN lineitem ON O_ORDERKEY=L_ORDERKEY;

DROP database IF EXISTS tpcholap;
create database tpcholap;
use tpcholap;
CREATE TABLE Product(
  ProductKey int NOT NULL,
  Name varchar (55) NULL ,
  Mfgr char (25) NULL ,
  Brand char (10) NULL ,
  Type varchar (25) NULL ,
  Size int NULL ,
  Container char (10) NULL ,
  RetailPrice decimal(18, 2) NULL ,
  MinCost decimal(18, 2) NULL ,
  MaxCost decimal(18, 2) NULL ,
  AvgCost decimal(18, 2) NULL ,
  PRIMARY KEY (ProductKey)
);

CREATE TABLE Customer(
  CustKey int NOT NULL,
  Name varchar (25) NULL ,
  Nation char (25) NULL ,
  Region char (25) NULL,
  MktSegment char (10) NULL,
  PRIMARY KEY (CustKey)
);

CREATE TABLE Time (
Date datetime NOT NULL ,
TimeKey int NOT NULL PRIMARY KEY ,
Day_of_week TINYINT NOT NULL ,
Day_in_number int NOT NULL ,
Week_in_year int NOT NULL ,
Month int NOT NULL ,
Year int NOT NULL ,
Quarter int NOT NULL ,
Holiday_flag VARCHAR(16) ,
Weekday_flag VARCHAR(16)
);

CREATE TABLE Sales (
SalesKey int NOT NULL AUTO_INCREMENT PRIMARY KEY ,
ProductKey int NULL ,
TimeKey int NULL ,
CustKey int NULL ,
Quantity int NULL ,
ExtendedPrice decimal(18, 2) NULL,
FOREIGN KEY (ProductKey) REFERENCES Product (ProductKey),
FOREIGN KEY (TimeKey) REFERENCES Time (TimeKey),
FOREIGN KEY (CustKey) REFERENCES Customer (CustKey)
);
INSERT INTO Product SELECT * FROM tpcholtp.Product;
INSERT INTO Customer SELECT * FROM tpcholtp.Customer;
INSERT INTO Time SELECT * FROM tpcholtp.Time;
INSERT INTO Sales (ProductKey, TimeKey, CustKey, Quantity, ExtendedPrice)
  SELECT ProductKey,TimeKey, CustKey, Quantity, ExtendedPrice
  FROM tpcholtp.Sales;
