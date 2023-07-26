<script>
  export let min = '1999Q1';
  export let max = '2023Q1';
  export let value = '2023Q1';

  const [year, quarter] = value.split('Q');
  const yearNum = parseInt(year); 
  const quarterNum = parseInt(quarter);

  const minYear = parseInt(min.substring(0, 4));
  const maxYear = parseInt(max.substring(0, 4));
  const totalQuarters = (maxYear - minYear + 1) * 4;

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
</script>

<div class="p-2 w-full font-sans text-sm rounded-md">
  <label for="rangeInput">
    <!-- Year: {mapNumberToYearQuarter(sliderValue)} -->
  </label>

  <input 
    id="rangeInput"
    type="range" 
    min="0"
    max={totalQuarters}
    bind:value={sliderValue}
    on:input={handleInput}
    style="width: 100%;
    accent-color: orange;
    background-color: #ccc;"
  >
</div>
