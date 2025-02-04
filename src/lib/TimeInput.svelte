<script lang="ts">
  let { value = $bindable(100) } = $props()

  let hours = $derived(Math.floor(value / 3600))
  let minutes = $derived(Math.floor((value % 3600) / 60))
  let seconds = $derived(value % 60)

  function hover({ target }: MouseEvent) {
    (target as HTMLInputElement).focus()
  }

  function wheel(step: number) {
    return function (e: WheelEvent) {
      value = Math.max(0, value - Math.sign(e.deltaY) * step)
      e.preventDefault()
    }
  }

  function setHours(h: number) {
    value = Math.max(0, h * 3600 + minutes * 60 + seconds)
  }
  function setMinutes(h: number) {
    value = Math.max(0, hours * 3600 + h * 60 + seconds)
  }
  function setSeconds(h: number) {
    value = Math.max(0, hours * 3600 + minutes * 60 + h)
  }
</script>

<main>
  <input type="number" bind:value={() => hours, setHours} onfocus={() => {}} onmouseover={hover} onwheel={wheel(3600)} min="0" max="23" />
  <span>:</span>
  <input type="number" bind:value={() => minutes, setMinutes} onfocus={() => {}} onmouseover={hover} onwheel={wheel(60)} min="0" max="23" />
  <span>:</span>
  <input type="number" bind:value={() => seconds, setSeconds} onfocus={() => {}} onmouseover={hover} onwheel={wheel(1)} min="0" max="23" />
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

