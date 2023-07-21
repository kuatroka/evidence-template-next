from main.orders
select state,
        SUM(sales) as sales_usd
group by all
order by SUM(sales) DESC
