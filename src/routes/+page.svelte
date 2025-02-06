<script lang="ts">
  import TimeInput from '../lib/TimeInput.svelte'
  import LoopControls from '$lib/LoopControls.svelte'

  let time: [current: number, goal: number] = $state([0, 1200])
  let loop: [current: number, goal: number] = $state([1, Infinity])
  let running = $state(false)
  let dir = $state(true)

  let status = $derived(running ? 'status status-accent' : 'status')
</script>

<main class="flex flex-col text-white gap-4">
  <LoopControls bind:time bind:loop onrunning={r => (running = r)}></LoopControls>
  <div id="controls" class="w-full flex justify-evenly text-xs">
    <label class="fieldset-label">
      <input type="checkbox" bind:checked={dir} class="toggle toggle-xs" />
      Count: {dir ? 'up' : 'down'}
    </label>
  </div>
  <input
    type="range"
    bind:value={time[0]}
    min={0}
    max={time[1]}
    class="range w-full"
    style={dir ? 'direction: ltr' : 'direction: rtl'}
  />
  <div class="flex flex-col gap-2 sm:flex-row place-items-center w-full justify-between">
    <fieldset class="fieldset bg-base-200 border border-base-300 p-4 rounded-box relative">
      {#if running}
        <div class="absolute right-1.5 top-0.5 {status} animate-ping"></div>
      {/if}
      <div class="absolute right-1.5 top-0.5 {status}"></div>
      {#if dir}
        <legend class="fieldset-legend h-0">Elapsed</legend>
        <TimeInput
          bind:value={() => time[0], v => ((time[1] = Math.max(time[1], v)), (time[0] = v))}
        />
      {:else}
        <legend class="fieldset-legend h-0">Remaining</legend>
        <TimeInput
          bind:value={() => time[1] - time[0],
          v => ((time[1] = Math.max(time[1], v)), (time[0] = time[1] - v))}
        />
      {/if}
    </fieldset>
    <span class="muted text-sm max-sm:hidden">of</span>
    <div class="flex flex-row place-items-center gap-4">
      <span class="muted text-sm sm:hidden">of</span>
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
