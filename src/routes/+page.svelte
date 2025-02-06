<script lang="ts">
  import TimeInput from '../lib/TimeInput.svelte'
  import LoopControls from '$lib/LoopControls.svelte'
  import StartStop from '$lib/StartStop.svelte'

  let cur = $state(0)
  let max = $state(1200)
  let running = $state(false)

  let loop = $state(1)
  let loops = $state(Infinity)
  let dir = $state(true)

  let cssdir = $derived(dir ? 'direction: ltr' : 'direction: rtl')
  let status = $derived(running ? 'status status-accent' : 'status')
</script>

<main class="flex flex-col text-white gap-4">
  <LoopControls bind:loop bind:loops>
    <StartStop bind:cur bind:max bind:loop bind:loops onrunning={r => (running = r)} />
  </LoopControls>
  <div id="controls" class="w-full flex justify-evenly text-xs">
    <!-- <label class="fieldset-label"> -->
    <!--   <input type="checkbox" bind:checked={loop} class="toggle toggle-xs" /> -->
    <!--   Loop: {loop ? 'on' : 'off'} -->
    <!-- </label> -->
    <label class="fieldset-label">
      <input type="checkbox" bind:checked={dir} class="toggle toggle-xs" />
      Count: {dir ? 'up' : 'down'}
    </label>
  </div>
  <input type="range" bind:value={cur} min={0} {max} class="range w-full" style={cssdir} />
  <div class="flex flex-col gap-2 sm:flex-row place-items-center w-full justify-between">
    <fieldset class="fieldset bg-base-200 border border-base-300 p-4 rounded-box relative">
      {#if running}
        <div class="absolute right-1.5 top-0.5 {status} animate-ping"></div>
      {/if}
      <div class="absolute right-1.5 top-0.5 {status}"></div>
      {#if dir}
        <legend class="fieldset-legend h-0">Elapsed</legend>
        <TimeInput bind:value={() => cur, v => ((max = Math.max(max, v)), (cur = v))} />
      {:else}
        <legend class="fieldset-legend h-0">Remaining</legend>
        <TimeInput bind:value={() => max - cur, v => ((max = Math.max(max, v)), (cur = max - v))} />
      {/if}
    </fieldset>
    <span class="muted text-sm max-sm:hidden">of</span>
    <div class="flex flex-row place-items-center gap-4">
      <span class="muted text-sm sm:hidden">of</span>
      {#if dir}
        <TimeInput bind:value={() => max, v => ((max = v), (cur = Math.min(v, cur)))} />
      {:else}
        <TimeInput bind:value={() => max, v => ((cur = Math.max(0, cur + v - max)), (max = v))} />
      {/if}
    </div>
  </div>
</main>
