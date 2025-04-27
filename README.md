Penjelasan:
1. WITH report_monthly_orders_product_agg AS (.....)
	- WITH clause (Common Table Expression/CTE) digunakan untuk membuat tabel 	sementara bernama `report_monthly_orders_product_agg`.
	- Pada bagian ini:
		- FORMAT_TIMESTAMP('%Y-%m', o.created_at) AS order_month: Query ini berfungsi untuk mengubah timestap order menjadi format tahun-bulan (YYYY-MM), lalu dinamai dengan `order_month`.
		- `oi.product_id`: Query ini berfungsi untuk mengambil ID produk dari tabel order_items (`oi`).
		-  `p.name AS product_name`: Query ini berfungsi untuk mengambil nama produk dari tabel products (`p`) dan dinamai `product_name`.
		- `SUM(oi.sale_price) AS total_revenue`: Query ini berfungsi untuk menjumlahkan seluruh nilai penjualan dari produk.
	- FROM: Data diambil dari tabel `order_items` (`oi`).
	- JOIN:
		- `orders`(`o`) di-join-kan dengan `order_items` berdasarkan `order_id`.
		- `products`(`p`) di-join-kan dengan `order_items` berdasarkan `product_id`.
	- WHERE: Dimana hanya mengambil data order yang memiliki status `Complete` (selesai).
	- GROUP BY: mengelompokkan data berdasarkan bulan order, ID produk, dan nama produk.

2. ranked_products AS (.....)
- CTE kedua bernama `ranked_products`.
- Pada bagian ini:
	- SELECT *: Query ini akan memilih atau mengambil semua kolom dari `report_monthly_orders_product_agg`.
	- ROW_NUMBER() OVER (PARTITION BY order_month ORDER BY total_revenue DESC) AS rank_per_month:
		- Memberikan nomor urut (`rank`) untuk setiap produk dalam satu bulan.
		- Urutan berdasarkan `total_revenue` terbesar dari terkecil (DESC).
		- Setiap bulan (`PARTITION BY order_month`) dihitung rank-nya masing-masing.

3. SELECT ..... FROM ranked_products WHERE rank_per_month = 1
- SELECT:
	- Memilih kolom `order_month`, `product_id`, `product_name`, dan `total_revenue`.
- FROM ranked_products: Data diambil dari hasil `ranked_products`.
- WHERE rank_per_month = 1:
	- Hanya memilih produk yang memiliki rank pertama (penjualan tertinggi) setiap bulan.
- ORDER BY order_month:
	- Mengurutkan hasil akhir berdasarkan bulan order secara naik (dari bulan awal ke bulan akhir).

Inti atau kesimpulan Query ini adalah untuk menghasilkan daftar produk dengan total revenue tertinggi di setiap bulan dari data ecommerce thelook BigQuery Public Dataset.