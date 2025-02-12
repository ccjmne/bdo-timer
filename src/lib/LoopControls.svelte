<script lang="ts">
  import EditableNumber from './EditableNumber.svelte'
  import StartStop from './StartStop.svelte'

  import Loop from '~icons/mdi/repeat'
  import NoLoop from '~icons/mdi/repeat-off'
  import Rewind from '~icons/mdi/rewind'

  let {
    time = $bindable([0, 1200]),
    loop = $bindable([1, Infinity]),
    running = $bindable(false),
    beeping = true,
  }: {
    time: [current: number, goal: number]
    loop: [current: number, goal: number]
    running: boolean
    beeping: boolean
  } = $props()

  let last = $derived(loop[0] === loop[1])
</script>

<div class="join grid grid-cols-[auto_1fr] md:grid-cols-[auto_auto_1fr_auto] grid-flow-col-dense">
  <button
    aria-label={last ? 'Repeat' : 'Do not repeat'}
    class="btn join-item max-md:rounded-bl-none"
    onclick={() => (loop[1] = last ? Infinity : loop[0])}
  >
    <div class={['swap', last && 'swap-active']}>
      <Loop class="swap-off" />
      <NoLoop class="swap-on" />
    </div>
  </button>
  <div class="bg-base-100 flex flex-row shadow-md justify-center items-center max-md:rounded-tr-sm">
    <div class="ps-4 muted">Loop</div>
    <EditableNumber
      min={1}
      class="px-3"
      bind:value={() => loop[0], v => ((loop[0] = v), (loop[1] = Math.max(loop[0], loop[1])))}
    ></EditableNumber>
    <div class="muted">of</div>
    <EditableNumber
      class="ps-3 pe-4"
      bind:value={() => loop[1], v => ((loop[1] = v), (loop[0] = Math.min(loop[0], loop[1])))}
    ></EditableNumber>
  </div>
  <StartStop bind:time bind:loop bind:running {beeping} class="max-md:rounded-br-sm" />
  <button
    aria-label="Rewind"
    class="btn join-item max-md:col-start-1 max-md:row-start-2 max-md:rounded-none max-md:rounded-bl-sm"
    disabled={loop[0] === 1 && time[0] === 0}
    onclick={() => ((loop[0] = 1), (time[0] = 0))}
  >
    <Rewind />
  </button>
</div>
