

```cik_quarters_table
from every_cik_qtr
select cik_name, quarter, quarter_end_date, value_usd, num_assets AS num_assets_num0
where cik = '${$page.params.superinvestor}'
order by quarter desc
```

```cik_quarters_table_filtered_quarter
from every_cik_qtr
select 
    *,
    (value_usd - prev_value_usd) / prev_value_usd  AS pct_change_value_pct,
    (num_assets - prev_num_assets) / prev_num_assets  AS pct_change_assets_pct,
where cik = '${$page.params.superinvestor}' AND quarter = '${inputYearQuater_cik}'
order by quarter desc
```



```cik_quarters_area
from every_cik_qtr
select cik_name, quarter, quarter_end_date, value_usd, num_assets AS num_assets_num0
where cik = '${$page.params.superinvestor}'
order by quarter asc
```

<script>
// /** @type {import('./$types').PageData} */
    let inputYearQuater_cik = cik_quarters_table.map(q => q.quarter)[0]
    let min_cik = cik_quarters_table.map(q => q.quarter)[cik_quarters_table.length-1]
    let max_cik = cik_quarters_table.map(q => q.quarter)[0]
</script>

{min_cik}, {inputYearQuater_cik}

# <span style="color: goldenrod;">**<Value data={cik_quarters_table}  column=cik_name row=0/>**</span>
## Overview
**TODO**:*Find the best ratio to display the table and charts. Now, when clicking from the table
to the chart and back, there is a slight jump in divs positions because the table and chart have different hights.*

**TODO**:*I could add multiple Big Value components to reflect what assets were added/closed/reduced/opened(completely new)... maybe enable some links to the detailed page with those transactions*

**TODO**:*Instead of having another nested page, I could have a component with detailed portfolio
composition for each quarter being selected with a slider*
<hr>

<Tabs>
    <Tab label="Table">
        <DataTable data="{cik_quarters_table}" link="quarter" search="true" rows=9>
            <Column id="quarter" />
            <Column id="value_usd" />
            <Column id="num_assets_num0" title= "# of Assets"/>
            
        </DataTable>

    </Tab>

    <Tab label="Value">
        <AreaChart 
            data={cik_quarters_area}
            x=quarter 
            y=value_usd
            chartAreaHeight=250
        />

    </Tab>

        <Tab label="Assets">
            <BarChart 
            data={cik_quarters_area}
            x=quarter 
            y=num_assets_num0
            yAxisTitle="# of unique assets"
            chartAreaHeight=250
            />
    </Tab>
</Tabs>

# Portfolio per Quarter: <span style="color: goldenrod;">{inputYearQuater_cik}</span>


<RangeInputYear min={min_cik} max={max_cik} bind:value={inputYearQuater_cik} />

**TODO**:*Correct the slider component so it uses exactly the values available for the selected cik*

**TODO**:*Correct the slider component so it only uses the values for quarters that are actually*
*available. Now, it just has all quarter between two points in time, but sometimes the dataset has*
*gaps in it, so the quarters that are not in the dataset should not be available in the slider*

<BigValue
    data={cik_quarters_table_filtered_quarter}
    title="Portfolio Value"
    value=value_usd  
    fmt='$#,##0.0,,,"B"'
    comparison=pct_change_value_pct
    comparisonTitle="Qtr over Qtr"
/>

    <!-- comparison=prc_change_total_value
    comparisonTitle="% Over {prev_quarter_one_value}" -->

<BigValue
    data={cik_quarters_table_filtered_quarter}
    title="# of Assets"
    value=num_assets 
    fmt='#,##0'  
    comparison=pct_change_assets_pct
    comparisonTitle="Qtr over Qtr"
/>



<!-- <BigValue
    data={cik_quarters_table_filtered_quarter}
    value=num_assets 
    fmt='#,##0'  
    comparison=pct_change_assets_pct
    comparisonTitle="Qtr over Qtr"
/> -->

<!-- <BigValue
    data={summary_filtered}
    title="# of Assets"
    value=num_assets  
    fmt='#,##0'  
/> -->




<!-- # **<Value data={props.entries} column=cik_name />** -->
 <!-- in **{$page.params.superinvestor}**: -->
**TODO**:*Add the total value for the quarter as /BigValue here* <br>
**TODO**:*To the table below add the percentage part of the whole columnn for each CUSIP*<br>

<!-- <DataTable
    data={props.entries} search=true>
    <Column id="cusip_ticker" title='Ticker'/>
    <Column id="cusip_ticker_name" title='Name'/>
    <Column id="value" title='Value' fmt='$#,##0.0,,"M"'/>
    <Column id="pct" title='%Fund', fmt='#,##0%'/>
    <Column id="avg_price_usd" title='Reported Price'/>
</DataTable>  -->
