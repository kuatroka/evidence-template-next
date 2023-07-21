# Overview {$page.params.superinvestor} across the years

```cik_quarters
from cik_all_quarters
select cik_name, quarter, value_usd
where cik = '${$page.params.superinvestor}'
```

# **<Value data={cik_quarters}  column=cik_name row=0/>**

<DataTable data="{cik_quarters}" link="quarter" search="true">
    <Column id="quarter" />
    <Column id="value_usd" />
</DataTable>

