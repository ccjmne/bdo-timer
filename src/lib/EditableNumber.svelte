<script lang="ts">
  import type { Snippet } from 'svelte'

  let {
    value = $bindable(0),
    children,
    class: cls,
  }: { value: number; children?: Snippet; class?: string } = $props()

  function select(e: FocusEvent) {
    const range = document.createRange()
    range.selectNodeContents(e.target as HTMLElement)
    const sel = window.getSelection()!
    sel.removeAllRanges()
    sel.addRange(range)
  }
</script>

<div class="{cls} text-xl text-center flex flex-col place-content-center">
  <div
    role="none"
    contenteditable="true"
    bind:innerText={() => String(value), v => (value = isNaN(parseInt(v)) ? 0 : parseInt(v))}
    onfocus={select}
    onkeypress={e => isNaN(parseInt(e.key)) && e.preventDefault()}
    onwheel={({ deltaY }) => (value -= Math.sign(deltaY))}
  ></div>
  {#if children}
    <label class="block text-center muted">{@render children()}</label>
  {/if}
</div>

<style>
  label {
    font-size: 0.4em;
  }
</style>
