<script lang="ts">
  import type { Snippet } from 'svelte'

  let {
    value = $bindable(0),
    min = -Infinity,
    max = Infinity,
    zeroisinfinity = false,
    children,
    class: cls,
  }: {
    value: number
    min?: number
    max?: number
    zeroisinfinity?: boolean
    children?: Snippet
    class?: string
  } = $props()

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

  function onwheel({ deltaY }: WheelEvent) {
    value =
      zeroisinfinity && value === Infinity && deltaY < 0
        ? 1
        : Math.max(min, Math.min(max, value - Math.sign(deltaY)))
  }
</script>

<div class="{cls} text-xl text-center flex flex-col place-content-center">
  <div
    role="none"
    contenteditable="true"
    bind:innerText={serialise, deserialise}
    onkeypress={e => isNaN(parseInt(e.key)) && e.preventDefault()}
    {onfocus}
    {onwheel}
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
