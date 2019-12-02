-- Query 1 --
DROP VIEW IF EXISTS view_1_1;
CREATE VIEW view_1_1 AS
SELECT ProductKey, Month, Nation, Quantity FROM Sales
LEFT JOIN Customer ON Customer.CustKey=Sales.CustKey
LEFT JOIN Time ON Sales.TimeKey=Time.TimeKey
WHERE Month>=5 AND Month<=12 AND Year=1994 AND Nation='RUSSIA';

SELECT Month, Mfgr, sum(Quantity) AS 'The units'
FROM Product
RIGHT JOIN view_1_1 v1 ON v1.ProductKey=Product.ProductKey
GROUP BY Month, Mfgr
UNION
SELECT 'total months' AS Month, Mfgr, sum(Quantity)
FROM Product
RIGHT JOIN view_1_1 v1 ON v1.ProductKey=Product.ProductKey
GROUP BY Mfgr
UNION
SELECT 'total months' AS Month, 'Total Mfgr' AS Mfgr, sum(Quantity)
FROM Product
RIGHT JOIN view_1_1 v1 ON v1.ProductKey=Product.ProductKey;

-- output
+--------------+----------------+-----------+
| Month        | Mfgr           | The units |
+--------------+----------------+-----------+
| 5            | Manufacturer#1 |     16294 |
| 5            | Manufacturer#2 |     15580 |
| 5            | Manufacturer#3 |     16639 |
| 5            | Manufacturer#4 |     18081 |
| 5            | Manufacturer#5 |     17275 |
| 6            | Manufacturer#1 |     18102 |
| 6            | Manufacturer#2 |     16601 |
| 6            | Manufacturer#3 |     16241 |
| 6            | Manufacturer#4 |     17284 |
| 6            | Manufacturer#5 |     17016 |
| 7            | Manufacturer#1 |     16848 |
| 7            | Manufacturer#2 |     15225 |
| 7            | Manufacturer#3 |     16858 |
| 7            | Manufacturer#4 |     16931 |
| 7            | Manufacturer#5 |     14575 |
| 8            | Manufacturer#1 |     17331 |
| 8            | Manufacturer#2 |     17244 |
| 8            | Manufacturer#3 |     17325 |
| 8            | Manufacturer#4 |     16614 |
| 8            | Manufacturer#5 |     17212 |
| 9            | Manufacturer#1 |     14837 |
| 9            | Manufacturer#2 |     16012 |
| 9            | Manufacturer#3 |     16066 |
| 9            | Manufacturer#4 |     15314 |
| 9            | Manufacturer#5 |     17079 |
| 10           | Manufacturer#1 |     16083 |
| 10           | Manufacturer#2 |     15440 |
| 10           | Manufacturer#3 |     14988 |
| 10           | Manufacturer#4 |     14777 |
| 10           | Manufacturer#5 |     14730 |
| 11           | Manufacturer#1 |     15731 |
| 11           | Manufacturer#2 |     16583 |
| 11           | Manufacturer#3 |     14552 |
| 11           | Manufacturer#4 |     14532 |
| 11           | Manufacturer#5 |     15782 |
| 12           | Manufacturer#1 |     16390 |
| 12           | Manufacturer#2 |     15897 |
| 12           | Manufacturer#3 |     15158 |
| 12           | Manufacturer#4 |     15554 |
| 12           | Manufacturer#5 |     15703 |
| total months | Manufacturer#1 |    131616 |
| total months | Manufacturer#2 |    128582 |
| total months | Manufacturer#3 |    127827 |
| total months | Manufacturer#4 |    129087 |
| total months | Manufacturer#5 |    129372 |
| total months | Total Mfgr     |    646484 |
+--------------+----------------+-----------+
46 rows in set (10.62 sec)

DROP VIEW IF EXISTS alldata;
CREATE VIEW alldata AS
SELECT S.SalesKey,S.Quantity,S.ExtendedPrice,P.*,C.*,T.* FROM Sales S
LEFT JOIN Product P ON P.ProductKey=S.ProductKey
LEFT JOIN Customer C ON C.CustKey=S.CustKey
RIGHT JOIN Time T ON T.TimeKey=S.TimeKey;

-- query 2
DROP VIEW IF EXISTS view_1;
CREATE VIEW view_1 AS
SELECT count(P.ProductKey) AS product_num, T.Year,C.Nation
FROM Sales S
LEFT JOIN Product P ON P.ProductKey=S.ProductKey
LEFT JOIN Time T ON T.TimeKey=S.TimeKey
LEFT JOIN Customer C ON C.CustKey=S.CustKey
GROUP BY T.Year,C.Nation ASC;

