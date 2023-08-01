<script>
    // import RangeInputYear2 from './components/RangeInputYear2.svelte';
    import  RangeInputYear2  from '../../components/RangeInputYear2.svelte';    
    // import Alert from './components/Alert.svelte';
    $: quarterValue = $quarterValue
</script>
{quarterValue}


<!-- <RangeInputYear2/> -->
<!-- {quarterValue} -->
<!-- {JSON.stringify($page.params, null, 2)} -->
<!-- {JSON.stringify($page, null, 2)} -->

<!-- <table>
    <thead>
        <tr>
        <th>Quarter</th>
        <th>Name</th>
        <th>Value</th>
        </tr>
    </thead>
    <tbody>
        {#each props.entries as entry}
        <tr>
            <td>{entry.quarter}</td>
            <td>{entry.name_of_issuer}</td>
        </tr>
        {/each}
    </tbody>
</table> -->





<!-- {$inputYearQuaterStore} -->