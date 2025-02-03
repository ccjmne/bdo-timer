<script lang="ts">
  let hours = $state(0)
  let minutes = $state(0)
  let seconds = $state(0)

  let { value = $bindable(100) } = $props()

  $effect(() => {
    if (value < 0) {
      value = 0
    }
    hours = Math.floor(value / 3600)
    minutes = Math.floor((value % 3600) / 60)
    seconds = value % 60
  })
  $effect(() => {
    value = hours * 3600 + minutes * 60 + seconds
  })

  function hover({ target }: MouseEvent) {
    (target as HTMLInputElement).focus()
  }
</script>

<main>
  <input type="number" bind:value={hours} onfocus={() => {}} onmouseover={hover} onwheel={({ deltaY, ...e }) => hours = Math.max(0, hours - Math.sign(deltaY))} min="0" max="23" />
  <span>:</span>
  <input type="number" bind:value={minutes} onfocus={() => {}} onmouseover={hover} onwheel={({ deltaY, ...e }) => minutes = Math.max(0, minutes - Math.sign(deltaY))} min="0" max="59" />
  <span>:</span>
  <input type="number" bind:value={seconds} onfocus={() => {}} onmouseover={hover} onwheel={({ deltaY, ...e }) => seconds = Math.max(0, seconds - Math.sign(deltaY))} min="0" max="59" />
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

