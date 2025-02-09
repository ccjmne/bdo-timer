<script lang="ts">
  import TimeInput from '../lib/TimeInput.svelte'
  import LoopControls from '$lib/LoopControls.svelte'
  import Icon from '@iconify/svelte'

  let time: [current: number, goal: number] = $state([0, 1200])
  let loop: [current: number, goal: number] = $state([1, Infinity])
  let running = $state(false)
  let dir = $state(true)
  let beep = $state(true)
</script>

<main class="flex flex-col text-white gap-4">
  <LoopControls bind:time bind:loop {beep} onrunning={r => (running = r)}></LoopControls>
  <input type="range" bind:value={time[0]} min={0} max={time[1]} class="range w-full" />
  <div class="flex flex-col gap-2 sm:flex-row place-items-center w-full justify-between">
    <div
      class="grid place-items-center join grid-cols-[auto_1fr] grid-rows-[1fr_1fr] bg-base-100 rounded-sm w-full"
    >
      <button class="btn btn-md h-full join-item" onclick={() => (dir = !dir)}>
        <label class="swap swap-rotate {dir ? 'swap-active' : ''}">
          <Icon class="swap-on" icon="ic:baseline-keyboard-double-arrow-up" />
          <Icon class="swap-off" icon="ic:baseline-keyboard-double-arrow-down" />
        </label>
      </button>
      <div
        class="p-2 relative row-span-2 rounded-e-sm border-[#8882] border-t-1 border-r-0 w-full shadow-sm"
      >
        <div class="flex justify-evenly items-center w-full max-sm:flex-col">
          {#if dir}
            <TimeInput
              label="Elapsed"
              bind:value={() => time[0], v => ((time[1] = Math.max(time[1], v)), (time[0] = v))}
            />
          {:else}
            <TimeInput
              label="Remaining"
              bind:value={() => time[1] - time[0],
              v => ((time[1] = Math.max(time[1], v)), (time[0] = time[1] - v))}
            />
          {/if}
          <div class="divider sm:divider-horizontal text-xs m-0 muted">of</div>
          {#if dir}
            <TimeInput
              bind:value={() => time[1], v => ((time[1] = v), (time[0] = Math.min(v, time[0])))}
            />
          {:else}
            <TimeInput
              bind:value={() => time[1],
              v => ((time[0] = Math.max(0, time[0] + v - time[1])), (time[1] = v))}
            />
          {/if}
        </div>
      </div>
      <button class="btn btn-md rounded-bl-sm h-full join-item" onclick={() => (beep = !beep)}>
        <label class="swap {beep ? 'swap-active' : ''}">
          <Icon class="swap-on" icon="mdi:music-note" />
          <Icon class="swap-off" icon="mdi:music-note-off" />
        </label>
      </button>
    </div>
  </div>
</main>
