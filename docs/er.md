# Online alışveriş sistemi — ER diyagramı

```mermaid
erDiagram
    CUSTOMER ||--o{ CUSTOMER_ORDER : places
    CUSTOMER_ORDER ||--o{ ORDER_ITEM : contains
    PRODUCT ||--o{ ORDER_ITEM : appears_in
    CUSTOMER {
        int customer_id PK
        string full_name
        string email
        string city
    }
    PRODUCT {
        int product_id PK
        string product_name
        string sku
        string category
        decimal list_price
        decimal discount_price
        int stock_quantity
    }
    CUSTOMER_ORDER {
        int order_id PK
        int customer_id FK
        date order_date
        string status
    }
    ORDER_ITEM {
        int order_item_id PK
        int order_id FK
        int product_id FK
        int quantity
        decimal unit_price
    }
```

Bir müşteri birden fazla sipariş verebilir; bir sipariş tek müşteriye aittir. Sipariş ve ürün arasındaki M:N ilişki `order_item` ile iki adet 1:N ilişkiye ayrılır.
