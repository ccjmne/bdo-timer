<script lang="ts">
  let {
    value = $bindable(0),
    min = -Infinity,
    max = Infinity,
    class: cls,
  }: { value: number; min?: number; max?: number; class?: string } = $props()

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

  function onkeydown(e: KeyboardEvent) {
    if (['ArrowUp', 'ArrowRight'].includes(e.key)) value = Math.min(value + 1, max)
    else if (['ArrowDown', 'ArrowLeft'].includes(e.key)) value = Math.max(value - 1, min)
    else if (['Home', 'PageUp'].includes(e.key)) value = max
    else if (['End', 'PageDown'].includes(e.key)) value = min
    if (e.key !== 'Tab' && isNaN(parseInt(e.key))) e.preventDefault()
  }
</script>

<div
  class={[cls, 'text-xl text-center flex flex-col place-content-center']}
  style:font-family="Syne,Outfit,sans-serif"
  onwheel={({ deltaY }) => (value -= Math.sign(deltaY))}
>
  <div
    role="none"
    contenteditable="true"
    bind:innerText={serialise, deserialise}
    {onfocus}
    {onkeydown}
  ></div>
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
</style>
