# Online Alışveriş Veritabanı

Bu proje müşterilerin ürünleri sipariş edebildiği bir online alışveriş sistemini modeller. `customer`, `product`, `customer_order` ve `order_item` tabloları kullanılır. Bir siparişin birden fazla ürün içermesi ve aynı ürünün birden fazla siparişte bulunabilmesi için M:N ilişki `order_item` ara tablosuyla çözülmüştür. Sipariş tarihini ve durumunu sipariş tablosunda, satın alma anındaki birim fiyatı ise `order_item` tablosunda saklamak tarihsel fiyat bilgisini korur.

ER diyagramı: [docs/er.md](docs/er.md). Çalıştırma yönergeleri: [week-05/README.md](week-05/README.md).
