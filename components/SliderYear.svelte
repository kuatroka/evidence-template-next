<script>
  import RangeSlider from "svelte-range-slider-pips";
  
  const minYear = 1999;
  const maxYear = 2023;
  const quarters = [];
  
  for (let year = minYear; year <= maxYear; year++) {
    for (let quarter = 1; quarter <= 4; quarter++) {
      quarters.push(`${year}Q${quarter}`);
    }
  }
  
  const formatQuarter = (value) => quarters[value];
  
  $: selectedQuarter = 10;
  
  // Refactor to use $: binding
  $: formattedQuarter = formatQuarter(selectedQuarter);
  
  </script>
  
  
  <RangeSlider
    min={0} 
    max={quarters.length - 1}
    values={[selectedQuarter]}
    step={1}
    format={formatQuarter}
    bind:value={selectedQuarter} 
    on:change={(event) => {
      // Update the formatted quarter text
      formattedQuarter = formatQuarter(event.detail.value);
    }}
  />
  
  <p>
    Selected Quarter: {formattedQuarter}
  </p>