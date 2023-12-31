```every_cik_every_qtr_filtered
select *,
ROUND(value_usd / sum(value_usd) over(),3) as pct_pct
from every_cik_qtr
where quarter = '${inputYearQuater}'
order by value_usd DESC
```
```summary_filtered
select 
quarter,
ANY_VALUE(prev_quarter) as prev_quarter,
sum(value_usd) as value,
sum(num_assets) as num_assets,
count(cik) as num_ciks,
from ${every_cik_every_qtr_filtered}
group by all
```


```every_cik_latest_qtr
select *,
ROUND(value_usd / sum(value_usd) over(),3) as pct_pct
from every_cik_qtr
where quarter = '${latest_quarter_one_value}'
order by value_usd DESC
```


```every_cik_prev_qtr
select *,
ROUND(value_usd / sum(value_usd) over(),3) as pct_pct
from every_cik_qtr
where quarter = '${prev_quarter_one_value}'
order by value_usd DESC
```

```prev_qtr_treemap
select cik_name as name,
    value_usd as value, 
    pct_pct
from ${every_cik_prev_qtr}
```

```latest_qtr_treemap
select cik_name as name,
    value_usd as value,
    pct_pct
from ${every_cik_latest_qtr}
```

```latest_qtr_treemap_filtered
select cik_name as name,
    value_usd as value,
    pct_pct
from ${every_cik_every_qtr_filtered}
```

```avg
select ROUND(avg(num_ciks_per_quarter_num0),0) as avg_ciks,
        ROUND(avg(num_cusip_per_quarter_num0),0) as avg_assets,
        ROUND(avg(total_value_per_quarter_usd),0) as avg_value,
from cik_cusip_per_quarter
```


```cik_cusip_per_quarter
select *
from cik_cusip_per_quarter
```

```cik_cusip_per_quarter_filtered
select *
from cik_cusip_per_quarter
where quarter = '${inputYearQuater}'
```

```cik_cusip_per_quarter2
SELECT
    t.year,
    t.max_quarter_end_date,
    q.num_ciks_per_quarter_num0,
    q.num_cusip_per_quarter_num0, 
    q.total_value_per_quarter_usd AS total_value_per_quarter_usd
    FROM (
    SELECT 
        SUBSTR(quarter, 1, 4) AS year,
        MAX(quarter_end_date) AS max_quarter_end_date
    FROM cik_cusip_per_quarter
    WHERE is_quarter_completed = 'YES'
    GROUP BY year
    ) t
    JOIN cik_cusip_per_quarter q 
    ON q.quarter_end_date = t.max_quarter_end_date
    ORDER BY t.year;
```


<script>

const latest_quarter = cik_cusip_per_quarter[0]
const prev_quarter = cik_cusip_per_quarter[1]
const prev_prev_quarter = cik_cusip_per_quarter[2]
// const total_years = cik_cusip_per_quarter.map(q => q.total_years)[0]
const total_quarters = cik_cusip_per_quarter.map(q => q.total_quarters)[0]
const total_ciks = cik_cusip_per_quarter.map(q => q.total_ciks)[0]
const latest_quarter_one_value = cik_cusip_per_quarter.map(q => q.quarter)[0]

$: prev_quarter_one_value = every_cik_every_qtr_filtered.map(item => item.prev_quarter)[0]


const prev_prev_quarter_one_value = cik_cusip_per_quarter.map(q => q.quarter)[2]
const current_year_one_value = cik_cusip_per_quarter.map(q => q.quarter.slice(0, 4))[0]

let quarters = cik_cusip_per_quarter.map(item => (item.quarter)).reverse();
$: inputYearQuater = quarters[quarters.length -1];

let min = '1999Q1'
let max = latest_quarter_one_value
function dynamicFormat(value) {
    if (value >= 1000000000000) {
        return (value / 1000000000000).toFixed(1) + 'T';
    } else if (value >= 1000000000){
        return (value / 1000000000).toFixed(1) + 'B';
    } else if (value >= 1000000) {
        return (value / 1000000).toFixed(1) + 'M'; 
    } else {
        return value.toLocaleString();
    }
}

const format_usd = '[>=1000000000000]$#,##0.0,,,,"T";[>=1000000000]$#,##0.0,,,"B";[>=1000000]$#,##0.0,,"M";$#,##0k'
const format_shares = '[>=1000000000]#,##0.0,,,"B";[>=1000000]#,##0.0,"M";#,##0k'

</script>

<!-- {JSON.stringify((Object.keys(data, null, 2)))} -->

<Modal title="Data Quality Warning and Site's Purpose" buttonText='Open Modal'> 

This site is for financial investigation and reseaerch only. Nothing here consitutes investment  or any other kind of advice.

The US SEC doesn't enforce or check the quality of the submitted 13F filings data and it is notoriously
bad. We are doing our best to make it better, but there will alwayse be some data bug or error especially 
in the years from 1999 to 2013. 

</Modal>

# **{cik_cusip_per_quarter[0].total_years}** Years Of 13F Filings
### Since 1999, *The U.S. Securities and Exchange Commission (SEC)* requires institutional investors that **"exercise investment discretion over $100 million or more"** to report what is known as **13F Filing**. <br>
### These filings are produced every **Quarter** and investors have **45 days** after the end of quarter to report what financial assets and in what quantity they owned at the last day of each quarter. 
<hr>

