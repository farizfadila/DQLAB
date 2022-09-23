-- Deskripsi Table Column, Data Type each Column
SELECT
    column_name, data_type
FROM
    INFORMATION_SCHEMA.COLUMNS
WHERE
    table_name="dqlab_sales_store";
/*
OUTPUT SQL

+----------------------+-----------+
| COLUMN_NAME          | DATA_TYPE |
+----------------------+-----------+
| customer             | varchar   |
| discount             | double    |
| discount_value       | double    |
| order_date           | date      |
| order_id             | int       |
| order_quantity       | double    |
| order_status         | varchar   |
| product_category     | varchar   |
| product_sub_category | varchar   |
| sales                | double    |
+----------------------+-----------+
*/


/*
Overall Performance by Year

Buatlah Query dengan menggunakan SQL
untuk mendapatkan total penjualan (sales)
dan jumlah order (number_of_order) dari
tahun 2009 sampai 2012 (years).
 */
SELECT
	DISTINCT DATE_FORMAT(order_date,'%Y') AS years,
	SUM(sales) as sales,
	COUNT(order_id) AS number_of_order
FROM dqlab_sales_store
WHERE
	order_status='Order Finished'
GROUP BY 1
ORDER BY 1;
/*
OUTPUT SQL
+-------+------------+-----------------+
| years | sales      | number_of_order |
+-------+------------+-----------------+
| 2009  | 4613872681 |            1244 |
| 2010  | 4059100607 |            1248 |
| 2011  | 4112036186 |            1178 |
| 2012  | 4482983158 |            1254 |
+-------+------------+-----------------+
*/

/*
Overall Performance by Product Sub Category

Buatlah Query dengan menggunakan SQL
untuk mendapatkan total penjualan (sales)
berdasarkan sub category dari
produk (product_sub_category)
pada tahun 2011 dan 2012 saja (years)
 */
SELECT
DATE_FORMAT(order_date,'%Y') as years,
product_sub_category,
SUM(sales) AS sales
FROM dqlab_sales_store
WHERE (DATE_FORMAT(order_date,'%Y') BETWEEN '2011' AND '2012') AND order_status='Order Finished'
GROUP BY 1,2
ORDER BY 1,3 DESC;
/*
 OUTPUT SQL
 +-------+--------------------------------+-----------+
| years | product_sub_category           | sales     |
+-------+--------------------------------+-----------+
| 2011  | Chairs & Chairmats             | 622962720 |
| 2011  | Office Machines                | 545856280 |
| 2011  | Tables                         | 505875008 |
| 2011  | Copiers and Fax                | 404074080 |
| 2011  | Telephones and Communication   | 392194658 |
| 2011  | Binders and Binder Accessories | 298023200 |
| 2011  | Storage & Organization         | 285991820 |
| 2011  | Appliances                     | 272630020 |
| 2011  | Computer Peripherals           | 232677960 |
| 2011  | Bookcases                      | 169304620 |
| 2011  | Office Furnishings             | 160471500 |
| 2011  | Paper                          | 111080380 |
| 2011  | Pens & Art Supplies            |  43093800 |
| 2011  | Envelopes                      |  36463900 |
| 2011  | Labels                         |  15607780 |
| 2011  | Scissors, Rulers and Trimmers  |  12638340 |
| 2011  | Rubber Bands                   |   3090120 |
| 2012  | Office Machines                | 811427140 |
| 2012  | Chairs & Chairmats             | 654168740 |
| 2012  | Telephones and Communication   | 422287514 |
| 2012  | Tables                         | 388993784 |
| 2012  | Binders and Binder Accessories | 363879200 |
| 2012  | Storage & Organization         | 356714140 |
| 2012  | Computer Peripherals           | 308014340 |
| 2012  | Copiers and Fax                | 292489800 |
| 2012  | Appliances                     | 266131100 |
| 2012  | Office Furnishings             | 178927480 |
| 2012  | Bookcases                      | 159984680 |
| 2012  | Paper                          | 126896160 |
| 2012  | Envelopes                      |  58629280 |
| 2012  | Pens & Art Supplies            |  43818480 |
| 2012  | Scissors, Rulers and Trimmers  |  36776400 |
| 2012  | Labels                         |  10007040 |
| 2012  | Rubber Bands                   |   3837880 |
+-------+--------------------------------+-----------+
*/

