\set VERBOSITY verbose
\set ON_ERROR_STOP off
-- Her calistirmada ayni baslangic durumunu kur.
TRUNCATE order_item, customer_order, product, customer RESTART IDENTITY CASCADE;
INSERT INTO customer (customer_id,full_name,email,city) VALUES (1,'Test Musteri','a@example.test','Istanbul'),(2,'Diger Musteri','b@example.test','Ankara');
INSERT INTO product (product_id,product_name,sku,category,list_price,discount_price,stock_quantity) VALUES (1,'Test Urun','T001','electronics',100,80,10),(2,'Test Urun 2','T002','books',50,NULL,5);
INSERT INTO customer_order (order_id,customer_id,order_date,status) VALUES (1,1,'2026-10-01','paid'),(2,2,'2026-10-02','pending');
INSERT INTO order_item (order_item_id,order_id,product_id,quantity,unit_price) VALUES (1,1,1,1,80),(2,2,2,1,50);
SELECT setval(pg_get_serial_sequence('customer','customer_id'), 2);
SELECT setval(pg_get_serial_sequence('product','product_id'), 2);
SELECT setval(pg_get_serial_sequence('customer_order','order_id'), 2);
SELECT setval(pg_get_serial_sequence('order_item','order_item_id'), 2);

-- T01 | customer.full_name NOT NULL | Beklenen: 23502
\echo T01 Beklenen=23502
UPDATE customer SET full_name=NULL WHERE customer_id=1;

-- T02 | customer.email NOT NULL | Beklenen: 23502
\echo T02 Beklenen=23502
UPDATE customer SET email=NULL WHERE customer_id=1;

-- T03 | product.product_name NOT NULL | Beklenen: 23502
\echo T03 Beklenen=23502
UPDATE product SET product_name=NULL WHERE product_id=1;

-- T04 | product.sku NOT NULL | Beklenen: 23502
\echo T04 Beklenen=23502
UPDATE product SET sku=NULL WHERE product_id=1;

-- T05 | product.category NOT NULL | Beklenen: 23502
\echo T05 Beklenen=23502
UPDATE product SET category=NULL WHERE product_id=1;

-- T06 | product.list_price NOT NULL | Beklenen: 23502
\echo T06 Beklenen=23502
UPDATE product SET list_price=NULL WHERE product_id=1;

-- T07 | product.stock_quantity NOT NULL | Beklenen: 23502
\echo T07 Beklenen=23502
UPDATE product SET stock_quantity=NULL WHERE product_id=1;

-- T08 | customer_order.customer_id NOT NULL | Beklenen: 23502
\echo T08 Beklenen=23502
UPDATE customer_order SET customer_id=NULL WHERE order_id=1;

-- T09 | customer_order.order_date NOT NULL | Beklenen: 23502
\echo T09 Beklenen=23502
UPDATE customer_order SET order_date=NULL WHERE order_id=1;

-- T10 | customer_order.status NOT NULL | Beklenen: 23502
\echo T10 Beklenen=23502
UPDATE customer_order SET status=NULL WHERE order_id=1;

-- T11 | order_item.order_id NOT NULL | Beklenen: 23502
\echo T11 Beklenen=23502
UPDATE order_item SET order_id=NULL WHERE order_item_id=1;

-- T12 | order_item.product_id NOT NULL | Beklenen: 23502
\echo T12 Beklenen=23502
UPDATE order_item SET product_id=NULL WHERE order_item_id=1;

-- T13 | order_item.quantity NOT NULL | Beklenen: 23502
\echo T13 Beklenen=23502
UPDATE order_item SET quantity=NULL WHERE order_item_id=1;

-- T14 | order_item.unit_price NOT NULL | Beklenen: 23502
\echo T14 Beklenen=23502
UPDATE order_item SET unit_price=NULL WHERE order_item_id=1;

-- T15 | uq_customer_email | Beklenen: 23505
\echo T15 Beklenen=23505
INSERT INTO customer (full_name,email,city) VALUES ('Tekrar','a@example.test','Istanbul');

