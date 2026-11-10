# Week 05 — Çalıştırma ve kontrol

Önce PostgreSQL kurulu ve `come381` adlı **boş** veritabanı hazır olmalı. Repo kökünde sırayla:

```bash
psql -d come381 -v ON_ERROR_STOP=1 -f sql/schema.sql
psql -d come381 -v ON_ERROR_STOP=1 -f week-05/constraints.sql
psql -d come381 -f week-05/violations.sql > week-05/violations_output.txt 2>&1
psql -d come381 -v ON_ERROR_STOP=1 -f week-05/seed.sql
psql -d come381 -v ON_ERROR_STOP=1 -f week-05/algebra.sql
```

Windows'ta her komuta `-h 127.0.0.1 -U postgres` ekle; parola istenir. `schema.sql` ve `constraints.sql` ikinci kez aynı veritabanına uygulanmaz; yeniden başlamak için boş veritabanı oluştur. İhlal dosyası beklenen hataları bilerek üretir, bu yüzden bu komutta `ON_ERROR_STOP` açılmaz. `violations_output.txt`, psql'nin stdout ve stderr akışları doğrudan aynı dosyaya yönlendirilerek üretildi ve elle düzenlenmedi. PowerShell yerine cmd.exe yönlendirmesi kullanılarak test işaretleri ve hataların sırası korundu.

## NULL testi

T31'de `discount_price` NULL olarak kabul edilir. PostgreSQL `CHECK` ifadesi `FALSE` olduğunda reddeder; `NULL` içeren karşılaştırma `UNKNOWN` üretebildiği için `NOT NULL` yoksa kabul edilebilir.

## Gerçek çalıştırma gözlemleri

PostgreSQL 18.6 üzerinde 33 testin tümü beklenen SQLSTATE veya OK sonucunu verdi. İki ardışık çalıştırmanın çıktıları birebir aynıydı. Yönergedeki genel 23503 beklentisinin aksine RESTRICT ile engellenen DELETE, T24 ve T27'de 23001 (restrict_violation) verdi; beklenen kodlar bu gerçek davranışa göre açıkça yazıldı. Kaynak: https://www.postgresql.org/docs/18/errcodes-appendix.html

Başlangıç taslağında açık ID ile INSERT, identity dizisini ilerletmediği için UNIQUE testleri yanlışlıkla primary key'e takılabiliyordu; hazırlık ve seed sonunda setval ile düzeltildi. T17'de fiyat düşürülürken indirimin de NULL yapılması, testin yanlış CHECK'e takılmasını önledi. Test çıktıları, cebir sonuçları ve otomatik doğrulama özeti bu klasördedir.

Ek kontrol: `psql -h 127.0.0.1 -U postgres -d come381 -v ON_ERROR_STOP=1 -f week-05/verification.sql`. Yalnız bu projeye ait test veritabanında çalıştır: violations ve seed tabloları boşaltır.

Not: `violations.sql` dosyasında T32 sipariş silme CASCADE testidir; ayrıca `on_delete.md` dosyasındaki sayım denemesini `seed.sql` sonrasında çalıştır.
