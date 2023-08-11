
```cik_quarters_table
from every_cik_qtr
select cik_name, quarter, quarter_end_date, value_usd, num_assets AS num_assets_num0,
prc_change_value AS prc_change_value_pct, prc_change_num_assets AS prc_change_num_assets_pct,
prev_quarter
where cik = '${$page.params.superinvestor}'
order by quarter desc
```
<!-- -- ```cik_quarters_table_filtered
-- from every_cik_qtr
-- select quarter, value_usd
-- where quarter = '${inputYearQuater}'
-- ``` -->


```cik_max_min_quarter
from every_cik_qtr
select MAX(quarter) AS max_quarter, MIN(quarter) AS min_quarter
where cik = '${$page.params.superinvestor}'
group by all
```



<!-- -- ```cik_quarters_table_filtered_quarter
-- from every_cik_qtr
-- select 
--     *,
--     (value_usd - prev_value_usd) / prev_value_usd  AS pct_change_value_pct,
--     (num_assets - prev_num_assets) / prev_num_assets  AS pct_change_assets_pct,
-- where cik = '${$page.params.superinvestor}' AND quarter = '${inputYearQuater_cik}'
-- order by quarter desc
-- ``` -->



```cik_quarters_area
from every_cik_qtr
select cik_name, quarter, quarter_end_date, value_usd, num_assets AS num_assets_num0
where cik = '${$page.params.superinvestor}'
order by quarter asc
```

<script>
//  /** @type {import('./$types').PageData} */

import { writable } from 'svelte/store';

let quarters = cik_quarters_table.map(item => (item.quarter)).reverse();
$: years_active = quarters.length/4;
let inputYearQuaterStore = writable(quarters[quarters.length - 1]);
$: inputYearQuater = $inputYearQuaterStore;
$: inputYearQuaterStore.set(inputYearQuater)


$: entries = props.entries.filter(d => d.quarter === $inputYearQuaterStore);
$: quarter_filtered = cik_quarters_table.filter(d => d.quarter === $inputYearQuaterStore);
$: prev_quarter = quarter_filtered.map(item => (item.prev_quarter))[0];
    

</script>

# <span style="color: goldenrod;">{cik_quarters_table[0].cik_name}</span>
## Active for **<span style="color: steelblue;">{years_active}</span>** years since **<span style="color: steelblue;">{quarters[0]}</span>**

<LineChart
title="Value($)"
    data={cik_quarters_area}
    x=quarter
    y=value_usd >
    <!-- <ReferenceArea xMin="2018Q4" xMax="2020Q4"/> -->
</LineChart>

## Quarter: <span style="color: goldenrod;">{inputYearQuater}</span>
<RangeInputYear {quarters} bind:quarterValue={inputYearQuater} />

<!-- **TODO**:*Play with the color of the slider rail and the trail. Try the same color as the lineChart* -->



<BigValue
    data={quarter_filtered}
    title="Value"
    value=value_usd  
    fmt={'[>=1000000000000]$#,##0.0,,,,"T";[>=1000000000]$#,##0.0,,,"B";[>=1000000]$#,##0.0,,"M";$#,##0k'}
    comparison=prc_change_value_pct
    comparisonTitle="% Over {prev_quarter}"
/>

<BigValue
    data={quarter_filtered}
    title="Assets"
    value=num_assets_num0  
    fmt='#,##0'  
    comparison=prc_change_num_assets_pct
    comparisonTitle="% Over {prev_quarter}"
/> 

<BigValue
    data={quarter_filtered}
    title="Placeholder: Synthetic P/L"
    value=num_assets_num0  
    fmt='#,##0'  
    comparison=prc_change_num_assets_pct
    omparisonTitle="% Over {prev_quarter}"
/> 

<!-- <BigValue
    data={quarter_filtered}
    title="Placeholder: Synthetic P/L - All time"
    value=num_assets_num0  
    fmt='#,##0'  
    comparison=prc_change_num_assets_pct
    omparisonTitle="% Over {prev_quarter}"
/>  -->

<Tabs>
<Tab label="Table">

<DataTable data="{entries}" link="cusip" search="true" rows=9>
    <Column id="name"  title='Name'/>
    <Column id="cusip_ticker" title= "Ticker"/>
    <Column id="value" fmt={'[>=1000000000000]$#,##0.0,,,,"T";[>=1000000000]$#,##0.0,,,"B";[>=1000000]$#,##0.0,,"M";$#,##0k'}/>
    <Column id="shares" />
    <Column id="pct_pct" title='%' />  
</DataTable>
</Tab>


<Tabs/>
<Tab label="Chart">

<ECharts config={
    {title: {
            text: 'Value by Asset',
            left: 'center'},
        tooltip: {
        formatter: function (params) {
                    let value = params.data.value;
                    let formattedValue = '';
                    if (value >= 1e12) {
                        formattedValue = (value / 1e12).toLocaleString('en-US', { maximumFractionDigits: 2 }) + 'T';
                    } else if (value >= 1e9) {
                        formattedValue = (value / 1e9).toLocaleString('en-US', { maximumFractionDigits: 2 }) + 'M';
                    } else if (value >= 1e6) {
                        formattedValue = (value / 1e6).toLocaleString('en-US', { maximumFractionDigits: 2 }) + 'M';
                    } else {
                        formattedValue = value.toLocaleString('en-US', { maximumFractionDigits: 2 });
                    }
                    return `${params.data.name}<br/>
                    $${formattedValue}<br/>
                    ${(params.data.pct_pct*100).toFixed(2)}% `;
                },
    },
        series: [
        {name: 'All Assets',
            type: 'treemap',
            data: entries,
            label: {
                fontWeight: 'bold',
            position: 'insideTopLeft',
            show: true,
            formatter: '{b}'
            },
            emphasis: {
                label: {
                    show: true,
                    fontSize: '14',
                    fontWeight: 'bold'
                }
            },
            itemStyle: {
                gapWidth: 3,
                borderColor: 'white',
            },
        }
        ]
    }
}/>
    </Tab>
</Tabs>