SELECT v2.Year,v2.Nation,v2.product_num,
  concat(round(COALESCE(( (v2.product_num-v1.product_num)/v2.product_num * 100 ),0),2),'%') AS inc_or_dec_percentage
FROM view_1 v1,view_1 v2
WHERE v1.Year=v2.Year-1 AND v1.Nation=v2.Nation AND v2.Year>=1992 AND v2.Year<=1995;

-- output
+------+----------------+-------------+-----------------------+
| Year | Nation         | product_num | inc_or_dec_percentage |
+------+----------------+-------------+-----------------------+
| 1993 | ALGERIA        |       35954 | -1.17%                |
| 1993 | ARGENTINA      |       36089 | 0.81%                 |
| 1993 | BRAZIL         |       36793 | 1.24%                 |
| 1993 | CANADA         |       37632 | 2.73%                 |
| 1993 | CHINA          |       36633 | -0.74%                |
| 1993 | EGYPT          |       36063 | 2.49%                 |
| 1993 | ETHIOPIA       |       36040 | -1.16%                |
| 1993 | FRANCE         |       36170 | -3.87%                |
| 1993 | GERMANY        |       36219 | 0.08%                 |
| 1993 | INDIA          |       36339 | -0.10%                |
| 1993 | INDONESIA      |       36130 | -4.51%                |
| 1993 | IRAN           |       36813 | 4.33%                 |
| 1993 | IRAQ           |       35271 | -1.70%                |
| 1993 | JAPAN          |       35761 | 0.32%                 |
| 1993 | JORDAN         |       37007 | -0.21%                |
| 1993 | KENYA          |       36179 | 1.68%                 |
| 1993 | MOROCCO        |       35898 | -0.42%                |
| 1993 | MOZAMBIQUE     |       37393 | 0.20%                 |
| 1993 | PERU           |       35818 | -0.20%                |
| 1993 | ROMANIA        |       37259 | 1.87%                 |
| 1993 | RUSSIA         |       37261 | 0.32%                 |
| 1993 | SAUDI ARABIA   |       34686 | -1.38%                |
| 1993 | UNITED KINGDOM |       36034 | 0.11%                 |
| 1993 | UNITED STATES  |       36103 | -0.50%                |
| 1993 | VIETNAM        |       36693 | 0.07%                 |
| 1994 | ALGERIA        |       36516 | 1.54%                 |
| 1994 | ARGENTINA      |       36245 | 0.43%                 |
| 1994 | BRAZIL         |       36333 | -1.27%                |
| 1994 | CANADA         |       36692 | -2.56%                |
| 1994 | CHINA          |       37305 | 1.80%                 |
| 1994 | EGYPT          |       35729 | -0.93%                |
| 1994 | ETHIOPIA       |       36497 | 1.25%                 |
| 1994 | FRANCE         |       37687 | 4.03%                 |
| 1994 | GERMANY        |       36173 | -0.13%                |
| 1994 | INDIA          |       36471 | 0.36%                 |
| 1994 | INDONESIA      |       37756 | 4.31%                 |
| 1994 | IRAN           |       36110 | -1.95%                |
| 1994 | IRAQ           |       35893 | 1.73%                 |
| 1994 | JAPAN          |       35856 | 0.26%                 |
| 1994 | JORDAN         |       36536 | -1.29%                |
| 1994 | KENYA          |       35552 | -1.76%                |
| 1994 | MOROCCO        |       35625 | -0.77%                |
| 1994 | MOZAMBIQUE     |       36433 | -2.63%                |
| 1994 | PERU           |       35614 | -0.57%                |
| 1994 | ROMANIA        |       36791 | -1.27%                |
| 1994 | RUSSIA         |       37729 | 1.24%                 |
| 1994 | SAUDI ARABIA   |       35724 | 2.91%                 |
| 1994 | UNITED KINGDOM |       36191 | 0.43%                 |
| 1994 | UNITED STATES  |       36367 | 0.73%                 |
| 1994 | VIETNAM        |       36694 | 0.00%                 |
| 1995 | ALGERIA        |       36715 | 0.54%                 |
| 1995 | ARGENTINA      |       36703 | 1.25%                 |
| 1995 | BRAZIL         |       36618 | 0.78%                 |
| 1995 | CANADA         |       37076 | 1.04%                 |
| 1995 | CHINA          |       36469 | -2.29%                |
| 1995 | EGYPT          |       36167 | 1.21%                 |
| 1995 | ETHIOPIA       |       36650 | 0.42%                 |
| 1995 | FRANCE         |       37341 | -0.93%                |
| 1995 | GERMANY        |       36279 | 0.29%                 |
| 1995 | INDIA          |       36842 | 1.01%                 |
| 1995 | INDONESIA      |       37746 | -0.03%                |
| 1995 | IRAN           |       36458 | 0.95%                 |
| 1995 | IRAQ           |       35023 | -2.48%                |
| 1995 | JAPAN          |       36067 | 0.59%                 |
| 1995 | JORDAN         |       36800 | 0.72%                 |
| 1995 | KENYA          |       35818 | 0.74%                 |
| 1995 | MOROCCO        |       36457 | 2.28%                 |
| 1995 | MOZAMBIQUE     |       37047 | 1.66%                 |
| 1995 | PERU           |       35902 | 0.80%                 |
| 1995 | ROMANIA        |       36961 | 0.46%                 |
| 1995 | RUSSIA         |       37226 | -1.35%                |
| 1995 | SAUDI ARABIA   |       35958 | 0.65%                 |
| 1995 | UNITED KINGDOM |       36577 | 1.06%                 |
| 1995 | UNITED STATES  |       36566 | 0.54%                 |
| 1995 | VIETNAM        |       36461 | -0.64%                |
+------+----------------+-------------+-----------------------+
75 rows in set (20.95 sec)

