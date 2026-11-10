# Bölüm C — ON DELETE kararları

| Foreign key | Ebeveyn → çocuk | Seçim | Neden | Diğer seçenek neden değil? |
|---|---|---|---|---|
| `fk_order_customer` | customer → customer_order | RESTRICT | Sipariş geçmişi olan müşterinin yanlışlıkla silinmesini önler | CASCADE sipariş geçmişini kaybettirirdi |
| `fk_item_order` | customer_order → order_item | CASCADE | Sipariş silinince ona bağlı kalemler de anlamını yitirir | RESTRICT sipariş temizliğini engellerdi |
| `fk_item_product` | product → order_item | RESTRICT | Satılmış ürüne ilişkin tarihsel kayıt korunur | CASCADE eski sipariş kalemlerini yok ederdi |

## CASCADE kanıtı — PostgreSQL 18.6 gerçek sonucu

`seed.sql` sonrasında aşağıdaki komutları **ayrı bir transaction içinde** çalıştır:

```sql
BEGIN;
SELECT count(*) AS orders_before FROM customer_order; -- beklenen: 8
SELECT count(*) AS items_before FROM order_item; -- beklenen: 14
DELETE FROM customer_order WHERE order_id = 6;
SELECT count(*) AS orders_after FROM customer_order; -- beklenen: 7
SELECT count(*) AS items_after FROM order_item; -- beklenen: 13
ROLLBACK;
```

10 Kasım 2026 tarihinde `verification.sql` çalıştırıldı: orders_before=8, items_before=14; DELETE 1; orders_after=7, items_after=13; ROLLBACK. Gerçek ham çıktı `verification_output.txt` içindedir. Transaction geri alındı ve seed sayıları otomatik doğrulamayla yeniden kontrol edildi.

`RESTRICT`, başvurulan satırın silinmesini hemen engeller; `NO ACTION` kontrolü uygun koşullarda transaction sonuna ertelenebilir (`DEFERRABLE` tanımlanmışsa). PostgreSQL dokümanı: https://www.postgresql.org/docs/current/ddl-constraints.html#DDL-CONSTRAINTS-FK
