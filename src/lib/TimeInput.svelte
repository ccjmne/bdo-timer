<script lang="ts">
  let { value = $bindable(100) } = $props()

  let hours = $derived(Math.floor(value / 3600))
  let minutes = $derived(Math.floor((value % 3600) / 60))
  let seconds = $derived(value % 60)

  function wheel(step: number) {
    return ({ deltaY }: WheelEvent) => (value = Math.max(0, value - Math.sign(deltaY) * step))
  }

  function setHours(h: string) {
    value = Math.max(0, (parseInt(h) ?? 0) * 3600 + minutes * 60 + seconds)
  }
  function setMinutes(m: string) {
    value = Math.max(0, hours * 3600 + (parseInt(m) ?? 0) * 60 + seconds)
  }
  function setSeconds(s: string) {
    value = Math.max(0, hours * 3600 + minutes * 60 + (parseInt(s) ?? 0))
  }

  function select(e: FocusEvent) {
    const range = document.createRange()
    range.selectNodeContents(e.target as HTMLElement)
    const sel = window.getSelection()!
    sel.removeAllRanges()
    sel.addRange(range)
  }
</script>

<main>
  <div
    role="none"
    contenteditable="true"
    onfocus={select}
    onkeypress={e => isNaN(parseInt(e.key)) && e.preventDefault()}
    bind:innerText={() => String(hours), setHours}
    onwheel={wheel(3600)}
  ></div>
  <div
    role="none"
    contenteditable="true"
    onfocus={select}
    onkeypress={e => isNaN(parseInt(e.key)) && e.preventDefault()}
    bind:innerText={() => String(minutes), setMinutes}
    onwheel={wheel(60)}
  ></div>
  <div
    role="none"
    contenteditable="true"
    onfocus={select}
    onkeypress={e => isNaN(parseInt(e.key)) && e.preventDefault()}
    bind:innerText={() => String(seconds), setSeconds}
    onwheel={wheel(1)}
  ></div>
  <small>hours</small>
  <small>minutes</small>
  <small>seconds</small>
</main>

<style>
  main {
    display: grid;
    grid-template: repeat(2, auto) / repeat(3, auto);
    text-align: center;
    gap: 0 0.5rem;
  }
</style>
