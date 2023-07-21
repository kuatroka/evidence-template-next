WITH total_sales AS (
        SELECT SUM(sales) as total_sales_usd
        FROM main.orders
)

SELECT state,
        SUM(sales) as sales_usd,
       (SUM(sales) / (SELECT total_sales_usd FROM total_sales)) * 100 as pct
FROM main.orders
GROUP BY state
ORDER BY SUM(sales) DESC
