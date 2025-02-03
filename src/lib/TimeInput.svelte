<script lang="ts">
  let hours = $state(0)
  let minutes = $state(0)
  let seconds = $state(0)

  let { value = $bindable(100) } = $props()

  $effect(() => {
    hours = Math.floor(value / 3600)
    minutes = Math.floor((value % 3600) / 60)
    seconds = value % 60
  })
  $effect(() => {
    value = hours * 3600 + minutes * 60 + seconds
  })
</script>

<main>
  <input type="number" bind:value={hours} min="0" max="23" />
  <span>:</span>
  <input type="number" bind:value={minutes} min="0" max="59" />
  <span>:</span>
  <input type="number" bind:value={seconds} min="0" max="59" />
  <small>hours</small>
  <small></small>
  <small>minutes</small>
  <small></small>
  <small>seconds</small>
</main>

<style lang="scss">
  main {
    display: grid;
    grid-template: repeat(2, auto) / repeat(5, auto);
    text-align: center;
    gap: 0.5rem;

    input {
      width: 5ch;
      font-size: 24px;
      text-align: center;
    }
  }
</style>