-- Query 3 --
DROP VIEW IF EXISTS v3;
CREATE VIEW v3 AS
SELECT Year, Month, Region, Nation, COUNT(DISTINCT(Sales.CustKey)) AS Num_of_Customer FROM Sales
LEFT JOIN Time ON Sales.TimeKey=Time.TimeKey
LEFT JOIN Customer ON Customer.CustKey=Sales.CustKey
WHERE Year=1995
GROUP BY Month, Nation;

SELECT Year, Month, Nation, num_OF_customer FROM v3;

DROP VIEW IF EXISTS v3_1;
CREATE VIEW v3_1 AS
SELECT Year, Nation, Region, SUM(num_OF_customer) AS sum, AVG(num_OF_customer) AS Year_AVG FROM v3
GROUP BY Nation;
SELECT Year, Nation, Year_AVG FROM v3_1;
SELECT Region, SUM(Year_AVG) AS 'Group by region of year Avg', SUM(sum) AS 'Total # of customer' FROM v3_1
GROUP BY Region;

-- output
+------+-------+----------------+-----------------+
| Year | Month | Nation         | num_OF_customer |
+------+-------+----------------+-----------------+
| 1995 |     1 | ALGERIA        |             694 |
| 1995 |     1 | ARGENTINA      |             702 |
| 1995 |     1 | BRAZIL         |             688 |
| 1995 |     1 | CANADA         |             721 |
| 1995 |     1 | CHINA          |             687 |
| 1995 |     1 | EGYPT          |             679 |
| 1995 |     1 | ETHIOPIA       |             749 |
| 1995 |     1 | FRANCE         |             689 |
| 1995 |     1 | GERMANY        |             714 |
| 1995 |     1 | INDIA          |             675 |
| 1995 |     1 | INDONESIA      |             708 |
| 1995 |     1 | IRAN           |             704 |
| 1995 |     1 | IRAQ           |             688 |
| 1995 |     1 | JAPAN          |             687 |
| 1995 |     1 | JORDAN         |             716 |
| 1995 |     1 | KENYA          |             705 |
| 1995 |     1 | MOROCCO        |             683 |
| 1995 |     1 | MOZAMBIQUE     |             702 |
| 1995 |     1 | PERU           |             715 |
| 1995 |     1 | ROMANIA        |             677 |
| 1995 |     1 | RUSSIA         |             687 |
| 1995 |     1 | SAUDI ARABIA   |             708 |
| 1995 |     1 | UNITED KINGDOM |             746 |
| 1995 |     1 | UNITED STATES  |             710 |
| 1995 |     1 | VIETNAM        |             691 |
| 1995 |     2 | ALGERIA        |             643 |
| 1995 |     2 | ARGENTINA      |             686 |
| 1995 |     2 | BRAZIL         |             635 |
| 1995 |     2 | CANADA         |             688 |
| 1995 |     2 | CHINA          |             629 |
| 1995 |     2 | EGYPT          |             641 |
| 1995 |     2 | ETHIOPIA       |             622 |
| 1995 |     2 | FRANCE         |             662 |
| 1995 |     2 | GERMANY        |             634 |
| 1995 |     2 | INDIA          |             632 |
| 1995 |     2 | INDONESIA      |             638 |
| 1995 |     2 | IRAN           |             636 |
| 1995 |     2 | IRAQ           |             640 |
| 1995 |     2 | JAPAN          |             673 |
| 1995 |     2 | JORDAN         |             674 |
| 1995 |     2 | KENYA          |             650 |
| 1995 |     2 | MOROCCO        |             661 |
| 1995 |     2 | MOZAMBIQUE     |             649 |
| 1995 |     2 | PERU           |             634 |
| 1995 |     2 | ROMANIA        |             643 |
| 1995 |     2 | RUSSIA         |             670 |
| 1995 |     2 | SAUDI ARABIA   |             615 |
| 1995 |     2 | UNITED KINGDOM |             633 |
| 1995 |     2 | UNITED STATES  |             623 |
| 1995 |     2 | VIETNAM        |             605 |
| 1995 |     3 | ALGERIA        |             691 |
| 1995 |     3 | ARGENTINA      |             708 |
| 1995 |     3 | BRAZIL         |             679 |
| 1995 |     3 | CANADA         |             733 |
| 1995 |     3 | CHINA          |             711 |
| 1995 |     3 | EGYPT          |             691 |
| 1995 |     3 | ETHIOPIA       |             718 |
| 1995 |     3 | FRANCE         |             727 |
| 1995 |     3 | GERMANY        |             677 |
| 1995 |     3 | INDIA          |             683 |
| 1995 |     3 | INDONESIA      |             707 |
| 1995 |     3 | IRAN           |             669 |
| 1995 |     3 | IRAQ           |             679 |
| 1995 |     3 | JAPAN          |             712 |
| 1995 |     3 | JORDAN         |             739 |
| 1995 |     3 | KENYA          |             656 |
| 1995 |     3 | MOROCCO        |             696 |
| 1995 |     3 | MOZAMBIQUE     |             723 |
| 1995 |     3 | PERU           |             678 |
| 1995 |     3 | ROMANIA        |             682 |
| 1995 |     3 | RUSSIA         |             706 |
| 1995 |     3 | SAUDI ARABIA   |             675 |
| 1995 |     3 | UNITED KINGDOM |             680 |
| 1995 |     3 | UNITED STATES  |             668 |
| 1995 |     3 | VIETNAM        |             645 |
| 1995 |     4 | ALGERIA        |             712 |
| 1995 |     4 | ARGENTINA      |             687 |
| 1995 |     4 | BRAZIL         |             682 |
| 1995 |     4 | CANADA         |             646 |
| 1995 |     4 | CHINA          |             651 |
| 1995 |     4 | EGYPT          |             691 |
| 1995 |     4 | ETHIOPIA       |             711 |
| 1995 |     4 | FRANCE         |             679 |
| 1995 |     4 | GERMANY        |             679 |
| 1995 |     4 | INDIA          |             668 |
| 1995 |     4 | INDONESIA      |             694 |
| 1995 |     4 | IRAN           |             660 |
| 1995 |     4 | IRAQ           |             669 |
| 1995 |     4 | JAPAN          |             666 |
| 1995 |     4 | JORDAN         |             654 |
| 1995 |     4 | KENYA          |             685 |
| 1995 |     4 | MOROCCO        |             713 |
| 1995 |     4 | MOZAMBIQUE     |             674 |
| 1995 |     4 | PERU           |             652 |
| 1995 |     4 | ROMANIA        |             717 |
| 1995 |     4 | RUSSIA         |             756 |
| 1995 |     4 | SAUDI ARABIA   |             638 |
| 1995 |     4 | UNITED KINGDOM |             673 |
| 1995 |     4 | UNITED STATES  |             711 |
| 1995 |     4 | VIETNAM        |             665 |
| 1995 |     5 | ALGERIA        |             677 |
| 1995 |     5 | ARGENTINA      |             651 |
| 1995 |     5 | BRAZIL         |             710 |
| 1995 |     5 | CANADA         |             726 |
| 1995 |     5 | CHINA          |             749 |
| 1995 |     5 | EGYPT          |             694 |
| 1995 |     5 | ETHIOPIA       |             680 |
| 1995 |     5 | FRANCE         |             707 |
| 1995 |     5 | GERMANY        |             687 |
| 1995 |     5 | INDIA          |             728 |
| 1995 |     5 | INDONESIA      |             709 |
| 1995 |     5 | IRAN           |             703 |
| 1995 |     5 | IRAQ           |             662 |
| 1995 |     5 | JAPAN          |             657 |
| 1995 |     5 | JORDAN         |             713 |
| 1995 |     5 | KENYA          |             645 |
| 1995 |     5 | MOROCCO        |             691 |
| 1995 |     5 | MOZAMBIQUE     |             727 |
| 1995 |     5 | PERU           |             691 |
| 1995 |     5 | ROMANIA        |             688 |
| 1995 |     5 | RUSSIA         |             688 |
| 1995 |     5 | SAUDI ARABIA   |             699 |
| 1995 |     5 | UNITED KINGDOM |             687 |
| 1995 |     5 | UNITED STATES  |             724 |
| 1995 |     5 | VIETNAM        |             706 |
| 1995 |     6 | ALGERIA        |             697 |
| 1995 |     6 | ARGENTINA      |             645 |
| 1995 |     6 | BRAZIL         |             703 |
| 1995 |     6 | CANADA         |             738 |
| 1995 |     6 | CHINA          |             671 |
| 1995 |     6 | EGYPT          |             708 |
| 1995 |     6 | ETHIOPIA       |             689 |
| 1995 |     6 | FRANCE         |             684 |
| 1995 |     6 | GERMANY        |             710 |
| 1995 |     6 | INDIA          |             646 |
| 1995 |     6 | INDONESIA      |             664 |
| 1995 |     6 | IRAN           |             670 |
| 1995 |     6 | IRAQ           |             621 |
| 1995 |     6 | JAPAN          |             663 |
| 1995 |     6 | JORDAN         |             684 |
| 1995 |     6 | KENYA          |             673 |
| 1995 |     6 | MOROCCO        |             691 |
| 1995 |     6 | MOZAMBIQUE     |             735 |
| 1995 |     6 | PERU           |             655 |
| 1995 |     6 | ROMANIA        |             712 |
| 1995 |     6 | RUSSIA         |             700 |
| 1995 |     6 | SAUDI ARABIA   |             643 |
| 1995 |     6 | UNITED KINGDOM |             690 |
| 1995 |     6 | UNITED STATES  |             669 |
| 1995 |     6 | VIETNAM        |             678 |
| 1995 |     7 | ALGERIA        |             677 |
| 1995 |     7 | ARGENTINA      |             703 |
| 1995 |     7 | BRAZIL         |             675 |
| 1995 |     7 | CANADA         |             745 |
| 1995 |     7 | CHINA          |             687 |
| 1995 |     7 | EGYPT          |             667 |
| 1995 |     7 | ETHIOPIA       |             710 |
| 1995 |     7 | FRANCE         |             732 |
| 1995 |     7 | GERMANY        |             721 |
| 1995 |     7 | INDIA          |             713 |
| 1995 |     7 | INDONESIA      |             742 |
| 1995 |     7 | IRAN           |             705 |
| 1995 |     7 | IRAQ           |             698 |
| 1995 |     7 | JAPAN          |             712 |
| 1995 |     7 | JORDAN         |             661 |
| 1995 |     7 | KENYA          |             712 |
| 1995 |     7 | MOROCCO        |             687 |
| 1995 |     7 | MOZAMBIQUE     |             671 |
| 1995 |     7 | PERU           |             667 |
| 1995 |     7 | ROMANIA        |             738 |
| 1995 |     7 | RUSSIA         |             731 |
| 1995 |     7 | SAUDI ARABIA   |             681 |
| 1995 |     7 | UNITED KINGDOM |             701 |
| 1995 |     7 | UNITED STATES  |             693 |
| 1995 |     7 | VIETNAM        |             697 |
| 1995 |     8 | ALGERIA        |             715 |
| 1995 |     8 | ARGENTINA      |             705 |
| 1995 |     8 | BRAZIL         |             731 |
| 1995 |     8 | CANADA         |             668 |
| 1995 |     8 | CHINA          |             664 |
| 1995 |     8 | EGYPT          |             731 |
| 1995 |     8 | ETHIOPIA       |             720 |
| 1995 |     8 | FRANCE         |             711 |
| 1995 |     8 | GERMANY        |             625 |
| 1995 |     8 | INDIA          |             723 |
| 1995 |     8 | INDONESIA      |             669 |
| 1995 |     8 | IRAN           |             699 |
| 1995 |     8 | IRAQ           |             717 |
| 1995 |     8 | JAPAN          |             698 |
| 1995 |     8 | JORDAN         |             691 |
| 1995 |     8 | KENYA          |             682 |
| 1995 |     8 | MOROCCO        |             714 |
| 1995 |     8 | MOZAMBIQUE     |             757 |
| 1995 |     8 | PERU           |             693 |
| 1995 |     8 | ROMANIA        |             707 |
| 1995 |     8 | RUSSIA         |             726 |
| 1995 |     8 | SAUDI ARABIA   |             699 |
| 1995 |     8 | UNITED KINGDOM |             710 |
| 1995 |     8 | UNITED STATES  |             683 |
| 1995 |     8 | VIETNAM        |             697 |
| 1995 |     9 | ALGERIA        |             664 |
| 1995 |     9 | ARGENTINA      |             717 |
| 1995 |     9 | BRAZIL         |             674 |
| 1995 |     9 | CANADA         |             670 |
| 1995 |     9 | CHINA          |             696 |
| 1995 |     9 | EGYPT          |             649 |
| 1995 |     9 | ETHIOPIA       |             682 |
| 1995 |     9 | FRANCE         |             665 |
| 1995 |     9 | GERMANY        |             693 |
| 1995 |     9 | INDIA          |             674 |
| 1995 |     9 | INDONESIA      |             702 |
| 1995 |     9 | IRAN           |             716 |
| 1995 |     9 | IRAQ           |             674 |
| 1995 |     9 | JAPAN          |             661 |
| 1995 |     9 | JORDAN         |             669 |
| 1995 |     9 | KENYA          |             643 |
| 1995 |     9 | MOROCCO        |             674 |
| 1995 |     9 | MOZAMBIQUE     |             683 |
| 1995 |     9 | PERU           |             649 |
| 1995 |     9 | ROMANIA        |             699 |
| 1995 |     9 | RUSSIA         |             666 |
| 1995 |     9 | SAUDI ARABIA   |             700 |
| 1995 |     9 | UNITED KINGDOM |             667 |
| 1995 |     9 | UNITED STATES  |             668 |
| 1995 |     9 | VIETNAM        |             667 |
| 1995 |    10 | ALGERIA        |             708 |
| 1995 |    10 | ARGENTINA      |             718 |
| 1995 |    10 | BRAZIL         |             741 |
| 1995 |    10 | CANADA         |             658 |
| 1995 |    10 | CHINA          |             708 |
| 1995 |    10 | EGYPT          |             727 |
| 1995 |    10 | ETHIOPIA       |             670 |
| 1995 |    10 | FRANCE         |             721 |
| 1995 |    10 | GERMANY        |             662 |
| 1995 |    10 | INDIA          |             709 |
| 1995 |    10 | INDONESIA      |             708 |
| 1995 |    10 | IRAN           |             697 |
| 1995 |    10 | IRAQ           |             655 |
| 1995 |    10 | JAPAN          |             689 |
| 1995 |    10 | JORDAN         |             706 |
| 1995 |    10 | KENYA          |             731 |
| 1995 |    10 | MOROCCO        |             700 |
| 1995 |    10 | MOZAMBIQUE     |             704 |
| 1995 |    10 | PERU           |             709 |
| 1995 |    10 | ROMANIA        |             709 |
| 1995 |    10 | RUSSIA         |             755 |
| 1995 |    10 | SAUDI ARABIA   |             680 |
| 1995 |    10 | UNITED KINGDOM |             728 |
| 1995 |    10 | UNITED STATES  |             709 |
| 1995 |    10 | VIETNAM        |             687 |
| 1995 |    11 | ALGERIA        |             689 |
| 1995 |    11 | ARGENTINA      |             655 |
| 1995 |    11 | BRAZIL         |             664 |
| 1995 |    11 | CANADA         |             633 |
| 1995 |    11 | CHINA          |             687 |
| 1995 |    11 | EGYPT          |             627 |
| 1995 |    11 | ETHIOPIA       |             668 |
| 1995 |    11 | FRANCE         |             704 |
| 1995 |    11 | GERMANY        |             676 |
| 1995 |    11 | INDIA          |             668 |
| 1995 |    11 | INDONESIA      |             695 |
| 1995 |    11 | IRAN           |             692 |
| 1995 |    11 | IRAQ           |             661 |
| 1995 |    11 | JAPAN          |             671 |
| 1995 |    11 | JORDAN         |             683 |
| 1995 |    11 | KENYA          |             683 |
| 1995 |    11 | MOROCCO        |             635 |
| 1995 |    11 | MOZAMBIQUE     |             697 |
| 1995 |    11 | PERU           |             657 |
| 1995 |    11 | ROMANIA        |             733 |
| 1995 |    11 | RUSSIA         |             685 |
| 1995 |    11 | SAUDI ARABIA   |             702 |
| 1995 |    11 | UNITED KINGDOM |             640 |
| 1995 |    11 | UNITED STATES  |             679 |
| 1995 |    11 | VIETNAM        |             710 |
| 1995 |    12 | ALGERIA        |             681 |
| 1995 |    12 | ARGENTINA      |             685 |
| 1995 |    12 | BRAZIL         |             656 |
| 1995 |    12 | CANADA         |             706 |
| 1995 |    12 | CHINA          |             719 |
| 1995 |    12 | EGYPT          |             679 |
| 1995 |    12 | ETHIOPIA       |             699 |
| 1995 |    12 | FRANCE         |             684 |
| 1995 |    12 | GERMANY        |             673 |
| 1995 |    12 | INDIA          |             706 |
| 1995 |    12 | INDONESIA      |             698 |
| 1995 |    12 | IRAN           |             704 |
| 1995 |    12 | IRAQ           |             642 |
| 1995 |    12 | JAPAN          |             664 |
| 1995 |    12 | JORDAN         |             692 |
| 1995 |    12 | KENYA          |             689 |
| 1995 |    12 | MOROCCO        |             692 |
| 1995 |    12 | MOZAMBIQUE     |             688 |
| 1995 |    12 | PERU           |             696 |
| 1995 |    12 | ROMANIA        |             690 |
| 1995 |    12 | RUSSIA         |             692 |
| 1995 |    12 | SAUDI ARABIA   |             705 |
| 1995 |    12 | UNITED KINGDOM |             709 |
| 1995 |    12 | UNITED STATES  |             651 |
| 1995 |    12 | VIETNAM        |             753 |
+------+-------+----------------+-----------------+
300 rows in set (12.56 sec)
+------+----------------+----------+
| Year | Nation         | Year_AVG |
+------+----------------+----------+
| 1995 | ALGERIA        | 687.3333 |
| 1995 | ARGENTINA      | 688.5000 |
| 1995 | BRAZIL         | 686.5000 |
| 1995 | CANADA         | 694.3333 |
| 1995 | CHINA          | 688.2500 |
| 1995 | EGYPT          | 682.0000 |
| 1995 | ETHIOPIA       | 693.1667 |
| 1995 | FRANCE         | 697.0833 |
| 1995 | GERMANY        | 679.2500 |
| 1995 | INDIA          | 685.4167 |
| 1995 | INDONESIA      | 694.5000 |
| 1995 | IRAN           | 687.9167 |
| 1995 | IRAQ           | 667.1667 |
| 1995 | JAPAN          | 679.4167 |
| 1995 | JORDAN         | 690.1667 |
| 1995 | KENYA          | 679.5000 |
| 1995 | MOROCCO        | 686.4167 |
| 1995 | MOZAMBIQUE     | 700.8333 |
| 1995 | PERU           | 674.6667 |
| 1995 | ROMANIA        | 699.5833 |
| 1995 | RUSSIA         | 705.1667 |
| 1995 | SAUDI ARABIA   | 678.7500 |
| 1995 | UNITED KINGDOM | 688.6667 |
| 1995 | UNITED STATES  | 682.3333 |
| 1995 | VIETNAM        | 683.4167 |
+------+----------------+----------+
25 rows in set (12.57 sec)
+-------------+-----------------------------+---------------------+
| Region      | Group by region of year Avg | Total # of customer |
+-------------+-----------------------------+---------------------+
| AFRICA      |                   3447.2500 |               41367 |
| AMERICA     |                   3426.3333 |               41116 |
| ASIA        |                   3431.0001 |               41172 |
| EUROPE      |                   3469.7500 |               41637 |
| MIDDLE EAST |                   3406.0001 |               40872 |
+-------------+-----------------------------+---------------------+
5 rows in set (13.20 sec)

