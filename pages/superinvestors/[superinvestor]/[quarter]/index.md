```cik_quarter
select 
cusip,
cusip_ticker,
name,
cik,
quarter,
SUM(value) as value,
SUM(shares) as shares,
ROUND((SUM(value)/ SUM(shares)),2) as avg_price_usd,
ROUND((SUM(value) / SUM(SUM(value)) OVER ()), 2) AS pct
from cik_quarter
where cik = '${$page.params.superinvestor}' AND quarter = '${$page.params.quarter}'
GROUP BY cusip, cusip_ticker, name, cik, quarter
ORDER BY SUM(value) DESC
```



<!-- # **<Value data={props.entries} column=cik_name />** in **{$page.params.quarter}**: -->
# **{$page.params.superinvestor}** in **{$page.params.quarter}**:
**TODO**:*Add the total value for the quarter as /BigValue here* <br>
**TODO**:*To the table below add the percentage part of the whole columnn for each CUSIP*<br>

<DataTable
    data={cik_quarter} search=true>
    <Column id="cusip_ticker" title='Ticker'/>
    <Column id="name" title='Name'/>
    <Column id="value" title='Value' fmt='$#,##0.0,,"M"'/>
    <Column id="pct" title='Part of' fmt='#,##0%'/>
    <Column id="avg_price_usd" title='Avg Price'/>
</DataTable>


<!-- <pre> -->
<!-- {JSON.stringify(treemap_data[0], null, 2)}, -->
<!-- {JSON.stringify(props.entries[0], null, 2)} -->
<!-- </pre> -->


# Asset Distribution


<ECharts config={
    {title: {
            text: 'Value by Asset',
            left: 'center'},
        tooltip: {
        formatter: function (params) {
                    let value = params.data.value;
                    let formattedValue = '';
                    if (value >= 1e9) {
                        formattedValue = (value / 1e9).toLocaleString('en-US', { maximumFractionDigits: 2 }) + 'B';
                    } else if (value >= 1e6) {
                        formattedValue = (value / 1e6).toLocaleString('en-US', { maximumFractionDigits: 2 }) + 'M';
                    } else {
                        formattedValue = value.toLocaleString('en-US', { maximumFractionDigits: 2 });
                    }
                    return `${params.name}<br/>
                    $${formattedValue}<br/>
                    ${params.data.pct*100}%`;
                },
    },
        series: [
        {name: 'All Assets',
            type: 'treemap',
            data: cik_quarter,
            label: {
                fontWeight: 'bold',
            position: 'insideTopLeft',
            show: true,
            formatter:  function (params) {      
                const formattedValue = params.data.value.toLocaleString('en-US', {
                maximumFractionDigits: 2
                    });
                return `${params.name}\n${params.data.pct*100}%`;
                        }
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


