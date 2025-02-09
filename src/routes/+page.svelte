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
    <div class="grid place-items-center grid-cols-[auto_1fr] bg-base-100 rounded-sm shadow-sm">
      <button class="btn btn-sm rounded-none rounded-tl-sm" onclick={() => (dir = !dir)}>
        <Icon icon="ic:sharp-flip-camera-android" />
      </button>
      <span class="text-sm">{dir ? 'Elapsed' : 'Remaining'}</span>
      <div class="py-2 px-8 relative rounded-b-sm col-span-2 border-t-gray-800 border-t-1">
        <div class="flex place-items-center">
          {#if dir}
            <TimeInput
              bind:value={() => time[0], v => ((time[1] = Math.max(time[1], v)), (time[0] = v))}
            />
          {:else}
            <TimeInput
              bind:value={() => time[1] - time[0],
              v => ((time[1] = Math.max(time[1], v)), (time[0] = time[1] - v))}
            />
          {/if}
        </div>
      </div>
    </div>
    <div class="divider sm:divider-horizontal text-xs m-0">of</div>
    <div class="flex flex-row place-items-center gap-4">
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
</main>
