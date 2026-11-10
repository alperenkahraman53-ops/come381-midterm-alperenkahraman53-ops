\echo CASCADE_BEFORE
BEGIN;
SELECT count(*) AS orders_before FROM customer_order;
SELECT count(*) AS items_before FROM order_item;
DELETE FROM customer_order WHERE order_id = 6;
SELECT count(*) AS orders_after FROM customer_order;
SELECT count(*) AS items_after FROM order_item;
ROLLBACK;

\echo D6_AI_CORRECT
SELECT c.customer_id,c.full_name FROM customer c WHERE NOT EXISTS (
 SELECT 1 FROM product p WHERE p.category='electronics' AND NOT EXISTS (
  SELECT 1 FROM customer_order o JOIN order_item i ON i.order_id=o.order_id
  WHERE o.customer_id=c.customer_id AND i.product_id=p.product_id
 )
) ORDER BY c.customer_id;

\echo D6_COUNT_COUNTEREXAMPLE
SELECT c.customer_id,c.full_name
FROM customer c JOIN customer_order o ON o.customer_id=c.customer_id
JOIN order_item i ON i.order_id=o.order_id
JOIN product p ON p.product_id=i.product_id
WHERE p.category='electronics'
GROUP BY c.customer_id,c.full_name
HAVING count(*)=(SELECT count(*) FROM product WHERE category='electronics')
ORDER BY c.customer_id;

\echo AUTOMATED_ASSERTIONS
DO $$
DECLARE result_ids integer[];
BEGIN
 SELECT array_agg(customer_id ORDER BY customer_id) INTO result_ids FROM customer c
 WHERE NOT EXISTS (SELECT 1 FROM product p WHERE category='electronics' AND NOT EXISTS (
 SELECT 1 FROM customer_order o JOIN order_item i ON i.order_id=o.order_id
 WHERE o.customer_id=c.customer_id AND i.product_id=p.product_id));
 IF result_ids IS DISTINCT FROM ARRAY[1] THEN RAISE EXCEPTION 'D6 mismatch: %',result_ids; END IF;
 SELECT array_agg(customer_id ORDER BY customer_id) INTO result_ids FROM customer c
 WHERE NOT EXISTS (SELECT 1 FROM customer_order o WHERE o.customer_id=c.customer_id);
 IF result_ids IS DISTINCT FROM ARRAY[6] THEN RAISE EXCEPTION 'D4 mismatch'; END IF;
 IF EXISTS ((SELECT customer_id FROM customer EXCEPT SELECT customer_id FROM customer_order)
 EXCEPT (SELECT customer_id FROM customer c WHERE NOT EXISTS (SELECT 1 FROM customer_order o WHERE o.customer_id=c.customer_id)))
 OR EXISTS ((SELECT customer_id FROM customer c WHERE NOT EXISTS (SELECT 1 FROM customer_order o WHERE o.customer_id=c.customer_id))
 EXCEPT (SELECT customer_id FROM customer EXCEPT SELECT customer_id FROM customer_order)) THEN RAISE EXCEPTION 'D4 methods differ'; END IF;
 IF (SELECT count(*) FROM customer) <> 6 OR (SELECT count(*) FROM product) <> 6
 OR (SELECT count(*) FROM customer_order) <> 8 OR (SELECT count(*) FROM order_item) <> 14 THEN RAISE EXCEPTION 'Seed or rollback mismatch'; END IF;
END $$;
\echo ASSERTIONS_PASS
