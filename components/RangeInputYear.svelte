<script>
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
	export let quarterValue = quarters[quarters.length - 1];

  function handleInput(event) {
    sliderValue = event.target.value;
  }
	$: quarterValue = quarters[sliderValue]

</script>

<div class="p-2 w-full font-sans text-sm rounded-md">
  <label for="rangeInput">
    <!-- Quarter: {quarters[sliderValue]} -->
  </label>

  <input 
    id="rangeInput"
    type="range" 
    min="0"
    max={quarters.length - 1}
    bind:value={sliderValue}
    on:input={handleInput}
    style="width: 100%;
    accent-color: goldenrod;
    background-color: #6496bf;"
  >
</div>





















<!-- <script>
  export let min = '1999Q1';
  export let max = '2023Q1';
  export let value = '2000Q1';

  const [year, quarter] = value.split('Q');
  const yearNum = parseInt(year); 
  const quarterNum = parseInt(quarter);

  const minYear = parseInt(min.substring(0, 4));
  const maxYear = parseInt(max.substring(0, 4));
  const maxQuarter = parseInt(max.substring(5));
  const totalQuarters = (maxYear - minYear) * 4 + maxQuarter - 1;

  const mapNumberToYearQuarter = (num) => {
    const year = Math.floor(num / 4) + minYear;
    const quarter = num % 4 + 1;
    return `${year}Q${quarter}`;
  };

  const mapYearQuarterToNumber = (year, quarter) => {
    return (year - minYear) * 4 + quarter - 1;
  };

  let sliderValue = mapYearQuarterToNumber(yearNum, quarterNum);

  function handleInput(event) {
    sliderValue = event.target.value;
    value = mapNumberToYearQuarter(sliderValue);
  }
</script> -->


<!-- <div class="p-2 w-full font-sans text-sm rounded-md">
  <label for="rangeInput"> -->
    <!-- Year: {mapNumberToYearQuarter(sliderValue)} -->
  <!-- </label> -->

  <!-- <input 
    id="rangeInput"
    type="range" 
    min="0"
    max={totalQuarters}
    bind:value={sliderValue}
    on:input={handleInput}
    style="width: 100%;
    accent-color: orange;
    background-color: #ccc;"
  > -->
<!-- </div> -->