-- Odev 2 Bolum A: sql/schema.sql dosyasindan SONRA calistirilir.
-- Musterinin adi ve e-postasi bos olamaz.
ALTER TABLE customer ALTER COLUMN full_name SET NOT NULL;
ALTER TABLE customer ALTER COLUMN email SET NOT NULL;
-- Urun adi, kodu, kategorisi, fiyati ve stogu bos olamaz.
ALTER TABLE product ALTER COLUMN product_name SET NOT NULL;
ALTER TABLE product ALTER COLUMN sku SET NOT NULL;
ALTER TABLE product ALTER COLUMN category SET NOT NULL;
ALTER TABLE product ALTER COLUMN list_price SET NOT NULL;
ALTER TABLE product ALTER COLUMN stock_quantity SET NOT NULL;
-- Her siparisin musteri, tarih ve durum bilgisi bulunmalidir.
ALTER TABLE customer_order ALTER COLUMN customer_id SET NOT NULL;
ALTER TABLE customer_order ALTER COLUMN order_date SET NOT NULL;
ALTER TABLE customer_order ALTER COLUMN status SET NOT NULL;
-- Her siparis kaleminin siparis, urun, miktar ve satis fiyati bulunmalidir.
ALTER TABLE order_item ALTER COLUMN order_id SET NOT NULL;
ALTER TABLE order_item ALTER COLUMN product_id SET NOT NULL;
ALTER TABLE order_item ALTER COLUMN quantity SET NOT NULL;
ALTER TABLE order_item ALTER COLUMN unit_price SET NOT NULL;

-- Ayni e-posta iki musteriye ait olamaz.
ALTER TABLE customer ADD CONSTRAINT uq_customer_email UNIQUE (email);
-- Ayni urun ayni sipariste iki ayri kalem olarak bulunamaz.
ALTER TABLE order_item ADD CONSTRAINT uq_order_item_order_product UNIQUE (order_id, product_id);
-- Urun liste fiyati sifirdan buyuk olmalidir.
ALTER TABLE product ADD CONSTRAINT chk_product_list_price_positive CHECK (list_price > 0);
-- Stok negatif olamaz.
ALTER TABLE product ADD CONSTRAINT chk_product_stock_nonnegative CHECK (stock_quantity >= 0);
-- Siparis durumu yalnizca izin verilen degerlerden biri olabilir.
ALTER TABLE customer_order ADD CONSTRAINT chk_order_status CHECK (status IN ('pending', 'paid', 'shipped', 'cancelled'));
-- Indirimli fiyat varsa liste fiyatini asamaz ve sifirdan buyuk olmalidir.
ALTER TABLE product ADD CONSTRAINT chk_product_discount_range CHECK (discount_price > 0 AND discount_price <= list_price);
-- Siparis kalemi miktari 1 ile 20 arasinda olmalidir.
ALTER TABLE order_item ADD CONSTRAINT chk_order_item_quantity CHECK (quantity BETWEEN 1 AND 20);
-- Satis anindaki birim fiyat sifirdan buyuk olmalidir.
ALTER TABLE order_item ADD CONSTRAINT chk_order_item_unit_price CHECK (unit_price > 0);

-- Siparis ancak var olan bir musteriye ait olabilir; siparisi olan musteri silinemez.
ALTER TABLE customer_order DROP CONSTRAINT fk_order_customer;
ALTER TABLE customer_order ADD CONSTRAINT fk_order_customer FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE RESTRICT;
-- Siparis silinirse o siparise ait kalemler de silinir.
ALTER TABLE order_item DROP CONSTRAINT fk_item_order;
ALTER TABLE order_item ADD CONSTRAINT fk_item_order FOREIGN KEY (order_id) REFERENCES customer_order(order_id) ON DELETE CASCADE;
-- Bir urun, siparis kalemlerinde kullaniliyorsa silinemez.
ALTER TABLE order_item DROP CONSTRAINT fk_item_product;
ALTER TABLE order_item ADD CONSTRAINT fk_item_product FOREIGN KEY (product_id) REFERENCES product(product_id) ON DELETE RESTRICT;
