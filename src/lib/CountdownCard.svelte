<script lang="ts">
  import TimeInput from './TimeInput.svelte'

  import Beep from '~icons/mdi/music-note'
  import NoBeep from '~icons/mdi/music-note-off'
  import Up from '~icons/mdi/chevron-double-up'
  import Down from '~icons/mdi/chevron-double-down'

  let {
    time = $bindable([0, 1200]),
    dir = $bindable(true),
    beeping = $bindable(true),
    running,
  }: {
    time: [current: number, goal: number]
    dir: boolean
    beeping: boolean
    running: boolean
  } = $props()

  function getCurrent() {
    return dir ? time[0] : time[1] - time[0]
  }

  function updateCurrent(v: number) {
    time[1] = Math.max(time[1], v)
    time[0] = dir ? v : time[1] - v
  }

  function updateTotal(v: number) {
    if (dir) {
      time[1] = v
      time[0] = Math.min(v, time[0])
    } else {
      time[0] = Math.max(0, time[0] + v - time[1])
      time[1] = v
    }
  }
</script>

<div class="grid w-full grid-flow-col grid-cols-[auto_1fr] grid-rows-[1fr_1fr]">
  <button class="btn btn-md rounded-tl-sm join h-full" onclick={() => (dir = !dir)}>
    <label class={['swap swap-rotate', dir && 'swap-active']}>
      <Up class="swap-on" />
      <Down class="swap-off" />
    </label>
  </button>
  <button class="btn btn-md rounded-bl-sm join h-full" onclick={() => (beeping = !beeping)}>
    <label class={['swap', beeping && 'swap-active']}>
      <Beep class="swap-on" />
      <NoBeep class="swap-off" />
    </label>
  </button>
  <div class="relative isolate rounded-e-sm bg-base-100 row-span-full">
    <div class="flex justify-evenly absolute inset-0 z-[-1] overflow-hidden">
      {#each [...Array(24).keys()].map(() => Math.random() * 2 + 's') as delay}
        <div class="w-[1px] bg-[#8882] max-sm:[:nth-child(-n+10)]:hidden">
          <div
            style:animation-delay={delay}
            class={[
              'absolute w-[1px] transition-opacity duration-500 animate-fall bg-linear-to-b from-[#8880] to-[#888a]',
              !running && 'opacity-0',
              dir && 'bg-linear-to-t animate-reverse',
            ]}
          ></div>
        </div>
      {/each}
    </div>
    <div class="p-2 flex justify-evenly items-center w-full max-sm:flex-col">
      <TimeInput bind:value={getCurrent, updateCurrent}>
        <span class="max-sm:row-start-1 col-span-full">{dir ? 'Elapsed' : 'Remaining'}</span>
      </TimeInput>
      <div class="divider sm:divider-horizontal text-xs m-0 muted">of</div>
      <TimeInput bind:value={() => time[1], updateTotal}>
        {#each [...'hms'] as l}<span>{l}</span>{/each}
      </TimeInput>
    </div>
  </div>
</div>