-- query 4
DROP VIEW IF EXISTS view_4_0;
CREATE VIEW view_4_0 AS
SELECT P.ProductKey,C.Region,T.Quarter
FROM Sales S
LEFT JOIN Product P ON P.ProductKey=S.ProductKey
LEFT JOIN Time T ON T.TimeKey=S.TimeKey
LEFT JOIN Customer C ON C.CustKey=S.CustKey
WHERE T.Year=1993;

DROP VIEW IF EXISTS view_4_1;
CREATE VIEW view_4_1 AS
SELECT ProductKey,Region,Quarter
FROM view_4_0 WHERE Quarter=3 OR Quarter=4;

DROP VIEW IF EXISTS view_4_2;
CREATE VIEW view_4_2 AS
SELECT ProductKey,Region,Quarter
FROM view_4_0 WHERE Quarter=1 OR Quarter=2;

SELECT v1.Region,count(v1.ProductKey) AS product_num
FROM view_4_1 v1 LEFT JOIN view_4_2 v2
ON v1.ProductKey=v2.ProductKey
WHERE v2.ProductKey IS NULL
GROUP BY v1.Region;

-- output
+--------------------+
| Tables_in_tpcholap |
+--------------------+
| Customer           |
| Product            |
| Sales              |
| Time               |
| view_1             |
| view_4_0           |
| view_4_1           |
| view_4_2           |
+--------------------+


