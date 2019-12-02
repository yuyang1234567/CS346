CREATE TABLE Product
SELECT P_PARTKEY AS ProductKey,
P_NAME AS Name,
P_MFGR AS Mfgr,
P_BRAND AS Brand,
P_TYPE AS Type,
P_SIZE AS Size,
P_CONTAINER AS Container,
P_RETAILPRICE AS RetailPrice,
CAST(MIN(tpch.partsupp.PS_SUPPLYCOST) AS decimal(18, 2)) AS MinCost,
CAST(MAX(tpch.partsupp.PS_SUPPLYCOST) AS decimal(18, 2)) AS MaxCost,
CAST(AVG(tpch.partsupp.PS_SUPPLYCOST) AS decimal(18, 2)) AS AvgCost
FROM tpch.part RIGHT JOIN tpch.partsupp
ON tpch.part.P_PARTKEY=tpch.partsupp.PS_PARTKEY
GROUP BY tpch.part.P_PARTKEY
;
ALTER TABLE Product ADD PRIMARY KEY (ProductKey);

CREATE TABLE Customer
SELECT C_CUSTKEY AS CustKey,
C_NAME AS Name,
N_NAME AS Nation,
R_NAME AS Region,
C_MKTSEGMENT AS MktSegment
FROM tpch.customer LEFT JOIN tpch.nation
ON tpch.customer.C_NATIONKEY=tpch.nation.N_NATIONKEY
LEFT JOIN tpch.region
ON tpch.nation.N_REGIONKEY=tpch.region.R_REGIONKEY
GROUP BY tpch.customer.C_CUSTKEY
;
ALTER TABLE Customer ADD PRIMARY KEY (CustKey);

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

CREATE TABLE Time
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
FROM tpch.orders
ORDER BY Date ASC;
ALTER TABLE Time ADD PRIMARY KEY (TimeKey);

CREATE TABLE Sales (
SalesKey int NOT NULL AUTO_INCREMENT PRIMARY KEY
)
SELECT L_PARTKEY AS ProductKey,
TO_DAYS(O_ORDERDATE) AS TimeKey,
O_CUSTKEY AS CustKey,
L_QUANTITY AS Quantity,
L_EXTENDEDPRICE/L_QUANTITY AS ExtendedPrice
FROM tpch.orders
RIGHT JOIN tpch.lineitem ON O_ORDERKEY=L_ORDERKEY;

ALTER TABLE Sales ADD FOREIGN KEY (ProductKey) REFERENCES Product (ProductKey);
ALTER TABLE Sales ADD FOREIGN KEY (CustKey) REFERENCES Customer (CustKey);
ALTER TABLE Sales ADD FOREIGN KEY (TimeKey) REFERENCES Time (TimeKey);
