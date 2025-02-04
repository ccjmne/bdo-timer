<script lang="ts">
  let { value = $bindable(0), children } = $props()

  function select(e: FocusEvent) {
    const range = document.createRange()
    range.selectNodeContents(e.target as HTMLElement)
    const sel = window.getSelection()!
    sel.removeAllRanges()
    sel.addRange(range)
  }
</script>

<div>
  <div
    role="none"
    contenteditable="true"
    onfocus={select}
    onkeypress={e => isNaN(parseInt(e.key)) && e.preventDefault()}
    bind:innerText={() => String(value), v => (value = parseInt(v))}
    onwheel={({ deltaY }) => (value -= Math.sign(deltaY))}
  ></div>
  <label class="muted">{@render children?.()}</label>
</div>

<style>
  label {
    display: block;
    text-align: center;
    font-size: 0.6em;
  }
</style>
