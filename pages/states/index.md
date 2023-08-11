```sales_by_state
from sales_by_state
select date, state, sales_usd
```
```sales_by_state_pct
from sales_by_state_pct
select state, sales_usd, pct
```

```sales_by_month
select trunc_date('date', date), value
from sales_by_month
```



<LineChart
title="Value($)"
    data={sales_by_month}
    x=date
    y=value>
    <ReferenceArea xMin="2018-01-01" xMax="2020-01-01"/>
</LineChart>


<DataTable data="{sales_by_state}" search="true" link="state">
    <Column id="state" />
    <Column id="sales_usd" />
</DataTable>


