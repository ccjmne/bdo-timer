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

  function serialise() {
    return value === Infinity ? '∞' : String(value)
  }

  function deserialise(v: string) {
    value = isNaN(parseInt(v)) ? 0 : parseInt(v)
  }
</script>

<div class="{cls} text-xl text-center flex flex-col place-content-center">
  <div
    role="none"
    contenteditable="true"
    bind:innerText={serialise, deserialise}
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
