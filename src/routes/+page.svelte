<script lang="ts">
  import { onDestroy, onMount } from 'svelte'
  import TimeInput from '../lib/TimeInput.svelte'

  let cur = $state(0)
  let max = $state(1200)
  let interval: number | null = $state(null)
  let endSound: HTMLAudioElement

  let loop = $state(false)
  let dir = $state(true)

  let runnable = $derived(max > 0)
  let running = $derived(interval !== null)
  let action = $derived(running ? 'Pause' : { [max]: 'Restart', 0: 'Start' }[cur] || 'Resume')
  let cssdir = $derived(dir ? 'direction: ltr' : 'direction: rtl')

  function resume() {
    clearInterval(interval!)
    interval = setInterval(() => (cur = Math.min(max, cur + 1)), 1000)
  }

  $effect(() => {
    if (running && cur >= max) {
      endSound.play()
      pause()
      if (loop) {
        click()
      }
    }
  })

  function pause() {
    clearInterval(interval!)
    interval = null
  }

  function click() {
    if (running) {
      return pause()
    }
    if (cur === max) {
      cur = 0
    }
    if (runnable) {
      resume()
    }
  }

  onDestroy(pause)
  onMount(() => {
    endSound = document.querySelector('#endSound')!
  })
</script>

<main class="flex flex-col text-white gap-4">
  <div id="controls" class="w-full flex justify-evenly text-xs">
    <label class="fieldset-label">
      <input type="checkbox" bind:checked={loop} class="toggle toggle-xs" />
      Loop: {loop ? 'on' : 'off'}
    </label>
    <label class="fieldset-label">
      <input type="checkbox" bind:checked={dir} class="toggle toggle-xs" />
      Count: {dir ? 'up' : 'down'}
    </label>
  </div>
  <input type="range" bind:value={cur} min={0} {max} class="range w-full" style={cssdir} />
  <div class="flex flex-col gap-2 sm:flex-row place-items-center w-full justify-between">
    <fieldset class="fieldset bg-base-200 border border-base-300 p-4 rounded-box">
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
  <button type="button" class="btn self-center" disabled={!runnable} onclick={click}>
    {action}
  </button>
</main>
<audio id="endSound" src="./beep.ogg"></audio>
