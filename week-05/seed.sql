-- Odev 2 Bolum D: violations.sql'den sonra calistirilir.
TRUNCATE order_item, customer_order, product, customer RESTART IDENTITY CASCADE;
INSERT INTO customer (customer_id,full_name,email,city) VALUES
 (1,'Ayse Yilmaz','ayse@example.test','Istanbul'),
 (2,'Mehmet Demir','mehmet@example.test','Ankara'),
 (3,'Elif Kaya','elif@example.test','Istanbul'),
 (4,'Can Arslan','can@example.test','Izmir'),
 (5,'Zeynep Celik','zeynep@example.test','Ankara'),
 (6,'Deniz Acar','deniz@example.test','Bursa');
INSERT INTO product (product_id,product_name,sku,category,list_price,discount_price,stock_quantity) VALUES
 (1,'Laptop','ELE-001','electronics',30000,28000,12),
 (2,'Mouse','ELE-002','electronics',500,NULL,40),
 (3,'Roman','BOOK-001','books',250,200,25),
 (4,'Defter','STAT-001','stationery',80,NULL,100),
 (5,'Kulaklik','ELE-003','electronics',1200,1100,20),
 (6,'Kalem','STAT-002','stationery',30,NULL,70);
INSERT INTO customer_order (order_id,customer_id,order_date,status) VALUES
 (1,1,'2026-10-01','paid'), (2,1,'2026-10-02','shipped'),
 (3,2,'2026-10-03','paid'), (4,2,'2026-10-04','pending'),
 (5,3,'2026-10-05','paid'), (6,4,'2026-10-06','cancelled'),
 (7,5,'2026-10-07','paid'), (8,3,'2026-10-08','shipped');
INSERT INTO order_item (order_item_id,order_id,product_id,quantity,unit_price) VALUES
 (1,1,1,1,28000), (2,1,2,1,500), (3,1,3,1,200),
 (4,2,5,1,1100), (5,2,4,2,80),
 (6,3,1,1,30000), (7,3,2,1,500), (8,4,3,1,250),
 (9,5,1,1,28000), (10,5,5,1,1100),
 (11,6,4,1,80), (12,7,6,2,30),
 (13,8,3,1,200), (14,2,1,1,28000);
-- Yukarida order_item 14 satirdir (5-15 kosuluna uygundur).
-- Ayse Laptop urununu 1 ve 2 numarali siparislerde tekrar alir; D6 bundan etkilenmemelidir.
SELECT setval(pg_get_serial_sequence('customer','customer_id'), 6);
SELECT setval(pg_get_serial_sequence('product','product_id'), 6);
SELECT setval(pg_get_serial_sequence('customer_order','order_id'), 8);
SELECT setval(pg_get_serial_sequence('order_item','order_item_id'), 14);
