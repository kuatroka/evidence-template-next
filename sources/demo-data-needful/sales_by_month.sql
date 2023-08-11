SELECT 
DATE_TRUNC('month', order_datetime) AS date,
channel_group AS name,
SUM(sales) AS value,
DENSE_RANK() OVER (PARTITION BY DATE_TRUNC('month', order_datetime) ORDER BY SUM(sales) DESC) AS rank
FROM orders 
GROUP BY DATE_TRUNC('month', order_datetime), channel_group
order by DATE_TRUNC('month', order_datetime) DESC