-- Query 5 --

-- GIVEN Query
SELECT c.Region, COUNT(*)
FROM Sales s, Customer c, Time t
WHERE s.TimeKey = t.TimeKey
AND s.CustKey = c.CustKey
AND Year = 1995
GROUP BY c.Region;

+-------------+----------+
| Region      | COUNT(*) |
+-------------+----------+
| AFRICA      |   182687 |
| AMERICA     |   182865 |
| ASIA        |   183585 |
| EUROPE      |   184384 |
| MIDDLE EAST |   180406 |
+-------------+----------+
5 rows in set (1 min 5.18 sec)

SELECT Region, COUNT(*) AS 'Number of Sales by region for 1995'
FROM Customer c
RIGHT JOIN (
  SELECT SalesKey, CustKey FROM Sales s
  LEFT JOIN Time t ON t.TimeKey=s.TimeKey
  WHERE Year = 1995
) ST ON ST.CustKey = c.CustKey
GROUP BY Region;

+-------------+----------+
| Region      | COUNT(*) |
+-------------+----------+
| AFRICA      |   182687 |
| AMERICA     |   182865 |
| ASIA        |   183585 |
| EUROPE      |   184384 |
| MIDDLE EAST |   180406 |
+-------------+----------+
5 rows in set (11.55 sec)

