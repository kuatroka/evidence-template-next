```sales_by_state
from sales_by_state
select state, sales_usd
where state = '${$page.params.state}'
```


# The state is {$page.params.state}

# The state is <Value data={sales_by_state} column=state />

<DataTable data="{sales_by_state}" search="true">
    <Column id="state" />
    <Column id="sales_usd" />
</DataTable>

