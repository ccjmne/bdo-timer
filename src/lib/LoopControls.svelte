<script lang="ts">
  import EditableNumber from './EditableNumber.svelte'
  import StartStop from './StartStop.svelte'

  let {
    time = $bindable([0, 1200]),
    loop = $bindable([1, Infinity]),
    onrunning = () => {},
  }: {
    time: [current: number, goal: number]
    loop: [current: number, goal: number]
    onrunning: (running: boolean) => void
  } = $props()

  let last = $derived(loop[0] === loop[1])
</script>

<div class="join">
  <div class="join-item flex flex-col">
    <button
      aria-label={last ? 'Repeat' : 'Do not repeat'}
      class="btn join-item"
      onclick={() => (loop[1] = last ? Infinity : loop[0])}
    >
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
        <path
          d={last
            ? 'M4 12V9a3 3 0 0 1 3-3h13m-3-3l3 3l-3 3m3 3v3a3 3 0 0 1-3 3H4m3 3l-3-3l3-3'
            : 'M4 12V9a3 3 0 0 1 2.08-2.856M10 6h10m-3-3l3 3l-3 3m3 3v3a3 3 0 0 1-.133.886m-1.99 1.984A3 3 0 0 1 17 18H4m3 3l-3-3l3-3M3 3l18 18'}
        />
      </svg>
    </button>
  </div>
  <div class="join-item bg-base-100 ps-4 muted relative top-[1px] flex place-items-center">
    Loop
  </div>
  <EditableNumber
    min={1}
    class="bg-base-100 px-2"
    bind:value={() => loop[0], v => ((loop[0] = v), (loop[1] = Math.max(loop[0], loop[1])))}
  ></EditableNumber>
  <div class="join-item bg-base-100 muted relative top-[1px] flex place-items-center">of</div>
  <EditableNumber
    class="bg-base-100 ps-2 pe-4"
    bind:value={() => loop[1], v => ((loop[1] = v), (loop[0] = Math.min(loop[0], loop[1])))}
  ></EditableNumber>
  <StartStop bind:time bind:loop {onrunning} />
  <button
    aria-label="Rewind"
    class="btn join-item"
    disabled={loop[0] === 1 && time[0] === 0}
    onclick={() => ((loop[0] = 1), (time[0] = 0))}
  >
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
      <path d="M20 18V6a2 2 0 0 0-2.75-1.84L9 10.26a2 2 0 0 0 0 3.5l8.25 6.1A2 2 0 0 0 20 18.11" />
      <path d="M4 20V4" />
    </svg>
  </button>
</div>

<style>
  svg {
    fill: none;
    stroke: currentColor;
    stroke-linecap: round;
    stroke-linejoin: round;
    stroke-width: 2;
    width: 1em;
    height: 1em;
  }
</style>