-- T16 | uq_order_item_order_product | Beklenen: 23505
\echo T16 Beklenen=23505
INSERT INTO order_item (order_id,product_id,quantity,unit_price) VALUES (1,1,1,100);

-- T17 | chk_product_list_price_positive | Beklenen: 23514
\echo T17 Beklenen=23514
UPDATE product SET list_price=0, discount_price=NULL WHERE product_id=1;

-- T18 | chk_product_stock_nonnegative | Beklenen: 23514
\echo T18 Beklenen=23514
UPDATE product SET stock_quantity=-1 WHERE product_id=1;

-- T19 | chk_order_status | Beklenen: 23514
\echo T19 Beklenen=23514
UPDATE customer_order SET status='unknown' WHERE order_id=1;

-- T20 | chk_product_discount_range | Beklenen: 23514
\echo T20 Beklenen=23514
UPDATE product SET discount_price=200 WHERE product_id=1;

-- T21 | chk_order_item_quantity | Beklenen: 23514
\echo T21 Beklenen=23514
UPDATE order_item SET quantity=0 WHERE order_item_id=1;

-- T22 | chk_order_item_unit_price | Beklenen: 23514
\echo T22 Beklenen=23514
UPDATE order_item SET unit_price=0 WHERE order_item_id=1;

-- T23 | fk_order_customer INSERT | Beklenen: 23503
\echo T23 Beklenen=23503
INSERT INTO customer_order (customer_id,order_date,status) VALUES (999,'2026-10-01','paid');

-- T24 | fk_order_customer DELETE | Beklenen: 23001 (PostgreSQL 18 RESTRICT)
\echo T24 Beklenen=23001
DELETE FROM customer WHERE customer_id=1;

-- T25 | fk_item_order INSERT | Beklenen: 23503
\echo T25 Beklenen=23503
INSERT INTO order_item (order_id,product_id,quantity,unit_price) VALUES (999,1,1,100);

-- T26 | fk_item_product INSERT | Beklenen: 23503
\echo T26 Beklenen=23503
INSERT INTO order_item (order_id,product_id,quantity,unit_price) VALUES (1,999,1,100);

-- T27 | fk_item_product DELETE | Beklenen: 23001 (PostgreSQL 18 RESTRICT)
\echo T27 Beklenen=23001
DELETE FROM product WHERE product_id=1;

-- T28 | chk_product_list_price_positive sinir | Beklenen: OK
\echo T28 Beklenen=OK
UPDATE product SET list_price=1, discount_price=NULL WHERE product_id=1;

-- T29 | chk_product_stock_nonnegative sinir | Beklenen: OK
\echo T29 Beklenen=OK
UPDATE product SET stock_quantity=0 WHERE product_id=1;

-- T30 | chk_order_item_quantity sinir | Beklenen: OK
\echo T30 Beklenen=OK
UPDATE order_item SET quantity=20 WHERE order_item_id=1;

-- T31 | chk_product_discount_range NULL | Beklenen: OK
\echo T31 Beklenen=OK
UPDATE product SET discount_price=NULL WHERE product_id=1;

-- T32 | fk_item_order CASCADE | Beklenen: OK
\echo T32 Beklenen=OK
DELETE FROM customer_order WHERE order_id=2;

-- T33 | fk_item_order UPDATE ebeveyn | Beklenen: 23503
\echo T33 Beklenen=23503
UPDATE customer_order SET order_id=999 WHERE order_id=1;

-- T34 | chk_product_discount_range NULL INSERT | Beklenen: OK
\echo T34 Beklenen=OK
INSERT INTO product (product_name,sku,category,list_price,discount_price,stock_quantity)
VALUES ('Indirimsiz urun','T003','books',10,NULL,1);

-- T35 | chk_product_discount_range iki sutun esitlik siniri | Beklenen: OK
\echo T35 Beklenen=OK
UPDATE product SET discount_price=list_price WHERE product_id=1;
