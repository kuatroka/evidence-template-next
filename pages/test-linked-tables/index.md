```channels
select
channel,
'?channel=' || channel as link
from orders
group by 1
```

## Filter



<DataTable data={channels} link=link />

```items
select
email,
channel,
sum(sales) as sales_usd
from orders
group by 1,2
order by 3 desc,1
```

Click on a row to filter the below table

## Filtered Table

{#if   $page.url.searchParams.get('channel')}

<DataTable data={items.filter(d=>d.channel ===   $page.url.searchParams.get('channel'))}/>

{:else}
<DataTable data={items}/>
{/if}