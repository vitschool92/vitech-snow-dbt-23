
-- SQL workspace for table operations, views, and clustering
-- Co-authored with CoCo

-- insert values in table --
insert into customers (id, full_name, email,phone,spent)
values
  (11,'Lewiss MacDwyer','lmacdwyer0@un.org','262-665-9168',140),
  (21,'Ty Pettingall','tpettingall1@mayoclinic.com','734-987-7120',254),
  (31,'Marlee Spadazzi','mspadazzi2@txnews.com','867-946-3659',120),
  (41,'Heywood Tearney','htearney3@patch.com','563-853-8192',1230),
  (51,'Odilia Seti','oseti4@globo.com','730-451-8637',143),
  (61,'Meggie Washtell','mwashtell5@rediff.com','568-896-6138',600);


SELECT * FROM customers ;

DELETE FROM customers WHERE ID >=20;

CREATE VIEW DEMO_DB.PUBLIC.CUST_VIEW 
AS 
(
    SELECT ID,FULL_NAME,PHONE FROM customers 
)
;



---------------------


SELECT * FROM DEMO_DB.PUBLIC.CUST_VIEW  ;


DELETE FROM DEMO_DB.PUBLIC.CUST_VIEW;


SHOW VIEWS ;



CREATE SECURE VIEW DEMO_DB.PUBLIC.CUST_SVIEW 
AS 
(
    SELECT ID,FULL_NAME,PHONE,SPENT FROM customers 
)
;



SELECT * FROM DEMO_DB.PUBLIC.CUST_SVIEW ;



-- Remove caching just to have a fair test -- Part 1

ALTER SESSION SET USE_CACHED_RESULT=TRUE; -- disable global caching
ALTER warehouse compute_wh suspend;
ALTER warehouse compute_wh resume;



-- Prepare table
CREATE OR REPLACE TRANSIENT DATABASE ORDERS;

CREATE OR REPLACE SCHEMA TPCH_SF100;

CREATE OR REPLACE TABLE TPCH_SF100.ORDERS AS
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF100.ORDERS;

SELECT * FROM ORDERS LIMIT 100



-- Example statement view -- 
SELECT
YEAR(O_ORDERDATE) AS YEAR,
MAX(O_COMMENT) AS MAX_COMMENT,
MIN(O_COMMENT) AS MIN_COMMENT,
MAX(O_CLERK) AS MAX_CLERK,
MIN(O_CLERK) AS MIN_CLERK
FROM ORDERS.TPCH_SF100.ORDERS
GROUP BY YEAR(O_ORDERDATE)
ORDER BY YEAR(O_ORDERDATE);




-- Create materialized view
CREATE OR REPLACE MATERIALIZED VIEW ORDERS_MV
AS 
SELECT
YEAR(O_ORDERDATE) AS YEAR,
MAX(O_COMMENT) AS MAX_COMMENT,
MIN(O_COMMENT) AS MIN_COMMENT,
MAX(O_CLERK) AS MAX_CLERK,
MIN(O_CLERK) AS MIN_CLERK
FROM ORDERS.TPCH_SF100.ORDERS
GROUP BY YEAR(O_ORDERDATE);


SHOW MATERIALIZED VIEWS;

-- Query view
SELECT * FROM ORDERS_MV
ORDER BY YEAR;



-- UPDATE or DELETE values
UPDATE ORDERS
SET O_CLERK='Clerk#99900000' 
WHERE O_ORDERDATE='1992-01-01'





   -- Test updated data --
-- Example statement view -- 
SELECT
YEAR(O_ORDERDATE) AS YEAR,
MAX(O_COMMENT) AS MAX_COMMENT,
MIN(O_COMMENT) AS MIN_COMMENT,
MAX(O_CLERK) AS MAX_CLERK,
MIN(O_CLERK) AS MIN_CLERK
FROM ORDERS.TPCH_SF100.ORDERS
GROUP BY YEAR(O_ORDERDATE)
ORDER BY YEAR(O_ORDERDATE);



-- Query view
SELECT * FROM ORDERS_MV
ORDER BY YEAR;


SHOW MATERIALIZED VIEWS;





SELECT * FROM customers ;



SELECT * FROM ORDERS LIMIT 10;


SELECT * FROM orders LIMIT 10;



select top 5 *  FROM orders ;


select top 1 * from orders ;

-------------------------------------------
select count(*) from orders ;

describe table orders ;

show tables ;


-- Create emp table with cluster keys
CREATE OR REPLACE TABLE emp (
    emp_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(50),
    hire_date DATE,
    salary NUMBER(10,2),
    location VARCHAR(100)
)
CLUSTER BY (empid,department, hire_date);

-- Verify clustering info
SELECT SYSTEM$CLUSTERING_INFORMATION('emp');

-- Show clustering depth
SELECT SYSTEM$CLUSTERING_DEPTH('emp');


-- Alter orders table to add cluster keys
ALTER TABLE orders CLUSTER BY (O_ORDERDATE, O_ORDERSTATUS);

-- Verify clustering info on orders
SELECT SYSTEM$CLUSTERING_INFORMATION('orders');

-- Check clustering depth on orders
SELECT SYSTEM$CLUSTERING_DEPTH('orders');



SELECT * FROM ORDERS where year(O_ORDERDATE ) = 1992 ;