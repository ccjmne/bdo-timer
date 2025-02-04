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
  let action = $derived(running ? 'Pause' : { 0: 'Start', [max]: 'Restart' }[cur] || 'Resume')
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

<main class="flex flex-col items-center justify-center h-screen bg-gray-800 text-white gap-4">
  <div id="controls" class="w-50">
    <label class="fieldset-label">
      <input type="checkbox" bind:checked={loop} class="toggle toggle-xs" />
      Loop: {loop ? 'on' : 'off'}
    </label>
    <label class="fieldset-label">
      <input type="checkbox" bind:checked={dir} class="toggle toggle-xs" />
      Count: {dir ? 'up' : 'down'}
    </label>
  </div>
  <input type="range" bind:value={cur} min={0} {max} class="range" style={cssdir} />
  <div id="textual">
    {#if dir}
      <TimeInput bind:value={() => cur, v => ((max = Math.max(max, v)), (cur = v))} />
      <span class="muted">to</span>
      <TimeInput bind:value={() => max, v => ((max = v), (cur = Math.min(v, cur)))} />
    {:else}
      <TimeInput bind:value={() => max - cur, v => ((max = Math.max(max, v)), (cur = max - v))} />
      <span class="muted">from</span>
      <TimeInput bind:value={() => max, v => ((cur = Math.max(0, cur + v - max)), (max = v))} />
    {/if}
  </div>
  <button type="button" class="btn w-50" disabled={!runnable} onclick={click}>{action}</button>
</main>
<audio id="endSound" src="./beep.ogg"></audio>

<style>
  #textual {
    display: flex;
    align-items: center;
    gap: 2em;
  }

  #controls {
    display: flex;
    justify-content: space-evenly;
    gap: 1em;
    font-size: 0.5em;
  }
</style>
