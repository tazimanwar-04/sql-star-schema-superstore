create database superstore_dw;
use superstore_dw;
show databases;
create table raw_sales (
row_id int,
order_id varchar(20),
order_date date,
ship_date date,
ship_mode varchar(50),
customer_id varchar(50),
customer_name varchar(50),
segment varchar(50),
city varchar(50),
state varchar(50),
country varchar(50),
postal_code varchar(50),
market varchar(50),
region varchar(50),
product_id varchar(50),
category varchar(50),
sub_category varchar(50),
product_name varchar(255),
sales decimal(10,2),
quantity int,
discount decimal(10,2),
profit decimal(10,2),
shipping_cost decimal(10,2),
order_priority varchar(50)
);
alter table raw_sales
modify product_name varchar(500),
modify city varchar(150),
modify state varchar(150);

truncate table raw_sales;
describe raw_sales;
select count(*) from raw_sales;
create table dim_customer (
customer_key int auto_increment primary key,
customer_id varchar(50),
customer_name varchar(200),
segment varchar(50)
);

insert into dim_customer (customer_id, customer_name, segment)
select distinct
customer_id,
customer_name,
segment
from raw_sales;
select count(*) from dim_customer;
select * from dim_customer limit 5;

create table dim_product (
product_key int auto_increment primary key,
product_id varchar(50),
product_name varchar(500),
category varchar(100),
sub_category varchar(100)
);

insert into dim_product (product_id, product_name, category, sub_category)
select distinct
product_id,
product_name,
category,
sub_category
from raw_sales;
select count(*) from dim_product;
select * from dim_product limit 5;

SELECT
    COUNT(*) AS total_rows,
    COUNT(postal_code) AS filled_postal,
    COUNT(*) - COUNT(postal_code) AS missing_postal
FROM raw_sales;
SELECT
    COUNT(*) AS total_rows,

    SUM(
        CASE
            WHEN postal_code IS NULL OR postal_code = ''
            THEN 1
            ELSE 0
        END
    ) AS missing_postal

FROM raw_sales;

SET SQL_SAFE_UPDATES = 0;

UPDATE raw_sales
SET postal_code = NULL
WHERE postal_code = '';

SELECT COUNT(*) - COUNT(postal_code) AS missing_postal
FROM raw_sales;


create table dim_region (
region_key int auto_increment primary key,
city varchar(100),
state varchar(100),
country varchar(100),
postal_code varchar(50),
market varchar(100),
region varchar(100)
);

insert into dim_region(city, state, country, postal_code, market, region)
select distinct
city, state, country, postal_code, market, region
from raw_sales;
select count(*) from raw_sales;
select * from raw_sales limit 5;

create table dim_date(
date_key int auto_increment primary key,
full_date date,
year int,
month int,
month_name varchar(20),
quarter varchar(2),
day int,
weekday varchar(20)
);
insert into dim_date(
full_date, year, month, month_name, quarter, day, weekday)
select distinct order_date,
year(order_date),
month(order_date),
monthname(order_date),
concat('Q', Quarter(order_date)),
day(order_date),
dayname(order_date)

from raw_sales
where order_date is not null;

select count(*) from dim_date;
select * from dim_date limit 5;

create table fact_sales (
fact_id int auto_increment primary key,
order_id varchar(50),
customer_key int,
product_key int,
region_key int,
date_key int,
ship_mode varchar(50),
order_priority varchar(50),
sales decimal(10,2),
quantity int,
discount decimal(10,2),
profit decimal(10,2),
shipping_cost decimal(10,2),

foreign key (customer_key) references dim_customer(customer_key),
foreign key (product_key) references dim_product(product_key),
foreign key (region_key) references dim_region(region_key),
foreign key (date_key) references dim_date(date_key)
);

INSERT INTO fact_sales (
    order_id,

    customer_key,
    product_key,
    region_key,
    date_key,

    ship_mode,
    order_priority,

    sales,
    quantity,
    discount,
    profit,
    shipping_cost
)

SELECT
    r.order_id,

    c.customer_key,      -- ✅ FIXED
    p.product_key,
    g.region_key,
    d.date_key,

    r.ship_mode,
    r.order_priority,

    r.sales,
    r.quantity,
    r.discount,
    r.profit,
    r.shipping_cost

FROM raw_sales r

JOIN dim_customer c
    ON r.customer_id = c.customer_id
   AND r.customer_name = c.customer_name
   AND r.segment = c.segment

JOIN dim_product p
    ON r.product_id = p.product_id
   AND r.product_name = p.product_name
   AND r.category = p.category
   AND r.sub_category = p.sub_category

JOIN dim_region g
    ON r.city = g.city
   AND r.state = g.state
   AND r.country = g.country
   AND (
        (r.postal_code = g.postal_code)
        OR (r.postal_code IS NULL AND g.postal_code IS NULL)
       )
   AND r.market = g.market
   AND r.region = g.region

JOIN dim_date d
    ON r.order_date = d.full_date;
   
SELECT COUNT(*) FROM fact_sales;

SELECT
    d.year,
    ROUND(SUM(f.sales),2) AS total_sales
FROM fact_sales f
JOIN dim_date d ON f.date_key = d.date_key
GROUP BY d.year
ORDER BY d.year;
SELECT
    c.customer_name,
    ROUND(SUM(f.profit),2) AS total_profit
FROM fact_sales f
JOIN dim_customer c ON f.customer_key = c.customer_key
GROUP BY c.customer_name
ORDER BY total_profit DESC
LIMIT 10;

SELECT
    g.region,
    ROUND(SUM(f.sales),2) AS total_sales
FROM fact_sales f
JOIN dim_region g ON f.region_key = g.region_key
GROUP BY g.region
ORDER BY total_sales DESC;

SELECT
    d.year,
    d.month_name,
    ROUND(SUM(f.sales),2) AS total_sales
FROM fact_sales f
JOIN dim_date d ON f.date_key = d.date_key
GROUP BY d.year, d.month, d.month_name
ORDER BY d.year, d.month;

SELECT
    p.category,
    ROUND(SUM(f.profit),2) AS total_profit
FROM fact_sales f
JOIN dim_product p ON f.product_key = p.product_key
GROUP BY p.category
ORDER BY total_profit DESC;





