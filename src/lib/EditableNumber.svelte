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

<div class="text-xl">
  <div
    role="none"
    contenteditable="true"
    onfocus={select}
    onkeypress={e => isNaN(parseInt(e.key)) && e.preventDefault()}
    bind:innerText={() => String(value), v => (value = isNaN(parseInt(v)) ? 0 : parseInt(v))}
    onwheel={({ deltaY }) => (value -= Math.sign(deltaY))}
  ></div>
  <label class="block text-center muted">{@render children?.()}</label>
</div>

<style>
  label {
    font-size: 0.4em;
  }
</style>
