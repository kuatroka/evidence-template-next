<script>
  import RangeSlider from "svelte-range-slider-pips";
  
  export let quarters = [ 
    "1999Q1",
    "1999Q2",
    "1999Q3",
		"2000Q3",
    "2015Q1",
    "2023Q2",
    "2023Q3", 
    "2023Q4"
  ];
  export let formattedQuarter = '';
  export let selectedQuarter = '';
  
  $: min = 0; 
  $: max = quarters.length - 1;
  
  $: selectedQuarter = max;  
  $: formattedQuarter = quarters[selectedQuarter];
  
  </script>
  
  <div style="--range-slider: goldenrod; --range-handle-inactive: goldenrod; --range-handle-focus:goldenrod;">
  <RangeSlider      
    min={min}   
    max={max}      
    values={[selectedQuarter]}   
    step={1}      
    bind:value={selectedQuarter}  
    on:change={({detail: {value}}) => { 
      selectedQuarter = value;
      formattedQuarter = quarters[selectedQuarter];
    }}    
  />
  </div>
  
  <!-- <p>
    Selected Quarter: {formattedQuarter}
  </p> -->