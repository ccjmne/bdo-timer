<script lang="ts">
  import Icon from '@iconify/svelte'
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

<div class="join w-full">
  <div class="join-item flex flex-col">
    <button
      aria-label={last ? 'Repeat' : 'Do not repeat'}
      class="btn join-item"
      onclick={() => (loop[1] = last ? Infinity : loop[0])}
    >
      <Icon icon={last ? 'mdi:repeat' : 'mdi:repeat-off'} />
    </button>
  </div>
  <div
    class="join-item flex flex-row"
    style="box-shadow:  oklch(1 0 0 / 0.06) 0px 0.5px 0px 0.5px inset, oklab(0.2326 -0.00406983 -0.0133954 / 0.3) 0px 3px 2px -2px, oklab(0.2326 -0.00406983 -0.0133954 / 0.3) 0px 4px 3px -2px"
  >
    <div class="bg-base-100 ps-4 muted relative flex place-items-center">Loop</div>
    <EditableNumber
      min={1}
      class="bg-base-100 px-2"
      bind:value={() => loop[0], v => ((loop[0] = v), (loop[1] = Math.max(loop[0], loop[1])))}
    ></EditableNumber>
    <div class="bg-base-100 muted relative flex place-items-center">of</div>
    <EditableNumber
      class="bg-base-100 ps-2 pe-4"
      bind:value={() => loop[1], v => ((loop[1] = v), (loop[0] = Math.min(loop[0], loop[1])))}
    ></EditableNumber>
  </div>
  <StartStop bind:time bind:loop {onrunning} />
  <button
    aria-label="Rewind"
    class="btn join-item"
    disabled={loop[0] === 1 && time[0] === 0}
    onclick={() => ((loop[0] = 1), (time[0] = 0))}
  >
    <Icon icon="mdi:rewind" />
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
