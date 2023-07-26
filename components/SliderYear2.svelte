<script>
  import RangeSlider from "svelte-range-slider-pips";
  const quarters = [ 
    { quarter: "1999Q1"},
    { quarter: "1999Q2" },
    { quarter: "1999Q3" },
    { quarter: "2015Q1" },
    { quarter: "2023Q2"},
    { quarter: "2023Q3"}, 
    {quarter: "2023Q4"}
  ];
  
  $: min = 0; 
  $: max = quarters.length - 1;
  
  $: selectedQuarter = max;  
  $: formattedQuarter = quarters[selectedQuarter].quarter;
  
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
      formattedQuarter = quarters[selectedQuarter].quarter;
    }}    
  />
  </div>
  
  <p>
    Selected Quarter: {formattedQuarter}
  </p>