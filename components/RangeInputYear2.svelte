<script>
  import { writable } from 'svelte/store';

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

  let sliderValue = quarters.length - 1; // Initial slider value
  export let quarterValue = writable(quarters[quarters.length - 1]);

  function handleInput(event) {
    sliderValue = event.target.value;
    quarterValue.set(quarters[sliderValue]);
  }
</script>

<div class="p-2 w-full font-sans text-sm rounded-md">
  <label for="rangeInput">
    <!-- Quarter: {$quarterValue} -->
  </label>

  <input 
    id="rangeInput"
    type="range" 
    min="0"
    max={quarters.length - 1}
    bind:value={sliderValue}
    on:input={handleInput}
    style="width: 100%;
    accent-color: orange;
    background-color: orange;"
  >
</div>
<p>{$quarterValue}</p>