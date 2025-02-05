<script lang="ts">
  import type { Snippet } from 'svelte'

  let {
    value = $bindable(0),
    min = -Infinity,
    max = Infinity,
    children,
    class: cls,
  }: { value: number; min?: number; max?: number; children?: Snippet; class?: string } = $props()

  $effect(() => {
    if (value < min) value = min
    if (value > max) value = max
  })

  // Select all the text when the input is focused
  function onfocus(e: FocusEvent) {
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
    {onfocus}
    onkeypress={e => isNaN(parseInt(e.key)) && e.preventDefault()}
    onwheel={({ deltaY }) => (value -= Math.sign(deltaY))}
  ></div>
  {#if children}
    <label class="block text-center muted">{@render children()}</label>
  {/if}
</div>

<style>
  @font-face {
    font-family: Syne;
    src: url('/syne.woff2') format('woff2');
    font-weight: 500;
    font-display: swap;
  }

  @font-face {
    font-family: Outfit;
    src: url('/outfit.woff2') format('woff2');
    font-weight: 400;
    font-display: swap;
  }

  .container {
    font-family: 'Syne', 'Outfit', sans-serif;
  }

  label {
    font-size: 0.4em;
  }
</style>
