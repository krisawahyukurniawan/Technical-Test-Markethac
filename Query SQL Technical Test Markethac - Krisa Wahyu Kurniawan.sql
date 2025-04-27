WITH report_monthly_orders_product_agg AS (
  SELECT
    FORMAT_TIMESTAMP('%Y-%m', o.created_at) AS order_month,
    oi.product_id,
    p.name AS product_name,
    COUNT(oi.id) AS total_order_items,
    SUM(oi.sale_price) AS total_revenue
  FROM
    `bigquery-public-data.thelook_ecommerce.order_items` AS oi
  JOIN
    `bigquery-public-data.thelook_ecommerce.orders` AS o
  ON
    oi.order_id = o.order_id
  JOIN
    `bigquery-public-data.thelook_ecommerce.products` AS p
  ON
    oi.product_id = p.id
  WHERE
    o.status = 'Complete'
  GROUP BY
    order_month, product_id, product_name
),
ranked_products AS (
  SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY order_month ORDER BY total_revenue DESC) AS rank_per_month
  FROM
    report_monthly_orders_product_agg
)

SELECT
  order_month,
  product_id,
  product_name,
  total_revenue
FROM
  ranked_products
WHERE
  rank_per_month = 1
ORDER BY
  order_month;