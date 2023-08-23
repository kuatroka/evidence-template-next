<script>
    const total_cik_per_cusip = props.other_cik_per_cusip[0].total_num_cik
    const total_tr_per_cusip = props.other_cik_per_cusip[0].total_num_tr
    const cik_name = props.tr_per_cik[0].cik_name
    const name_of_issuer = props.tr_per_cik[0].name_of_issuer 
    const num_tr = props.tr_per_cik[0].num_tr
    const format_usd = '[>=1000000000000]$#,##0.0,,,,"T";[>=1000000000]$#,##0.0,,,"B";[>=1000000]$#,##0.0,,"M";$#,##0k'
    const format_shares = '[>=1000000000]#,##0.0,,,"B";[>=1000000]#,##0.0,"M";#,##0k'

    // '[>=1000000000000]$#,##0.0,,,,"T";[>=1000000000]$#,##0.0,,,"B";[>=1000000]$#,##0,,"M";$#,##k'
</script>

# <span style="color: goldenrod;">{cik_name}</span> {num_tr === 1 ? 'trade' : 'trades'} in<br>**<span style="color: steelblue;">{name_of_issuer}</span>** 

## List of trades:
(click for details)




<DataTable data={props.tr_per_cik} link=link>
<Column id="tr_number"  title='Tr #' align="left" />
    <Column id="tr_open"  title='Open'/>
    <Column id="tr_open_value"  title='($)' fmt={format_usd} align="left"/>
    <Column id="tr_duration_qtr" title='# Quarters' align="left"/>
    <Column id="tr_close"  title='Close' align="right"/>
    <Column id="tr_close_value" title='($)' fmt={format_usd} align="right"/>
    <Column id="tr_pnl" title='%P/L' fmt='#0.01\%'/>
</DataTable>


{#if   $page.url.searchParams.get('tr_id')}
# <span style="color: goldenrod;">Transaction **<span style="color: steelblue;"># {props.tr_per_cik.filter(d=>d.tr_id ===   $page.url.searchParams.get('tr_id'))[0].tr_number}</span>** Drill Down</span>


<DataTable data={props.tr_per_cik_drilldown.filter(d=>d.tr_id ===   $page.url.searchParams.get('tr_id'))}>
<Column id="quarter"  title='Quarter' sort=true/>
<Column id="tr_type"  title='Type' />
<Column id="tr_shares"  title='Tr Shares(#)' fmt={format_shares}/>
<Column id="tr_value"  title='Tr Value' fmt={format_usd}/>
<Column id="value"  title='Total Value' fmt={format_usd}/>
<Column id="shares"  title='Total Shares'/>
<Column id="qtr_pnl_prc"  title='Qtr %P/L' fmt='#0.01\%'/>
</DataTable>

{:else}
<!-- <DataTable data={props.tr_per_cik_drilldown}>
<Column id="quarter"  title='Quarter'/>
<Column id="tr_type"  title='Exit On' />
</DataTable> -->

{/if}
**TODO**:*Sort out wrong P/L in transactins wehere stock split occured"*

**TODO**:*Sort out wrong 'CLOSE' when the current quarter is the same as the maximum reported quarter for this cik"*


**TODO**:*Maybe add component/info on "Who else added/reduced the same security in the same quarter?"*

**TODO**:*Add more statistics around the transaction. Like total P/L per each TR and P/L between each period, percentage change for values/shares
added or reduced, "
I might also somehow connect the cik, cusip AND the quarter from the previos page to this page's default view and automaticallyl select the correct transation and maybe even highlight the quarte of transactions...
but it might be just a red herring and something that disctacts me from the core focus on quality and not
quantity of charts...
focus on what is really needed...*

# <span style="color: goldenrod;">Who else traded in<br>**<span style="color: steelblue;">{name_of_issuer}</span>** 
### Since 1999  there have been **{total_cik_per_cusip}** superinvestors who traded **{total_tr_per_cusip}** times in {name_of_issuer}

**TODO**:*I need to make the part 'since 1999' dynamic and dependent on the actual data.
I need to have a real year where trading in this company started for the first time"*

<DataTable data={props.other_cik_per_cusip} link="link">
<Column id="cik_name"  title='Superinvestor' sort=true/>
<Column id="num_tr_per_cik"  title='# Tr' />
<Column id="avg_tr_pnl_per_cik"  title='Avg %P/L' fmt='#0.01\%'/>
<Column id="link"  />
</DataTable>

