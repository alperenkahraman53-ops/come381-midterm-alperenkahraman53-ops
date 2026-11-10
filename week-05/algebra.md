# Bölüm D — İlişkisel cebir ve hesap

Kısaltmalar: C=customer, P=product, O=customer_order, I=order_item. `⋈` koşullu birleştirme, `π` izdüşüm, `σ` seçim, `ρ` yeniden adlandırmadır. Aşağıdaki sonuçlar 10 Kasım 2026 tarihinde PostgreSQL 18.6 üzerinde doğrulanmıştır. Ham çıktı: `algebra_output.txt`; D2 için aşağıda ilk 10 satır gösterilmiştir.

## D1 — Fiyatı 1000'den büyük ürünlerin adları

Cebir: `π product_name (σ list_price>1000 (P))`

SQL: `algebra.sql` D1. Beklenen: `Kulaklik`, `Laptop`.

Tuple relational calculus: `{ t.product_name | product(t) ∧ t.list_price > 1000 }`.

`DISTINCT`: SQL'de cebir küme olduğu için kullanıldı; bu veride isimler farklı olsa da şema aynı ada izin verir.

## D2 — Her sipariş kaleminin müşteri ve ürün adı

Cebir: `π full_name,product_name (C ⋈ C.customer_id=O.customer_id O ⋈ O.order_id=I.order_id I ⋈ I.product_id=P.product_id P)`.

SQL: `algebra.sql` D2. 13 farklı müşteri/ürün çifti döndü; ilk 10 satır:

| Müşteri | Ürün |
|---|---|
| Ayse Yilmaz | Defter |
| Ayse Yilmaz | Kulaklik |
| Ayse Yilmaz | Laptop |
| Ayse Yilmaz | Mouse |
| Ayse Yilmaz | Roman |
| Can Arslan | Defter |
| Elif Kaya | Kulaklik |
| Elif Kaya | Laptop |
| Elif Kaya | Roman |
| Mehmet Demir | Laptop |

`DISTINCT`: Cebirdeki izdüşümle aynı küme sonucunu almak için kullanıldı. Ayse'nin Laptop satın alımı iki siparişte geçse de sonuçta bir kez görünür.

## D3 — Elektronik veya kitap almış müşteriler

Cebir: `π customer_id,full_name (C ⋈ O ⋈ I ⋈ σ category='electronics' (P)) ∪ π customer_id,full_name (C ⋈ O ⋈ I ⋈ σ category='books' (P))` (birleştirmeler ilgili FK=PK üzerinden).

SQL: `algebra.sql` D3. Beklenen: Ayse Yilmaz, Mehmet Demir, Elif Kaya.

`DISTINCT`: `UNION` zaten tekrarları kaldırır; ayrıca gerekli değil.

## D4 — Hiç sipariş vermeyen müşteriler

Cebir: `π customer_id,full_name (C) − π customer_id,full_name (C ⋈ C.customer_id=O.customer_id O)`.

SQL: `algebra.sql` D4a (`EXCEPT`) ve D4b (`NOT EXISTS`). Beklenen: `6 | Deniz Acar`.

`DISTINCT`: `EXCEPT` küme sonucu üretir; `NOT EXISTS` müşteri anahtarına göre tek müşteri satırı döndürür. İkisine de gerekmez.

## D5 — Aynı şehirde yaşayan farklı müşteri çiftleri

Cebir: `π A.full_name,B.full_name,A.city (σ A.city=B.city ∧ A.customer_id<B.customer_id (ρ A(C) × ρ B(C)))`.

SQL: `algebra.sql` D5. Beklenen: `Ayse Yilmaz | Elif Kaya | Istanbul`; `Mehmet Demir | Zeynep Celik | Ankara`.

`DISTINCT`: Aynı isimli farklı müşteriler bulunabileceğinden izdüşümün küme anlamını korumak için kullanıldı. Kimlik karşılaştırması çiftleri tek yönde üretir.

## D6 — Elektronik kategorisindeki tüm ürünleri satın almış müşteriler

`E = π product_id (σ category='electronics' (P))`

`R = π customer_id,product_id (O ⋈ O.order_id=I.order_id I)`

Cebir: `π customer_id,full_name (C ⋈ (R ÷ E))`.

Bu ifade, seed verisindeki gibi E boş değilken SQL ile eşdeğerdir. Boş bölen durumunda klasik R÷E yalnız R'nin müşteri izdüşümünü aday alır; SQL ise bütün C'yi aday alır. Bütün müşterileri aday alan tam ifade: `π customer_id,full_name (C ⋈ (π customer_id(C) − π customer_id((π customer_id(C) × E) − R)))`.

SQL: `algebra.sql` D6. Beklenen: `1 | Ayse Yilmaz`. Mehmet yalnız Laptop ve Mouse aldığı için **neredeyse adaydır**; Kulaklik eksiktir.

`DISTINCT`: İki `NOT EXISTS` varlık kontrolü yaptığı ve dış sorgu tekil müşteri satırlarını gezdiği için gerekli değildir. `NOT EXISTS` yöntemini seçtim; bir ürünün farklı siparişlerde tekrar satın alınması sonucu bozmaz. Elektronik ürün kümesi boş olsaydı bu mantık bütün müşterileri döndürürdü (boş küme üzerinde evrensel niceleme).