<!-- **TODO**:*I could add a collapsible content here to give user an option to use a slider to
interact and filter on other quarters and see the same cards (BigValue) with their dynamically
changing data* -->



<BigValue
    data={cik_cusip_per_quarter}
    title="All Superinvestors"
    value=total_ciks_num0
/>

<BigValue
    data={cik_cusip_per_quarter}
    title="Reported Years"
    value=total_years
/>

<BigValue
    data={cik_cusip_per_quarter}
    title="Traded Assets"
    value=total_cusip_num0
/>

**TODO**:*Maybe add one more BigValue here for Total Value traded in 25 years*



<!-- **TODO**:*correct the tooltip formatting for Line Chart for Value, Assets. Now it shows data in Billions and 
it needs to be Trillions* -->

<hr>

<Tabs>
    <Tab label="Value">
        <AreaChart 
            data={cik_cusip_per_quarter2}
            x=year 
            y=total_value_per_quarter_usd
            yAxisTitle="Value end of Year"
            sort=asc
        />

    </Tab>

    <Tab label="Superinvestors">
        <BarChart 
        data={cik_cusip_per_quarter2}
        x=year 
        y=num_ciks_per_quarter_num0
        yAxisTitle="Active Superinvestors During Year"
        />
    </Tab>

        <Tab label="Assets">
        <BarChart 
        data={cik_cusip_per_quarter2}
        x=year 
        y=num_cusip_per_quarter_num0
        fmt= '#,##0'
        yAxisTitle="# of Traded Assets"
        />
    </Tab>
        <Tab label="Table">
        <DataTable data="{cik_cusip_per_quarter2}" search="true">
            <Column id="year" title='Year'/>
            <Column id="total_value_per_quarter_usd" title='Value at End of Year'/>
        </DataTable>

    </Tab>

    <Tab label="Every Cik Last Qtr">
        <DataTable data="{every_cik_prev_qtr}" search="true">
            <Column id="cik" title='cik'/>
            <Column id="value_usd" title='Value'/>
        </DataTable>
    </Tab>

</Tabs>




<!-- # There has been **<Value data={max_qtr} column=num_ciks/>** superinvestors <br> between **1999** and **<Value data={max_qtr} column=max_year/>**  -->



# Quarter: <span style="color: goldenrod;">{inputYearQuater}</span>
### Filing closes on: **{cik_cusip_per_quarter[0].last_reporting_date}** (Fix this)
<!-- **TODO**:*Fix the code for the last reporting date/reporting closed date* -->

<RangeInputYear {quarters} bind:quarterValue={inputYearQuater} />

<BigValue
    data={every_cik_every_qtr_filtered}
    title="Total Value"
    value=total_value_quarter_all_cik_usd  
    fmt='$#,##0.0,,,,"T"' 
    comparison=prc_change_total_value_pct
    comparisonTitle="Over {prev_quarter_one_value}"
/>


<BigValue
    data={every_cik_every_qtr_filtered}
    title="# of Superinvestors"
    value=total_num_cik_per_quarter_num0  
    fmt='#,##0'  
    comparison=prc_change_total_num_cik_pct
    comparisonTitle="Over {prev_quarter_one_value}"
/>


<BigValue
    data={every_cik_every_qtr_filtered}
    title="# of Assets"
    value=total_assets_per_quarter_num0  
    fmt='#,##0'  
    comparison=prc_change_total_num_assets_pct
    comparisonTitle="Over {prev_quarter_one_value}"
/>
    <!-- comparison=prc_change_cik
    comparisonTitle="% Over {prev_quarter_one_value}" -->

<!-- **TODO**:*Formatting of values in the table is not dynamic - needs correction*
**TODO**:*The search box is not synchronised with the slider. When inputting search term and 
selecting values on slider the results ignore the search term*  -->


<Tabs>
    <Tab label="Table">
        <DataTable data="{every_cik_every_qtr_filtered}" link="cik" search="true">
            <Column id="cik_name" title='Superinvestor'/>
            <Column id="num_assets" title='Assets (#)'/>
            <Column id="value_usd" title='Value ($)' fmt={'[>=1000000000000]$#,##0.0,,,,"T";[>=1000000000]$#,##0.0,,,"B";[>=1000000]$#,##0.0,,"M";[>=1000]$#,##0k'}/>
            <Column id="pct_pct" title='Weight (%)'/>
        </DataTable>

    </Tab>

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
            data: latest_qtr_treemap_filtered,
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
**TODO**:*By dedault, under the chart, the title shows some arbitrary tile's name*
    </Tab>

</Tabs>

**TODO**:*I'd like to make the Racing Bar chart work*
**TODO**:*It might be interesting to make a timeline of all cik over all 25 years.
I could show when each cik first appeared and when it disappeared. When it had gaps in being active
I could use color coding. Those with no gaps - blue, with gaps - red...o something like it
i could use this [example](https://unovis.dev/gallery/view?collection=Lines%20and%20Areas&title=Basic%20Timeline) to do the timeline*






































<!-- <ScatterPlot 
    data={cik_cusip_per_quarter} 
    y=num_cusip_per_quarter_num0 
    x=total_value_per_quarter_usd
    xAxisTitle="total_value_per_quarter_usd" 
    yAxisTitle="num_cusip_per_quarter_num0" 
/> -->