/*
Promotion Effectiveness and Efficiency by Years
Formula untuk burn rate :
(total discount / total sales) * 100

Buatkan Derived Tables untuk menghitung
total sales (sales) dan
total discount (promotion_value)
berdasarkan tahun(years)
dan formulasikan persentase
burn rate nya (burn_rate_percentage).
*/
SELECT
	DISTINCT DATE_FORMAT(order_date,'%Y') AS years,
	SUM(sales) AS sales,
	SUM(discount_value) AS promotion_value,
	ROUND((ROUND(SUM(discount_value),2)/ROUND(SUM(SALES),2))*100,2) AS burn_rate_percentage
FROM
	dqlab_sales_store
WHERE
	order_status='Order Finished'
GROUP BY 1
ORDER BY 1;
/*
OUTPUT SQL
+-------+------------+-----------------+----------------------+
| years | sales      | promotion_value | burn_rate_percentage |
+-------+------------+-----------------+----------------------+
| 2009  | 4613872681 |       214330327 |                 4.65 |
| 2010  | 4059100607 |       197506939 |                 4.87 |
| 2011  | 4112036186 |       214611556 |                 5.22 |
| 2012  | 4482983158 |       225867642 |                 5.04 |
+-------+------------+-----------------+----------------------+
*/

/*
Promotion Effectiveness and Efficiency
by Product Sub Category
*/
SELECT
	DATE_FORMAT(order_date,'%Y') AS years,
	product_sub_category,
	product_category,
	SUM(sales) AS sales,
	SUM(discount_value) AS promotion_value,
	ROUND((ROUND(SUM(discount_value),2)/ROUND(SUM(sales),2))*100,2) AS burn_rate_percentage
FROM
	dqlab_sales_store
WHERE
	order_status='Order Finished'
	AND
	DATE_FORMAT(order_date,'%Y')='2012'
GROUP BY 3,2,1
ORDER BY 4 DESC;

/*
 OUTPUT SQL
 +-------+--------------------------------+------------------+-----------+-----------------+----------------------+
| years | product_sub_category           | product_category | sales     | promotion_value | burn_rate_percentage |
+-------+--------------------------------+------------------+-----------+-----------------+----------------------+
| 2012  | Office Machines                | Technology       | 811427140 |        46616695 |                 5.75 |
| 2012  | Chairs & Chairmats             | Furniture        | 654168740 |        26623882 |                 4.07 |
| 2012  | Telephones and Communication   | Technology       | 422287514 |        18800188 |                 4.45 |
| 2012  | Tables                         | Furniture        | 388993784 |        16348689 |                  4.2 |
| 2012  | Binders and Binder Accessories | Office Supplies  | 363879200 |        22338980 |                 6.14 |
| 2012  | Storage & Organization         | Office Supplies  | 356714140 |        18802166 |                 5.27 |
| 2012  | Computer Peripherals           | Technology       | 308014340 |        15333293 |                 4.98 |
| 2012  | Copiers and Fax                | Technology       | 292489800 |        14530870 |                 4.97 |
| 2012  | Appliances                     | Office Supplies  | 266131100 |        14393300 |                 5.41 |
| 2012  | Office Furnishings             | Furniture        | 178927480 |         8233849 |                  4.6 |
| 2012  | Bookcases                      | Furniture        | 159984680 |        10024365 |                 6.27 |
| 2012  | Paper                          | Office Supplies  | 126896160 |         6224694 |                 4.91 |
| 2012  | Envelopes                      | Office Supplies  |  58629280 |         2334321 |                 3.98 |
| 2012  | Pens & Art Supplies            | Office Supplies  |  43818480 |         2343501 |                 5.35 |
| 2012  | Scissors, Rulers and Trimmers  | Office Supplies  |  36776400 |         2349280 |                 6.39 |
| 2012  | Labels                         | Office Supplies  |  10007040 |          452245 |                 4.52 |
| 2012  | Rubber Bands                   | Office Supplies  |   3837880 |          117324 |                 3.06 |
+-------+--------------------------------+------------------+-----------+-----------------+----------------------+
*/

/*
 Customers Transactions per Year
*/
SELECT
	DATE_FORMAT(order_date,'%Y') AS years,
	COUNT(DISTINCT LOWER(customer)) AS number_of_customer
FROM dqlab_sales_store
WHERE order_status='Order Finished'
GROUP BY 1
ORDER BY 1;
/*
 OUTPUT SQL
 +-------+--------------------+
| years | number_of_customer |
+-------+--------------------+
| 2009  |                585 |
| 2010  |                593 |
| 2011  |                581 |
| 2012  |                594 |
+-------+--------------------+
*/