-- query 6
+----------------+----------+
| Nation         | count(*) |
+----------------+----------+
| FRANCE         |   246415 |
| GERMANY        |   239064 |
| ROMANIA        |   243962 |
| RUSSIA         |   245236 |
| UNITED KINGDOM |   237400 |
+----------------+----------+
5 rows in set (1.15 sec)

-- Query 7 --
SELECT COUNT(*)
FROM Sales s, Customer c, Time t
WHERE s.TimeKey = t.TimeKey
AND s.CustKey = c.CustKey
AND t.Year = 1994
AND (c.Region='AMERICA' OR c.Region='ASIA');
+----------+
| COUNT(*) |
+----------+
|   365333 |
+----------+
1 row in set (26.50 sec)


SELECT COUNT(*)
FROM Time t
RIGHT JOIN (
  SELECT SalesKey, TimeKey FROM Sales s
  LEFT JOIN Customer c ON s.CustKey = c.CustKey
  WHERE c.Region = 'AMERICA' OR c.Region = 'ASIA'
) SC ON t.TimeKey=SC.TimeKey
WHERE Year = 1994;
+----------+
| COUNT(*) |
+----------+
|   365333 |
+----------+
1 row in set (26.14 sec)

-- Additional Method for Query 7

SELECT COUNT(*) AS 'Number of sales in America and Asia for 1994'
FROM Sales s
LEFT JOIN Customer c ON s.CustKey = c.CustKey
WHERE YEAR(FROM_DAYS(s.TimeKey))=1994 AND
(c.Region = 'AMERICA' OR c.Region = 'ASIA');
+----------+
| COUNT(*) |
+----------+
|   365333 |
+----------+
1 row in set (25.72 sec)

-- query 8
+----------+
| count(*) |
+----------+
|  1203959 |
+----------+
1 row in set (0.86 sec)
