<script>
    const cik_name = props.tr_per_cik[0].cik_name
    const name_of_issuer = props.tr_per_cik[0].name_of_issuer 
    const num_tr = props.tr_per_cik[0].num_tr
    const format_usd = '[>=1000000000000]$#,##0.0,,,,"T";[>=1000000000]$#,##0.0,,,"B";[>=1000000]$#,##0.0,,"M";$#,##0k'
    const format_shares = '[>=1000000000]#,##0.0,,,"B";[>=1000000]#,##0.0,"M";#,##0k'
</script>

# <span style="color: goldenrod;">{cik_name}</span> {num_tr === 1 ? 'trade' : 'trades'} in<br>**<span style="color: steelblue;">{name_of_issuer}</span>** 




<DataTable data={props.tr_per_cik} link=link>
<Column id="tr_number"  title='Tr #' align="left" />
    <Column id="tr_open"  title='Entry'/>
    <Column id="tr_open_value"  title='Entry ($)' fmt={format_usd}/>
    <Column id="tr_open_shares"  title='Entry Shares' fmt={format_shares}/>
    <Column id="tr_close"  title='Exit On' />
    <Column id="tr_close_value" title='Exit ($)' fmt={format_usd}/>
    <Column id="tr_close_shares" title='Exit Shares' fmt={format_shares}/>
</DataTable>


{#if   $page.url.searchParams.get('tr_id')}
# <span style="color: goldenrod;">Transaction **<span style="color: steelblue;"># {props.tr_per_cik.filter(d=>d.tr_id ===   $page.url.searchParams.get('tr_id'))[0].tr_number}</span>** Drill Down</span>


<DataTable data={props.tr_per_cik_drilldown.filter(d=>d.tr_id ===   $page.url.searchParams.get('tr_id'))}>
<Column id="quarter"  title='Quarter' sort=true/>
<Column id="tr_type"  title='Type' />
<Column id="tr_value"  title='($)' fmt={format_usd}/>
<Column id="tr_shares"  title='# Shares' fmt={format_shares}/>
</DataTable>

{:else}
<!-- <DataTable data={props.tr_per_cik_drilldown}>
<Column id="quarter"  title='Quarter'/>
<Column id="tr_type"  title='Exit On' />
</DataTable> -->

{/if}


**TODO**:*Maybe add component/info on "Who else added/reduced the same security in the same quarter?"*

**TODO**:*Add more statistics around the transaction. Like total P/L per each TR and P/L between each period, percentage change for values/shares
added or reduced, "*

# <span style="color: goldenrod;">Who else traded in<br>**<span style="color: steelblue;">{name_of_issuer}</span>** 

