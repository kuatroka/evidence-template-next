from main.orders
select order_datetime AS date,
        state,
        SUM(sales) as sales_usd
group by all
order by SUM(sales) DESC
