# Yapay zekâ kullanım günlüğü

## GitHub teslim hazırlığı — 10 Kasım 2026

Kullanıcı GitHub bağlantısını açıp teslimi yapmamı istedi. Codex özel `alperenkahraman53-ops/come381-midterm-alperenkahraman53-ops` reposunu doğruladı; yalnız başlangıç README'si vardı. Ödevler week-05 dalına ayrı konu commit'leriyle yüklenecek ve main yönüne Pull Request açılacak; geçmiş tarihlerde çalışma yapılmış gibi commit üretilmedi. Bu repoda veya ders reposunda kullanıcıya ait senaryo Issue'su bulunamadı. Hocanın collaborator erişimi henüz yok; davet gönderimi mevcut bağlantı araçlarında desteklenmediğinden kullanıcının tamamlaması gerekebilir. Aşağıdaki önceki oturum kaydı, yerel hazırlığın yapıldığı aşamayı anlatır.

## Ödev 1

Araç: ChatGPT. Kullanım: Online alışveriş senaryosunun dört tabloya ayrılması, Mermaid ER diyagramı ve başlangıç PostgreSQL şeması taslağı. Çıktı kişisel olarak gözden geçirilmeli ve PostgreSQL'de test edilmelidir.

## Ödev 2

**Kullanılan araç:** ChatGPT.

**D6 için aynen kullanılan prompt:** "Online alışveriş veritabanımda customer, customer_order, order_item ve product tabloları var. electronics kategorisindeki tüm ürünleri satın almış müşterileri PostgreSQL SQL ile bul. Aynı ürün farklı siparişlerde birden fazla kez alınmış olabilir."

**AI tarafından önerilen sorgu:**

```sql
SELECT c.customer_id,c.full_name FROM customer c WHERE NOT EXISTS (
 SELECT 1 FROM product p WHERE p.category='electronics' AND NOT EXISTS (
  SELECT 1 FROM customer_order o JOIN order_item i ON i.order_id=o.order_id
  WHERE o.customer_id=c.customer_id AND i.product_id=p.product_id
 )
);
```

**Beklenen sonuç:** Ayse Yilmaz. **Gerçek PostgreSQL sonucu (10 Kasım 2026, 18.6):** `1 | Ayse Yilmaz`. Aynı seed üzerinde AI sorgusu ile algebra.sql D6 aynı sonucu verdi; verification.sql bunu ARRAY[1] ile otomatik karşılaştırdı.

**Yanıltıcı veri denemesi:** Ayse iki farklı siparişte aynı elektronik ürünü alsa bile `NOT EXISTS` sonucu değişmemeli. `COUNT(*)` tabanlı, tekrarlı satın alımları ayırmayan alternatif bir sorgu yanlış sayım yapabilir. `seed.sql` içinde Ayse, Laptop ürününü iki farklı siparişte satın alır (order_id 1 ve 2). Bu, tekrarları sayan hatalı `COUNT(*)` çözümünü yanıltmak için hazırlanmış karşı örnektir. İki sorguyu PostgreSQL'de çalıştırıp gerçek karşılaştırma sonucunu ekle.

**Karşı örneğin gerçek sonucu:** `verification.sql` içindeki doğru NOT EXISTS sorgusu Ayse'yi döndürdü; karşılaştırma amacıyla yazılan hatalı COUNT(*) sorgusu sıfır satır döndürdü. Ayse'nin üç farklı elektronik ürüne karşı dört elektronik satın alma satırı var; tekrar sayan sorgu onu yanlış eliyor. Mehmet bir elektronik ürünü eksik aldığı için doğru sorguda da elendi. Doğru NOT EXISTS sorgusunu tekrar satın alımla yanıltamadık; hata bulmuş gibi iddia etmiyoruz. Ham sonuç: week-05/verification_output.txt.

**Diğer kullanım:** Özgün ZIP'teki taslaklar ChatGPT yardımı içeriyordu. Bu devam oturumunda Codex yönergeleri okuyup eksik Ödev 1 foreign key'lerini ekledi, identity dizilerini düzeltti, D2 ve D5'te cebir/SQL küme eşdeğerliğini sağladı, D6 boş bölen farkını açıkladı ve 33 testi gerçek PostgreSQL üzerinde çalıştırdı. Gerçek RESTRICT kodunun 23001 olduğu görüldü. Test kanıtları otomatik kaydedildi. Kullanıcı bu açıklamaları ve önceki senaryo Issue'suna uyumu teslimden önce gözden geçirmelidir.

**Bu oturumun kullanıcı talimatı:** “ödev son aşamaya gelene kadar yap ve bana özet geç”. Buna göre dosyalar tamamlandı ve yerel test yapıldı; GitHub'a gönderilmedi. Önceki taslaktaki D6 prompt kaydı korunmuştur; bu oturumda yeniden gönderilmiş bağımsız bir dış araç çağrısı gibi sunulmamaktadır.

## Baştan kontrol — 10 Kasım 2026

Kullanıcının aynen talebi: “peki baştan bi kontrol edermisin herhangi bir sıkıntı eksiklik birşey varmı? hocanın yazdığı şeylerde ödevin konusunda bi baştan kontrol edermisin”. Codex ders reposundaki güncel iki yönergeyi yeniden okuyup projeyle karşılaştırdı. NOT NULL kurallarını PostgreSQL 18 ADD CONSTRAINT sözdizimiyle adlandırdı ve her kurala yorum ekledi; NULL INSERT ve iki sütun eşitliği için T34/T35 ekledi. D2 soru başlığını DISTINCT sonucuyla uyumlu yaptı. Cebir sonuçları ve silme kanıtları testlerle doğrulanır. Bu istem, D6 için yeniden yapılmış bağımsız bir AI çağrısı değildir; yukarıdaki D6 kaydı özgün ZIP'ten gelir. Doğru sorguyu bozmuş gibi gösterilmedi; COUNT karşı örneği yalnız karşılaştırma içindir.

Teslim durumu: Proje GitHub'a yüklendi ve PR #1 açıldı; önceki 'gönderilmedi' kaydı yerel hazırlık aşamasına aittir. Kullanıcı gizemturker davetini gönderdi; son kontrolde erişim henüz kabul edilmemişti. Senaryo Issue'sunun öğretmen onayı henüz kanıtlanamadı.
