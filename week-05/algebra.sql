-- D1: Liste fiyati 1000'den buyuk urunler
SELECT DISTINCT product_name FROM product WHERE list_price > 1000 ORDER BY product_name;
-- D2: Her siparis kaleminde musteri ve urun adi
SELECT DISTINCT c.full_name, p.product_name FROM customer c JOIN customer_order o ON o.customer_id=c.customer_id JOIN order_item i ON i.order_id=o.order_id JOIN product p ON p.product_id=i.product_id ORDER BY c.full_name,p.product_name;
-- D3: Elektronik ya da kitap almis musteriler
SELECT c.customer_id,c.full_name FROM customer c WHERE EXISTS (SELECT 1 FROM customer_order o JOIN order_item i ON i.order_id=o.order_id JOIN product p ON p.product_id=i.product_id WHERE o.customer_id=c.customer_id AND p.category='electronics')
UNION
SELECT c.customer_id,c.full_name FROM customer c WHERE EXISTS (SELECT 1 FROM customer_order o JOIN order_item i ON i.order_id=o.order_id JOIN product p ON p.product_id=i.product_id WHERE o.customer_id=c.customer_id AND p.category='books') ORDER BY customer_id;
-- D4a: Hic siparis vermeyen musteriler (EXCEPT)
SELECT customer_id,full_name FROM customer EXCEPT SELECT c.customer_id,c.full_name FROM customer c JOIN customer_order o ON o.customer_id=c.customer_id ORDER BY customer_id;
-- D4b: Hic siparis vermeyen musteriler (NOT EXISTS)
SELECT c.customer_id,c.full_name FROM customer c WHERE NOT EXISTS (SELECT 1 FROM customer_order o WHERE o.customer_id=c.customer_id) ORDER BY customer_id;
-- D5: Ayni sehirde yasayan farkli musteri ciftleri
SELECT DISTINCT a.full_name AS customer_a,b.full_name AS customer_b,a.city FROM customer a JOIN customer b ON a.city=b.city AND a.customer_id<b.customer_id ORDER BY customer_a,customer_b;
-- D6: Elektronik kategorisindeki tum urunleri satin alan musteriler
SELECT c.customer_id,c.full_name FROM customer c WHERE NOT EXISTS (
 SELECT 1 FROM product p WHERE p.category='electronics' AND NOT EXISTS (
  SELECT 1 FROM customer_order o JOIN order_item i ON i.order_id=o.order_id
  WHERE o.customer_id=c.customer_id AND i.product_id=p.product_id
 )
) ORDER BY c.customer_id;
